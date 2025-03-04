import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import '../utils/carbon_colors.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final DateTime _currentDate = DateTime.now();
  late DateTime _selectedDate;
  late DateTime _focusedDate;
  
  // Mock data for events
  final Map<DateTime, List<CalendarEvent>> _events = {};

  @override
  void initState() {
    super.initState();
    _selectedDate = _currentDate;
    _focusedDate = _currentDate;
    
    // Generate some sample events
    _generateSampleEvents();
  }

  void _generateSampleEvents() {
    // Today's events
    _addEvent(
      _currentDate,
      '경영진 회의 지원',
      '10:00 AM - 12:00 PM',
      CarbonColors.blue60,
      '대회의실',
      EventType.meeting,
    );
    
    _addEvent(
      _currentDate,
      '프로젝터 점검',
      '2:00 PM - 3:00 PM',
      CarbonColors.yellow30,
      'B동 세미나실',
      EventType.equipment,
    );
    
    // Tomorrow's events
    final tomorrow = _currentDate.add(const Duration(days: 1));
    _addEvent(
      tomorrow,
      '신입사원 교육 지원',
      '9:00 AM - 11:00 AM',
      CarbonColors.green50,
      '교육장',
      EventType.meeting,
    );
    
    // Events for next week
    final nextWeek = _currentDate.add(const Duration(days: 7));
    _addEvent(
      nextWeek,
      '연차 휴가',
      '종일',
      CarbonColors.red60,
      '-',
      EventType.vacation,
    );
    
    // More sample events
    for (int i = 2; i < 20; i++) {
      final date = _currentDate.add(Duration(days: i % 5 == 0 ? i : -i));
      _addEvent(
        date,
        '회의실 $i 마이크 설치',
        '${(i % 12) + 1}:00 PM - ${(i % 12) + 2}:00 PM',
        CarbonColors.blue70,
        '회의실 $i',
        EventType.equipment,
      );
    }
  }

  void _addEvent(
    DateTime date,
    String title,
    String time,
    Color color,
    String location,
    EventType type,
  ) {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    if (_events[normalizedDate] == null) {
      _events[normalizedDate] = [];
    }
    _events[normalizedDate]!.add(
      CalendarEvent(
        title: title,
        time: time,
        color: color,
        location: location,
        type: type,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? CarbonColors.gray100 : Colors.white;
    final textColor = isDarkMode ? Colors.white : CarbonColors.gray100;
    final dividerColor = isDarkMode ? CarbonColors.gray80 : CarbonColors.gray20;
    
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: isDarkMode
          ? SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.transparent)
          : SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent),
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          title: Text(
            '캘린더',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: textColor,
            ),
          ),
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
              icon: Icon(HugeIcons.strokeRoundedFilterHorizontal, color: textColor),
              onPressed: () {
                _showFilterDialog();
              },
            ),
            IconButton(
              icon: Icon(HugeIcons.strokeRoundedAdd01, color: textColor),
              onPressed: () {
                _showAddEventDialog();
              },
            ),
          ],
        ),
        body: Column(
          children: [
            _buildCalendarHeader(),
            _buildWeekdayHeader(),
            Expanded(
              flex: 5,
              child: _buildCalendarGrid(),
            ),
            Divider(height: 1, color: dividerColor),
            Expanded(
              flex: 5,
              child: _buildEventsList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarHeader() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : CarbonColors.gray100;
    final secondaryColor = isDarkMode ? CarbonColors.gray60 : CarbonColors.gray70;
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                DateFormat('yyyy년 MM월').format(_focusedDate),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
              IconButton(
                icon: Icon(Icons.arrow_drop_down, color: secondaryColor),
                onPressed: () {
                  _showMonthYearPicker();
                },
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.chevron_left, color: secondaryColor),
                onPressed: () {
                  setState(() {
                    _focusedDate = DateTime(
                      _focusedDate.year,
                      _focusedDate.month - 1,
                      _focusedDate.day,
                    );
                  });
                },
              ),
              IconButton(
                icon: Icon(Icons.chevron_right, color: secondaryColor),
                onPressed: () {
                  setState(() {
                    _focusedDate = DateTime(
                      _focusedDate.year,
                      _focusedDate.month + 1,
                      _focusedDate.day,
                    );
                  });
                },
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _focusedDate = DateTime.now();
                    _selectedDate = DateTime.now();
                  });
                },
                style: TextButton.styleFrom(
                  foregroundColor: CarbonColors.blue60,
                ),
                child: const Text('오늘'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeekdayHeader() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final weekdays = ['일', '월', '화', '수', '목', '금', '토'];
    final textColor = isDarkMode ? Colors.white70 : CarbonColors.gray70;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: weekdays.map((day) {
          final isWeekend = day == '토' || day == '일';
          return Expanded(
            child: Text(
              day,
              style: TextStyle(
                color: isWeekend
                    ? (day == '일' ? CarbonColors.red60 : CarbonColors.blue60)
                    : textColor,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCalendarGrid() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : CarbonColors.gray100;
    final secondaryColor = isDarkMode ? CarbonColors.gray60 : CarbonColors.gray70;
    final selectedBgColor = CarbonColors.blue60.withOpacity(0.2);
    final todayBorderColor = CarbonColors.blue60;
    
    final daysInMonth = DateTime(
      _focusedDate.year,
      _focusedDate.month + 1,
      0,
    ).day;
    
    // Calculate the first day of the month
    final firstDayOfMonth = DateTime(_focusedDate.year, _focusedDate.month, 1);
    final firstWeekdayOfMonth = firstDayOfMonth.weekday % 7; // 0 for Sunday

    // Calculate total number of cells needed (previous month days + current month days)
    final totalDays = firstWeekdayOfMonth + daysInMonth;
    final totalWeeks = (totalDays / 7).ceil();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          childAspectRatio: 1.0,
        ),
        itemCount: totalWeeks * 7,
        itemBuilder: (context, index) {
          // Calculate the day for this cell
          final adjustedIndex = index - firstWeekdayOfMonth;
          if (adjustedIndex < 0 || adjustedIndex >= daysInMonth) {
            // Previous or next month's day
            return const SizedBox();
          }
          
          final day = adjustedIndex + 1;
          final date = DateTime(_focusedDate.year, _focusedDate.month, day);
          final isToday = date.year == _currentDate.year &&
              date.month == _currentDate.month &&
              date.day == _currentDate.day;
          final isSelected = date.year == _selectedDate.year &&
              date.month == _selectedDate.month &&
              date.day == _selectedDate.day;
          
          final hasEvents = _events[date] != null && _events[date]!.isNotEmpty;
          
          return InkWell(
            onTap: () {
              setState(() {
                _selectedDate = date;
              });
            },
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Container(
              margin: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: isSelected ? selectedBgColor : null,
                borderRadius: BorderRadius.circular(8),
                border: isToday
                    ? Border.all(color: todayBorderColor, width: 2)
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    day.toString(),
                    style: TextStyle(
                      fontWeight: isToday || isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected
                          ? CarbonColors.blue60
                          : (index % 7 == 0)
                              ? CarbonColors.red60
                              : (index % 7 == 6)
                                  ? CarbonColors.blue60
                                  : textColor,
                      fontSize: 14,
                    ),
                  ),
                  if (hasEvents)
                    Container(
                      width: 6,
                      height: 6,
                      margin: const EdgeInsets.only(top: 2),
                      decoration: BoxDecoration(
                        color: _events[date]![0].color,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEventsList() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : CarbonColors.gray100;
    final secondaryColor = isDarkMode ? Colors.white70 : CarbonColors.gray70;
    
    final eventsForSelectedDate = _events[_selectedDate] ?? [];
    
    if (eventsForSelectedDate.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(HugeIcons.strokeRoundedCalendar01, size: 48, color: secondaryColor),
            const SizedBox(height: 16),
            Text(
              '일정이 없습니다',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: secondaryColor,
              ),
            ),
            const SizedBox(height: 16),
            _buildCarbonButton(
              label: '일정 추가하기',
              icon: HugeIcons.strokeRoundedAdd01,
              onPressed: () {
                _showAddEventDialog();
              },
            ),
          ],
        ),
      );
    }
    
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: eventsForSelectedDate.length,
      separatorBuilder: (context, index) => Divider(
        color: isDarkMode ? CarbonColors.gray80 : CarbonColors.gray20,
        height: 1,
      ),
      itemBuilder: (context, index) {
        final event = eventsForSelectedDate[index];
        return InkWell(
          onTap: () {
            // Show event details
            _showEventDetails(event);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 4,
                  height: 60,
                  decoration: BoxDecoration(
                    color: event.color,
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
                              color: event.color.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              _getEventTypeText(event.type),
                              style: TextStyle(
                                color: event.color,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            event.time,
                            style: TextStyle(
                              fontSize: 12,
                              color: secondaryColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        event.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (event.location.isNotEmpty && event.location != '-')
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 14,
                              color: secondaryColor,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              event.location,
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
      },
    );
  }

  Widget _buildCarbonButton({
    required String label,
    required VoidCallback onPressed,
    IconData? icon,
    bool isPrimary = true,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary ? CarbonColors.blue60 : Colors.transparent,
        foregroundColor: isPrimary ? Colors.white : CarbonColors.blue60,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
          side: isPrimary ? BorderSide.none : BorderSide(color: CarbonColors.blue60),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16, color: isPrimary ? Colors.white : CarbonColors.blue60),
            const SizedBox(width: 8),
          ],
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _showMonthYearPicker() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? CarbonColors.gray90 : Colors.white;
    final textColor = isDarkMode ? Colors.white : CarbonColors.gray100;
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: backgroundColor,
          title: Text(
            '월/년 선택',
            style: TextStyle(color: textColor),
          ),
          content: Text(
            '실제 앱에서는 월/년 선택 위젯을 구현하세요.',
            style: TextStyle(color: textColor),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: CarbonColors.blue60,
              ),
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
  }

  void _showFilterDialog() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? CarbonColors.gray90 : Colors.white;
    final textColor = isDarkMode ? Colors.white : CarbonColors.gray100;
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: backgroundColor,
          title: Text(
            '일정 필터',
            style: TextStyle(color: textColor),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CheckboxListTile(
                title: Text('회의', style: TextStyle(color: textColor)),
                value: true,
                activeColor: CarbonColors.blue60,
                onChanged: (bool? value) {
                  Navigator.of(context).pop();
                },
              ),
              CheckboxListTile(
                title: Text('장비 관리', style: TextStyle(color: textColor)),
                value: true,
                activeColor: CarbonColors.blue60,
                onChanged: (bool? value) {
                  Navigator.of(context).pop();
                },
              ),
              CheckboxListTile(
                title: Text('휴가', style: TextStyle(color: textColor)),
                value: true,
                activeColor: CarbonColors.blue60,
                onChanged: (bool? value) {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: CarbonColors.blue60,
              ),
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: CarbonColors.blue60,
              ),
              child: const Text('적용'),
            ),
          ],
        );
      },
    );
  }

  void _showAddEventDialog() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? CarbonColors.gray90 : Colors.white;
    final textColor = isDarkMode ? Colors.white : CarbonColors.gray100;
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: backgroundColor,
          title: Text(
            '새 일정 추가',
            style: TextStyle(color: textColor),
          ),
          content: Text(
            '실제 앱에서는 일정 추가 폼을 구현하세요.',
            style: TextStyle(color: textColor),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: CarbonColors.blue60,
              ),
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () {
                // Add a sample event to current date
                _addEvent(
                  _selectedDate,
                  '새 일정',
                  '12:00 PM - 1:00 PM',
                  CarbonColors.green50,
                  '미정',
                  EventType.meeting,
                );
                Navigator.of(context).pop();
                setState(() {});
              },
              style: TextButton.styleFrom(
                foregroundColor: CarbonColors.blue60,
              ),
              child: const Text('추가'),
            ),
          ],
        );
      },
    );
  }

  void _showEventDetails(CalendarEvent event) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? CarbonColors.gray90 : Colors.white;
    final textColor = isDarkMode ? Colors.white : CarbonColors.gray100;
    final secondaryColor = isDarkMode ? Colors.white70 : CarbonColors.gray70;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: event.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      _getEventTypeText(event.type),
                      style: TextStyle(
                        color: event.color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: secondaryColor),
                        onPressed: () {
                          Navigator.pop(context);
                          // Edit event
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: secondaryColor),
                        onPressed: () {
                          Navigator.pop(context);
                          // Delete event
                        },
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                event.title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.access_time, size: 16, color: secondaryColor),
                  const SizedBox(width: 8),
                  Text(
                    '${DateFormat('yyyy년 MM월 dd일').format(_selectedDate)} (${event.time})',
                    style: TextStyle(
                      fontSize: 14,
                      color: secondaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (event.location.isNotEmpty && event.location != '-')
                Row(
                  children: [
                    Icon(Icons.location_on, size: 16, color: secondaryColor),
                    const SizedBox(width: 8),
                    Text(
                      event.location,
                      style: TextStyle(
                        fontSize: 14,
                        color: secondaryColor,
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 24),
              Text(
                '세부 내용',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '이 일정에 대한 세부 내용이 표시됩니다. 실제 앱에서는 일정에 대한 자세한 설명과 참석자, 필요한 장비 등의 정보가 포함될 수 있습니다.',
                style: TextStyle(
                  color: secondaryColor,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CarbonColors.blue60,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: const Text('닫기'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _getEventTypeText(EventType type) {
    switch (type) {
      case EventType.meeting:
        return '회의';
      case EventType.equipment:
        return '장비 관리';
      case EventType.vacation:
        return '휴가';
      default:
        return '';
    }
  }
}

enum EventType {
  meeting,
  equipment,
  vacation,
}

class CalendarEvent {
  final String title;
  final String time;
  final Color color;
  final String location;
  final EventType type;

  CalendarEvent({
    required this.title,
    required this.time,
    required this.color,
    required this.location,
    required this.type,
  });
} 