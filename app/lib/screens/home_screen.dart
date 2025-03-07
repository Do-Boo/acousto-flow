import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import '../utils/carbon_colors.dart';
import '../services/restaurant_service.dart';
import '../models/restaurant_menu.dart';

class HomeScreen extends StatefulWidget {
  final bool hideAppBar;
  final ScrollController? scrollController;
  
  HomeScreen({Key? key, this.hideAppBar = false, this.scrollController}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // RestaurantService 추가
  final RestaurantService _restaurantService = RestaurantService();
  List<RestaurantMenu> _todayMenus = [];
  bool _isLoadingMenu = false;

  @override
  void initState() {
    super.initState();
    _loadTodayMenu();
  }
  
  // 오늘의 메뉴 로드 함수
  Future<void> _loadTodayMenu() async {
    setState(() {
      _isLoadingMenu = true;
    });
    
    try {
      // 실제 서버에서 메뉴 데이터 불러오기
      final menus = await _restaurantService.getTodayMenu();
      
      setState(() {
        _todayMenus = [menus]; // RestaurantMenu를 List<RestaurantMenu>로 변환
        _isLoadingMenu = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingMenu = false;
        _todayMenus = []; // 오류 발생 시 빈 리스트로 초기화
      });
      print('Error loading today menu: $e');
      
      // 에러 발생 시 스낵바 표시
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('메뉴 정보를 불러오는 데 실패했습니다.'),
            backgroundColor: CarbonColors.red60,
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  // 지금 이 함수는 샘플 데이터를 리턴하지만, 실제로는 캘린더 서비스/컨트롤러에서 가져와야 합니다
  List<Map<String, dynamic>> _getTodayEvents() {
    return [
      {
        'title': '경영진 회의 지원',
        'location': 'A동 대회의실',
        'time': '10:00 - 12:00',
        'type': 'meeting',
        'color': CarbonColors.blue60,
      },
      {
        'title': '프로젝터 점검',
        'location': 'B동 세미나실',
        'time': '14:00 - 15:00',
        'type': 'equipment',
        'color': CarbonColors.yellow30,
      },
      {
        'title': '마케팅팀 워크숍 음향 설치',
        'location': 'C동 다목적홀',
        'time': '16:00 - 18:00',
        'type': 'equipment',
        'color': CarbonColors.green50,
      },
    ];
  }

  // 회의실 상태 샘플 데이터
  List<Map<String, dynamic>> _getRoomStatus() {
    return [
      {
        'name': 'A동 대회의실',
        'status': '사용 중',
        'until': '12:00',
        'isAvailable': false,
      },
      {
        'name': 'B동 세미나실',
        'status': '사용 중',
        'until': '15:00',
        'isAvailable': false,
      },
      {
        'name': 'C동 다목적홀',
        'status': '예약 대기',
        'until': '16:00',
        'isAvailable': true,
      },
      {
        'name': 'A동 소회의실 1',
        'status': '사용 가능',
        'until': '',
        'isAvailable': true,
      },
      {
        'name': 'A동 소회의실 2',
        'status': '사용 가능',
        'until': '',
        'isAvailable': true,
      },
    ];
  }

  // 최근 피드 게시물 샘플 데이터
  List<Map<String, dynamic>> _getRecentPosts() {
    return [
      {
        'author': '김민준',
        'department': '음향실',
        'content': 'A동 대회의실 마이크 시스템 점검 완료했습니다. 무선 마이크 2개 배터리 교체하고, 수신기 위치 조정했습니다.',
        'time': '2시간 전',
        'likes': 24,
        'comments': 2,
      },
      {
        'author': '이서연',
        'department': '음향실',
        'content': 'B동 교육장 빔프로젝터 설치 완료했습니다. HDMI와 무선 연결 모두 테스트 완료했습니다.',
        'time': '5시간 전',
        'likes': 8,
        'comments': 0,
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? CarbonColors.gray100 : Colors.white;
    final textColor = isDarkMode ? Colors.white : CarbonColors.gray100;
    final secondaryColor = isDarkMode ? CarbonColors.gray60 : CarbonColors.gray70;
    
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: isDarkMode
          ? SystemUiOverlayStyle.light.copyWith(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.light,
              statusBarBrightness: Brightness.dark,
              systemNavigationBarColor: backgroundColor,
            )
          : SystemUiOverlayStyle.dark.copyWith(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.dark,
              statusBarBrightness: Brightness.light,
              systemNavigationBarColor: backgroundColor,
            ),
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: RefreshIndicator(
          onRefresh: () async {
            // 데이터 새로고침
            await Future.delayed(const Duration(seconds: 1));
            _loadTodayMenu();
            setState(() {});
          },
          color: CarbonColors.blue60,
          child: AnnotatedRegion<SystemUiOverlayStyle>(
            value: isDarkMode
                ? SystemUiOverlayStyle.light.copyWith(
                    statusBarColor: Colors.transparent,
                    statusBarIconBrightness: Brightness.light,
                    statusBarBrightness: Brightness.dark,
                  )
                : SystemUiOverlayStyle.dark.copyWith(
                    statusBarColor: Colors.transparent,
                    statusBarIconBrightness: Brightness.dark,
                    statusBarBrightness: Brightness.light,
                  ),
            child: SingleChildScrollView(
              controller: widget.scrollController,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 환영 메시지 및 날짜
                  Text(
                    '안녕하세요, 김도유님',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('yyyy년 MM월 dd일 EEEE', 'ko_KR').format(DateTime.now()),
                    style: TextStyle(
                      fontSize: 14,
                      color: secondaryColor,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // 구내식당 메뉴 섹션을 가장 먼저 표시
                  _buildSectionHeader('오늘의 메뉴', '전체 보기', () {
                    Get.toNamed('/restaurant');
                  }),
                  const SizedBox(height: 12),
                  _buildTodayMenu(),
                  const SizedBox(height: 24),
                  
                  // 오늘의 일정 섹션
                  _buildSectionHeader('오늘의 일정', '더 보기', () {
                    Get.toNamed('/calendar');
                  }),
                  const SizedBox(height: 12),
                  _buildTodayEvents(),
                  const SizedBox(height: 24),
                  
                  // 회의실 현황 섹션
                  _buildSectionHeader('회의실 현황', '모두 보기', () {
                    Get.toNamed('/meeting-rooms');
                  }),
                  const SizedBox(height: 12),
                  _buildRoomStatus(),
                  const SizedBox(height: 24),
                  
                  // 최근 활동 피드
                  _buildSectionHeader('최근 피드', '더 보기', () {
                    Get.toNamed('/feed');
                  }),
                  const SizedBox(height: 12),
                  _buildRecentPosts(),
                  const SizedBox(height: 24),
                  
                  // 빠른 액션 버튼들
                  _buildQuickActions(),
                  const SizedBox(height: 88),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, String actionText, VoidCallback onAction) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : CarbonColors.gray100;
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        TextButton(
          onPressed: onAction,
          style: TextButton.styleFrom(
            foregroundColor: CarbonColors.blue60,
            padding: EdgeInsets.zero,
            minimumSize: const Size(0, 36),
          ),
          child: Text(
            actionText,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTodayEvents() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : CarbonColors.gray100;
    final secondaryColor = isDarkMode ? CarbonColors.gray60 : CarbonColors.gray70;
    final events = _getTodayEvents();
    
    if (events.isEmpty) {
      return _buildEmptyState(
        icon: Icons.calendar_today,
        message: '오늘은 일정이 없습니다',
        buttonText: '일정 추가하기',
        onButtonPressed: () {
          Get.toNamed('/calendar');
        },
      );
    }
    
    return Column(
      children: events.map((event) {
        final Color eventColor = event['color'] as Color;
        return Card(
          elevation: 0,
          color: isDarkMode ? CarbonColors.gray90 : CarbonColors.gray10,
          margin: const EdgeInsets.only(bottom: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 4,
                  height: 40,
                  decoration: BoxDecoration(
                    color: eventColor,
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
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: eventColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              event['time'] as String,
                              style: TextStyle(
                                color: eventColor,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            event['location'] as String,
                            style: TextStyle(
                              fontSize: 12,
                              color: secondaryColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        event['title'] as String,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildRoomStatus() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : CarbonColors.gray100;
    final secondaryColor = isDarkMode ? CarbonColors.gray60 : CarbonColors.gray70;
    final rooms = _getRoomStatus();
    
    if (rooms.isEmpty) {
      return _buildEmptyState(
        icon: Icons.meeting_room,
        message: '회의실 정보가 없습니다',
        buttonText: '회의실 확인하기',
        onButtonPressed: () {
          Get.toNamed('/meeting-rooms');
        },
      );
    }
    
    return Container(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: rooms.length,
        itemBuilder: (context, index) {
          final room = rooms[index];
          final bool isAvailable = room['isAvailable'] as bool;
          
          return Container(
            width: 180,
            margin: EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: isDarkMode ? CarbonColors.gray90 : CarbonColors.gray10,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isAvailable ? CarbonColors.green50 : CarbonColors.red60,
                width: 1,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    room['name'] as String,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: textColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    children: [
                      Icon(
                        isAvailable ? Icons.check_circle : Icons.cancel,
                        size: 16,
                        color: isAvailable ? CarbonColors.green50 : CarbonColors.red60,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        room['status'] as String,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: isAvailable ? CarbonColors.green50 : CarbonColors.red60,
                        ),
                      ),
                      if (!isAvailable && room['until'].toString().isNotEmpty) ...[
                        const SizedBox(width: 4),
                        Text(
                          '(${room['until']}까지)',
                          style: TextStyle(
                            fontSize: 12,
                            color: secondaryColor,
                          ),
                        ),
                      ]
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRecentPosts() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : CarbonColors.gray100;
    final secondaryColor = isDarkMode ? CarbonColors.gray60 : CarbonColors.gray70;
    final posts = _getRecentPosts();
    
    if (posts.isEmpty) {
      return _buildEmptyState(
        icon: Icons.comment,
        message: '최근 피드가 없습니다',
        buttonText: '새 글 작성하기',
        onButtonPressed: () {
          Get.toNamed('/feed');
        },
      );
    }
    
    return Column(
      children: posts.map((post) {
        return Card(
          elevation: 0,
          color: isDarkMode ? CarbonColors.gray90 : CarbonColors.gray10,
          margin: const EdgeInsets.only(bottom: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _buildAvatar(post['author'].toString()[0]),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post['author'] as String,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: textColor,
                          ),
                        ),
                        Text(
                          post['department'] as String,
                          style: TextStyle(
                            fontSize: 12,
                            color: secondaryColor,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Text(
                      post['time'] as String,
                      style: TextStyle(
                        fontSize: 12,
                        color: secondaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  post['content'] as String,
                  style: TextStyle(
                    fontSize: 14,
                    color: textColor,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.thumb_up_outlined,
                      size: 16,
                      color: secondaryColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      post['likes'].toString(),
                      style: TextStyle(
                        fontSize: 12,
                        color: secondaryColor,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(
                      Icons.comment_outlined,
                      size: 16,
                      color: secondaryColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      post['comments'].toString(),
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
        );
      }).toList(),
    );
  }

  Widget _buildAvatar(String initial) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: CarbonColors.blue60,
        borderRadius: BorderRadius.circular(4),
      ),
      alignment: Alignment.center,
      child: Text(
        initial,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildActionButton(
          label: '회의실 예약',
          icon: Icons.meeting_room,
          onPressed: () {
            Get.toNamed('/meeting-rooms');
          },
        ),
        _buildActionButton(
          label: '일정 추가',
          icon: Icons.calendar_today,
          onPressed: () {
            Get.toNamed('/calendar');
          },
        ),
        _buildActionButton(
          label: '글 작성',
          icon: Icons.edit,
          onPressed: () {
            Get.toNamed('/feed');
          },
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : CarbonColors.gray100;
    
    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: Ink(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: CarbonColors.blue60.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: InkWell(
              onTap: onPressed,
              customBorder: CircleBorder(),
              child: Center(
                child: Icon(
                  icon,
                  color: CarbonColors.blue60,
                  size: 24,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: textColor,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String message,
    required String buttonText,
    required VoidCallback onButtonPressed,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : CarbonColors.gray100;
    final secondaryColor = isDarkMode ? CarbonColors.gray60 : CarbonColors.gray70;
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 36,
            color: secondaryColor,
          ),
          const SizedBox(height: 12),
          Text(
            message,
            style: TextStyle(
              fontSize: 14,
              color: secondaryColor,
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: onButtonPressed,
            style: TextButton.styleFrom(
              foregroundColor: CarbonColors.blue60,
            ),
            child: Text(buttonText),
          ),
        ],
      ),
    );
  }

  // 오늘의 메뉴 위젯 구현
  Widget _buildTodayMenu() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : CarbonColors.gray100;
    final secondaryColor = isDarkMode ? CarbonColors.gray60 : CarbonColors.gray70;
    final cardColor = isDarkMode ? CarbonColors.gray90 : Colors.white;
    final borderColor = isDarkMode ? CarbonColors.gray80 : CarbonColors.gray20;
    
    if (_isLoadingMenu) {
      return Container(
        height: 120,
        alignment: Alignment.center,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(CarbonColors.blue60),
        ),
      );
    }
    
    if (_todayMenus.isEmpty) {
      return _buildEmptyState(
        icon: Icons.restaurant,
        message: '오늘의 메뉴 정보가 없습니다.',
        buttonText: '메뉴 보기',
        onButtonPressed: () {
          Get.toNamed('/restaurant');
        },
      );
    }
    
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _todayMenus.length,
        itemBuilder: (context, index) {
          final menu = _todayMenus[index];
          
          return Container(
            width: 240,
            margin: EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: borderColor,
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: InkWell(
              onTap: () {
                Get.toNamed('/restaurant');
              },
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 식사 유형 및 날짜 표시
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getMealTypeColor(menu.mealType).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            menu.mealTypeText,
                            style: TextStyle(
                              color: _getMealTypeColor(menu.mealType),
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Text(
                          '오늘',
                          style: TextStyle(
                            fontSize: 12,
                            color: secondaryColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    
                    // 메인 메뉴
                    if (menu.mainDish != null) ...[
                      Text(
                        menu.mainDish!,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8),
                    ],
                    
                    // 반찬 목록
                    if (menu.sideDishes != null && menu.sideDishes!.isNotEmpty) ...[
                      Text(
                        menu.sideDishes!.join(', '),
                        style: TextStyle(
                          fontSize: 14,
                          color: secondaryColor,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    
                    const Spacer(),
                    
                    // 하단 정보 (칼로리 또는 바로가기)
                    if (menu.dessert != null)
                      Text(
                        '디저트: ${menu.dessert}',
                        style: TextStyle(
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                          color: secondaryColor,
                        ),
                      )
                    else
                      const SizedBox.shrink(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
  
  // 식사 유형에 따른 색상 반환
  Color _getMealTypeColor(MealType type) {
    switch (type) {
      case MealType.breakfast:
        return CarbonColors.blue60;
      case MealType.lunch:
        return CarbonColors.green50;
      case MealType.dinner:
        return CarbonColors.blue70;
    }
  }

  // 네비게이션 메뉴 항목에 회의실 예약 항목 추가
  Widget _buildMainMenuSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.settings, size: 20, color: CarbonColors.blue60),
              SizedBox(width: 8),
              Text(
                '주요 메뉴',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            children: [
              _buildMenuTile(
                title: '회의 일정',
                icon: Icons.calendar_month,
                route: '/meeting_schedule',
                color: CarbonColors.blue60,
              ),
              _buildMenuTile(
                title: '장비 관리',
                icon: Icons.cable,
                route: '/tasks',
                color: CarbonColors.purple60,
              ),
              _buildMenuTile(
                title: '휴가 관리',
                icon: Icons.beach_access,
                route: '/vacations',
                color: CarbonColors.green60,
              ),
              _buildMenuTile(
                title: '식당 메뉴',
                icon: Icons.restaurant,
                route: '/restaurant',
                color: CarbonColors.blue60,
              ),
              // 회의실 예약 메뉴 추가
              _buildMenuTile(
                title: '회의실 예약',
                icon: Icons.meeting_room,
                route: '/meeting_reports',
                color: CarbonColors.green50,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuTile({
    required String title,
    required IconData icon,
    required String route,
    required Color color,
  }) {
    return InkWell(
      onTap: () {
        Get.toNamed(route);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 24,
            color: color,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
} 