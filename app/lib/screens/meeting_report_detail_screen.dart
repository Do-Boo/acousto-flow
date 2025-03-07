import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../models/report_model.dart';
import '../models/meeting_note_model.dart';
import '../services/meeting_note_service.dart';
import '../utils/carbon_colors.dart';

class MeetingReportDetailScreen extends StatefulWidget {
  final Report report;
  
  const MeetingReportDetailScreen({
    Key? key, 
    required this.report,
  }) : super(key: key);
  
  @override
  _MeetingReportDetailScreenState createState() => _MeetingReportDetailScreenState();
}

class _MeetingReportDetailScreenState extends State<MeetingReportDetailScreen> {
  final MeetingNoteService _noteService = MeetingNoteService();
  
  List<MeetingNote> _notes = [];
  bool _isLoading = false;
  
  // 회의실 장비 목록 (실제로는 API에서 가져오거나 설정에서 관리할 수 있음)
  final List<EquipmentItem> _equipmentItems = [
    EquipmentItem(name: '무선 마이크', icon: Icons.mic),
    EquipmentItem(name: '유선 마이크', icon: Icons.mic),
    EquipmentItem(name: '빔프로젝터', icon: Icons.videocam),
    EquipmentItem(name: '화상회의 시스템', icon: Icons.video_call),
    EquipmentItem(name: 'TV 모니터', icon: Icons.tv),
    EquipmentItem(name: '화이트보드', icon: Icons.edit),
    EquipmentItem(name: '노트북', icon: Icons.laptop),
    EquipmentItem(name: '음향시스템', icon: Icons.speaker),
  ];
  
  @override
  void initState() {
    super.initState();
    _loadNotes();
  }
  
  Future<void> _loadNotes() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      // report_id로 해당 예약에 관련된 메모 가져오기
      final notes = await _noteService.getNotes(reportId: widget.report.id);
      
      setState(() {
        _notes = notes;
        _isLoading = false;
      });
    } catch (e) {
      print('메모 데이터 로드 오류: $e');
      setState(() {
        _isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('메모 데이터를 불러오는데 실패했습니다.'))
      );
    }
  }
  
  void _showAddNoteDialog() {
    final TextEditingController contentController = TextEditingController();
    final TextEditingController callerNameController = TextEditingController();
    final TextEditingController callerContactController = TextEditingController();
    
    // 선택된 장비 목록 추적을 위한 상태
    final selectedEquipment = <String>[];
    
    NoteImportance selectedImportance = NoteImportance.medium;
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('전화 메모 추가'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 회의실 정보
                Text('회의실:'),
                Text(widget.report.getRoomNameText()),
                SizedBox(height: 8),
                Text('회의: ${widget.report.meetingTitle ?? ""}'),
                Text('신청자: ${widget.report.getRequesterText()}'),
                SizedBox(height: 16),
                
                // 발신자 정보
                TextField(
                  controller: callerNameController,
                  decoration: InputDecoration(
                    labelText: '전화한 사람',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: callerContactController,
                  decoration: InputDecoration(
                    labelText: '연락처',
                    border: OutlineInputBorder(),
                    hintText: '전화번호 또는 이메일',
                  ),
                ),
                SizedBox(height: 16),
                
                // 중요도 선택
                Text('중요도:'),
                Row(
                  children: [
                    Radio<NoteImportance>(
                      value: NoteImportance.low,
                      groupValue: selectedImportance,
                      onChanged: (value) => setState(() => selectedImportance = value!),
                    ),
                    Text('낮음'),
                    Radio<NoteImportance>(
                      value: NoteImportance.medium,
                      groupValue: selectedImportance,
                      onChanged: (value) => setState(() => selectedImportance = value!),
                    ),
                    Text('보통'),
                    Radio<NoteImportance>(
                      value: NoteImportance.high,
                      groupValue: selectedImportance,
                      onChanged: (value) => setState(() => selectedImportance = value!),
                    ),
                    Text('높음'),
                  ],
                ),
                SizedBox(height: 16),
                
                // 장비 선택 섹션
                Text(
                  '사용 장비:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Column(
                    children: _equipmentItems.map((equipment) {
                      final isSelected = selectedEquipment.contains(equipment.name);
                      return CheckboxListTile(
                        title: Row(
                          children: [
                            Icon(equipment.icon, size: 20, color: CarbonColors.gray60),
                            SizedBox(width: 8),
                            Text(equipment.name),
                          ],
                        ),
                        value: isSelected,
                        onChanged: (bool? value) {
                          setState(() {
                            if (value == true) {
                              selectedEquipment.add(equipment.name);
                            } else {
                              selectedEquipment.remove(equipment.name);
                            }
                          });
                        },
                        dense: true,
                        controlAffinity: ListTileControlAffinity.leading,
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: 16),
                
                // 메모 내용
                TextField(
                  controller: contentController,
                  decoration: InputDecoration(
                    labelText: '추가 메모',
                    border: OutlineInputBorder(),
                    hintText: '전화 내용 등 필요한 정보를 기록하세요',
                  ),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('취소'),
            ),
            ElevatedButton(
              onPressed: () async {
                // 메모 내용 검증
                if (selectedEquipment.isEmpty && contentController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('장비를 선택하거나 메모 내용을 입력해주세요'))
                  );
                  return;
                }
                
                // 메모 저장
                final newNote = MeetingNote(
                  reportId: widget.report.id ?? '',
                  roomName: widget.report.getRoomNameText(),
                  content: contentController.text.trim(),
                  callerName: callerNameController.text.isEmpty ? null : callerNameController.text,
                  callerContact: callerContactController.text.isEmpty ? null : callerContactController.text,
                  createdAt: DateTime.now(),
                  importance: selectedImportance,
                  usedEquipment: selectedEquipment,
                );
                
                try {
                  final success = await _noteService.addNote(newNote);
                  if (success) {
                    // 메모 목록 새로고침
                    _loadNotes();
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('메모가 저장되었습니다'))
                    );
                  } else {
                    throw Exception('메모 저장에 실패했습니다');
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('메모 저장 중 오류가 발생했습니다: $e'))
                  );
                }
              },
              child: Text('저장'),
              style: ElevatedButton.styleFrom(
                backgroundColor: CarbonColors.blue60,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? CarbonColors.gray100 : Colors.white;
    final textColor = isDarkMode ? Colors.white : CarbonColors.gray100;
    
    final systemUiOverlayStyle = isDarkMode
        ? SystemUiOverlayStyle.light.copyWith(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark,
          )
        : SystemUiOverlayStyle.dark.copyWith(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,
          );
    
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: systemUiOverlayStyle,
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          title: Text(
            widget.report.meetingTitle ?? '회의실 예약 상세',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: textColor,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          backgroundColor: backgroundColor,
          elevation: 0,
          iconTheme: IconThemeData(
            color: textColor,
          ),
        ),
        body: RefreshIndicator(
          onRefresh: _loadNotes,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildReportCard(),
                  SizedBox(height: 24),
                  
                  // 전화 메모 섹션
                  Row(
                    children: [
                      Text(
                        '전화 메모',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      Spacer(),
                      OutlinedButton.icon(
                        onPressed: _showAddNoteDialog,
                        icon: Icon(Icons.add),
                        label: Text('메모 추가'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: CarbonColors.blue60,
                          side: BorderSide(color: CarbonColors.blue60),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  _isLoading
                      ? Center(child: CircularProgressIndicator(color: CarbonColors.blue60))
                      : _buildNotesSection(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildReportCard() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDarkMode ? CarbonColors.gray90 : Colors.white;
    final dividerColor = isDarkMode ? CarbonColors.gray80 : CarbonColors.gray20;
    
    return Card(
      elevation: 0,
      color: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: dividerColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    widget.report.meetingTitle ?? '제목 없음',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _buildStatusBadge(widget.report.status ?? ''),
              ],
            ),
            SizedBox(height: 16),
            _buildInfoRow('회의실', widget.report.getRoomNameText()),
            _buildInfoRow('날짜', widget.report.getDateFormatted()),
            _buildInfoRow('시간', widget.report.getTimeFormatted()),
            _buildInfoRow('부서', widget.report.department ?? ''),
            _buildInfoRow('신청자', widget.report.getRequesterText()),
          ],
        ),
      ),
    );
  }
  
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: TextStyle(
                color: CarbonColors.gray60,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildStatusBadge(String status) {
    Color badgeColor;
    
    switch (status) {
      case '승인':
        badgeColor = CarbonColors.green50;
        break;
      case '취소':
        badgeColor = CarbonColors.red60;
        break;
      default:
        badgeColor = CarbonColors.yellow30;
    }
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: badgeColor),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: badgeColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
  
  Widget _buildNotesSection() {
    if (_notes.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.note_alt_outlined, size: 48, color: CarbonColors.gray60),
              SizedBox(height: 8),
              Text(
                '저장된 메모가 없습니다',
                style: TextStyle(
                  color: CarbonColors.gray60,
                ),
              ),
              SizedBox(height: 8),
              TextButton(
                onPressed: _showAddNoteDialog,
                child: Text('메모 추가하기'),
              ),
            ],
          ),
        ),
      );
    }
    
    // 날짜별로 메모 그룹화
    final groupedNotes = <String, List<MeetingNote>>{};
    for (var note in _notes) {
      final dateStr = DateFormat('yyyy-MM-dd').format(note.createdAt);
      if (!groupedNotes.containsKey(dateStr)) {
        groupedNotes[dateStr] = [];
      }
      groupedNotes[dateStr]!.add(note);
    }
    
    // 날짜 기준 정렬 (최신순)
    final sortedDates = groupedNotes.keys.toList()
      ..sort((a, b) => b.compareTo(a));
    
    return Column(
      children: sortedDates.map((dateStr) {
        final notes = groupedNotes[dateStr]!;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                dateStr,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: CarbonColors.gray60,
                ),
              ),
            ),
            ...notes.map((note) => _buildNoteItem(note)).toList(),
            Divider(),
          ],
        );
      }).toList(),
    );
  }
  
  Widget _buildNoteItem(MeetingNote note) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDarkMode ? CarbonColors.gray90 : Colors.white;
    final dividerColor = isDarkMode ? CarbonColors.gray80 : CarbonColors.gray20;
    
    // 중요도에 따른 색상
    Color importanceColor;
    switch (note.importance) {
      case NoteImportance.low:
        importanceColor = Colors.grey;
        break;
      case NoteImportance.high:
        importanceColor = CarbonColors.red60;
        break;
      default:
        importanceColor = CarbonColors.blue60;
    }
    
    return Card(
      margin: EdgeInsets.only(bottom: 8),
      elevation: 0,
      color: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: dividerColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: importanceColor,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  note.callerName ?? '발신자 정보 없음',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                Text(
                  DateFormat('HH:mm').format(note.createdAt),
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            if (note.callerContact != null && note.callerContact!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  note.callerContact!,
                  style: TextStyle(
                    color: CarbonColors.gray60,
                    fontSize: 13,
                  ),
                ),
              ),
            
            // 장비 정보
            if (note.usedEquipment.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: note.usedEquipment.map((equipment) {
                    // 장비 아이콘 매핑
                    IconData icon = Icons.devices;
                    if (equipment.contains('마이크')) icon = Icons.mic;
                    else if (equipment.contains('프로젝터')) icon = Icons.videocam;
                    else if (equipment.contains('화상')) icon = Icons.video_call;
                    else if (equipment.contains('TV') || equipment.contains('모니터')) icon = Icons.tv;
                    else if (equipment.contains('보드')) icon = Icons.edit;
                    else if (equipment.contains('노트북')) icon = Icons.laptop;
                    else if (equipment.contains('음향')) icon = Icons.speaker;
                    
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isDarkMode ? CarbonColors.gray80 : CarbonColors.gray10,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: CarbonColors.gray30),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(icon, size: 14, color: CarbonColors.gray60),
                          SizedBox(width: 4),
                          Text(
                            equipment,
                            style: TextStyle(
                              fontSize: 12,
                              color: CarbonColors.gray60,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            
            // 메모 내용
            if (note.content.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(note.content),
              ),
          ],
        ),
      ),
    );
  }
}

// 장비 데이터 모델
class EquipmentItem {
  final String name;
  final IconData icon;
  
  EquipmentItem({
    required this.name,
    required this.icon,
  });
} 