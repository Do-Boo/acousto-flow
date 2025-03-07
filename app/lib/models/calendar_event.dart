import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/equipment_task.dart';
import '../models/construction_project.dart';

enum EventType {
  meeting,       // 회의
  equipment,     // 장비 관리
  vacation,      // 휴가
  construction,  // 공사
  other          // 기타
}

class CalendarEvent {
  final String id;
  final String title;
  final String description;
  final DateTime startTime;
  final DateTime endTime;
  final bool isAllDay;
  final String? location;
  final String eventType; // 이벤트 유형 (vacation, meeting, equipment, construction)
  final Color eventColor; // 이벤트 색상
  final Map<String, dynamic>? rawData; // 원본 데이터
  final String status;
  final Map<String, dynamic> additionalInfo; // 각 이벤트 유형별 추가 정보
  final String time;
  final String organizer;    // 주최자/담당자
  final String department;   // 부서
  final String contactPerson; // 연락처
  final List<String> participants; // 참여자 목록
  final String resourceId;   // 관련 리소스 ID (회의실, 장비 등)
  
  CalendarEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.startTime,
    required this.endTime,
    this.isAllDay = false,
    this.location,
    required this.eventType,
    required this.eventColor,
    this.rawData,
    this.status = '',
    this.additionalInfo = const {},
    required this.time,
    this.organizer = '',
    this.department = '',
    this.contactPerson = '',
    this.participants = const [],
    this.resourceId = '',
  });
  
  // JSON에서 CalendarEvent 객체 생성
  factory CalendarEvent.fromJson(Map<String, dynamic> json) {
    return CalendarEvent(
      id: json['id'],
      title: json['title'],
      description: json['description'] ?? '',
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      isAllDay: json['isAllDay'] ?? false,
      location: json['location'],
      status: json['status'] ?? '',
      eventType: json['eventType'] ?? 'meeting',
      eventColor: Color(int.parse(json['eventColor'] ?? '0xFF4285F4')),
      rawData: json['rawData'],
      time: json['time'] ?? '',
      organizer: json['organizer'] ?? '',
      department: json['department'] ?? '',
      contactPerson: json['contactPerson'] ?? '',
      participants: List<String>.from(json['participants'] ?? []),
      resourceId: json['resourceId'] ?? '',
    );
  }
  
  // CalendarEvent 객체를 JSON으로 변환
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'isAllDay': isAllDay,
      'location': location,
      'status': status,
      'eventType': eventType,
      'eventColor': eventColor.value.toString(),
      'rawData': rawData,
      'time': time,
      'organizer': organizer,
      'department': department,
      'contactPerson': contactPerson,
      'participants': participants,
      'resourceId': resourceId,
    };
  }
  
  // 회의실 예약으로부터 CalendarEvent 생성
  factory CalendarEvent.fromRoomReservation(
    dynamic reservation,
    Color color,
  ) {
    final timeFormat = '${reservation.startTime.hour.toString().padLeft(2, '0')}:${reservation.startTime.minute.toString().padLeft(2, '0')} ~ '
      '${reservation.endTime.hour.toString().padLeft(2, '0')}:${reservation.endTime.minute.toString().padLeft(2, '0')}';
      
    return CalendarEvent(
      id: reservation.id,
      title: reservation.title,
      description: reservation.description,
      startTime: reservation.startTime,
      endTime: reservation.endTime,
      isAllDay: reservation.isAllDay,
      location: '회의실 #${reservation.roomId}',
      status: reservation.status,
      eventType: 'meeting',
      eventColor: color,
      rawData: null,
      time: timeFormat,
      organizer: reservation.contactPerson,
      department: reservation.department,
      contactPerson: reservation.contactPerson,
      participants: List<String>.from(reservation.participants ?? []),
      resourceId: reservation.roomId.toString(),
    );
  }
  
  // 휴가 일정으로부터 CalendarEvent 생성
  factory CalendarEvent.fromVacation(
    dynamic vacation,
    Color color,
  ) {
    return CalendarEvent(
      id: vacation.id,
      title: '${vacation.userName} ${vacation.vacationType}',
      description: vacation.reason,
      startTime: vacation.startTime,
      endTime: vacation.endTime,
      isAllDay: vacation.isAllDay,
      location: '-',
      status: vacation.status,
      eventType: 'vacation',
      eventColor: color,
      rawData: null,
      time: vacation.isAllDay ? '종일' : '${vacation.startTime.hour}:${vacation.startTime.minute} ~ ${vacation.endTime.hour}:${vacation.endTime.minute}',
      organizer: vacation.userName,
      department: vacation.department,
      contactPerson: vacation.contactPerson,
      participants: List<String>.from(vacation.participants ?? []),
      resourceId: '',
    );
  }
  
  // 장비 관리 일정으로부터 CalendarEvent 생성
  factory CalendarEvent.fromEquipment(
    dynamic equipment,
    Color color,
  ) {
    return CalendarEvent(
      id: equipment.id,
      title: equipment.taskName,
      description: equipment.description,
      startTime: equipment.startTime,
      endTime: equipment.endTime,
      isAllDay: false,
      location: equipment.location,
      status: equipment.status,
      eventType: 'equipment',
      eventColor: color,
      rawData: {},
      time: '${equipment.startTime.hour}:${equipment.startTime.minute} ~ ${equipment.endTime.hour}:${equipment.endTime.minute}',
      organizer: equipment.assignedTo,
      department: equipment.department,
      contactPerson: equipment.contactPerson,
      participants: List<String>.from(equipment.participants ?? []),
      resourceId: equipment.equipmentId.toString(),
    );
  }
  
  // 공사 일정으로부터 CalendarEvent 생성
  factory CalendarEvent.fromConstruction(
    dynamic construction,
    Color color,
  ) {
    return CalendarEvent(
      id: construction.id,
      title: construction.projectName,
      description: construction.description,
      startTime: construction.startTime,
      endTime: construction.endTime,
      isAllDay: construction.isAllDay,
      location: construction.location,
      status: construction.status,
      eventType: 'construction',
      eventColor: color,
      rawData: {},
      time: construction.isAllDay ? '종일' : '${construction.startTime.hour}:${construction.startTime.minute} ~ ${construction.endTime.hour}:${construction.endTime.minute}',
      organizer: construction.contractor,
      department: construction.department,
      contactPerson: construction.contactPerson,
      participants: List<String>.from(construction.participants ?? []),
      resourceId: '',
    );
  }
  
  // EquipmentTask로부터 CalendarEvent 생성
  static CalendarEvent fromEquipmentTask(EquipmentTask equipment) {
    // 장비 관리 작업에 적합한 색상 설정
    String color = getDefaultColorForEventType(EventType.equipment);
    
    return CalendarEvent(
      id: equipment.id,
      title: equipment.taskName,
      description: equipment.description,
      startTime: equipment.startTime,
      endTime: equipment.endTime,
      isAllDay: false,
      location: equipment.location,
      status: equipment.status,
      eventType: 'equipment',
      eventColor: Color(int.parse(color)),
      rawData: {
        'equipmentId': equipment.equipmentId,
        'equipmentName': equipment.equipmentName,
      },
      time: '${DateFormat('HH:mm').format(equipment.startTime)} ~ ${DateFormat('HH:mm').format(equipment.endTime)}',
      organizer: equipment.assignedTo,
      department: equipment.department,
      contactPerson: equipment.assignedTo,
      participants: [],
      resourceId: equipment.equipmentId,
    );
  }

  // ConstructionProject로부터 CalendarEvent 생성
  static CalendarEvent fromConstructionProject(ConstructionProject construction) {
    // 공사 일정에 적합한 색상 설정
    String color = getDefaultColorForEventType(EventType.construction);
    
    return CalendarEvent(
      id: construction.id,
      title: construction.projectName,
      description: construction.description,
      startTime: construction.startTime,
      endTime: construction.endTime,
      isAllDay: construction.isAllDay,
      location: construction.location,
      status: construction.status,
      eventType: 'construction',
      eventColor: Color(int.parse(color)),
      rawData: {
        'contractor': construction.contractor,
      },
      time: construction.isAllDay ? '종일' : '${DateFormat('HH:mm').format(construction.startTime)} ~ ${DateFormat('HH:mm').format(construction.endTime)}',
      organizer: construction.contractor,
      department: construction.department,
      contactPerson: construction.contactPerson,
      participants: [],
      resourceId: '',
    );
  }
  
  // 이벤트 기간(일) 계산
  int get durationInDays {
    return endTime.difference(startTime).inDays + 1;
  }
  
  // 이벤트 기간(시간) 계산
  int get durationInHours {
    return endTime.difference(startTime).inHours;
  }
  
  // 이벤트 기간(분) 계산
  int get durationInMinutes {
    return endTime.difference(startTime).inMinutes;
  }
  
  // 형식화된 기간 문자열 반환
  String get formattedDuration {
    if (isAllDay) {
      final days = durationInDays;
      return days > 1 ? '$days일' : '종일';
    } else {
      final hours = durationInHours;
      final minutes = durationInMinutes % 60;
      
      if (hours > 0) {
        return '$hours시간 ${minutes > 0 ? '$minutes분' : ''}';
      } else {
        return '$minutes분';
      }
    }
  }
  
  // 포맷된 시작 시간
  String getFormattedStartTime() {
    if (isAllDay) {
      return DateFormat('yyyy-MM-dd').format(startTime);
    } else {
      return DateFormat('yyyy-MM-dd HH:mm').format(startTime);
    }
  }
  
  // 포맷된 종료 시간
  String getFormattedEndTime() {
    if (isAllDay) {
      return DateFormat('yyyy-MM-dd').format(endTime);
    } else {
      return DateFormat('yyyy-MM-dd HH:mm').format(endTime);
    }
  }
  
  // 상태 텍스트 (한국어)
  String getStatusText() {
    switch (status.toLowerCase()) {
      case 'pending':
        return '대기 중';
      case 'in_progress':
      case 'progress':
        return '진행 중';
      case 'approved':
        return '승인됨';
      case 'rejected':
        return '거절됨';
      case 'cancelled':
        return '취소됨';
      case 'completed':
        return '완료됨';
      default:
        return status;
    }
  }
  
  // 이벤트 유형 텍스트 (한국어)
  String getEventTypeText() {
    switch (eventType) {
      case 'meeting':
        return '회의';
      case 'vacation':
        return '휴가';
      case 'equipment':
        return '장비 관리';
      case 'construction':
        return '공사';
      default:
        return '기타';
    }
  }
  
  // 이벤트가 특정 날짜에 해당하는지 확인
  bool isOnDate(DateTime date) {
    return startTime.year == date.year && 
           startTime.month == date.month && 
           startTime.day == date.day;
  }
  
  // 이벤트 기간(분) 계산
  int getDurationMinutes() {
    return endTime.difference(startTime).inMinutes;
  }
  
  // 이벤트 유형별 기본 색상 반환
  static String getDefaultColorForEventType(EventType type) {
    switch (type) {
      case EventType.meeting:
        return '#4285F4'; // 파란색
      case EventType.vacation:
        return '#34A853'; // 녹색
      case EventType.equipment:
        return '#FBBC05'; // 노란색
      case EventType.construction:
        return '#EA4335'; // 빨간색
      default:
        return '#4285F4'; // 기본 파란색
    }
  }
} 