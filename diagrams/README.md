# 회의실 장비 관리 시스템 데이터베이스 설계

이 문서는 회의실 장비 관리 시스템의 데이터베이스 설계를 설명합니다. 이 시스템은 회의실 정보, 장비 현황, 예약 관리, 보고서 생성 등의 기능을 지원합니다.

## 데이터베이스 구조도

`acoustoflow_erd.md` 파일에 포함된 ERD(Entity-Relationship Diagram)는 다음과 같은 주요 테이블 간의 관계를 보여줍니다:

- **MEETING_ROOM**: 회의실 정보
- **EQUIPMENT_MASTER**: 장비 마스터 정보
- **ROOM_EQUIPMENT**: 회의실별 장비 현황
- **RESERVATION**: 회의실 예약 정보
- **EQUIPMENT_TASK**: 장비 관련 작업
- **EQUIPMENT_MAINTENANCE**: 장비 유지보수 기록
- **REPORT**: 회의 보고서
- **USER**: 사용자 정보
- **DEPARTMENT**: 부서 정보
- **MEETING_NOTE**: 회의록
- **VACATION**: 휴가 정보
- **CONSTRUCTION_PROJECT**: 공사 프로젝트
- **RESTAURANT_MENU**: 식당 메뉴

## 주요 테이블 설명

### 회의실 장비 관리 핵심 테이블

1. **meeting_rooms**: 회의실 기본 정보
   - 위치, 층, 호수, 수용 인원 등 포함
   - 각 회의실의 현재 상태 (사용 가능, 유지보수 중 등)

2. **equipment_master**: 장비 마스터 데이터
   - 장비 유형, 모델, 제조사 등 장비 기본 정보
   - 장비의 현재 상태 (활성, 유지보수 중, 폐기 등)

3. **room_equipment**: 회의실별 장비 현황 (핵심)
   - 각 회의실에 설치된 장비 정보
   - 수량, 상태, 최근 점검 일자 등 포함
   - 이 테이블을 통해 "서소문청사 후생동 강당: 빔프로젝터, 유선 마이크 1개, 무선 마이크 2개" 등의 현황 정보 관리 가능

## 설치 및 설정 방법

### 데이터베이스 생성

1. MySQL 또는 MariaDB 서버에 접속합니다.
2. 데이터베이스를 생성합니다: `CREATE DATABASE acoustoflow CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;`
3. 데이터베이스를 선택합니다: `USE acoustoflow;`
4. `create_tables.sql` 스크립트를 실행하여 테이블을 생성합니다.
5. `sample_data.sql` 스크립트를 실행하여 샘플 데이터를 삽입합니다.

### API 설정

1. 서버의 `api` 디렉토리에 `get_room_equipment.php` 파일을 추가합니다.
2. `.env` 파일에 데이터베이스 연결 정보 및 API 설정을 업데이트합니다.
3. 필요한 경우 DB 접근 권한을 설정합니다.

## API 사용 방법

### 회의실 장비 현황 조회 API

**엔드포인트**: `/api/get_room_equipment.php`

**매개변수**:
- `room_id`: (선택) 특정 회의실 ID
- `building`: (선택) 건물명 (부분 검색 가능)
- `floor`: (선택) 층
- `equipment_type`: (선택) 장비 유형
- `status`: (선택) 장비 상태

**예시 요청**:
```
GET /api/get_room_equipment.php?building=서소문청사&floor=4
```

**응답 형식**:
```json
{
  "status": "success",
  "message": "Room equipment data retrieved successfully",
  "data": [
    {
      "room_id": 1,
      "name": "대회의실",
      "building": "서소문청사 후생동",
      "floor": 4,
      "room_number": "401",
      "capacity": 50,
      "status": "available",
      "equipment": [
        {
          "equipment_id": 1,
          "name": "빔프로젝터",
          "type": "visual",
          "description": "고해상도 빔프로젝터",
          "model_number": "BenQ MW632ST",
          "manufacturer": "BenQ",
          "quantity": 1,
          "status": "available",
          "last_checked": "2023-07-15 10:30:00",
          "checked_by": "정성훈"
        },
        {
          "equipment_id": 2,
          "name": "무선 마이크",
          "type": "audio",
          "quantity": 2,
          "status": "available"
        },
        // 기타 장비 정보...
      ]
    }
  ],
  "count": 1
}
```

## 앱 연동

Flutter 앱에서 회의실 장비 현황을 가져오기 위해 `room_equipment_service.dart` 파일을 추가하고 다음과 같이 구현할 수 있습니다:

```dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/room_equipment_model.dart';
import '../utils/api_constants.dart';

class RoomEquipmentService {
  final String apiUrl = '${ApiConstants.baseUrl}get_room_equipment.php';
  
  Future<List<RoomEquipment>> getRoomEquipment({
    int? roomId,
    String? building,
    int? floor,
    String? equipmentType,
    String? status
  }) async {
    Map<String, String> queryParams = {};
    
    if (roomId != null) queryParams['room_id'] = roomId.toString();
    if (building != null) queryParams['building'] = building;
    if (floor != null) queryParams['floor'] = floor.toString();
    if (equipmentType != null) queryParams['equipment_type'] = equipmentType;
    if (status != null) queryParams['status'] = status;
    
    final uri = Uri.parse(apiUrl).replace(queryParameters: queryParams);
    
    try {
      final response = await http.get(uri);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['status'] == 'success' && data['data'] != null) {
          return (data['data'] as List)
              .map((json) => RoomEquipment.fromJson(json))
              .toList();
        } else {
          return [];
        }
      } else {
        throw Exception('API 요청 실패: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('회의실 장비 데이터 로드 중 오류: $e');
    }
  }
}
```

## 데이터 모델 예시

앱에서 사용할 장비 모델 클래스는 다음과 같습니다:

```dart
class Equipment {
  final int id;
  final String name;
  final String type;
  final String? description;
  final String? modelNumber;
  final String? manufacturer;
  final int quantity;
  final String status;
  final DateTime? lastChecked;
  final String? checkedBy;
  final String? notes;

  Equipment({
    required this.id,
    required this.name,
    required this.type,
    this.description,
    this.modelNumber,
    this.manufacturer,
    required this.quantity,
    required this.status,
    this.lastChecked,
    this.checkedBy,
    this.notes,
  });

  factory Equipment.fromJson(Map<String, dynamic> json) {
    return Equipment(
      id: json['equipment_id'],
      name: json['name'],
      type: json['type'],
      description: json['description'],
      modelNumber: json['model_number'],
      manufacturer: json['manufacturer'],
      quantity: json['quantity'] ?? 1,
      status: json['status'] ?? 'available',
      lastChecked: json['last_checked'] != null 
          ? DateTime.parse(json['last_checked']) 
          : null,
      checkedBy: json['checked_by'],
      notes: json['notes'],
    );
  }
}

class RoomEquipment {
  final int roomId;
  final String name;
  final String building;
  final int floor;
  final String roomNumber;
  final int capacity;
  final String status;
  final List<Equipment> equipment;

  RoomEquipment({
    required this.roomId,
    required this.name,
    required this.building,
    required this.floor,
    required this.roomNumber,
    required this.capacity,
    required this.status,
    required this.equipment,
  });

  factory RoomEquipment.fromJson(Map<String, dynamic> json) {
    return RoomEquipment(
      roomId: json['room_id'],
      name: json['name'],
      building: json['building'],
      floor: json['floor'],
      roomNumber: json['room_number'],
      capacity: json['capacity'] ?? 0,
      status: json['status'] ?? 'available',
      equipment: (json['equipment'] as List)
          .map((item) => Equipment.fromJson(item))
          .toList(),
    );
  }
}
```

## 결론

이 데이터베이스 구조를 통해 회의실별 장비 현황을 체계적으로 관리할 수 있습니다. 회의실마다 어떤 장비가 설치되어 있는지, 각 장비의 상태는 어떤지, 마지막 점검 일자는 언제인지 등의 정보를 손쉽게 조회하고 관리할 수 있습니다. 

## 음향실 피드 API 사용 방법

음향실 작업 내용을 앱에서 피드 형태로 표시하기 위한 API를 제공합니다. 이 API를 사용하여 장비 유지보수 작업을 공유하고 소통할 수 있습니다.

### 1. 피드 데이터 조회 API

**엔드포인트**: `/get_feed_posts.php`

**요청 파라미터**:
- `limit` (선택, 기본값: 20): 한 번에 가져올 포스트 수
- `offset` (선택, 기본값: 0): 페이징을 위한 오프셋
- `user_id` (선택): 특정 사용자가 작성한 포스트만 필터링
- `action_type` (선택): 특정 작업 유형(점검, 수리, 교체, 설치, 기타)으로 필터링

**요청 예시**:
```
GET /get_feed_posts.php?limit=10&offset=0&action_type=점검
Authorization: Bearer YOUR_API_KEY
```

**응답 예시**:
```json
{
  "status": "success",
  "posts": [
    {
      "id": 123,
      "user": {
        "id": "user1",
        "name": "김민준",
        "department": "음향실"
      },
      "content": "A동 대회의실의 프로젝터 NEC-P605UL 장비를 점검했습니다. 필터 사용 시간: 245시간",
      "location": "A동 대회의실",
      "timestamp": "2023-05-15T14:30:00",
      "images": ["uploads/images/maintenance_123_1.jpg"],
      "equipment": {
        "id": 45,
        "name": "프로젝터",
        "model": "NEC-P605UL",
        "manufacturer": "NEC",
        "type": "프로젝터"
      },
      "maintenance": {
        "action_type": "점검",
        "start_time": "2023-05-15T14:00:00",
        "end_time": "2023-05-15T14:30:00",
        "issues_found": null,
        "resolution": null,
        "filter_hours_updated": 245,
        "lamp_hours_updated": 1020
      },
      "comments": [],
      "likes": 3
    }
  ],
  "pagination": {
    "limit": 10,
    "offset": 0,
    "count": 1
  }
}
```

### 2. 유지보수 기록 추가 API

**엔드포인트**: `/add_maintenance_record.php`

**요청 메서드**: POST

**요청 형식**: JSON

**필수 파라미터**:
- `equipment_id`: 장비 ID
- `action_type`: 작업 유형 (점검, 수리, 교체, 설치, 기타)
- `start_time`: 작업 시작 시간 (ISO 형식)
- `end_time`: 작업 종료 시간 (ISO 형식)
- `worked_by`: 작업자 ID

**선택 파라미터**:
- `location_description`: 위치 설명 (회의실이 아닌 경우)
- `reservation_id`: 연관된 예약 ID
- `issues_found`: 발견된 문제점
- `resolution`: 해결 방법
- `filter_hours_updated`: 업데이트된 필터 사용 시간
- `lamp_hours_updated`: 업데이트된 램프 사용 시간
- `images`: 이미지 파일 경로 배열

**요청 예시**:
```json
{
  "equipment_id": 45,
  "action_type": "점검",
  "start_time": "2023-05-15T14:00:00",
  "end_time": "2023-05-15T14:30:00",
  "worked_by": "user1",
  "location_description": "A동 대회의실",
  "filter_hours_updated": 245,
  "lamp_hours_updated": 1020
}
```

**응답 예시**:
```json
{
  "status": "success",
  "message": "유지보수 기록이 추가되었습니다",
  "maintenance_id": 123
}
```

### 3. 댓글 및 좋아요 API

유지보수 기록에 댓글을 추가하고 좋아요를 표시하는 API도 제공됩니다:

- **댓글 추가**: `/add_maintenance_comment.php`
- **좋아요 토글**: `/toggle_maintenance_like.php`

## Flutter 앱 연동 방법

음향실 피드 화면과 API를 연동하는 방법은 다음과 같습니다:

1. `lib/utils/api_config.dart` 파일에 API 설정 업데이트:
```dart
class ApiConfig {
  static const String baseUrl = '실제 서버 URL';
  static const String apiKey = '실제 API 키';
}
```

2. `MaintenanceService` 클래스를 사용하여 API 요청:
```dart
// 피드 데이터 로드
final posts = await MaintenanceService.getFeedPosts();

// 새 유지보수 기록 추가
final maintenanceId = await MaintenanceService.addMaintenanceRecord(
  equipmentId: 45,
  actionType: '점검',
  startTime: DateTime.now().subtract(Duration(hours: 1)),
  endTime: DateTime.now(),
  workedBy: 'user1',
  // 기타 필요한 파라미터...
);
```

3. 피드 화면에서 데이터 표시:
```dart
// MaintenancePost 모델 사용
final post = MaintenancePost.fromJson(jsonData);

// UI에 표시
Text(post.content);
Text(post.location);
// ...
``` 