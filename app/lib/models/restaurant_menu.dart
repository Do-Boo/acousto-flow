import 'package:intl/intl.dart';

enum MealType {
  breakfast,
  lunch,
  dinner
}

class RestaurantMenu {
  final int id;
  final DateTime date;
  final MealType mealType;
  final String? mainDish;
  final List<String>? sideDishes;
  final String? dessert;
  final int? calories;
  final String? imageUrl;
  final int restaurantId;

  RestaurantMenu({
    required this.id,
    required this.date,
    required this.mealType,
    this.mainDish,
    this.sideDishes,
    this.dessert,
    this.calories,
    this.imageUrl,
    this.restaurantId = 1,
  });

  // 서버에서 받은 JSON 데이터를 모델로 변환
  factory RestaurantMenu.fromJson(Map<String, dynamic> json) {
    return RestaurantMenu(
      id: json['id'],
      date: DateTime.parse(json['date']),
      mealType: _parseMealType(json['meal_type']),
      mainDish: json['main_dish'],
      sideDishes: json['side_dishes'] != null 
          ? json['side_dishes'].toString().split(',') 
          : null,
      dessert: json['dessert'],
      calories: json['calories'],
      imageUrl: json['image_url'],
      restaurantId: json['restaurant_id'] ?? 1,
    );
  }

  // 기존 RestaurantList 테이블 데이터를 변환
  factory RestaurantMenu.fromLegacyData(Map<String, dynamic> json) {
    final menuText = json['menu'] as String;
    
    // 간단한 파싱 로직 (메뉴 텍스트는 적절히 조정 필요)
    final menuItems = menuText.split('\n');
    String? mainDish;
    List<String> sideDishes = [];
    
    if (menuItems.isNotEmpty) {
      mainDish = menuItems[0];
      if (menuItems.length > 1) {
        sideDishes = menuItems.sublist(1);
      }
    }
    
    return RestaurantMenu(
      id: json['id'],
      date: DateTime.parse(json['date']),
      mealType: MealType.lunch, // 기본값으로 점심 설정
      mainDish: mainDish,
      sideDishes: sideDishes.isEmpty ? null : sideDishes,
      restaurantId: 1,
    );
  }

  // 문자열을 MealType으로 변환
  static MealType _parseMealType(String type) {
    switch (type.toLowerCase()) {
      case 'breakfast':
        return MealType.breakfast;
      case 'lunch':
        return MealType.lunch;
      case 'dinner':
        return MealType.dinner;
      default:
        return MealType.lunch;
    }
  }

  // 식사 유형을 한글로 변환
  String get mealTypeText {
    switch (mealType) {
      case MealType.breakfast:
        return '아침';
      case MealType.lunch:
        return '점심';
      case MealType.dinner:
        return '저녁';
    }
  }

  // 날짜 형식 변환
  String get formattedDate {
    return DateFormat('yyyy년 MM월 dd일').format(date);
  }
  
  // 요일 반환
  String get dayOfWeek {
    final weekdays = ['월', '화', '수', '목', '금', '토', '일'];
    // DateTime의 weekday는 1(월요일)부터 7(일요일)
    return weekdays[date.weekday - 1];
  }
} 