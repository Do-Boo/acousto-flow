import 'package:flutter/foundation.dart';

enum NoteImportance { low, medium, high }
enum NoteStatus { new_, inProgress, completed }

class MeetingNote {
  final int? id;
  final String reportId;
  final String roomName;
  final String content;
  final String? callerName;
  final String? callerContact;
  final DateTime createdAt;
  final String? createdBy;
  final NoteImportance importance;
  final NoteStatus status;
  final List<String> usedEquipment;
  
  MeetingNote({
    this.id,
    required this.reportId,
    required this.roomName,
    required this.content,
    this.callerName,
    this.callerContact,
    required this.createdAt,
    this.createdBy,
    this.importance = NoteImportance.medium,
    this.status = NoteStatus.new_,
    this.usedEquipment = const [],
  });
  
  factory MeetingNote.fromJson(Map<String, dynamic> json) {
    List<String> equipment = [];
    if (json['used_equipment'] != null) {
      try {
        final equipmentData = json['used_equipment'];
        if (equipmentData is String) {
          equipment = equipmentData.split(',').map((e) => e.trim()).toList();
        } else if (equipmentData is List) {
          equipment = equipmentData.map((e) => e.toString()).toList();
        }
      } catch (e) {
        print('장비 데이터 파싱 오류: $e');
      }
    }
    
    return MeetingNote(
      id: json['id'] != null ? int.tryParse(json['id'].toString()) : null,
      reportId: json['report_id'] ?? '',
      roomName: json['room_name'] ?? '',
      content: json['content'] ?? '',
      callerName: json['caller_name'],
      callerContact: json['caller_contact'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      createdBy: json['created_by'],
      importance: _parseImportance(json['importance']),
      status: _parseStatus(json['status']),
      usedEquipment: equipment,
    );
  }
  
  static NoteImportance _parseImportance(String? value) {
    switch (value) {
      case '낮음':
        return NoteImportance.low;
      case '높음':
        return NoteImportance.high;
      default:
        return NoteImportance.medium;
    }
  }
  
  static NoteStatus _parseStatus(String? value) {
    switch (value) {
      case '처리중':
        return NoteStatus.inProgress;
      case '완료':
        return NoteStatus.completed;
      default:
        return NoteStatus.new_;
    }
  }
  
  Map<String, dynamic> toJson() {
    return {
      'report_id': reportId,
      'room_name': roomName,
      'content': content,
      'caller_name': callerName,
      'caller_contact': callerContact,
      'created_at': createdAt.toIso8601String(),
      'created_by': createdBy,
      'importance': _importanceToString(),
      'status': _statusToString(),
      'used_equipment': usedEquipment.join(','),
    };
  }
  
  String _importanceToString() {
    switch (importance) {
      case NoteImportance.low:
        return '낮음';
      case NoteImportance.high:
        return '높음';
      default:
        return '보통';
    }
  }
  
  String _statusToString() {
    switch (status) {
      case NoteStatus.inProgress:
        return '처리중';
      case NoteStatus.completed:
        return '완료';
      default:
        return '신규';
    }
  }
} 