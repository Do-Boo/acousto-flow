import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../models/report_model.dart';
import '../services/report_service.dart';
import '../utils/carbon_colors.dart';
import 'meeting_report_detail_screen.dart';

class MeetingReportsScreen extends StatefulWidget {
  final DateTime? initialDate;
  
  const MeetingReportsScreen({
    Key? key,
    this.initialDate,
  }) : super(key: key);
  
  @override
  _MeetingReportsScreenState createState() => _MeetingReportsScreenState();
}

class _MeetingReportsScreenState extends State<MeetingReportsScreen> {
  final ReportService _reportService = ReportService();
  List<Report> _reports = [];
  List<Report> _filteredReports = [];
  bool _isLoading = false;
  late DateTime _selectedDate;
  
  // 필터링 관련 변수
  String? _selectedRoomFilter;
  String? _selectedTimeFilter;
  bool _showFilters = false;
  
  // 시간대 필터 옵션
  final List<String> _timeFilterOptions = [
    '오전 (09:00-12:00)',
    '점심 (12:00-13:00)',
    '오후 (13:00-18:00)',
    '저녁 (18:00-)',
  ];
  
  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate ?? DateTime.now();
    _loadReports();
  }
  
  Future<void> _loadReports() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final reports = await _reportService.getReportsByDate(_selectedDate);
      setState(() {
        _reports = reports;
        _applyFilters(); // 필터 적용
        _isLoading = false;
      });
    } catch (e) {
      print('회의실 예약 데이터 로드 오류: $e');
      setState(() {
        _isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('회의실 예약 데이터를 불러오는데 실패했습니다.'))
      );
    }
  }
  
  // 필터 적용 함수
  void _applyFilters() {
    setState(() {
      _filteredReports = _reports.where((report) {
        // 회의실 필터 적용
        bool passRoomFilter = _selectedRoomFilter == null || 
            report.getRoomNameText().contains(_selectedRoomFilter!);
        
        // 시간대 필터 적용
        bool passTimeFilter = true;
        if (_selectedTimeFilter != null) {
          final timeSlot = report.getTimeSlotText();
          switch (_selectedTimeFilter) {
            case '오전 (09:00-12:00)':
              passTimeFilter = timeSlot.contains('09:') || 
                  timeSlot.contains('10:') || 
                  timeSlot.contains('11:');
              break;
            case '점심 (12:00-13:00)':
              passTimeFilter = timeSlot.contains('12:');
              break;
            case '오후 (13:00-18:00)':
              passTimeFilter = timeSlot.contains('13:') || 
                  timeSlot.contains('14:') || 
                  timeSlot.contains('15:') || 
                  timeSlot.contains('16:') || 
                  timeSlot.contains('17:');
              break;
            case '저녁 (18:00-)':
              passTimeFilter = timeSlot.contains('18:') || 
                  timeSlot.contains('19:') || 
                  timeSlot.contains('20:') || 
                  timeSlot.contains('21:') || 
                  timeSlot.contains('22:');
              break;
          }
        }
        
        return passRoomFilter && passTimeFilter;
      }).toList();
    });
  }
  
  // 회의실 목록 가져오기
  List<String> _getRoomNames() {
    final Set<String> roomNames = {};
    for (var report in _reports) {
      roomNames.add(report.getRoomNameText());
    }
    return roomNames.toList()..sort();
  }
  
  // 필터 초기화
  void _resetFilters() {
    setState(() {
      _selectedRoomFilter = null;
      _selectedTimeFilter = null;
      _applyFilters();
    });
  }
  
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      locale: const Locale('ko', 'KR'),
    );
    
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      _loadReports();
    }
  }
  
  // HTML 태그를 제거하는 메소드
  String _formatHtmlText(String text) {
    // HTML 태그 및 <br> 태그 제거
    return text.replaceAll(RegExp(r'<br>|<.*?>'), ' ').trim();
  }
  
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? CarbonColors.gray100 : Colors.white;
    final textColor = isDarkMode ? Colors.white : CarbonColors.gray100;
    final dividerColor = isDarkMode ? CarbonColors.gray80 : CarbonColors.gray20;
    
    // SystemUiOverlayStyle 설정
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
            '회의실 예약 내역',
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          backgroundColor: backgroundColor,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: textColor),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: [
            // 필터 토글 버튼
            IconButton(
              icon: _showFilters 
                ? Icon(Icons.filter_alt, color: CarbonColors.blue60)
                : Icon(Icons.filter_alt_outlined, color: textColor),
              tooltip: _showFilters ? '필터 숨기기' : '필터 표시하기',
              onPressed: () {
                setState(() {
                  _showFilters = !_showFilters;
                });
              },
            ),
            // 달력 선택 버튼
            IconButton(
              icon: Icon(
                Icons.calendar_today,
                color: textColor,
              ),
              onPressed: () => _selectDate(context),
            ),
            // 새로고침 버튼
            IconButton(
              icon: Icon(
                Icons.refresh,
                color: textColor,
              ),
              onPressed: _loadReports,
            ),
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(_showFilters ? 80 : 48),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 선택된 날짜 표시
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () => _selectDate(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: CarbonColors.blue60.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: CarbonColors.blue60, width: 1),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.event,
                                size: 16,
                                color: CarbonColors.blue60,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                DateFormat('yyyy년 MM월 dd일 (E)', 'ko_KR').format(_selectedDate),
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: CarbonColors.blue60,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                Icons.arrow_drop_down,
                                size: 16,
                                color: CarbonColors.blue60,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                Divider(height: 1, color: dividerColor),
              ],
            ),
          ),
        ),
        body: Column(
          children: [
            // 필터 섹션을 바디로 이동 (보이거나 숨김)
            if (_showFilters)
              _buildFilterSection(),
              
            Expanded(
              child: RefreshIndicator(
                onRefresh: _loadReports,
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _filteredReports.isEmpty
                        ? _buildEmptyState()
                        : _buildReportsList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // 필터 섹션 위젯
  Widget _buildFilterSection() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDarkMode ? CarbonColors.gray90 : CarbonColors.gray10;
    final textColor = isDarkMode ? Colors.white : CarbonColors.gray100;
    
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: isDarkMode ? CarbonColors.gray80 : CarbonColors.gray20,
            width: 1,
          ),
        ),
        color: cardColor,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '필터 옵션',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: textColor,
                    ),
                  ),
                  TextButton.icon(
                    icon: Icon(Icons.refresh, size: 14),
                    label: Text('초기화', style: TextStyle(fontSize: 12)),
                    onPressed: _resetFilters,
                    style: TextButton.styleFrom(
                      foregroundColor: CarbonColors.blue60,
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              
              // 회의실 필터
              Text(
                '회의실:',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
              SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: FilterChip(
                          label: Text('전체'),
                          labelStyle: TextStyle(fontSize: 12),
                          labelPadding: EdgeInsets.symmetric(horizontal: 4),
                          padding: EdgeInsets.symmetric(horizontal: 2),
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          selected: _selectedRoomFilter == null,
                          onSelected: (selected) {
                            setState(() {
                              _selectedRoomFilter = null;
                              _applyFilters();
                            });
                          },
                          backgroundColor: cardColor,
                          selectedColor: CarbonColors.blue60.withOpacity(0.2),
                          checkmarkColor: CarbonColors.blue60,
                          visualDensity: VisualDensity.compact,
                        ),
                      ),
                      ..._getRoomNames().map((room) => Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: FilterChip(
                          label: Text(room),
                          labelStyle: TextStyle(fontSize: 12),
                          labelPadding: EdgeInsets.symmetric(horizontal: 4),
                          padding: EdgeInsets.symmetric(horizontal: 2),
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          selected: _selectedRoomFilter == room,
                          onSelected: (selected) {
                            setState(() {
                              _selectedRoomFilter = selected ? room : null;
                              _applyFilters();
                            });
                          },
                          backgroundColor: cardColor,
                          selectedColor: CarbonColors.blue60.withOpacity(0.2),
                          checkmarkColor: CarbonColors.blue60,
                          visualDensity: VisualDensity.compact,
                        ),
                      )).toList(),
                    ],
                  ),
                ),
              ),
              
              // 시간대 필터
              Text(
                '시간대:',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
              SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: FilterChip(
                          label: Text('전체'),
                          labelStyle: TextStyle(fontSize: 12),
                          labelPadding: EdgeInsets.symmetric(horizontal: 4),
                          padding: EdgeInsets.symmetric(horizontal: 2),
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          selected: _selectedTimeFilter == null,
                          onSelected: (selected) {
                            setState(() {
                              _selectedTimeFilter = null;
                              _applyFilters();
                            });
                          },
                          backgroundColor: cardColor,
                          selectedColor: CarbonColors.blue60.withOpacity(0.2),
                          checkmarkColor: CarbonColors.blue60,
                          visualDensity: VisualDensity.compact,
                        ),
                      ),
                      ..._timeFilterOptions.map((time) => Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: FilterChip(
                          label: Text(time),
                          labelStyle: TextStyle(fontSize: 12),
                          labelPadding: EdgeInsets.symmetric(horizontal: 4),
                          padding: EdgeInsets.symmetric(horizontal: 2),
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          selected: _selectedTimeFilter == time,
                          onSelected: (selected) {
                            setState(() {
                              _selectedTimeFilter = selected ? time : null;
                              _applyFilters();
                            });
                          },
                          backgroundColor: cardColor,
                          selectedColor: CarbonColors.blue60.withOpacity(0.2),
                          checkmarkColor: CarbonColors.blue60,
                          visualDensity: VisualDensity.compact,
                        ),
                      )).toList(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildReportsList() {
    // 시간순으로 정렬
    _filteredReports.sort((a, b) {
      if (a.useDate == null || b.useDate == null) return 0;
      // 같은 날짜인 경우 시간 슬롯으로 정렬 시도
      if (a.useDate!.compareTo(b.useDate!) == 0) {
        final aTime = a.timeSlot ?? '';
        final bTime = b.timeSlot ?? '';
        return aTime.compareTo(bTime);
      }
      return a.useDate!.compareTo(b.useDate!);
    });
    
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final dividerColor = isDarkMode ? CarbonColors.gray80 : CarbonColors.gray20;
    
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredReports.length,
      separatorBuilder: (context, index) => Divider(
        color: dividerColor,
        height: 1,
      ),
      itemBuilder: (context, index) {
        return _buildReportItem(_filteredReports[index]);
      },
    );
  }
  
  Widget _buildEmptyState() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : CarbonColors.gray100;
    final secondaryColor = isDarkMode ? Colors.white70 : CarbonColors.gray70;
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_busy_outlined,
            size: 64,
            color: secondaryColor,
          ),
          const SizedBox(height: 24),
          Text(
            '예약된 회의가 없습니다',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '다른 날짜를 선택해보세요',
            style: TextStyle(
              fontSize: 14,
              color: secondaryColor,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => _selectDate(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: CarbonColors.blue60,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.calendar_today, size: 16),
                const SizedBox(width: 8),
                Text('날짜 선택하기'),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildReportItem(Report report) {
    // 회의실 이름에 따라 색상 결정 (다양한 색상 사용)
    Color itemColor;
    String? roomName = report.roomName;
    
    if (roomName != null) {
      if (roomName.contains('대회의실')) {
        itemColor = CarbonColors.blue60;
      } else if (roomName.contains('소회의실')) {
        itemColor = CarbonColors.purple60;
      } else if (roomName.contains('세미나실')) {
        itemColor = CarbonColors.green50;
      } else if (roomName.contains('교육장')) {
        itemColor = CarbonColors.cyan60;
      } else {
        itemColor = CarbonColors.yellow30;
      }
    } else {
      itemColor = CarbonColors.gray60;
    }
    
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : CarbonColors.gray100;
    final secondaryColor = isDarkMode ? CarbonColors.gray60 : CarbonColors.gray70;
    
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MeetingReportDetailScreen(
              report: report,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 왼쪽 컬러 바
            Container(
              width: 4,
              height: 70,
              decoration: BoxDecoration(
                color: itemColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // 상태 태그
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: itemColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          report.status ?? '대기중',
                          style: TextStyle(
                            color: itemColor,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // 시간 정보
                      Text(
                        _formatHtmlText(report.timeSlot ?? ''),
                        style: TextStyle(
                          fontSize: 12,
                          color: secondaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  // 회의 제목
                  Text(
                    report.meetingTitle ?? '제목 없음',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // 신청자 및 부서 정보
                  Row(
                    children: [
                      Icon(
                        Icons.person_outline,
                        size: 14,
                        color: secondaryColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${_formatHtmlText(report.requester ?? '')} (${report.department ?? ''})',
                        style: TextStyle(
                          fontSize: 12,
                          color: secondaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // 회의실 정보
                  if (report.roomName != null && report.roomName!.isNotEmpty)
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 14,
                          color: secondaryColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatHtmlText(report.roomName ?? ''),
                          style: TextStyle(
                            fontSize: 12,
                            color: secondaryColor,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
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
} 