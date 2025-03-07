import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../models/meeting_room.dart';
import '../models/room_reservation.dart';
import '../utils/api_constants.dart';

class MeetingRoomService {
  // Request headers for API calls
  final Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // API에서 받은 데이터를 파싱하여 MeetingRoom과 RoomReservation 객체로 변환
  Future<List<RoomReservation>> getReservations() async {
    try {
      final url = ApiConstants.buildUrl(ApiConstants.reportsEndpoint);
      
      if (ApiConstants.loggingEnabled) {
        print('API 요청 URL: $url');
        print('모듈: meeting, 액션: reports');
      }
      
      final response = await http.get(Uri.parse(url), headers: headers);
      
      if (response.statusCode == 200) {
        print('API 응답 성공: ${response.statusCode}');
        final List<dynamic> data = json.decode(response.body);
        return _parseReservationsFromApi(data);
      } else {
        print('API 호출 실패: 상태 코드 ${response.statusCode}');
        print('요청 URL: $url');
        throw Exception('Failed to load reservations: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching reservations: $e');
      // API 호출에 실패한 경우 샘플 데이터 반환
      return getSampleReservations();
    }
  }

  // API 형식의 데이터를 앱 모델 형식으로 변환
  List<RoomReservation> _parseReservationsFromApi(List<dynamic> apiData) {
    List<RoomReservation> reservations = [];
    Map<String, MeetingRoom> roomCache = {};

    for (var item in apiData) {
      // 회의실 이름에서 <br> 태그 제거
      String roomName = item['회의실'].toString().replaceAll('<br>', ' ');
      
      // 회의실 ID 파싱
      int roomId = int.tryParse(item['sort'].toString()) ?? 0;
      
      // 회의실 객체가 캐시에 없으면 생성
      if (!roomCache.containsKey(roomName)) {
        roomCache[roomName] = MeetingRoom(
          id: roomId,
          name: roomName,
          capacity: 0, // API에서 제공하지 않는 정보
          location: '', // 이미 roomName에 포함됨
          facilities: [], // API에서 제공하지 않는 정보
          status: 'available' // 기본값
        );
      }
      
      // 사용 시간 문자열 파싱 (예: '2025-03-14 (fri)<br>09:00 ~ 12:00')
      String timeRange = item['사용시간'].toString().replaceAll('<br>', ' ');
      
      // 날짜와 시간 추출을 위한 정규식
      RegExp timeRegex = RegExp(r'(\d{4}-\d{2}-\d{2}).*?(\d{2}:\d{2}).*?(\d{2}:\d{2})');
      Match? timeMatch = timeRegex.firstMatch(timeRange);
      
      DateTime startTime;
      DateTime endTime;
      
      if (timeMatch != null) {
        String date = timeMatch.group(1) ?? '';
        String start = timeMatch.group(2) ?? '';
        String end = timeMatch.group(3) ?? '';
        
        startTime = DateFormat('yyyy-MM-dd HH:mm').parse('$date $start');
        endTime = DateFormat('yyyy-MM-dd HH:mm').parse('$date $end');
      } else {
        // 사용날짜 필드를 기본으로 사용
        startTime = DateTime.parse(item['사용날짜'].toString());
        // 시간 정보가 없으면 1시간 기본 예약
        endTime = startTime.add(Duration(hours: 1));
      }
      
      // 예약 상태 매핑
      String status = item['신청여부'].toString();
      String mappedStatus = 'pending';
      if (status == '승인') {
        mappedStatus = 'approved';
      } else if (status == '취소') {
        mappedStatus = 'cancelled';
      } else if (status == '반려') {
        mappedStatus = 'rejected';
      }
      
      // 신청자 정보 파싱 (예: '최은희<br>(02-2133-5372)')
      String requester = item['신청자'].toString().replaceAll('<br>', ' ');
      
      // 예약 객체 생성
      RoomReservation reservation = RoomReservation(
        id: item['id'].toString(),
        roomId: roomId,
        userId: 0, // API에서 제공하지 않는 정보
        title: item['회의명'].toString(),
        description: '', // API에서 제공하지 않는 정보
        department: item['사용부서'].toString(),
        contactPerson: requester,
        startTime: startTime,
        endTime: endTime,
        status: mappedStatus,
        createdAt: DateTime.now(), // API에서 제공하지 않는 정보
        updatedAt: DateTime.now() // API에서 제공하지 않는 정보
      );
      
      reservations.add(reservation);
    }
    
    return reservations;
  }
  
  // Get all meeting rooms
  Future<List<MeetingRoom>> getMeetingRooms() async {
    try {
      final url = ApiConstants.buildUrl(ApiConstants.meetingRoomsEndpoint);
      
      if (ApiConstants.loggingEnabled) {
        print('API 요청 URL: $url');
        print('모듈: meeting, 액션: rooms');
      }
      
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode == 200) {
        print('API 응답 성공: ${response.statusCode}');
        final List<dynamic> data = json.decode(response.body);
        return _parseMeetingRoomsFromApi(data);
      } else {
        throw Exception('Failed to load meeting rooms: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching meeting rooms: $e');
      // API 호출에 실패한 경우 샘플 데이터 반환
      return getSampleMeetingRooms();
    }
  }
  
  // API 형식의 데이터를 앱 모델 형식으로 변환
  List<MeetingRoom> _parseMeetingRoomsFromApi(List<dynamic> apiData) {
    List<MeetingRoom> rooms = [];
    Map<String, MeetingRoom> roomCache = {};

    for (var item in apiData) {
      // 회의실 이름에서 <br> 태그 제거
      String roomName = item['회의실'].toString().replaceAll('<br>', ' ');
      
      // 회의실 ID 파싱
      int roomId = int.tryParse(item['sort'].toString()) ?? 0;
      
      // 회의실 객체가 캐시에 없으면 생성
      if (!roomCache.containsKey(roomName)) {
        roomCache[roomName] = MeetingRoom(
          id: roomId,
          name: roomName,
          capacity: 0, // API에서 제공하지 않는 정보
          location: '', // 이미 roomName에 포함됨
          facilities: [], // API에서 제공하지 않는 정보
          status: 'available' // 기본값
        );
      }
      
      rooms.add(roomCache[roomName]!);
    }
    
    return rooms;
  }
  
  // 특정 날짜의 예약 목록 가져오기
  Future<List<RoomReservation>> getReservationsByDate(DateTime date) async {
    List<RoomReservation> allReservations = await getReservations();
    
    return allReservations.where((reservation) {
      return reservation.startTime.year == date.year &&
             reservation.startTime.month == date.month &&
             reservation.startTime.day == date.day;
    }).toList();
  }
  
  // 샘플 예약 데이터 반환 (API 호출 실패 시 사용)
  List<RoomReservation> getSampleReservations() {
    return [
      RoomReservation(
        id: '1738887170753',
        roomId: 1,
        userId: 1,
        title: '세계소비자의날 기념행사',
        description: '',
        department: '공정경제과',
        contactPerson: '최은희 (02-2133-5372)',
        startTime: DateTime.parse('2025-03-14 09:00:00'),
        endTime: DateTime.parse('2025-03-14 12:00:00'),
        status: 'approved',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now()
      ),
      RoomReservation(
        id: '1739260401440',
        roomId: 2,
        userId: 2,
        title: '2025년 상반기 사회복지시설 및 법인 종사자 재무회계교육',
        description: '',
        department: '복지정책과',
        contactPerson: '이유섭 (02-2133-7325)',
        startTime: DateTime.parse('2025-03-14 09:00:00'),
        endTime: DateTime.parse('2025-03-14 12:30:00'),
        status: 'approved',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now()
      ),
      RoomReservation(
        id: '1738822400134',
        roomId: 1,
        userId: 3,
        title: '스마트도시 기본계획 중간보고',
        description: '',
        department: '디지털정책과',
        contactPerson: '박수진 (02-2133-2916)',
        startTime: DateTime.parse('2025-03-14 12:30:00'),
        endTime: DateTime.parse('2025-03-14 16:00:00'),
        status: 'cancelled',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now()
      ),
      RoomReservation(
        id: '1738649941820',
        roomId: 2,
        userId: 4,
        title: '공공공사 동영상 기록관리 공사관계자 교육',
        description: '',
        department: '건설혁신담당관',
        contactPerson: '정영호 (02-2133-8562)',
        startTime: DateTime.parse('2025-03-14 13:00:00'),
        endTime: DateTime.parse('2025-03-14 17:00:00'),
        status: 'approved',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now()
      ),
      RoomReservation(
        id: '1740640849690',
        roomId: 11,
        userId: 5,
        title: '경제관 지표등 기획회의',
        description: '',
        department: '데이터전략과',
        contactPerson: '홍소양 (02-2133-4265)',
        startTime: DateTime.parse('2025-03-14 13:30:00'),
        endTime: DateTime.parse('2025-03-14 17:30:00'),
        status: 'approved',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now()
      ),
      RoomReservation(
        id: '1739244308206',
        roomId: 1,
        userId: 6,
        title: '투자출연기관 청렴도 향상 회의',
        description: '',
        department: '공공감사담당관',
        contactPerson: '정혜윤 (02-2133-1574)',
        startTime: DateTime.parse('2025-03-14 13:30:00'),
        endTime: DateTime.parse('2025-03-14 17:30:00'),
        status: 'approved',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now()
      )
    ];
  }

  // 샘플 회의실 데이터 반환 (API 호출 실패 시 사용)
  List<MeetingRoom> getSampleMeetingRooms() {
    return [
      MeetingRoom(
        id: 1,
        name: '회의실 1',
        capacity: 10,
        location: '1층',
        facilities: [],
        status: 'available'
      ),
      MeetingRoom(
        id: 2,
        name: '회의실 2',
        capacity: 15,
        location: '2층',
        facilities: [],
        status: 'available'
      ),
      MeetingRoom(
        id: 11,
        name: '경제관 회의실',
        capacity: 20,
        location: '경제관',
        facilities: [],
        status: 'available'
      )
    ];
  }
} 