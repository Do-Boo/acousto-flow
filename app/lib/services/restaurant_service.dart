import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../models/restaurant_menu.dart';
import '../utils/api_constants.dart';
import 'dart:math' as math;

class RestaurantService {
  // API 요청용 헤더
  final Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // 오늘 식단 가져오기
  Future<RestaurantMenu> getTodayMenu() async {
    final today = DateTime.now();
    return getMenuForDate(today);
  }

  // 특정 날짜의 식단 가져오기
  Future<RestaurantMenu> getMenuForDate(DateTime date) async {
    try {
      final formattedDate = DateFormat('yyyy-MM-dd').format(date);
      
      // 모듈과 액션 개념을 사용하여 URL 구성
      final url = ApiConstants.buildUrl(ApiConstants.restaurantMenuEndpoint, {'date': formattedDate});
      
      if (ApiConstants.loggingEnabled) {
        print('API 요청 URL: $url');
        print('모듈: restaurant, 액션: menu, 날짜: $formattedDate');
      }
      
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode == 200) {
        print('API 응답 성공: ${response.statusCode}');
        
        final responseData = json.decode(response.body);
        
        if (responseData['success'] == true && responseData['data'] != null) {
          final data = responseData['data'];
          
          // API 응답이 날짜별 객체 형태로 오는 경우 처리
          if (data is Map<String, dynamic>) {
            // 날짜 정보 추출
            final menuDate = data['date'] ?? formattedDate;
            
            // 아침, 점심, 저녁 데이터 확인 (현재 시간에 맞는 식사 선택)
            final currentHour = DateTime.now().hour;
            Map<String, dynamic>? mealData;
            String mealType;
            
            if (currentHour < 10) {
              mealData = data['breakfast'] as Map<String, dynamic>?;
              mealType = 'breakfast';
            } else if (currentHour < 15) {
              mealData = data['lunch'] as Map<String, dynamic>?;
              mealType = 'lunch';
            } else {
              mealData = data['dinner'] as Map<String, dynamic>?;
              mealType = 'dinner';
            }
            
            // 선택된 식사 데이터가 없는 경우
            if (mealData == null) {
              if (data['breakfast'] != null) {
                mealData = data['breakfast'] as Map<String, dynamic>;
                mealType = 'breakfast';
              } else if (data['lunch'] != null) {
                mealData = data['lunch'] as Map<String, dynamic>;
                mealType = 'lunch';
              } else if (data['dinner'] != null) {
                mealData = data['dinner'] as Map<String, dynamic>;
                mealType = 'dinner';
              } else {
                print('API 응답에 식사 데이터가 없습니다. 샘플 데이터 사용');
                return _getFilteredSampleMenus(date).first;
              }
            }
            
            // 식사 데이터로 RestaurantMenu 객체 생성
            List<String> sideDishes = [];
            if (mealData['side'] is List) {
              sideDishes = List<String>.from(mealData['side']);
            }
            
            return RestaurantMenu(
              id: 1, // 임시 ID
              date: DateTime.parse(menuDate),
              mealType: _parseMealType(mealType),
              mainDish: mealData['main'] as String? ?? '정보 없음',
              sideDishes: sideDishes,
              calories: mealData['calories'] as int? ?? 0,
              restaurantId: 1,
            );
          }
          // 기존 형태의 응답 처리 (List 형태)
          else if (data is List && data.isNotEmpty) {
            final menus = <RestaurantMenu>[];
            
            for (var item in data) {
              try {
                // API 응답의 side_dishes가 리스트인 경우와 문자열인 경우 모두 처리
                List<String> sideDishes = [];
                if (item['side_dishes'] is List) {
                  sideDishes = List<String>.from(item['side_dishes']);
                } else if (item['side_dishes'] is String) {
                  sideDishes = (item['side_dishes'] as String).split(',');
                }
                
                // 특별 메시지인 경우 (예: *정시퇴근의 날*)
                final isSpecialMessage = item['main_dish'] != null && 
                    item['main_dish'].toString().startsWith('*') && 
                    item['main_dish'].toString().endsWith('*');
                
                final menu = RestaurantMenu(
                  id: item['id'] ?? 0,
                  date: DateTime.parse(item['date'] ?? formattedDate),
                  mealType: _parseMealType(item['meal_type']),
                  mainDish: item['main_dish'],
                  sideDishes: isSpecialMessage ? [] : sideDishes,
                  dessert: isSpecialMessage ? null : item['dessert'],
                  calories: isSpecialMessage ? 0 : (item['calories'] ?? 0),
                  imageUrl: item['image_url'],
                  restaurantId: item['restaurant_id'] ?? 1,
                );
                menus.add(menu);
              } catch (e) {
                print('메뉴 파싱 오류: $e');
                continue;
              }
            }
            
            if (menus.isNotEmpty) {
              return menus.first;
            }
          }
        }
      }
      
      print('API 응답 형식이 예상과 다릅니다. 샘플 데이터 사용: 상태 코드 ${response.statusCode}');
      print('요청 URL: $url');
      if (response.body.isNotEmpty) {
        print('응답 내용: ${response.body.substring(0, math.min(200, response.body.length))}...');
      }
      return _getFilteredSampleMenus(date).first;
    } catch (e) {
      print('API 호출 중 오류 발생, 샘플 데이터 사용: $e');
      print('요청 URL: ${ApiConstants.buildUrl(ApiConstants.restaurantMenuEndpoint, {'date': DateFormat('yyyy-MM-dd').format(date)})}');
      return _getFilteredSampleMenus(date).first;
    }
  }

  // 특정 날짜 범위의 메뉴 가져오기 (주간 메뉴 등)
  Future<Map<DateTime, List<RestaurantMenu>>> getMenuByDateRange(
      DateTime startDate, DateTime endDate) async {
    final Map<DateTime, List<RestaurantMenu>> result = {};
    
    final dateFormat = DateFormat('yyyy-MM-dd');
    final formattedStartDate = dateFormat.format(startDate);
    final formattedEndDate = dateFormat.format(endDate);
    
    try {
      // URL 구성
      final url = ApiConstants.buildUrl(ApiConstants.restaurantMenuEndpoint, {
        'start_date': formattedStartDate,
        'end_date': formattedEndDate
      });
      
      if (ApiConstants.loggingEnabled) {
        print('API 요청 URL: $url');
        print('모듈: restaurant, 액션: menu, 날짜 범위: $formattedStartDate ~ $formattedEndDate');
      }
      
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );
      
      if (response.statusCode == 200) {
        print('API 응답 성공: ${response.statusCode}');
        
        final responseData = json.decode(response.body);
        
        if (responseData['success'] == true && responseData['data'] != null) {
          final data = responseData['data'];
          
          // 새로운 API 구조 처리 - 객체 배열 형태
          if (data is List) {
            for (var dayMenu in data) {
              if (dayMenu is Map<String, dynamic> && dayMenu['date'] != null) {
                String dateStr = dayMenu['date'];
                DateTime menuDate = DateTime.parse(dateStr);
                List<RestaurantMenu> dayMenus = [];
                
                // 아침, 점심, 저녁 메뉴 확인
                if (dayMenu['breakfast'] != null) {
                  Map<String, dynamic> breakfast = dayMenu['breakfast'];
                  List<String> breakfastSides = [];
                  if (breakfast['side'] is List) {
                    breakfastSides = List<String>.from(breakfast['side']);
                  }
                  
                  dayMenus.add(RestaurantMenu(
                    id: 1,
                    date: menuDate,
                    mealType: MealType.breakfast,
                    mainDish: breakfast['main'] as String? ?? '정보 없음',
                    sideDishes: breakfastSides,
                    calories: breakfast['calories'] as int? ?? 0,
                    restaurantId: 1,
                  ));
                }
                
                if (dayMenu['lunch'] != null) {
                  Map<String, dynamic> lunch = dayMenu['lunch'];
                  List<String> lunchSides = [];
                  if (lunch['side'] is List) {
                    lunchSides = List<String>.from(lunch['side']);
                  }
                  
                  dayMenus.add(RestaurantMenu(
                    id: 2,
                    date: menuDate,
                    mealType: MealType.lunch,
                    mainDish: lunch['main'] as String? ?? '정보 없음',
                    sideDishes: lunchSides,
                    calories: lunch['calories'] as int? ?? 0,
                    restaurantId: 1,
                  ));
                }
                
                if (dayMenu['dinner'] != null) {
                  Map<String, dynamic> dinner = dayMenu['dinner'];
                  List<String> dinnerSides = [];
                  if (dinner['side'] is List) {
                    dinnerSides = List<String>.from(dinner['side']);
                  }
                  
                  dayMenus.add(RestaurantMenu(
                    id: 3,
                    date: menuDate,
                    mealType: MealType.dinner,
                    mainDish: dinner['main'] as String? ?? '정보 없음',
                    sideDishes: dinnerSides,
                    calories: dinner['calories'] as int? ?? 0,
                    restaurantId: 1,
                  ));
                }
                
                if (dayMenus.isNotEmpty) {
                  final normalizedDate = DateTime(
                    menuDate.year, 
                    menuDate.month, 
                    menuDate.day
                  );
                  result[normalizedDate] = dayMenus;
                }
              }
            }
            
            if (result.isNotEmpty) {
              return result;
            }
          }
          // 기존 API 구조 처리 (List 형태)
          else if (data is List) {
            final allMenus = <RestaurantMenu>[];
            
            for (var item in data) {
              try {
                // API 응답의 side_dishes가 리스트인 경우와 문자열인 경우 모두 처리
                List<String> sideDishes = [];
                if (item['side_dishes'] is List) {
                  sideDishes = List<String>.from(item['side_dishes']);
                } else if (item['side_dishes'] is String) {
                  sideDishes = (item['side_dishes'] as String).split(',');
                }
                
                // 특별 메시지인 경우 (예: *정시퇴근의 날*)
                final isSpecialMessage = item['main_dish'] != null && 
                    item['main_dish'].toString().startsWith('*') && 
                    item['main_dish'].toString().endsWith('*');
                
                final menu = RestaurantMenu(
                  id: item['id'] ?? 0,
                  date: DateTime.parse(item['date'] ?? dateFormat.format(startDate)),
                  mealType: _parseMealType(item['meal_type']),
                  mainDish: item['main_dish'],
                  sideDishes: isSpecialMessage ? [] : sideDishes,
                  dessert: isSpecialMessage ? null : item['dessert'],
                  calories: isSpecialMessage ? 0 : (item['calories'] ?? 0),
                  imageUrl: item['image_url'],
                  restaurantId: item['restaurant_id'] ?? 1,
                );
                allMenus.add(menu);
              } catch (e) {
                print('메뉴 파싱 오류: $e');
                continue;
              }
            }
            
            // 날짜별로 그룹화
            for (var menu in allMenus) {
              final normalizedDate = DateTime(
                menu.date.year, 
                menu.date.month, 
                menu.date.day
              );
              
              if (!result.containsKey(normalizedDate)) {
                result[normalizedDate] = [];
              }
              
              result[normalizedDate]!.add(menu);
            }
            
            return result;
          }
        }
      }
      
      // API 요청이 실패하면 샘플 데이터 사용
      print('API 호출 실패, 샘플 데이터 사용: 상태 코드 ${response.statusCode}');
      print('요청 URL: $url');
      if (response.body.isNotEmpty) {
        print('응답 내용: ${response.body.substring(0, math.min(200, response.body.length))}...');
      }
      return _getSampleMenusByDateRange(startDate, endDate);
    } catch (e) {
      print('날짜 범위 메뉴 조회 중 오류: $e');
      print('요청 URL: ${ApiConstants.buildUrl(ApiConstants.restaurantMenuEndpoint, {'start_date': formattedStartDate, 'end_date': formattedEndDate})}');
      return _getSampleMenusByDateRange(startDate, endDate);
    }
  }
  
  // 샘플 데이터를 날짜 범위로 가져오기
  Map<DateTime, List<RestaurantMenu>> _getSampleMenusByDateRange(
      DateTime startDate, DateTime endDate) {
    final Map<DateTime, List<RestaurantMenu>> result = {};
    
    DateTime currentDate = startDate;
    while (currentDate.isBefore(endDate) || currentDate.isAtSameMomentAs(endDate)) {
      final menuList = _getFilteredSampleMenus(currentDate);
      
      final normalizedDate = DateTime(
        currentDate.year, 
        currentDate.month, 
        currentDate.day
      );
      
      result[normalizedDate] = menuList;
      currentDate = currentDate.add(const Duration(days: 1));
    }
    
    return result;
  }
  
  // 문자열을 MealType으로 변환하는 헬퍼 메서드
  MealType _parseMealType(String? mealTypeStr) {
    switch (mealTypeStr?.toLowerCase()) {
      case 'breakfast':
        return MealType.breakfast;
      case 'lunch':
        return MealType.lunch;
      case 'dinner':
        return MealType.dinner;
      default:
        return MealType.lunch; // 기본값
    }
  }
  
  // 특정 날짜에 해당하는 샘플 메뉴만 필터링
  List<RestaurantMenu> _getFilteredSampleMenus(DateTime date) {
    final targetDate = DateTime(date.year, date.month, date.day);
    final sampleMenus = getSampleMenus();
    
    return sampleMenus.where((menu) {
      final menuDate = DateTime(menu.date.year, menu.date.month, menu.date.day);
      return menuDate.isAtSameMomentAs(targetDate);
    }).toList();
  }
  
  // 샘플 데이터 생성 (API 연결 전 테스트용)
  List<RestaurantMenu> getSampleMenus() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final dayAfterTomorrow = today.add(const Duration(days: 2));
    
    return [
      RestaurantMenu(
        id: 1,
        date: today,
        mealType: MealType.breakfast,
        mainDish: '베이컨 에그 샌드위치',
        sideDishes: ['과일 샐러드', '요거트', '오렌지 주스'],
        calories: 550,
        restaurantId: 1,
      ),
      RestaurantMenu(
        id: 2,
        date: today,
        mealType: MealType.lunch,
        mainDish: '제육볶음',
        sideDishes: ['된장찌개', '계란말이', '시금치 나물', '깍두기'],
        dessert: '수정과',
        calories: 750,
        restaurantId: 1,
      ),
      RestaurantMenu(
        id: 3,
        date: today,
        mealType: MealType.dinner,
        mainDish: '소고기 미역국',
        sideDishes: ['계란찜', '고등어 구이', '콩나물 무침', '배추김치'],
        dessert: '과일',
        calories: 680,
        restaurantId: 1,
      ),
      RestaurantMenu(
        id: 4,
        date: tomorrow,
        mealType: MealType.breakfast,
        mainDish: '시리얼과 우유',
        sideDishes: ['토스트', '딸기 잼', '바나나'],
        calories: 450,
        restaurantId: 1,
      ),
      RestaurantMenu(
        id: 5,
        date: tomorrow,
        mealType: MealType.lunch,
        mainDish: '닭갈비',
        sideDishes: ['된장국', '무생채', '멸치볶음', '배추김치'],
        dessert: '바나나',
        calories: 720,
        restaurantId: 1,
      ),
      RestaurantMenu(
        id: 6,
        date: tomorrow,
        mealType: MealType.dinner,
        mainDish: '버섯 들깨탕',
        sideDishes: ['두부조림', '호박볶음', '시래기나물', '깍두기'],
        dessert: '요구르트',
        calories: 620,
        restaurantId: 1,
      ),
      RestaurantMenu(
        id: 7,
        date: dayAfterTomorrow,
        mealType: MealType.breakfast,
        mainDish: '야채 오믈렛',
        sideDishes: ['베이컨', '토스트', '오렌지 주스'],
        calories: 520,
        restaurantId: 1,
      ),
      RestaurantMenu(
        id: 8,
        date: dayAfterTomorrow,
        mealType: MealType.lunch,
        mainDish: '돈까스',
        sideDishes: ['우동', '양배추 샐러드', '피클', '배추김치'],
        dessert: '수박',
        calories: 850,
        restaurantId: 1,
      ),
      RestaurantMenu(
        id: 9,
        date: dayAfterTomorrow,
        mealType: MealType.dinner,
        mainDish: '*정시퇴근의 날*',
        sideDishes: [],
        dessert: null,
        calories: 0,
        restaurantId: 1,
      ),
    ];
  }
} 