import 'dart:convert';
import 'dart:math' as math;
import 'package:http/http.dart' as http;
import '../models/vacation.dart';
import '../utils/api_constants.dart';

class VacationService {
  // API 요청용 헤더
  final Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // 모든 휴가 일정 가져오기
  Future<List<Vacation>> getVacations() async {
    try {
      // 모듈과 액션 개념을 사용하여 URL 구성
      final url = ApiConstants.buildUrl(ApiConstants.vacationsEndpoint);
      
      if (ApiConstants.loggingEnabled) {
        print('API 요청 URL: $url');
        print('모듈: users, 액션: vacations');
      }
      
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );
      
      if (response.statusCode == 200) {
        print('API 응답 성공: ${response.statusCode}');
        
        final data = json.decode(response.body);
        
        // 응답 구조 확인 - 직접 배열이거나 data 필드 내 배열인 경우 처리
        if (data is List) {
          return data.map((item) => Vacation.fromJson(item)).toList();
        } else if (data is Map && (data['success'] == true || data['status'] == 'success') && data['data'] is List) {
          return List<Vacation>.from(data['data'].map((x) => Vacation.fromJson(x)));
        }
        
        print('API 응답 형식이 예상과 다릅니다: ${data.toString().substring(0, math.min(100, data.toString().length))}...');
        return getSampleVacations();
      } else {
        print('API 호출 실패: 상태 코드 ${response.statusCode}');
        print('요청 URL: $url');
        if (response.body.isNotEmpty) {
          print('응답 내용: ${response.body.substring(0, math.min(200, response.body.length))}...');
        }
        return getSampleVacations();
      }
    } catch (e) {
      print('휴가 정보 조회 오류: $e');
      print('요청 URL: ${ApiConstants.buildUrl(ApiConstants.vacationsEndpoint)}');
      // API 호출에 실패한 경우 샘플 데이터 반환
      return getSampleVacations();
    }
  }

  // 특정 사용자의 휴가 일정 가져오기
  Future<List<Vacation>> getVacationsByUserId(int userId) async {
    try {
      final url = ApiConstants.buildUrl(ApiConstants.vacationsEndpoint, {'user_id': userId});
      
      if (ApiConstants.loggingEnabled) {
        print('API 요청 URL: $url');
      }
      
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        // 응답 구조 확인
        if (data is List) {
          return data.map((item) => Vacation.fromJson(item)).toList();
        } else if (data is Map && (data['success'] == true || data['status'] == 'success') && data['data'] is List) {
          return List<Vacation>.from(data['data'].map((x) => Vacation.fromJson(x)));
        }
        
        print('API 응답 형식이 예상과 다릅니다.');
        // 모든 휴가를 가져온 후 필터링하는 대체 방법 사용
        return getVacations().then((allVacations) => 
          allVacations.where((v) => v.userId == userId).toList());
      } else {
        print('API 호출 실패: 상태 코드 ${response.statusCode}');
        // 모든 휴가를 가져온 후 필터링하는 대체 방법 사용
        return getVacations().then((allVacations) => 
          allVacations.where((v) => v.userId == userId).toList());
      }
    } catch (e) {
      print('사용자별 휴가 정보 조회 오류: $e');
      // 오류 발생 시 모든 휴가를 가져온 후 필터링
      return getVacations().then((allVacations) => 
        allVacations.where((v) => v.userId == userId).toList());
    }
  }

  // 특정 부서의 휴가 일정 가져오기
  Future<List<Vacation>> getVacationsByDepartment(String department) async {
    List<Vacation> allVacations = await getVacations();
    return allVacations.where((vacation) => vacation.department == department).toList();
  }

  // 특정 날짜의 휴가 일정 가져오기
  Future<List<Vacation>> getVacationsByDate(DateTime date) async {
    List<Vacation> allVacations = await getVacations();
    return allVacations.where((vacation) {
      final vacationStart = DateTime(vacation.startTime.year, vacation.startTime.month, vacation.startTime.day);
      final vacationEnd = DateTime(vacation.endTime.year, vacation.endTime.month, vacation.endTime.day);
      final targetDate = DateTime(date.year, date.month, date.day);
      
      return (targetDate.isAtSameMomentAs(vacationStart) || targetDate.isAfter(vacationStart)) && 
             (targetDate.isAtSameMomentAs(vacationEnd) || targetDate.isBefore(vacationEnd));
    }).toList();
  }

  // 특정 기간의 휴가 일정 가져오기
  Future<List<Vacation>> getVacationsByDateRange(DateTime startDate, DateTime endDate) async {
    List<Vacation> allVacations = await getVacations();
    return allVacations.where((vacation) {
      final vacationStart = DateTime(vacation.startTime.year, vacation.startTime.month, vacation.startTime.day);
      final vacationEnd = DateTime(vacation.endTime.year, vacation.endTime.month, vacation.endTime.day);
      final rangeStart = DateTime(startDate.year, startDate.month, startDate.day);
      final rangeEnd = DateTime(endDate.year, endDate.month, endDate.day);
      
      // 휴가 기간이 지정된 기간과 겹치는지 확인
      return (vacationEnd.isAtSameMomentAs(rangeStart) || vacationEnd.isAfter(rangeStart)) && 
             (vacationStart.isAtSameMomentAs(rangeEnd) || vacationStart.isBefore(rangeEnd));
    }).toList();
  }

  // 휴가 신청하기
  Future<Vacation> requestVacation(Vacation vacation) async {
    try {
      final url = ApiConstants.buildUrl(ApiConstants.addVacationEndpoint);
      
      if (ApiConstants.loggingEnabled) {
        print('API 요청 URL: $url');
      }
      
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: json.encode(vacation.toJson()),
      );
      
      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = json.decode(response.body);
        
        // 응답 구조 확인 - 직접 객체이거나 data 필드 내 객체인 경우 처리
        if (data is Map) {
          if (data.containsKey('id') || data.containsKey('userId')) {
            // 필요한 경우 Map<dynamic, dynamic>에서 Map<String, dynamic>으로 변환
            final Map<String, dynamic> typedData = {};
            data.forEach((key, value) {
              typedData[key.toString()] = value;
            });
            return Vacation.fromJson(typedData);
          } else if ((data['success'] == true || data['status'] == 'success') && data['data'] != null) {
            if (data['data'] is Map) {
              // 필요한 경우 Map<dynamic, dynamic>에서 Map<String, dynamic>으로 변환
              final Map<String, dynamic> typedData = {};
              (data['data'] as Map).forEach((key, value) {
                typedData[key.toString()] = value;
              });
              return Vacation.fromJson(typedData);
            }
          }
        }
        
        print('API 응답 형식이 예상과 다릅니다: ${data.toString().substring(0, math.min(100, data.toString().length))}...');
        return vacation;
      } else {
        print('API 호출 실패: 상태 코드 ${response.statusCode}');
        print('요청 URL: $url');
        if (response.body.isNotEmpty) {
          print('응답 내용: ${response.body.substring(0, math.min(200, response.body.length))}...');
        }
        return vacation;
      }
    } catch (e) {
      print('휴가 신청 오류: $e');
      print('요청 URL: ${ApiConstants.buildUrl(ApiConstants.addVacationEndpoint)}');
      // API 호출에 실패한 경우 입력된 휴가 객체 그대로 반환
      return vacation;
    }
  }

  // 휴가 상태 업데이트 (승인, 취소, 거절 등)
  Future<bool> updateVacationStatus(String id, String status) async {
    try {
      final url = ApiConstants.buildUrl(ApiConstants.updateVacationStatusEndpoint, {'id': id});
      
      if (ApiConstants.loggingEnabled) {
        print('API 요청 URL: $url');
      }
      
      final response = await http.patch(
        Uri.parse(url),
        headers: headers,
        body: json.encode({'status': status}),
      );
      
      return response.statusCode == 200;
    } catch (e) {
      print('휴가 상태 업데이트 오류: $e');
      print('요청 URL: ${ApiConstants.buildUrl(ApiConstants.updateVacationStatusEndpoint, {'id': id})}');
      return false;
    }
  }

  // 샘플 휴가 데이터 반환 (API 호출 실패 시 사용)
  List<Vacation> getSampleVacations() {
    final now = DateTime.now();
    return [
      Vacation(
        id: '1',
        userId: 1,
        userName: '김도유',
        department: '음향실',
        vacationType: 'annual',
        startTime: DateTime(now.year, now.month, now.day + 5),
        endTime: DateTime(now.year, now.month, now.day + 5),
        isAllDay: true,
        reason: '개인 사정',
        status: 'approved',
        createdAt: DateTime.now().subtract(Duration(days: 10)),
        updatedAt: DateTime.now().subtract(Duration(days: 9)),
      ),
      Vacation(
        id: '2',
        userId: 2,
        userName: '이서연',
        department: '음향실',
        vacationType: 'half_day',
        startTime: DateTime(now.year, now.month, now.day + 2, 14),
        endTime: DateTime(now.year, now.month, now.day + 2, 18),
        isAllDay: false,
        reason: '병원 예약',
        status: 'approved',
        createdAt: DateTime.now().subtract(Duration(days: 5)),
        updatedAt: DateTime.now().subtract(Duration(days: 4)),
      ),
      Vacation(
        id: '3',
        userId: 3,
        userName: '박지훈',
        department: '시설관리부',
        vacationType: 'annual',
        startTime: DateTime(now.year, now.month, now.day - 2),
        endTime: DateTime(now.year, now.month, now.day + 1),
        isAllDay: true,
        reason: '가족 여행',
        status: 'approved',
        createdAt: DateTime.now().subtract(Duration(days: 15)),
        updatedAt: DateTime.now().subtract(Duration(days: 14)),
      ),
      Vacation(
        id: '4',
        userId: 4,
        userName: '최민지',
        department: '인사팀',
        vacationType: 'sick',
        startTime: DateTime(now.year, now.month, now.day),
        endTime: DateTime(now.year, now.month, now.day + 3),
        isAllDay: true,
        reason: '감기 치료',
        status: 'approved',
        createdAt: DateTime.now().subtract(Duration(days: 1)),
        updatedAt: DateTime.now().subtract(Duration(days: 1)),
      ),
      Vacation(
        id: '5',
        userId: 5,
        userName: '정승호',
        department: '개발팀',
        vacationType: 'special',
        startTime: DateTime(now.year, now.month, now.day + 7),
        endTime: DateTime(now.year, now.month, now.day + 8),
        isAllDay: true,
        reason: '결혼식',
        status: 'pending',
        createdAt: DateTime.now().subtract(Duration(days: 2)),
        updatedAt: DateTime.now().subtract(Duration(days: 2)),
      ),
    ];
  }
} 