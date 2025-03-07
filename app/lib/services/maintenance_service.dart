import 'dart:convert';
import 'dart:math' as math;
import 'package:http/http.dart' as http;

import '../models/equipment_maintenance.dart';
import '../utils/api_constants.dart';

// 이 클래스는 EquipmentMaintenanceService와 중복되므로 사용을 권장하지 않습니다.
// 새로운 코드에서는 EquipmentMaintenanceService를 사용하세요.
// 호환성을 위해 이 클래스를 유지합니다.
@Deprecated('Use EquipmentMaintenanceService instead')
class MaintenanceService {
  // API 요청용 헤더
  final Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // 장비별 유지보수 이력 조회
  Future<List<Maintenance>> getMaintenanceHistory(int equipmentId) async {
    try {
      // 모듈과 액션 개념을 사용하여 URL 구성
      final url = ApiConstants.buildUrl(ApiConstants.equipmentMaintenanceEndpoint, {
        'action': 'list',
        'equipment_id': equipmentId
      });
      
      if (ApiConstants.loggingEnabled) {
        print('API 요청 URL: $url');
        print('모듈: equipment, 액션: maintenance, 하위액션: list, 장비ID: $equipmentId');
      }
      
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode == 200) {
        print('API 응답 성공: ${response.statusCode}');
        
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['success'] && data['data'] != null) {
          return List<Maintenance>.from(
            data['data'].map((x) => Maintenance.fromJson(x)),
          );
        }
        
        // 성공했지만 데이터 형식이 예상과 다른 경우
        print('API 응답 형식이 예상과 다릅니다');
        print('응답 데이터: ${data.toString().substring(0, math.min(100, data.toString().length))}...');
        return [];
      } else {
        print('API 호출 실패: 상태 코드 ${response.statusCode}');
        print('요청 URL: $url');
        if (response.body.isNotEmpty) {
          print('응답 내용: ${response.body.substring(0, math.min(200, response.body.length))}...');
        }
        // 샘플 데이터 반환 코드 추가
        return [];
      }
    } catch (e) {
      print('유지보수 이력 조회 오류: $e');
      print('요청 URL: ${ApiConstants.buildUrl(ApiConstants.equipmentMaintenanceEndpoint, {'action': 'list', 'equipment_id': equipmentId})}');
      // 샘플 데이터 반환 코드 추가
      return [];
    }
  }

  // 유지보수 상세 정보 조회
  Future<Maintenance?> getMaintenanceDetail(int maintenanceId) async {
    try {
      final url = ApiConstants.buildUrl(ApiConstants.equipmentMaintenanceEndpoint, {
        'action': 'detail',
        'id': maintenanceId
      });
      
      if (ApiConstants.loggingEnabled) {
        print('API 요청 URL: $url');
      }
      
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['success'] && data['data'] != null) {
          return Maintenance.fromJson(data['data']);
        }
        return null;
      } else {
        print('API 호출 실패: 상태 코드 ${response.statusCode}');
        print('요청 URL: $url');
        if (response.body.isNotEmpty) {
          print('응답 내용: ${response.body.substring(0, math.min(200, response.body.length))}...');
        }
        return null;
      }
    } catch (e) {
      print('유지보수 상세 정보 조회 오류: $e');
      print('요청 URL: ${ApiConstants.buildUrl(ApiConstants.equipmentMaintenanceEndpoint, {'action': 'detail', 'id': maintenanceId})}');
      return null;
    }
  }

  // 유지보수 기록 추가
  Future<Map<String, dynamic>> addMaintenance(int equipmentId, Map<String, dynamic> maintenanceData) async {
    try {
      final url = ApiConstants.buildUrl(ApiConstants.equipmentMaintenanceEndpoint, {
        'action': 'add',
        'equipment_id': equipmentId
      });
      
      if (ApiConstants.loggingEnabled) {
        print('API 요청 URL: $url');
      }
      
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: json.encode(maintenanceData),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('API 호출 실패: 상태 코드 ${response.statusCode}');
        print('요청 URL: $url');
        throw Exception('서버 오류: ${response.statusCode}');
      }
    } catch (e) {
      print('유지보수 기록 추가 오류: $e');
      throw Exception('유지보수 기록을 추가하는 중 오류가 발생했습니다.');
    }
  }

  // 유지보수 기록 수정
  Future<Map<String, dynamic>> updateMaintenance(int maintenanceId, Map<String, dynamic> maintenanceData) async {
    try {
      final url = ApiConstants.buildUrl(ApiConstants.equipmentMaintenanceEndpoint, {
        'action': 'update',
        'id': maintenanceId
      });
      
      if (ApiConstants.loggingEnabled) {
        print('API 요청 URL: $url');
      }
      
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: json.encode(maintenanceData),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('API 호출 실패: 상태 코드 ${response.statusCode}');
        print('요청 URL: $url');
        throw Exception('서버 오류: ${response.statusCode}');
      }
    } catch (e) {
      print('유지보수 기록 수정 오류: $e');
      throw Exception('유지보수 기록을 수정하는 중 오류가 발생했습니다.');
    }
  }

  // 유지보수 기록 삭제
  Future<Map<String, dynamic>> deleteMaintenance(int maintenanceId) async {
    try {
      final url = ApiConstants.buildUrl(ApiConstants.equipmentMaintenanceEndpoint, {
        'action': 'delete',
        'id': maintenanceId
      });
      
      if (ApiConstants.loggingEnabled) {
        print('API 요청 URL: $url');
      }
      
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('API 호출 실패: 상태 코드 ${response.statusCode}');
        print('요청 URL: $url');
        throw Exception('서버 오류: ${response.statusCode}');
      }
    } catch (e) {
      print('유지보수 기록 삭제 오류: $e');
      throw Exception('유지보수 기록을 삭제하는 중 오류가 발생했습니다.');
    }
  }

  // 댓글 추가
  Future<Map<String, dynamic>> addComment(int maintenanceId, String content) async {
    try {
      final url = ApiConstants.buildUrl(ApiConstants.equipmentMaintenanceEndpoint, {
        'action': 'comment',
        'operation': 'add',
        'maintenance_id': maintenanceId
      });
      
      if (ApiConstants.loggingEnabled) {
        print('API 요청 URL: $url');
      }
      
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: json.encode({'content': content}),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('API 호출 실패: 상태 코드 ${response.statusCode}');
        print('요청 URL: $url');
        throw Exception('서버 오류: ${response.statusCode}');
      }
    } catch (e) {
      print('댓글 추가 오류: $e');
      throw Exception('댓글을 추가하는 중 오류가 발생했습니다.');
    }
  }

  // 댓글 삭제
  Future<Map<String, dynamic>> deleteComment(int commentId) async {
    try {
      final url = ApiConstants.buildUrl(ApiConstants.equipmentMaintenanceEndpoint, {
        'action': 'comment',
        'operation': 'delete',
        'comment_id': commentId
      });
      
      if (ApiConstants.loggingEnabled) {
        print('API 요청 URL: $url');
      }
      
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('API 호출 실패: 상태 코드 ${response.statusCode}');
        print('요청 URL: $url');
        throw Exception('서버 오류: ${response.statusCode}');
      }
    } catch (e) {
      print('댓글 삭제 오류: $e');
      throw Exception('댓글을 삭제하는 중 오류가 발생했습니다.');
    }
  }

  // 좋아요 토글
  Future<Map<String, dynamic>> toggleLike(int maintenanceId) async {
    try {
      final url = ApiConstants.buildUrl(ApiConstants.equipmentMaintenanceEndpoint, {
        'action': 'like',
        'maintenance_id': maintenanceId
      });
      
      if (ApiConstants.loggingEnabled) {
        print('API 요청 URL: $url');
      }
      
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('API 호출 실패: 상태 코드 ${response.statusCode}');
        print('요청 URL: $url');
        throw Exception('서버 오류: ${response.statusCode}');
      }
    } catch (e) {
      print('좋아요 토글 오류: $e');
      throw Exception('좋아요를 토글하는 중 오류가 발생했습니다.');
    }
  }
} 