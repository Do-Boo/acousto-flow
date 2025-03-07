class RoomReservation {
  final String id;
  final int roomId;
  final int userId;
  final String title;
  final String description;
  final String department;
  final String contactPerson;
  final DateTime startTime;
  final DateTime endTime;
  final String status; // pending, approved, cancelled, rejected
  final DateTime createdAt;
  final DateTime updatedAt;

  RoomReservation({
    required this.id,
    required this.roomId,
    required this.userId,
    required this.title,
    required this.description,
    required this.department,
    required this.contactPerson,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  // JSON 변환 메서드
  factory RoomReservation.fromJson(Map<String, dynamic> json) {
    return RoomReservation(
      id: json['id'],
      roomId: json['room_id'],
      userId: json['user_id'],
      title: json['title'],
      description: json['description'] ?? '',
      department: json['department'] ?? '',
      contactPerson: json['contact_person'] ?? '',
      startTime: DateTime.parse(json['start_time']),
      endTime: DateTime.parse(json['end_time']),
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'room_id': roomId,
      'user_id': userId,
      'title': title,
      'description': description,
      'department': department,
      'contact_person': contactPerson,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime.toIso8601String(),
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  // 예약 시간이 겹치는지 확인하는 메서드
  bool isOverlapping(RoomReservation other) {
    if (roomId != other.roomId) return false;
    
    return (startTime.isBefore(other.endTime) && 
            endTime.isAfter(other.startTime));
  }

  // 예약 기간(분) 계산 메서드
  int getDurationMinutes() {
    return endTime.difference(startTime).inMinutes;
  }

  // 예약 상태 텍스트 반환 메서드 (한글)
  String getStatusText() {
    switch(status) {
      case 'pending': return '대기 중';
      case 'approved': return '승인됨';
      case 'cancelled': return '취소됨';
      case 'rejected': return '거부됨';
      default: return '알 수 없음';
    }
  }
} 