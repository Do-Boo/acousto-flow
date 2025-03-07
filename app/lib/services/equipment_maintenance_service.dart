import 'dart:convert';
import 'dart:math' as math;
import 'package:http/http.dart' as http;
import '../models/equipment_maintenance.dart';
import '../utils/api_constants.dart';

class EquipmentMaintenanceService {
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
        'equipment_id': equipmentId.toString()
      });
      
      if (ApiConstants.loggingEnabled) {
        print('API 요청 URL: $url');
        print('모듈: equipment, 액션: maintenance, 장비ID: $equipmentId');
      }
      
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode == 200) {
        print('API 응답 성공: ${response.statusCode}');
        
        final Map<String, dynamic> responseData = json.decode(response.body);
        
        if (responseData['success'] == true && responseData['data'] != null) {
          final data = responseData['data'];
          
          // 데이터가 리스트 형태인 경우
          if (data is List) {
            try {
              return data.map((item) {
                // 안전하게 파싱하기 위해 필요한 필드들이 있는지 확인
                return _safeParseMaintenanceItem(item);
              }).toList();
            } catch (e) {
              print('유지보수 데이터 파싱 오류: $e');
              print('응답 데이터: ${data.toString().substring(0, math.min(300, data.toString().length))}...');
              return _getSampleMaintenanceHistory(equipmentId);
            }
          } 
          // 데이터가 Map 형태인 경우 (단일 항목)
          else if (data is Map<String, dynamic>) {
            try {
              return [_safeParseMaintenanceItem(data)];
            } catch (e) {
              print('유지보수 데이터 파싱 오류(단일 항목): $e');
              return _getSampleMaintenanceHistory(equipmentId);
            }
          }
          // 기타 형식은 샘플 데이터 반환
          else {
            print('API 응답이 예상 형식이 아닙니다. 데이터 타입: ${data.runtimeType}');
            print('응답 데이터: ${data.toString().substring(0, math.min(100, data.toString().length))}...');
            return _getSampleMaintenanceHistory(equipmentId);
          }
        } else {
          print('API 응답이 success가 아니거나 data가 null입니다');
          print('응답 데이터: ${responseData.toString().substring(0, math.min(100, responseData.toString().length))}...');
          return _getSampleMaintenanceHistory(equipmentId);
        }
      } else {
        print('API 호출 실패: 상태 코드 ${response.statusCode}');
        print('요청 URL: $url');
        if (response.body.isNotEmpty) {
          print('응답 내용: ${response.body.substring(0, math.min(200, response.body.length))}...');
        }
        return _getSampleMaintenanceHistory(equipmentId);
      }
    } catch (e) {
      print('유지보수 이력 조회 오류: $e');
      print('요청 URL: ${ApiConstants.buildUrl(ApiConstants.equipmentMaintenanceEndpoint, {'equipment_id': equipmentId.toString()})}');
      return _getSampleMaintenanceHistory(equipmentId);
    }
  }

  // 안전하게 유지보수 항목 파싱
  Maintenance _safeParseMaintenanceItem(Map<String, dynamic> item) {
    print('유지보수 아이템 파싱 시도: ${item.toString().substring(0, math.min(300, item.toString().length))}...');
    
    // 기본값과 함께 안전하게 값 가져오기
    final id = item['id'] is int ? item['id'] : int.tryParse(item['id']?.toString() ?? '0') ?? 0;
    final equipmentId = item['equipmentId'] is int ? item['equipmentId'] : 
        int.tryParse(item['equipmentId']?.toString() ?? '0') ?? 0;
    
    // 새로운 API 응답 형식에 맞게 필드 매핑
    // maintenanceType이 actionType에 해당함
    final actionType = item['maintenanceType']?.toString() ?? '점검';
    
    // 날짜 관련 필드 처리
    final maintenanceDate = item['maintenanceDate']?.toString() ?? DateTime.now().toString().substring(0, 10);
    final createdAt = item['createdAt']?.toString() ?? DateTime.now().toString();
    
    // commentCount, likeCount 처리 - 이제 단순 숫자로 제공
    int commentCount = 0;
    if (item['comments'] is int) {
      commentCount = item['comments'];
    } else {
      commentCount = int.tryParse(item['comments']?.toString() ?? '0') ?? 0;
    }
    
    int likeCount = 0;
    if (item['likes'] is int) {
      likeCount = item['likes'];
    } else {
      likeCount = int.tryParse(item['likes']?.toString() ?? '0') ?? 0;
    }
    
    // 설명 관련 필드
    final description = item['description']?.toString() ?? '';
    final performedBy = item['performedBy']?.toString() ?? '';
    final status = item['status']?.toString() ?? 'completed';
    final partsReplaced = item['partsReplaced']?.toString();
    
    // 비용 처리
    int cost = 0;
    if (item['cost'] is int) {
      cost = item['cost'];
    } else {
      cost = int.tryParse(item['cost']?.toString() ?? '0') ?? 0;
    }
    
    // 기본 필드들 안전하게 파싱 - 새로운 형식과 이전 형식을 모두 지원
    return Maintenance(
      id: id,
      equipmentId: equipmentId,
      locationDescription: item['locationDescription']?.toString() ?? '',
      reservationId: item['reservationId']?.toString() ?? '',
      actionType: actionType,
      startTime: item['startTime']?.toString() ?? '$maintenanceDate 09:00:00',
      endTime: item['endTime']?.toString() ?? '$maintenanceDate 10:00:00',
      date: maintenanceDate,
      time: item['time']?.toString() ?? '09:00 - 10:00',
      duration: item['duration']?.toString() ?? '1시간',
      // description을 issuesFound와 resolution에 나누어 저장
      issuesFound: description,
      resolution: partsReplaced,
      filterHoursUpdated: item['filterHoursUpdated'] is int ? item['filterHoursUpdated'] : null,
      lampHoursUpdated: item['lampHoursUpdated'] is int ? item['lampHoursUpdated'] : null,
      workedBy: performedBy,
      createdAt: createdAt,
      // 장비 정보가 없는 경우 일반적인 이름 사용
      equipmentName: item['equipmentName']?.toString() ?? '장비 #$equipmentId',
      equipmentModel: item['equipmentModel']?.toString() ?? '모델 정보 없음',
      manufacturer: item['manufacturer']?.toString() ?? '제조사 정보 없음',
      meetingName: item['meetingName']?.toString() ?? '',
      meetingDate: item['meetingDate']?.toString() ?? '',
      // 새 형식에는 이미지가 포함되지 않음
      images: [],
      commentCount: commentCount,
      likeCount: likeCount,
      comments: [],
      likes: [],
      imageCount: 0,
    );
  }

  // 샘플 데이터 생성
  List<Maintenance> _getSampleMaintenanceHistory(int equipmentId) {
    final now = DateTime.now();
    final todayStr = now.toString().substring(0, 10);
    final yesterdayStr = now.subtract(Duration(days: 1)).toString().substring(0, 10);
    final lastWeekStr = now.subtract(Duration(days: 7)).toString().substring(0, 10);
    
    return [
      Maintenance(
        id: 1,
        equipmentId: equipmentId,
        actionType: '정기점검',
        startTime: '$todayStr 09:00:00',
        endTime: '$todayStr 10:30:00',
        date: todayStr,
        time: '09:00 - 10:30',
        duration: '1시간 30분',
        workedBy: '김도유',
        createdAt: '$todayStr 10:35:00',
        equipmentName: '프로젝터 #$equipmentId',
        equipmentModel: 'XYZ-1000',
        manufacturer: 'ABC Electronics',
        images: [],
        commentCount: 0,
        likeCount: 2,
      ),
      Maintenance(
        id: 2,
        equipmentId: equipmentId,
        actionType: '수리',
        startTime: '$yesterdayStr 14:00:00',
        endTime: '$yesterdayStr 16:30:00',
        date: yesterdayStr,
        time: '14:00 - 16:30',
        duration: '2시간 30분',
        issuesFound: '램프 밝기 저하 및 간헐적 깜빡임',
        resolution: '램프 교체 및 냉각 팬 청소',
        workedBy: '이서연',
        createdAt: '$yesterdayStr 16:40:00',
        equipmentName: '프로젝터 #$equipmentId',
        equipmentModel: 'XYZ-1000',
        manufacturer: 'ABC Electronics',
        images: [],
        commentCount: 3,
        likeCount: 5,
      ),
      Maintenance(
        id: 3,
        equipmentId: equipmentId,
        actionType: '청소',
        startTime: '$lastWeekStr 10:00:00',
        endTime: '$lastWeekStr 11:00:00',
        date: lastWeekStr,
        time: '10:00 - 11:00',
        duration: '1시간',
        workedBy: '박지훈',
        createdAt: '$lastWeekStr 11:10:00',
        equipmentName: '프로젝터 #$equipmentId',
        equipmentModel: 'XYZ-1000',
        manufacturer: 'ABC Electronics',
        images: [],
        commentCount: 1,
        likeCount: 0,
      ),
    ];
  }

  // 유지보수 상세 정보 조회
  Future<Maintenance?> getMaintenanceDetail(int maintenanceId) async {
    try {
      final url = ApiConstants.buildUrl(ApiConstants.equipmentMaintenanceEndpoint, {
        'maintenance_id': maintenanceId.toString()
      });
      
      if (ApiConstants.loggingEnabled) {
        print('API 요청 URL: $url');
        print('모듈: equipment, 액션: maintenance, 유지보수ID: $maintenanceId');
      }
      
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode == 200) {
        print('API 응답 성공: ${response.statusCode}');
        
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['success'] == true && responseData['data'] != null) {
          final data = responseData['data'];
          
          try {
            if (data is Map<String, dynamic>) {
              return _safeParseMaintenanceItem(data);
            } else {
              print('API 응답 형식이 예상과 다릅니다. 응답: ${data.runtimeType}');
              return null;
            }
          } catch (e) {
            print('유지보수 상세 정보 파싱 오류: $e');
            return null;
          }
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
      print('요청 URL: ${ApiConstants.buildUrl(ApiConstants.equipmentMaintenanceEndpoint, {'maintenance_id': maintenanceId.toString()})}');
      return null;
    }
  }

  // 유지보수 기록 추가
  Future<Map<String, dynamic>> addMaintenance(int equipmentId, Map<String, dynamic> maintenanceData) async {
    try {
      final url = ApiConstants.buildUrl(ApiConstants.equipmentMaintenanceEndpoint, {
        'action': 'add',
        'equipment_id': equipmentId.toString()
      });
      
      if (ApiConstants.loggingEnabled) {
        print('API 요청 URL: $url');
        print('모듈: equipment, 액션: maintenance, 하위액션: add, 장비ID: $equipmentId');
      }
      
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: json.encode(maintenanceData),
      );

      if (response.statusCode == 200) {
        print('API 응답 성공: ${response.statusCode}');
        return json.decode(response.body);
      } else {
        print('API 호출 실패: 상태 코드 ${response.statusCode}');
        print('요청 URL: $url');
        if (response.body.isNotEmpty) {
          print('응답 내용: ${response.body.substring(0, math.min(200, response.body.length))}...');
        }
        throw Exception('서버 오류: ${response.statusCode}');
      }
    } catch (e) {
      print('유지보수 기록 추가 오류: $e');
      print('요청 URL: ${ApiConstants.buildUrl(ApiConstants.equipmentMaintenanceEndpoint, {'action': 'add', 'equipment_id': equipmentId.toString()})}');
      throw Exception('유지보수 기록을 추가하는 중 오류가 발생했습니다.');
    }
  }

  // 유지보수 기록 수정
  Future<Map<String, dynamic>> updateMaintenance(int maintenanceId, Map<String, dynamic> maintenanceData) async {
    try {
      final url = ApiConstants.buildUrl(ApiConstants.equipmentMaintenanceEndpoint, {
        'action': 'update',
        'maintenance_id': maintenanceId.toString()
      });
      
      if (ApiConstants.loggingEnabled) {
        print('API 요청 URL: $url');
        print('모듈: equipment, 액션: maintenance, 하위액션: update, ID: $maintenanceId');
      }
      
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: json.encode(maintenanceData),
      );

      if (response.statusCode == 200) {
        print('API 응답 성공: ${response.statusCode}');
        return json.decode(response.body);
      } else {
        print('API 호출 실패: 상태 코드 ${response.statusCode}');
        print('요청 URL: $url');
        if (response.body.isNotEmpty) {
          print('응답 내용: ${response.body.substring(0, math.min(200, response.body.length))}...');
        }
        throw Exception('서버 오류: ${response.statusCode}');
      }
    } catch (e) {
      print('유지보수 기록 수정 오류: $e');
      print('요청 URL: ${ApiConstants.buildUrl(ApiConstants.equipmentMaintenanceEndpoint, {'action': 'update', 'maintenance_id': maintenanceId.toString()})}');
      throw Exception('유지보수 기록을 수정하는 중 오류가 발생했습니다.');
    }
  }

  // 유지보수 기록 삭제
  Future<Map<String, dynamic>> deleteMaintenance(int maintenanceId) async {
    try {
      final url = ApiConstants.buildUrl(ApiConstants.equipmentMaintenanceEndpoint, {
        'action': 'delete',
        'maintenance_id': maintenanceId.toString()
      });
      
      if (ApiConstants.loggingEnabled) {
        print('API 요청 URL: $url');
        print('모듈: equipment, 액션: maintenance, 하위액션: delete, ID: $maintenanceId');
      }
      
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode == 200) {
        print('API 응답 성공: ${response.statusCode}');
        return json.decode(response.body);
      } else {
        print('API 호출 실패: 상태 코드 ${response.statusCode}');
        print('요청 URL: $url');
        if (response.body.isNotEmpty) {
          print('응답 내용: ${response.body.substring(0, math.min(200, response.body.length))}...');
        }
        throw Exception('서버 오류: ${response.statusCode}');
      }
    } catch (e) {
      print('유지보수 기록 삭제 오류: $e');
      print('요청 URL: ${ApiConstants.buildUrl(ApiConstants.equipmentMaintenanceEndpoint, {'action': 'delete', 'maintenance_id': maintenanceId.toString()})}');
      throw Exception('유지보수 기록을 삭제하는 중 오류가 발생했습니다.');
    }
  }

  // 댓글 추가
  Future<Map<String, dynamic>> addComment(int maintenanceId, String content) async {
    try {
      final url = ApiConstants.buildUrl(ApiConstants.equipmentMaintenanceEndpoint, {
        'action': 'comment',
        'operation': 'add',
        'maintenance_id': maintenanceId.toString()
      });
      
      if (ApiConstants.loggingEnabled) {
        print('API 요청 URL: $url');
        print('모듈: equipment, 액션: maintenance, 하위액션: comment/add, ID: $maintenanceId');
      }
      
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: json.encode({'content': content}),
      );

      if (response.statusCode == 200) {
        print('API 응답 성공: ${response.statusCode}');
        return json.decode(response.body);
      } else {
        print('API 호출 실패: 상태 코드 ${response.statusCode}');
        print('요청 URL: $url');
        if (response.body.isNotEmpty) {
          print('응답 내용: ${response.body.substring(0, math.min(200, response.body.length))}...');
        }
        throw Exception('서버 오류: ${response.statusCode}');
      }
    } catch (e) {
      print('댓글 추가 오류: $e');
      print('요청 URL: ${ApiConstants.buildUrl(ApiConstants.equipmentMaintenanceEndpoint, {'action': 'comment', 'operation': 'add', 'maintenance_id': maintenanceId.toString()})}');
      throw Exception('댓글을 추가하는 중 오류가 발생했습니다.');
    }
  }

  // 댓글 삭제
  Future<Map<String, dynamic>> deleteComment(int commentId) async {
    try {
      final url = ApiConstants.buildUrl(ApiConstants.equipmentMaintenanceEndpoint, {
        'action': 'comment',
        'operation': 'delete',
        'comment_id': commentId.toString()
      });
      
      if (ApiConstants.loggingEnabled) {
        print('API 요청 URL: $url');
        print('모듈: equipment, 액션: maintenance, 하위액션: comment/delete, 댓글ID: $commentId');
      }
      
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode == 200) {
        print('API 응답 성공: ${response.statusCode}');
        return json.decode(response.body);
      } else {
        print('API 호출 실패: 상태 코드 ${response.statusCode}');
        print('요청 URL: $url');
        if (response.body.isNotEmpty) {
          print('응답 내용: ${response.body.substring(0, math.min(200, response.body.length))}...');
        }
        throw Exception('서버 오류: ${response.statusCode}');
      }
    } catch (e) {
      print('댓글 삭제 오류: $e');
      print('요청 URL: ${ApiConstants.buildUrl(ApiConstants.equipmentMaintenanceEndpoint, {'action': 'comment', 'operation': 'delete', 'comment_id': commentId.toString()})}');
      throw Exception('댓글을 삭제하는 중 오류가 발생했습니다.');
    }
  }

  // 좋아요 토글
  Future<Map<String, dynamic>> toggleLike(int maintenanceId) async {
    try {
      final url = ApiConstants.buildUrl(ApiConstants.equipmentMaintenanceEndpoint, {
        'action': 'like',
        'maintenance_id': maintenanceId.toString()
      });
      
      if (ApiConstants.loggingEnabled) {
        print('API 요청 URL: $url');
        print('모듈: equipment, 액션: maintenance, 하위액션: like, ID: $maintenanceId');
      }
      
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode == 200) {
        print('API 응답 성공: ${response.statusCode}');
        return json.decode(response.body);
      } else {
        print('API 호출 실패: 상태 코드 ${response.statusCode}');
        print('요청 URL: $url');
        if (response.body.isNotEmpty) {
          print('응답 내용: ${response.body.substring(0, math.min(200, response.body.length))}...');
        }
        throw Exception('서버 오류: ${response.statusCode}');
      }
    } catch (e) {
      print('좋아요 토글 오류: $e');
      print('요청 URL: ${ApiConstants.buildUrl(ApiConstants.equipmentMaintenanceEndpoint, {'action': 'like', 'maintenance_id': maintenanceId.toString()})}');
      throw Exception('좋아요를 토글하는 중 오류가 발생했습니다.');
    }
  }

  // 이미지 파일 업로드 (Base64)
  Future<Map<String, dynamic>> uploadImage(
    int maintenanceId, 
    String base64Image, // 'data:image/jpeg;base64,...' 형식
    String fileName, 
    String? caption
  ) async {
    try {
      final url = ApiConstants.buildUrl(ApiConstants.equipmentMaintenanceEndpoint, {
        'action': 'add_image',
        'maintenance_id': maintenanceId.toString()
      });
      
      if (ApiConstants.loggingEnabled) {
        print('API 요청 URL: $url');
        print('모듈: equipment, 액션: maintenance, 하위액션: add_image, ID: $maintenanceId');
      }
      
      // MIME 타입 추출
      String imageType = 'image/jpeg'; // 기본값
      if (base64Image.startsWith('data:')) {
        final mimeMatch = RegExp(r'data:(image\/[^;]+)').firstMatch(base64Image);
        if (mimeMatch != null) {
          imageType = mimeMatch.group(1) ?? imageType;
        }
      }
      
      final Map<String, dynamic> requestData = {
        'imageData': base64Image,
        'imageType': imageType,
        'fileName': fileName,
        'caption': caption ?? '',
      };
      
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: json.encode(requestData),
      );

      if (response.statusCode == 200) {
        print('API 응답 성공: ${response.statusCode}');
        return json.decode(response.body);
      } else {
        print('API 호출 실패: 상태 코드 ${response.statusCode}');
        print('요청 URL: $url');
        if (response.body.isNotEmpty) {
          print('응답 내용: ${response.body.substring(0, math.min(200, response.body.length))}...');
        }
        throw Exception('서버 오류: ${response.statusCode}');
      }
    } catch (e) {
      print('이미지 업로드 오류: $e');
      print('요청 URL: ${ApiConstants.buildUrl(ApiConstants.equipmentMaintenanceEndpoint, {'action': 'add_image', 'maintenance_id': maintenanceId.toString()})}');
      throw Exception('이미지를 업로드하는 중 오류가 발생했습니다: $e');
    }
  }
} 