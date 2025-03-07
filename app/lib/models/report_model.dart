import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class Report {
  final String? id;
  final String? roomName;      // 회의실
  final String? timeSlot;      // 사용시간
  final String? meetingTitle;  // 회의명
  final String? department;    // 사용부서
  final String? requester;     // 신청자
  final String? status;        // 신청여부
  final DateTime? useDate;     // 사용날짜
  final int? sort;             // sort
  
  Report({
    this.id,
    this.roomName,
    this.timeSlot,
    this.meetingTitle,
    this.department,
    this.requester,
    this.status,
    this.useDate,
    this.sort,
  });
  
  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      id: json['id'],
      roomName: json['회의실'],
      timeSlot: json['사용시간'],
      meetingTitle: json['회의명'],
      department: json['사용부서'],
      requester: json['신청자'],
      status: json['신청여부'],
      useDate: json['사용날짜'] != null ? 
        DateTime.parse(json['사용날짜'] is String ? json['사용날짜'] : json['사용날짜'].toString()) : null,
      sort: json['sort'] != null ? int.tryParse(json['sort'].toString()) : null,
    );
  }
  
  String getRoomNameText() {
    return roomName?.replaceAll(RegExp(r'<br>|<.*?>'), ' ') ?? '';
  }
  
  String getTimeSlotText() {
    return timeSlot?.replaceAll(RegExp(r'<br>|<.*?>'), ' ') ?? '';
  }
  
  String getRequesterText() {
    return requester?.replaceAll(RegExp(r'<br>|<.*?>'), ' ') ?? '';
  }
  
  String getDateFormatted() {
    if (useDate == null) return '날짜 정보 없음';
    return DateFormat('yyyy년 MM월 dd일').format(useDate!);
  }
  
  String getTimeFormatted() {
    return timeSlot?.replaceAll(RegExp(r'<br>|<.*?>'), ' ') ?? '시간 정보 없음';
  }
  
  @override
  String toString() {
    return 'Report(id: $id, roomName: $roomName, meetingTitle: $meetingTitle, status: $status)';
  }
} 