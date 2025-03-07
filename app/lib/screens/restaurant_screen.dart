import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../models/restaurant_menu.dart';
import '../services/restaurant_service.dart';
import '../utils/carbon_colors.dart';

class RestaurantScreen extends StatefulWidget {
  final bool hideAppBar;
  
  RestaurantScreen({Key? key, this.hideAppBar = false}) : super(key: key);
  
  @override
  _RestaurantScreenState createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> {
  final RestaurantService _restaurantService = RestaurantService();
  List<RestaurantMenu> _menus = [];
  bool _isLoading = true;
  DateTime _selectedDate = DateTime.now();
  MealType _selectedMealType = MealType.lunch; // 기본값: 점심
  
  @override
  void initState() {
    super.initState();
    _loadMenus();
  }
  
  Future<void> _loadMenus() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      // 실제 API 연결 시 주석 해제
      // final menus = await _restaurantService.getMenuByDate(_selectedDate);
      
      // 테스트를 위한 샘플 데이터 사용
      final menus = _restaurantService.getSampleMenus();
      
      setState(() {
        _menus = menus;
        _isLoading = false;
        
        // 선택된 날짜에 선택된 식사 유형이 없으면 기본값 설정
        final hasSelectedMealType = menus.any((menu) => 
          menu.date.year == _selectedDate.year && 
          menu.date.month == _selectedDate.month && 
          menu.date.day == _selectedDate.day &&
          menu.mealType == _selectedMealType
        );
        
        if (!hasSelectedMealType && menus.isNotEmpty) {
          // 해당 날짜의 메뉴가 있으면 첫 번째 메뉴의 식사 유형 선택
          final menusForSelectedDate = menus.where((menu) => 
            menu.date.year == _selectedDate.year && 
            menu.date.month == _selectedDate.month && 
            menu.date.day == _selectedDate.day
          ).toList();
          
          if (menusForSelectedDate.isNotEmpty) {
            _selectedMealType = menusForSelectedDate.first.mealType;
          }
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      // 에러 처리
      Get.snackbar(
        '오류',
        '메뉴를 불러오는 데 실패했습니다.',
        backgroundColor: CarbonColors.red60.withOpacity(0.9),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
  
  void _selectDate(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
    _loadMenus();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? CarbonColors.gray100 : Colors.white;
    final textColor = isDarkMode ? Colors.white : CarbonColors.gray100;
    
    // 통합된 SystemUiOverlayStyle
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
        appBar: widget.hideAppBar ? null : AppBar(
          title: Text(
            '구내식당',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: textColor,
              fontSize: 16,
            ),
          ),
          centerTitle: false,
          backgroundColor: backgroundColor,
          elevation: 0,
          systemOverlayStyle: systemUiOverlayStyle,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Divider(
              height: 1,
              color: isDarkMode ? CarbonColors.gray80 : CarbonColors.gray20,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.calendar_today, color: textColor),
              onPressed: () {
                _showDatePicker();
              },
            ),
            IconButton(
              icon: Icon(Icons.refresh, color: textColor),
              onPressed: () {
                _loadMenus();
              },
            ),
          ],
        ),
        body: NotificationListener<ScrollNotification>(
          onNotification: (scrollNotification) {
            // 스크롤 중에도 상태표시줄 스타일 유지
            SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
            return false;
          },
          child: _buildBody(),
        ),
      ),
    );
  }
  
  Widget _buildBody() {
    if (_isLoading) {
      return _buildLoadingState();
    }
    
    if (_menus.isEmpty) {
      return _buildEmptyState();
    }
    
    return Column(
      children: [
        _buildDateSelector(),
        _buildMealTypeSelector(),
        Expanded(
          child: _buildMenuContent(),
        ),
      ],
    );
  }
  
  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(CarbonColors.blue60),
          ),
          const SizedBox(height: 16),
          Text(
            '메뉴 불러오는 중...',
            style: TextStyle(
              color: CarbonColors.gray60,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildEmptyState() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : CarbonColors.gray100;
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.restaurant,
            size: 64,
            color: CarbonColors.gray60,
          ),
          const SizedBox(height: 16),
          Text(
            '메뉴 정보가 없습니다',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '선택한 날짜의 메뉴 정보가 없습니다',
            style: TextStyle(
              fontSize: 14,
              color: CarbonColors.gray60,
            ),
          ),
          const SizedBox(height: 24),
          _buildCarbonButton(
            label: '오늘 메뉴 보기',
            onPressed: () {
              setState(() {
                _selectedDate = DateTime.now();
              });
              _loadMenus();
            },
          ),
        ],
      ),
    );
  }
  
  Widget _buildDateSelector() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : CarbonColors.gray100;
    final secondaryColor = isDarkMode ? CarbonColors.gray60 : CarbonColors.gray70;
    
    // 이번 주 날짜 범위 계산
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final List<DateTime> weekDays = [];
    
    // 월요일부터 금요일까지의 날짜 계산
    final currentWeekday = now.weekday;
    final mondayDiff = (currentWeekday - 1) % 7;
    final monday = today.subtract(Duration(days: mondayDiff));
    
    for (int i = 0; i < 5; i++) {
      weekDays.add(monday.add(Duration(days: i)));
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: isDarkMode ? CarbonColors.gray90 : CarbonColors.gray10,
        border: Border(
          bottom: BorderSide(
            color: isDarkMode ? CarbonColors.gray80 : CarbonColors.gray20,
          ),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${DateFormat('yyyy년 MM월').format(_selectedDate)}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                Text(
                  DateFormat('yyyy년 MM월 dd일 (E)', 'ko_KR').format(_selectedDate),
                  style: TextStyle(
                    fontSize: 14,
                    color: secondaryColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: weekDays.length,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemBuilder: (context, index) {
                final date = weekDays[index];
                final isSelected = date.year == _selectedDate.year &&
                                   date.month == _selectedDate.month &&
                                   date.day == _selectedDate.day;
                final isToday = date.year == today.year &&
                                date.month == today.month &&
                                date.day == today.day;
                
                // 선택된 날짜의 메뉴가 있는지 확인
                final hasMenu = _menus.any((menu) => 
                  menu.date.year == date.year && 
                  menu.date.month == date.month && 
                  menu.date.day == date.day
                );
                
                return _buildDateItem(
                  date, 
                  isSelected, 
                  isToday,
                  hasMenu,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildDateItem(
    DateTime date, 
    bool isSelected, 
    bool isToday,
    bool hasMenu,
  ) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : CarbonColors.gray100;
    final secondaryColor = isDarkMode ? CarbonColors.gray60 : CarbonColors.gray70;
    
    // 요일 표시
    final dayNames = ['월', '화', '수', '목', '금'];
    final dayIndex = date.weekday - 1; // 0: 월, 1: 화, ...
    final dayName = dayIndex >= 0 && dayIndex < dayNames.length 
                     ? dayNames[dayIndex] 
                     : '';
    
    return InkWell(
      onTap: () {
        _selectDate(date);
      },
      child: Container(
        width: 60,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: isSelected 
            ? CarbonColors.blue60.withOpacity(0.1) 
            : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: isToday
            ? Border.all(color: CarbonColors.blue60, width: 2)
            : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              dayName,
              style: TextStyle(
                color: isSelected 
                  ? CarbonColors.blue60 
                  : secondaryColor,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${date.day}',
              style: TextStyle(
                color: isSelected 
                  ? CarbonColors.blue60 
                  : textColor,
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: hasMenu 
                  ? CarbonColors.green50 
                  : Colors.transparent,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildMealTypeSelector() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : CarbonColors.gray100;
    
    // 선택된 날짜에 있는 식사 유형 필터링
    final availableMealTypes = _menus
        .where((menu) => 
          menu.date.year == _selectedDate.year && 
          menu.date.month == _selectedDate.month && 
          menu.date.day == _selectedDate.day
        )
        .map((menu) => menu.mealType)
        .toList();
    
    // 중복 제거
    final uniqueMealTypes = <MealType>[];
    for (var type in availableMealTypes) {
      if (!uniqueMealTypes.contains(type)) {
        uniqueMealTypes.add(type);
      }
    }
    
    // 타입별 정렬 (아침, 점심, 저녁 순)
    uniqueMealTypes.sort((a, b) => a.index.compareTo(b.index));
    
    if (uniqueMealTypes.isEmpty) {
      return const SizedBox.shrink();
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isDarkMode ? CarbonColors.gray80 : CarbonColors.gray20,
          ),
        ),
      ),
      child: Row(
        children: [
          Text(
            '식사:',
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: uniqueMealTypes.map((type) {
                  final isSelected = type == _selectedMealType;
                  
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(_getMealTypeText(type)),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _selectedMealType = type;
                          });
                        }
                      },
                      backgroundColor: isDarkMode 
                        ? CarbonColors.gray90 
                        : CarbonColors.gray10,
                      selectedColor: CarbonColors.blue60.withOpacity(0.1),
                      labelStyle: TextStyle(
                        color: isSelected 
                          ? CarbonColors.blue60 
                          : textColor,
                        fontWeight: isSelected 
                          ? FontWeight.w600 
                          : FontWeight.normal,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  String _getMealTypeText(MealType type) {
    switch (type) {
      case MealType.breakfast:
        return '아침';
      case MealType.lunch:
        return '점심';
      case MealType.dinner:
        return '저녁';
    }
  }
  
  Widget _buildMenuContent() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : CarbonColors.gray100;
    final secondaryColor = isDarkMode ? Colors.white70 : CarbonColors.gray70;
    final backgroundColor = isDarkMode ? CarbonColors.gray90 : Colors.white;
    
    // 선택된 날짜와 식사 유형에 맞는 메뉴 찾기
    final selectedMenu = _menus.firstWhere(
      (menu) => 
        menu.date.year == _selectedDate.year && 
        menu.date.month == _selectedDate.month && 
        menu.date.day == _selectedDate.day &&
        menu.mealType == _selectedMealType,
      orElse: () => RestaurantMenu(
        id: -1,
        date: _selectedDate,
        mealType: _selectedMealType,
      ),
    );
    
    if (selectedMenu.id == -1) {
      return Center(
        child: Text(
          '선택한 날짜의 ${_getMealTypeText(_selectedMealType)} 메뉴가 없습니다',
          style: TextStyle(
            color: secondaryColor,
            fontSize: 16,
          ),
        ),
      );
    }
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 메뉴 제목 및 정보
          Text(
            '${selectedMenu.formattedDate} (${selectedMenu.dayOfWeek}) ${selectedMenu.mealTypeText}',
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
          
          if (selectedMenu.calories != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                '${selectedMenu.calories} kcal',
                style: TextStyle(
                  color: CarbonColors.blue60,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          
          const SizedBox(height: 24),
          
          // 메인 메뉴
          if (selectedMenu.mainDish != null)
            _buildMenuSection('메인 메뉴', [selectedMenu.mainDish!]),
          
          const SizedBox(height: 16),
          
          // 반찬
          if (selectedMenu.sideDishes != null && selectedMenu.sideDishes!.isNotEmpty)
            _buildMenuSection('반찬', selectedMenu.sideDishes!),
          
          const SizedBox(height: 16),
          
          // 디저트
          if (selectedMenu.dessert != null)
            _buildMenuSection('디저트', [selectedMenu.dessert!]),
          
          const SizedBox(height: 24),
          
          // 이미지 (있는 경우)
          if (selectedMenu.imageUrl != null)
            Container(
              width: double.infinity,
              height: 200,
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: isDarkMode ? CarbonColors.gray80 : CarbonColors.gray20,
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: NetworkImage(selectedMenu.imageUrl!),
                  fit: BoxFit.cover,
                ),
              ),
            )
          else
            Container(
              width: double.infinity,
              height: 200,
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: isDarkMode ? CarbonColors.gray80 : CarbonColors.gray20,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.image_not_supported,
                      size: 48,
                      color: secondaryColor,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '이미지가 없습니다',
                      style: TextStyle(
                        color: secondaryColor,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
          // 추가 정보
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isDarkMode ? CarbonColors.gray80 : CarbonColors.gray20,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '알레르기 정보',
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '본 메뉴에는 난류, 우유, 대두, 밀, 땅콩, 호두, 쇠고기, 닭고기, 돼지고기, 새우, 고등어, 게, 오징어, 조개류, 토마토가 포함되어 있을 수 있습니다.',
                  style: TextStyle(
                    color: secondaryColor,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '식단 관련 문의',
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '구내식당: 02-123-4567',
                  style: TextStyle(
                    color: secondaryColor,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildMenuSection(String title, List<String> items) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : CarbonColors.gray100;
    final secondaryColor = isDarkMode ? Colors.white70 : CarbonColors.gray70;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 12),
        ...items.map((item) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.circle,
                size: 8,
                color: secondaryColor,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  item,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        )).toList(),
      ],
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
            Icon(icon, size: 16),
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
  
  void _showDatePicker() async {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? CarbonColors.gray90 : Colors.white;
    final textColor = isDarkMode ? Colors.white : CarbonColors.gray100;
    
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: CarbonColors.blue60,
              onPrimary: Colors.white,
              surface: backgroundColor,
              onSurface: textColor,
            ),
            dialogBackgroundColor: backgroundColor,
          ),
          child: child!,
        );
      },
    );
    
    if (pickedDate != null && pickedDate != _selectedDate) {
      _selectDate(pickedDate);
    }
  }
} 