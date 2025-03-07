import 'dart:ui';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import '../utils/carbon_colors.dart';
import '../models/equipment_maintenance.dart';
import '../services/equipment_maintenance_service.dart';
import 'dart:convert';
import './maintenance_image_upload_screen.dart';
import '../main.dart';  // MainScreenState 접근을 위해

class FeedScreen extends StatefulWidget {
  final bool hideAppBar;
  final ScrollController? scrollController;
  final GlobalKey<_FeedScreenState> _key = GlobalKey<_FeedScreenState>();
  
  FeedScreen({Key? key, this.hideAppBar = false, this.scrollController}) : super(key: key);
  
  // 외부에서 호출 가능한 메서드
  void showCreateMaintenanceDialog(BuildContext context) {
    // 메인 클래스에서 사용할 Helper 메서드들
    Widget _buildMediaOption(
      BuildContext context,
      IconData icon,
      String label,
      VoidCallback onTap,
      bool isDarkMode,
    ) {
      return InkWell(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isDarkMode ? Colors.white : Colors.black87,
                size: 24,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
              ),
            ),
          ],
        ),
      );
    }
    
    void _showSnackMessage(BuildContext context, String message) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
    
    // 새로운 다이얼로그 표시
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? CarbonColors.gray100 : Colors.white;
    final textColor = isDarkMode ? Colors.white : CarbonColors.gray100;
    final borderColor = isDarkMode ? CarbonColors.gray80 : CarbonColors.gray20;
    
    // 필드 컨트롤러
    final descriptionController = TextEditingController();
    final equipmentIdController = TextEditingController(text: '1'); // 기본값
    String selectedActionType = '정기 점검'; // 기본값
    
    // 작업 유형 목록
    final actionTypes = ['정기 점검', '수리', '청소', '부품교체', '소프트웨어 업데이트', '기타'];
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 바텀 시트 핸들
                  Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isDarkMode ? Colors.grey[700] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  
                  // 제목
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        Text(
                          '유지보수 기록 작성',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: Icon(Icons.close, color: textColor),
                          onPressed: () => Navigator.pop(context),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                  ),
                  
                  // 장비 ID 입력 필드
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: TextField(
                      controller: equipmentIdController,
                      style: TextStyle(color: textColor),
                      decoration: InputDecoration(
                        labelText: '장비 ID',
                        labelStyle: TextStyle(color: textColor.withOpacity(0.7)),
                        hintText: '장비 ID를 입력하세요',
                        hintStyle: TextStyle(color: isDarkMode ? Colors.grey[400] : Colors.grey[600]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide(color: borderColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide(color: CarbonColors.blue60),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  
                  // 작업 유형 선택 드롭다운
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: DropdownButtonFormField<String>(
                      value: selectedActionType,
                      dropdownColor: backgroundColor,
                      style: TextStyle(color: textColor),
                      decoration: InputDecoration(
                        labelText: '작업 유형',
                        labelStyle: TextStyle(color: textColor.withOpacity(0.7)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide(color: borderColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide(color: CarbonColors.blue60),
                        ),
                      ),
                      items: actionTypes.map((String type) {
                        return DropdownMenuItem<String>(
                          value: type,
                          child: Text(
                            type,
                            style: TextStyle(color: textColor),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            selectedActionType = newValue;
                          });
                        }
                      },
                    ),
                  ),
                  
                  // 설명 입력 필드
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: TextField(
                      controller: descriptionController,
                      style: TextStyle(color: textColor),
                      decoration: InputDecoration(
                        labelText: '설명',
                        labelStyle: TextStyle(color: textColor.withOpacity(0.7)),
                        hintText: '유지보수 작업에 대한 설명을 입력하세요',
                        hintStyle: TextStyle(color: isDarkMode ? Colors.grey[400] : Colors.grey[600]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide(color: borderColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide(color: CarbonColors.blue60),
                        ),
                      ),
                      maxLines: 3,
                    ),
                  ),
                  
                  // 미디어 옵션 (이미지 추가)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildMediaOption(
                          context,
                          Icons.photo_library,
                          '이미지 추가',
                          () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => MaintenanceImageUploadScreen(
                                  maintenanceId: 1, // 임시 ID
                                  onImageUploaded: (image) {
                                    // 이미지 선택 후 처리 로직
                                    Navigator.pop(context);
                                    _showSnackMessage(context, '이미지가 선택되었습니다');
                                  },
                                ),
                              ),
                            );
                          },
                          isDarkMode,
                        ),
                      ],
                    ),
                  ),
                  
                  // 저장 버튼
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CarbonColors.blue60,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        onPressed: () {
                          // 유지보수 데이터 저장 로직 
                          Navigator.pop(context);
                          _showSnackMessage(context, '유지보수 기록이 저장되었습니다');
                        },
                        child: const Text(
                          '저장하기',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
  
  // 피드 게시물 작성 바텀시트를 표시하는 외부 메서드
  void showCreateFeedPost(BuildContext context) {
    // 내부 상태를 찾아 해당 메서드 호출
    final state = context.findAncestorStateOfType<_FeedScreenState>();
    if (state != null) {
      state.showCreateFeedPost(context);
    }
  }

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  // Mock data for posts
  final List<Post> _posts = [];
  final List<MaintenanceFeedItem> _maintenanceItems = [];
  final EquipmentMaintenanceService _maintenanceService = EquipmentMaintenanceService();
  bool _isLoading = true;
  String _errorMessage = '';
  
  // 미디어 옵션 버튼 구성 메서드
  Widget _buildMediaOption(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onTap,
    bool isDarkMode,
  ) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: isDarkMode ? Colors.white : Colors.black87,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
  
  // 스낵바 메시지 표시
  void _showSnackMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
  
  @override
  void initState() {
    super.initState();
    
    // // Generate sample posts
    _generateSamplePosts();
    
    // 유지보수 데이터 로드
    _loadMaintenanceData();
  }
  
  // 유지보수 데이터 로드
  Future<void> _loadMaintenanceData() async {
    try {
      print('유지보수 데이터 로딩 시작...');
      // 장비 ID 1번의 유지보수 데이터 로드 (실제로는 여러 장비 데이터를 조합해야 함)
      final maintenanceList = await _maintenanceService.getMaintenanceHistory(1);
      
      print('로드된 유지보수 데이터 개수: ${maintenanceList.length}');
      for (var item in maintenanceList) {
        print('유지보수 항목: ID=${item.id}, 이름=${item.equipmentName}, 유형=${item.actionType}, 댓글수=${item.commentCount}, 좋아요수=${item.likeCount}');
      }
      
      if (mounted) {
        setState(() {
          // 유지보수 데이터를 피드 아이템으로 변환
          _maintenanceItems.clear();
          for (var maintenance in maintenanceList) {
            _maintenanceItems.add(MaintenanceFeedItem(
              maintenance: maintenance,
            ));
          }
          
          print('피드 아이템으로 변환 완료: ${_maintenanceItems.length}개');
          _isLoading = false;
        });
      }
    } catch (e) {
      print('유지보수 데이터 로드 오류: $e');
      if (mounted) {
        setState(() {
          _errorMessage = '유지보수 데이터를 불러오는 중 오류가 발생했습니다: $e';
          _isLoading = false;
        });
      }
    }
  }
  
  void _generateSamplePosts() {
    final user1 = User(
      id: '1',
      name: '김민준',
      avatar: 'assets/avatars/user1.png',
      username: 'minjun_kim',
      department: '음향실'
    );
    
    final user2 = User(
      id: '2',
      name: '이서연',
      avatar: 'assets/avatars/user2.png',
      username: 'seoyeon_lee',
      department: '음향실'
    );
    
    final user3 = User(
      id: '3',
      name: '박지훈',
      avatar: 'assets/avatars/user3.png',
      username: 'jihoon_park',
      department: '음향실'
    );
    
    _posts.add(
      Post(
        id: '1',
        user: user1,
        content: '오늘 A동 대회의실 마이크 시스템 점검 완료했습니다. 무선 마이크 2개 배터리 교체하고, 수신기 위치 조정했습니다. 다음 주 화요일 경영진 회의 준비 완료했습니다.',
        images: ['assets/images/mic_setup1.jpg', 'assets/images/mic_setup2.jpg'],
        location: 'A동 대회의실',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        comments: [
          Comment(
            id: '1',
            user: user2,
            content: '고생하셨습니다. 회의 때 음향 담당은 제가 할게요.',
            timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 45)),
          ),
          Comment(
            id: '2',
            user: user1,
            content: '네, 알겠습니다. 회의 시작 30분 전에 미리 준비해주세요.',
            timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 30)),
          ),
        ],
        likes: 24,
      ),
    );
    
    _posts.add(
      Post(
        id: '2',
        user: user2,
        content: 'B동 교육장 빔프로젝터 설치 완료했습니다. HDMI와 무선 연결 모두 테스트 완료했습니다. 내일 신입사원 교육 준비 완료했습니다.',
        images: ['assets/images/projector_setup.jpg'],
        location: 'B동 교육장',
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        comments: [],
        likes: 8,
      ),
    );
    
    _posts.add(
      Post(
        id: '3',
        user: user3,
        content: 'C동 회의실 3, 4, 5 음향 시스템 전체 점검했습니다. 회의실 4의 스피커에서 간헐적으로 노이즈가 발생하는 문제가 있어 케이블 교체했습니다. 현재는 정상 작동 확인했습니다.',
        images: [],
        location: 'C동 회의실',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        comments: [
          Comment(
            id: '3',
            user: user1,
            content: '회의실 4 스피커 문제 해결해주셔서 감사합니다. 지난 주 회의 때 노이즈 때문에 불편했었는데요.',
            timestamp: DateTime.now().subtract(const Duration(hours: 23)),
          ),
        ],
        likes: 5,
      ),
    );
    
    _posts.add(
      Post(
        id: '4',
        user: user1,
        content: '업무용 장비 재고 현황 업데이트했습니다. 무선마이크 배터리 재고가 부족하니 추가 구매 필요합니다. 발주 요청 올렸습니다.',
        images: ['assets/images/inventory.jpg'],
        location: '음향실 사무실',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        comments: [
          Comment(
            id: '4',
            user: user3,
            content: '발주 승인 처리했습니다. 다음 주 화요일에 입고 예정입니다.',
            timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 22)),
          ),
        ],
        likes: 3,
      ),
    );
  }

  // 유지보수 상세 정보 표시
  void _showMaintenanceDetail(Maintenance maintenance) {
    // 상세 정보 화면으로 이동 또는 바텀 시트 표시
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? CarbonColors.gray100 : Colors.white;
    final textColor = isDarkMode ? Colors.white : CarbonColors.gray100;
    final borderColor = isDarkMode ? CarbonColors.gray80 : CarbonColors.gray20;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
        backgroundColor: backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.8,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 제목 및 닫기 버튼
                    Row(
                      children: [
                        Text(
                          '유지보수 상세 정보',
            style: TextStyle(
                            fontSize: 18,
              fontWeight: FontWeight.w600,
              color: textColor,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: Icon(Icons.close, color: CarbonColors.gray60),
                          onPressed: () => Navigator.pop(context),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // 장비 정보
                    _buildDetailItem('장비 정보', '${maintenance.equipmentName} (${maintenance.equipmentModel})', textColor),
                    _buildDetailItem('제조사', maintenance.manufacturer, textColor),
                    
                    // 작업 정보
                    _buildDetailItem('작업 유형', maintenance.actionType, textColor),
                    _buildDetailItem('작업 날짜', maintenance.date, textColor),
                    _buildDetailItem('작업 시간', maintenance.time, textColor),
                    _buildDetailItem('소요 시간', maintenance.duration, textColor),
                    
                    // 작업 내용
                    _buildDetailItem('작업 내용', maintenance.issuesFound ?? '', textColor),
                    if (maintenance.resolution != null && maintenance.resolution!.isNotEmpty)
                      _buildDetailItem('조치 사항', maintenance.resolution!, textColor),
                    
                    // 작업자
                    _buildDetailItem('작업자', maintenance.workedBy ?? '', textColor),
                    
                    const SizedBox(height: 24),
                    
                    // 이미지 업로드 버튼
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.add_a_photo),
                        label: const Text('이미지 추가'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CarbonColors.blue60,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
              onPressed: () {
                          Navigator.pop(context);
                          _navigateToImageUpload(maintenance.id);
              },
                      ),
            ),
          ],
        ),
              ),
            );
          },
        );
      },
    );
  }

  // 상세 정보 항목 위젯
  Widget _buildDetailItem(String label, String value, Color textColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: CarbonColors.gray60,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : CarbonColors.gray100;
    final backgroundColor = isDarkMode ? CarbonColors.gray100 : Colors.white;
    
    return Scaffold(
      backgroundColor: backgroundColor,
      // AppBar는 MainScreen으로 옮겨 중앙 관리함
      // 필요한 경우에만 AppBar 사용
      appBar: widget.hideAppBar ? null : AppBar(
        backgroundColor: backgroundColor.withOpacity(0.85),
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              color: Colors.transparent,
            ),
          ),
        ),
        title: Text(
          '피드',
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_outlined, color: textColor),
            onPressed: () {
              // Show notifications
            },
          ),
          IconButton(
            icon: Icon(Icons.search, color: textColor),
            onPressed: () {
              // Show search
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showCreateFeedPost(context),
        backgroundColor: CarbonColors.blue60,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _errorMessage,
                          style: TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadMaintenanceData,
                          child: const Text('다시 시도'),
                        ),
                      ],
                    ),
                  ),
                )
              : ListView.builder(
                  controller: widget.scrollController,
                  itemCount: _maintenanceItems.length,
                  itemBuilder: (context, index) {
                    final item = _maintenanceItems[index];
                    return InkWell(
                      onTap: () => _showMaintenanceDetail(item.maintenance),
                      child: _buildMaintenanceCard(item.maintenance, isDarkMode),
                    );
                  },
      ),
    );
  }

  // 유지보수 카드 위젯
  Widget _buildMaintenanceCard(Maintenance maintenance, bool isDarkMode) {
    final textColor = isDarkMode ? Colors.white : CarbonColors.gray100;
    final backgroundColor = isDarkMode ? CarbonColors.gray90 : Colors.white;
    final borderColor = isDarkMode ? CarbonColors.gray80 : CarbonColors.gray20;
    
    // 액션 타입 아이콘 설정
    IconData actionIcon;
    Color actionColor;
    
    // 작업 유형에 따른 아이콘 및 색상 설정
    switch (maintenance.actionType.toLowerCase()) {
      case '정기점검':
      case '정기 점검':
      case '예정된 점검':
        actionIcon = Icons.check_circle;
        actionColor = Colors.blue;
        break;
      case '수리':
        actionIcon = Icons.build;
        actionColor = Colors.orange;
        break;
      case '청소':
        actionIcon = Icons.cleaning_services;
        actionColor = Colors.green;
        break;
      case '부품교체':
        actionIcon = Icons.swap_horiz;
        actionColor = Colors.purple;
        break;
      case '소프트웨어 업데이트':
        actionIcon = Icons.system_update;
        actionColor = Colors.teal;
        break;
      default:
        actionIcon = Icons.note;
        actionColor = Colors.grey;
    }

    // 날짜 변환
    final date = DateTime.parse(maintenance.createdAt);
    final formatter = DateFormat('yyyy. M. d');
    final timeFormatter = DateFormat('HH:mm');
    final formattedDate = formatter.format(date);
    final formattedTime = timeFormatter.format(date);
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: borderColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      color: backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 헤더 (사용자 정보)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 프로필 사진
                CircleAvatar(
                  radius: 20,
                  backgroundColor: CarbonColors.blue60,
                  child: Text(
                    maintenance.workedBy != null && maintenance.workedBy!.isNotEmpty
                        ? maintenance.workedBy!.substring(0, 1)
                        : '?',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 12),
                // 사용자 정보 및 날짜
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            maintenance.workedBy ?? '관리자',
                            style: TextStyle(
                              fontWeight: FontWeight.bold, 
                              color: textColor
                            ),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              '· $formattedDate $formattedTime',
                              style: TextStyle(
                                color: CarbonColors.gray60,
                                fontSize: 13,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      // 장비 정보
                      Text(
                        '장비: ${maintenance.equipmentName}',
                        style: TextStyle(
                          color: CarbonColors.gray60,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                // 작업 유형 아이콘
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: actionColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    actionIcon,
                    size: 16,
                    color: actionColor,
                  ),
                ),
              ],
            ),
            
            // 내용
            Padding(
              padding: const EdgeInsets.only(left: 52, top: 8),
              child: Text(
                maintenance.issuesFound ?? maintenance.resolution ?? '유지보수 내용 없음',
                style: TextStyle(color: textColor),
              ),
            ),
            
            // 하단 상호작용 버튼들
            Padding(
              padding: const EdgeInsets.only(left: 40, top: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildInteractionButton(
                    Icons.chat_bubble_outline,
                    maintenance.commentCount.toString(),
                    () {}, // 댓글 기능
                    isDarkMode,
                  ),
                  _buildInteractionButton(
                    Icons.repeat,
                    '',
                    () {}, // 리포스트 기능
                    isDarkMode,
                  ),
                  _buildInteractionButton(
                    Icons.favorite_border,
                    maintenance.likeCount.toString(),
                    () {}, // 좋아요 기능
                    isDarkMode,
                  ),
                  _buildInteractionButton(
                    Icons.share_outlined,
                    '',
                    () {}, // 공유 기능
                    isDarkMode,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 상호작용 버튼 생성
  Widget _buildInteractionButton(
    IconData icon, 
    String count, 
    VoidCallback onTap,
    bool isDarkMode,
  ) {
    final buttonColor = isDarkMode ? Colors.grey[400] : Colors.grey[600];
    
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 16, color: buttonColor),
          if (count.isNotEmpty) const SizedBox(width: 4),
          if (count.isNotEmpty)
            Text(
              count,
              style: TextStyle(
                fontSize: 13,
                color: buttonColor,
              ),
            ),
        ],
      ),
    );
  }

  // 유지보수 이미지 표시 위젯
  Widget _buildMaintenanceImage(MaintenanceImage image) {
    // base64 이미지 데이터가 있으면 그것을 사용
    if (image.imageData != null && image.imageData!.isNotEmpty) {
      return Image.memory(
        _decodeBase64Image(image.imageData!),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          print('이미지 로드 오류: $error');
          return _buildImagePlaceholder();
        },
      );
    }
    // URL 기반 이미지가 있으면 그것을 사용 (레거시 지원)
    else if (image.imagePath != null && image.imagePath!.isNotEmpty) {
      return Image.network(
        image.imagePath!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          print('이미지 로드 오류: $error');
          return _buildImagePlaceholder();
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return _buildImageLoadingIndicator();
        },
      );
    }
    // 둘 다 없으면 플레이스홀더 표시
    else {
      return _buildImagePlaceholder();
    }
  }
  
  // 이미지 로딩 인디케이터
  Widget _buildImageLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
  
  // 이미지 플레이스홀더
  Widget _buildImagePlaceholder() {
    return Container(
      color: Colors.grey[200],
      child: Center(
        child: Icon(
          Icons.image,
          size: 48,
          color: Colors.grey[400],
        ),
      ),
    );
  }
  
  // Base64 이미지 데이터 디코딩
  Uint8List _decodeBase64Image(String base64String) {
    // data:image/jpeg;base64, 형식에서 실제 base64 부분만 추출
    String dataString = base64String;
    if (base64String.contains(',')) {
      dataString = base64String.split(',')[1];
    }
    
    try {
      return base64Decode(dataString);
    } catch (e) {
      print('Base64 디코딩 오류: $e');
      // 오류 시 1x1 투명 픽셀 반환
      return Uint8List.fromList([0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A]);
    }
  }
  
  // 유지보수 옵션 모달
  void _showMaintenanceOptions(Maintenance maintenance) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? CarbonColors.gray90 : Colors.white;
    final textColor = isDarkMode ? Colors.white : CarbonColors.gray100;
    
    showModalBottomSheet(
      context: context,
      backgroundColor: backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: CarbonColors.gray60,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              _buildOptionItem(
                icon: Icons.visibility,
                text: '상세 정보 보기',
                onTap: () {
                  Navigator.pop(context);
                  _showMaintenanceDetail(maintenance);
                },
              ),
              _buildOptionItem(
                icon: Icons.image,
                text: '이미지 추가',
                onTap: () {
                  Navigator.pop(context);
                  _navigateToImageUpload(maintenance.id);
                },
              ),
              _buildOptionItem(
                icon: Icons.edit,
                text: '수정하기',
                onTap: () {
                  Navigator.pop(context);
                  // Edit maintenance - 미구현
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('수정 기능은 아직 준비 중입니다')),
                  );
                },
              ),
              _buildOptionItem(
                icon: Icons.delete,
                text: '삭제하기',
                onTap: () {
                  Navigator.pop(context);
                  // Delete maintenance - 미구현
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('삭제 기능은 아직 준비 중입니다')),
                  );
                },
                isDestructive: true,
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
  
  // 옵션 아이템 위젯
  Widget _buildOptionItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDestructive 
        ? Colors.red
        : (isDarkMode ? Colors.white : CarbonColors.gray100);
    
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Row(
          children: [
            Icon(icon, color: textColor, size: 20),
            const SizedBox(width: 16),
            Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: textColor,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 이미지 업로드 화면으로 이동
  void _navigateToImageUpload(int maintenanceId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MaintenanceImageUploadScreen(
          maintenanceId: maintenanceId,
          onImageUploaded: (image) {
            // 이미지가 업로드되면 데이터 다시 로드
            _loadMaintenanceData();
          },
        ),
      ),
    );
  }

  // 피드 게시물 작성 바텀시트 표시
  void showCreateFeedPost(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? CarbonColors.gray100 : Colors.white;
    final textColor = isDarkMode ? Colors.white : CarbonColors.gray100;
    final hintColor = isDarkMode ? Colors.grey[400] : Colors.grey[500];
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              left: 20,
              right: 20,
              top: 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 상단 바 - 제목과 닫기 버튼
                Row(
                  children: [
                    Text(
                      '새 게시물 작성',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                    Spacer(),
                    IconButton(
                      icon: Icon(Icons.close, color: textColor),
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                
                SizedBox(height: 20),
                
                // 프로필 및 입력 필드
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 프로필 이미지 (원형)
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: CarbonColors.blue60,
                      child: Text(
                        'A',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // 입력 필드 (확장)
                    Expanded(
                      child: TextField(
                        style: TextStyle(
                          color: textColor,
                          fontSize: 16,
                        ),
                        decoration: InputDecoration(
                          hintText: '무슨 일이 일어나고 있나요?',
                          hintStyle: TextStyle(
                            color: hintColor,
                            fontSize: 16,
                          ),
                          border: InputBorder.none,
                        ),
                        maxLines: 5,
                        minLines: 3,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // 미디어 옵션 및 게시 버튼
                Row(
                  children: [
                    // 미디어 옵션들
                    _buildMediaOptionButton(
                      Icons.photo_library,
                      '갤러리',
                      () => _pickImageFromGallery(context),
                      isDarkMode,
                    ),
                    const SizedBox(width: 16),
                    _buildMediaOptionButton(
                      Icons.camera_alt,
                      '카메라',
                      () => _pickImageFromCamera(context),
                      isDarkMode,
                    ),
                    const SizedBox(width: 16),
                    _buildMediaOptionButton(
                      Icons.location_on,
                      '위치', 
                      () => _showSnackMessage(context, '위치 기능이 준비 중입니다'),
                      isDarkMode,
                    ),
                    
                    const Spacer(),
                    
                    // 게시 버튼
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CarbonColors.blue60,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        _showSnackMessage(context, '게시물이 공유되었습니다');
                      },
                      child: Text(
                        '게시하기',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  // 미디어 옵션 버튼 위젯
  Widget _buildMediaOptionButton(
    IconData icon,
    String label,
    VoidCallback onTap,
    bool isDarkMode,
  ) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: CarbonColors.blue60,
              size: 20,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  // 갤러리에서 이미지 선택
  void _pickImageFromGallery(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      
      if (image != null) {
        Navigator.pop(context);
        _showImagePreview(context, image);
      }
    } catch (e) {
      print('갤러리 이미지 선택 오류: $e');
      _showSnackMessage(context, '이미지를 선택하는 중에 오류가 발생했습니다');
    }
  }
  
  // 카메라로 사진 촬영
  void _pickImageFromCamera(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? photo = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );
      
      if (photo != null) {
        Navigator.pop(context);
        _showImagePreview(context, photo);
      }
    } catch (e) {
      print('카메라 이미지 촬영 오류: $e');
      _showSnackMessage(context, '사진을 촬영하는 중에 오류가 발생했습니다');
    }
  }
  
  // 이미지 미리보기 표시
  void _showImagePreview(BuildContext context, XFile imageFile) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? CarbonColors.gray100 : Colors.white;
    final textColor = isDarkMode ? Colors.white : CarbonColors.gray100;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 16,
                right: 16,
                top: 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 상단 프로필 및 게시 버튼 행
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 프로필 이미지 (원형)
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: CarbonColors.blue60,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      const SizedBox(width: 12),
                      // 입력 필드 (확장)
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextField(
                              style: TextStyle(color: textColor),
                              decoration: InputDecoration(
                                hintText: '무슨 일이 일어나고 있나요?',
                                hintStyle: TextStyle(color: isDarkMode ? Colors.grey[400] : Colors.grey[600]),
                                border: InputBorder.none,
                              ),
                              maxLines: 5,
                              minLines: 1,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // 이미지 미리보기 (둥근 모서리)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Stack(
                      children: [
                        Image.file(
                          File(imageFile.path),
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 250,
                        ),
                        Positioned(
                          right: 8,
                          top: 8,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black.withOpacity(0.6),
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.close, color: Colors.white, size: 18),
                              onPressed: () {
                                Navigator.pop(context);
                                showCreateFeedPost(context);
                              },
                              constraints: const BoxConstraints(
                                minWidth: 30,
                                minHeight: 30,
                              ),
                              padding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // 미디어 옵션 및 게시 버튼
                  Row(
                    children: [
                      // 미디어 옵션들
                      IconButton(
                        icon: Icon(Icons.photo_library, color: CarbonColors.blue60),
                        onPressed: () {
                          Navigator.pop(context);
                          _pickImageFromGallery(context);
                        },
                        iconSize: 22,
                      ),
                      IconButton(
                        icon: Icon(Icons.gif_box, color: CarbonColors.blue60),
                        onPressed: () => _showSnackMessage(context, 'GIF 기능이 준비 중입니다'),
                        iconSize: 22,
                      ),
                      IconButton(
                        icon: Icon(Icons.location_on, color: CarbonColors.blue60),
                        onPressed: () => _showSnackMessage(context, '위치 기능이 준비 중입니다'),
                        iconSize: 22,
                      ),
                      
                      const Spacer(),
                      
                      // 게시 버튼 (둥근 버튼)
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CarbonColors.blue60,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          minimumSize: Size(80, 36),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          _showSnackMessage(context, '게시물이 공유되었습니다');
                        },
                        child: const Text('게시', style: TextStyle(fontSize: 14)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

// 피드 아이템 추상 클래스
abstract class FeedItem {
  DateTime get timestamp;
}

// 포스트 피드 아이템
class PostFeedItem extends FeedItem {
  final Post post;
  
  PostFeedItem({required this.post});
  
  @override
  DateTime get timestamp => post.timestamp;
}

// 유지보수 피드 아이템
class MaintenanceFeedItem extends FeedItem {
  final Maintenance maintenance;
  
  MaintenanceFeedItem({
    required this.maintenance, 
  });
  
  @override
  DateTime get timestamp => DateTime.parse(maintenance.createdAt);
}

class User {
  final String id;
  final String name;
  final String avatar;
  final String department;
  final String username;
  
  const User({
    required this.id,
    required this.name,
    required this.avatar,
    required this.department,
    required this.username,
  });
}

class Post {
  final String id;
  final User user;
  final String content;
  final List<String> images;
  final String location;
  final DateTime timestamp;
  final List<Comment> comments;
  final int likes;
  
  const Post({
    required this.id,
    required this.user,
    required this.content,
    required this.images,
    required this.location,
    required this.timestamp,
    required this.comments,
    required this.likes,
  });
}

class Comment {
  final String id;
  final User user;
  final String content;
  final DateTime timestamp;
  
  const Comment({
    required this.id,
    required this.user,
    required this.content,
    required this.timestamp,
  });
} 