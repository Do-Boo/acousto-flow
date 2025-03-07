import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/construction_project.dart';
import '../utils/api_constants.dart';

class ConstructionService {
  // API 기본 URL
  final String baseUrl = ApiConstants.baseUrl;
  final Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // 모든 공사 일정 가져오기
  Future<List<ConstructionProject>> getConstructionProjects() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl${ApiConstants.constructionProjectsEndpoint}'),
        headers: headers,
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => ConstructionProject.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load construction projects: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching construction projects: $e');
      // API 호출에 실패한 경우 샘플 데이터 반환
      return getSampleConstructionProjects();
    }
  }

  // 특정 담당 부서의 공사 일정 가져오기
  Future<List<ConstructionProject>> getProjectsByDepartment(String department) async {
    List<ConstructionProject> allProjects = await getConstructionProjects();
    return allProjects.where((project) => project.department == department).toList();
  }

  // 특정 시공사의 공사 일정 가져오기
  Future<List<ConstructionProject>> getProjectsByContractor(String contractor) async {
    List<ConstructionProject> allProjects = await getConstructionProjects();
    return allProjects.where((project) => project.contractor == contractor).toList();
  }

  // 특정 날짜에 진행 중인 공사 일정 가져오기
  Future<List<ConstructionProject>> getProjectsByDate(DateTime date) async {
    List<ConstructionProject> allProjects = await getConstructionProjects();
    return allProjects.where((project) {
      final projectStart = DateTime(project.startTime.year, project.startTime.month, project.startTime.day);
      final projectEnd = DateTime(project.endTime.year, project.endTime.month, project.endTime.day);
      final targetDate = DateTime(date.year, date.month, date.day);
      
      return (targetDate.isAtSameMomentAs(projectStart) || targetDate.isAfter(projectStart)) && 
             (targetDate.isAtSameMomentAs(projectEnd) || targetDate.isBefore(projectEnd));
    }).toList();
  }

  // 특정 기간 내의 공사 일정 가져오기
  Future<List<ConstructionProject>> getProjectsByDateRange(DateTime startDate, DateTime endDate) async {
    List<ConstructionProject> allProjects = await getConstructionProjects();
    return allProjects.where((project) {
      final projectStart = DateTime(project.startTime.year, project.startTime.month, project.startTime.day);
      final projectEnd = DateTime(project.endTime.year, project.endTime.month, project.endTime.day);
      final rangeStart = DateTime(startDate.year, startDate.month, startDate.day);
      final rangeEnd = DateTime(endDate.year, endDate.month, endDate.day);
      
      // 프로젝트 기간이 지정된 기간과 겹치는지 확인
      return (projectEnd.isAtSameMomentAs(rangeStart) || projectEnd.isAfter(rangeStart)) && 
             (projectStart.isAtSameMomentAs(rangeEnd) || projectStart.isBefore(rangeEnd));
    }).toList();
  }

  // 새 공사 일정 등록
  Future<ConstructionProject> createProject(ConstructionProject project) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl${ApiConstants.addConstructionProjectEndpoint}'),
        headers: headers,
        body: json.encode(project.toJson()),
      );
      
      if (response.statusCode == 201) {
        return ConstructionProject.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to create project: ${response.statusCode}');
      }
    } catch (e) {
      print('Error creating project: $e');
      // API 호출에 실패한 경우 입력된 프로젝트 객체 그대로 반환
      return project;
    }
  }

  // 공사 일정 상태 업데이트
  Future<bool> updateProjectStatus(String id, String status) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl${ApiConstants.updateConstructionStatusEndpoint}?id=$id'),
        headers: headers,
        body: json.encode({'status': status}),
      );
      
      return response.statusCode == 200;
    } catch (e) {
      print('Error updating project status: $e');
      return false;
    }
  }

  // 샘플 공사 일정 데이터 반환 (API 호출 실패 시 사용)
  List<ConstructionProject> getSampleConstructionProjects() {
    final now = DateTime.now();
    return [
      ConstructionProject(
        id: '1',
        projectName: '대회의실 리모델링 공사',
        description: '대회의실 벽면 및 천장 공사, 음향 시스템 업그레이드',
        startTime: DateTime(now.year, now.month, now.day - 5),
        endTime: DateTime(now.year, now.month, now.day + 10),
        isAllDay: true,
        location: '대회의실',
        contractor: '한국건설(주)',
        contactPerson: '김영수 (010-1234-5678)',
        department: '시설관리부',
        status: 'in_progress',
        createdAt: DateTime.now().subtract(Duration(days: 30)),
        updatedAt: DateTime.now().subtract(Duration(days: 25)),
      ),
      ConstructionProject(
        id: '2',
        projectName: '주차장 확장 공사',
        description: '지하 주차장 추가 공간 확보를 위한 공사',
        startTime: DateTime(now.year, now.month, now.day + 15),
        endTime: DateTime(now.year, now.month, now.day + 45),
        isAllDay: true,
        location: '지하 주차장',
        contractor: '서울건설(주)',
        contactPerson: '박성민 (010-2345-6789)',
        department: '시설관리부',
        status: 'pending',
        createdAt: DateTime.now().subtract(Duration(days: 20)),
        updatedAt: DateTime.now().subtract(Duration(days: 20)),
      ),
      ConstructionProject(
        id: '3',
        projectName: '로비 조명 교체 공사',
        description: '로비 LED 조명 교체 및 전기 배선 공사',
        startTime: DateTime(now.year, now.month, now.day - 10),
        endTime: DateTime(now.year, now.month, now.day - 8),
        isAllDay: true,
        location: '로비',
        contractor: '광명전기(주)',
        contactPerson: '이정호 (010-3456-7890)',
        department: '시설관리부',
        status: 'completed',
        createdAt: DateTime.now().subtract(Duration(days: 15)),
        updatedAt: DateTime.now().subtract(Duration(days: 8)),
      ),
      ConstructionProject(
        id: '4',
        projectName: '화장실 수리 공사',
        description: '3층 화장실 배관 및 타일 교체',
        startTime: DateTime(now.year, now.month, now.day + 3),
        endTime: DateTime(now.year, now.month, now.day + 5),
        isAllDay: true,
        location: '3층 화장실',
        contractor: '청담설비(주)',
        contactPerson: '최영민 (010-4567-8901)',
        department: '시설관리부',
        status: 'pending',
        createdAt: DateTime.now().subtract(Duration(days: 5)),
        updatedAt: DateTime.now().subtract(Duration(days: 5)),
      ),
      ConstructionProject(
        id: '5',
        projectName: '옥상 방수 공사',
        description: '옥상 방수층 보수 및 균열 보강 공사',
        startTime: DateTime(now.year, now.month, now.day + 20),
        endTime: DateTime(now.year, now.month, now.day + 25),
        isAllDay: true,
        location: '옥상',
        contractor: '강남건설(주)',
        contactPerson: '나영석 (010-5678-9012)',
        department: '시설관리부',
        status: 'pending',
        createdAt: DateTime.now().subtract(Duration(days: 10)),
        updatedAt: DateTime.now().subtract(Duration(days: 10)),
      ),
    ];
  }
} 