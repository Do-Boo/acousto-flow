import 'dart:convert';
import 'dart:math' as math;
import 'package:http/http.dart' as http;
import '../models/equipment_task.dart';
import '../utils/api_constants.dart';

class EquipmentService {
  // API 요청용 헤더
  final Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // 모든 장비 관리 일정 가져오기
  Future<List<EquipmentTask>> getEquipmentTasks() async {
    try {
      // 모듈과 액션 개념을 사용하여 URL 구성
      final url = ApiConstants.buildUrl(ApiConstants.equipmentTasksEndpoint);
      
      if (ApiConstants.loggingEnabled) {
        print('API 요청 URL: $url');
        print('모듈: equipment, 액션: tasks');
      }
      
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode == 200) {
        print('API 응답 성공: ${response.statusCode}');
        
        final data = json.decode(response.body);
        
        if (data['success'] == true && data['data'] != null) {
          return List<EquipmentTask>.from(
            data['data'].map((x) => EquipmentTask.fromJson(x))
          );
        }
        
        // 성공했지만 데이터 형식이 예상과 다른 경우
        print('API 응답 형식이 예상과 다릅니다');
        print('응답 데이터: ${data.toString().substring(0, math.min(100, data.toString().length))}...');
        return getSampleEquipmentTasks();
      } else {
        print('API 호출 실패: 상태 코드 ${response.statusCode}');
        print('요청 URL: $url');
        if (response.body.isNotEmpty) {
          print('응답 내용: ${response.body.substring(0, math.min(200, response.body.length))}...');
        }
        return getSampleEquipmentTasks();
      }
    } catch (e) {
      print('장비 관리 일정 조회 오류: $e');
      print('요청 URL: ${ApiConstants.buildUrl(ApiConstants.equipmentTasksEndpoint)}');
      return getSampleEquipmentTasks();
    }
  }

  // 특정 담당자의 장비 관리 일정 가져오기
  Future<List<EquipmentTask>> getTasksByAssignee(String assignee) async {
    List<EquipmentTask> allTasks = await getEquipmentTasks();
    return allTasks.where((task) => task.assignedTo == assignee).toList();
  }

  // 특정 장비의 관리 일정 가져오기
  Future<List<EquipmentTask>> getTasksByEquipmentId(String equipmentId) async {
    List<EquipmentTask> allTasks = await getEquipmentTasks();
    return allTasks.where((task) => task.equipmentId == equipmentId).toList();
  }

  // 특정 날짜의 장비 관리 일정 가져오기
  Future<List<EquipmentTask>> getTasksByDate(DateTime date) async {
    List<EquipmentTask> allTasks = await getEquipmentTasks();
    return allTasks.where((task) {
      final taskDate = DateTime(task.startTime.year, task.startTime.month, task.startTime.day);
      final targetDate = DateTime(date.year, date.month, date.day);
      return taskDate.isAtSameMomentAs(targetDate);
    }).toList();
  }

  // 특정 기간의 장비 관리 일정 가져오기
  Future<List<EquipmentTask>> getTasksByDateRange(DateTime startDate, DateTime endDate) async {
    List<EquipmentTask> allTasks = await getEquipmentTasks();
    return allTasks.where((task) {
      final taskDate = DateTime(task.startTime.year, task.startTime.month, task.startTime.day);
      final rangeStart = DateTime(startDate.year, startDate.month, startDate.day);
      final rangeEnd = DateTime(endDate.year, endDate.month, endDate.day);
      
      return (taskDate.isAtSameMomentAs(rangeStart) || taskDate.isAfter(rangeStart)) && 
             (taskDate.isAtSameMomentAs(rangeEnd) || taskDate.isBefore(rangeEnd));
    }).toList();
  }

  // 새 장비 관리 일정 등록
  Future<EquipmentTask> createTask(EquipmentTask task) async {
    try {
      final url = ApiConstants.buildUrl(ApiConstants.addEquipmentTaskEndpoint);
      
      if (ApiConstants.loggingEnabled) {
        print('API 요청 URL: $url');
        print('모듈: equipment, 액션: tasks/add');
      }
      
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: json.encode(task.toJson()),
      );
      
      if (response.statusCode == 201 || response.statusCode == 200) {
        print('API 응답 성공: ${response.statusCode}');
        final data = json.decode(response.body);
        
        // 응답 구조 확인
        if (data is Map && (data['success'] == true || data['status'] == 'success') && data['data'] != null) {
          // Map<dynamic, dynamic>에서 Map<String, dynamic>으로 변환
          final Map<String, dynamic> typedData = {};
          (data['data'] as Map).forEach((key, value) {
            typedData[key.toString()] = value;
          });
          return EquipmentTask.fromJson(typedData);
        } else if (data is Map && data.containsKey('id')) {
          // Map<dynamic, dynamic>에서 Map<String, dynamic>으로 변환
          final Map<String, dynamic> typedData = {};
          data.forEach((key, value) {
            typedData[key.toString()] = value;
          });
          return EquipmentTask.fromJson(typedData);
        }
        
        print('API 응답 형식이 예상과 다릅니다: ${data.toString().substring(0, math.min(100, data.toString().length))}...');
        return task;
      } else {
        print('API 호출 실패: 상태 코드 ${response.statusCode}');
        print('요청 URL: $url');
        if (response.body.isNotEmpty) {
          print('응답 내용: ${response.body.substring(0, math.min(200, response.body.length))}...');
        }
        return task;
      }
    } catch (e) {
      print('장비 관리 일정 등록 오류: $e');
      print('요청 URL: ${ApiConstants.buildUrl(ApiConstants.addEquipmentTaskEndpoint)}');
      // API 호출에 실패한 경우 입력된 태스크 객체 그대로 반환
      return task;
    }
  }

  // 장비 관리 일정 상태 업데이트
  Future<bool> updateTaskStatus(String id, String status) async {
    try {
      final url = ApiConstants.buildUrl(ApiConstants.updateEquipmentTaskStatusEndpoint, {'id': id});
      
      if (ApiConstants.loggingEnabled) {
        print('API 요청 URL: $url');
        print('모듈: equipment, 액션: tasks/update-status, ID: $id');
      }
      
      final response = await http.patch(
        Uri.parse(url),
        headers: headers,
        body: json.encode({'status': status}),
      );
      
      if (response.statusCode == 200) {
        print('API 응답 성공: ${response.statusCode}');
        return true;
      } else {
        print('API 호출 실패: 상태 코드 ${response.statusCode}');
        print('요청 URL: $url');
        if (response.body.isNotEmpty) {
          print('응답 내용: ${response.body.substring(0, math.min(200, response.body.length))}...');
        }
        return false;
      }
    } catch (e) {
      print('장비 관리 일정 상태 업데이트 오류: $e');
      print('요청 URL: ${ApiConstants.buildUrl(ApiConstants.updateEquipmentTaskStatusEndpoint, {'id': id})}');
      return false;
    }
  }

  // 샘플 장비 관리 일정 데이터 반환 (API 호출 실패 시 사용)
  List<EquipmentTask> getSampleEquipmentTasks() {
    final now = DateTime.now();
    return [
      EquipmentTask(
        id: '1',
        taskName: '프로젝터 점검',
        description: 'B동 세미나실 프로젝터 화질 및 연결 상태 점검',
        startTime: DateTime(now.year, now.month, now.day, 14, 0),
        endTime: DateTime(now.year, now.month, now.day, 15, 0),
        location: 'B동 세미나실',
        equipmentId: 'PROJ-001',
        equipmentName: 'Sony VPL-FHZ75',
        assignedTo: '김도유',
        department: '음향실',
        status: 'completed',
        createdAt: DateTime.now().subtract(Duration(days: 5)),
        updatedAt: DateTime.now().subtract(Duration(days: 5)),
      ),
      EquipmentTask(
        id: '2',
        taskName: '마이크 설치',
        description: '대회의실 유선 마이크 10개 설치 및 테스트',
        startTime: DateTime(now.year, now.month, now.day + 1, 9, 0),
        endTime: DateTime(now.year, now.month, now.day + 1, 11, 0),
        location: '대회의실',
        equipmentId: 'MIC-001',
        equipmentName: 'Shure SM58',
        assignedTo: '이서연',
        department: '음향실',
        status: 'pending',
        createdAt: DateTime.now().subtract(Duration(days: 2)),
        updatedAt: DateTime.now().subtract(Duration(days: 2)),
      ),
      EquipmentTask(
        id: '3',
        taskName: '비디오 월 유지보수',
        description: '로비 비디오 월 소프트웨어 업데이트 및 화면 조정',
        startTime: DateTime(now.year, now.month, now.day + 3, 16, 0),
        endTime: DateTime(now.year, now.month, now.day + 3, 18, 0),
        location: '로비',
        equipmentId: 'VW-001',
        equipmentName: 'Samsung Video Wall',
        assignedTo: '박지훈',
        department: '시설관리부',
        status: 'pending',
        createdAt: DateTime.now().subtract(Duration(days: 1)),
        updatedAt: DateTime.now().subtract(Duration(days: 1)),
      ),
      EquipmentTask(
        id: '4',
        taskName: '스피커 교체',
        description: '회의실 3의 고장난 스피커 교체',
        startTime: DateTime(now.year, now.month, now.day - 1, 10, 0),
        endTime: DateTime(now.year, now.month, now.day - 1, 11, 30),
        location: '회의실 3',
        equipmentId: 'SPK-003',
        equipmentName: 'Bose SoundLink',
        assignedTo: '김도유',
        department: '음향실',
        status: 'completed',
        createdAt: DateTime.now().subtract(Duration(days: 4)),
        updatedAt: DateTime.now().subtract(Duration(days: 3)),
      ),
      EquipmentTask(
        id: '5',
        taskName: '네트워크 장비 점검',
        description: '세미나실 네트워크 스위치 및 AP 점검',
        startTime: DateTime(now.year, now.month, now.day + 2, 13, 0),
        endTime: DateTime(now.year, now.month, now.day + 2, 15, 0),
        location: '세미나실',
        equipmentId: 'NET-001',
        equipmentName: 'Cisco Catalyst 9200',
        assignedTo: '정재훈',
        department: 'IT팀',
        status: 'pending',
        createdAt: DateTime.now().subtract(Duration(days: 3)),
        updatedAt: DateTime.now().subtract(Duration(days: 3)),
      ),
    ];
  }
} 