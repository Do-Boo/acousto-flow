import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import '../utils/carbon_colors.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
    final dividerColor = isDarkMode ? CarbonColors.gray80 : CarbonColors.gray20;
    
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: isDarkMode
          ? SystemUiOverlayStyle.light.copyWith(
              statusBarColor: Colors.transparent,
              systemNavigationBarColor: backgroundColor,
            )
          : SystemUiOverlayStyle.dark.copyWith(
              statusBarColor: Colors.transparent,
              systemNavigationBarColor: backgroundColor,
            ),
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          title: Text(
            '홈',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: textColor,
            ),
          ),
          centerTitle: false,
          backgroundColor: backgroundColor,
          elevation: 0,
          systemOverlayStyle: isDarkMode
              ? SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.transparent)
              : SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Divider(
              height: 1,
              color: dividerColor,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.notifications_outlined,
                color: textColor,
              ),
              onPressed: () {
                // 알림 메뉴 표시
              },
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            // 데이터 새로고침
            await Future.delayed(const Duration(seconds: 1));
            setState(() {});
          },
          color: CarbonColors.blue60,
          child: SingleChildScrollView(
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
                const SizedBox(height: 16),
              ],
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
} 