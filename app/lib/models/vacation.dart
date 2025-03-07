class Vacation {
  final String id;
  final int userId;
  final String userName;
  final String department;
  final String vacationType; // 연차, 반차, 특별휴가 등
  final DateTime startTime;
  final DateTime endTime;
  final bool isAllDay;
  final String reason;
  final String status; // pending, approved, cancelled, rejected
  final DateTime createdAt;
  final DateTime updatedAt;

  Vacation({
    required this.id,
    required this.userId,
    required this.userName,
    required this.department,
    required this.vacationType,
    required this.startTime,
    required this.endTime,
    this.isAllDay = true,
    this.reason = '',
    this.status = 'pending',
    required this.createdAt,
    required this.updatedAt,
  });

  // JSON 변환 메서드
  factory Vacation.fromJson(Map<String, dynamic> json) {
    return Vacation(
      id: json['id'],
      userId: json['user_id'],
      userName: json['user_name'],
      department: json['department'],
      vacationType: json['vacation_type'],
      startTime: DateTime.parse(json['start_time']),
      endTime: DateTime.parse(json['end_time']),
      isAllDay: json['is_all_day'] ?? true,
      reason: json['reason'] ?? '',
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'user_name': userName,
      'department': department,
      'vacation_type': vacationType,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime.toIso8601String(),
      'is_all_day': isAllDay,
      'reason': reason,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  // 휴가 일수 계산
  int getDays() {
    return endTime.difference(startTime).inDays + 1;
  }

  // 휴가 유형 텍스트 반환 (한글)
  String getVacationTypeText() {
    switch (vacationType) {
      case 'annual': return '연차';
      case 'half_day': return '반차';
      case 'sick': return '병가';
      case 'special': return '특별휴가';
      default: return vacationType;
    }
  }

  // 상태 텍스트 반환 (한글)
  String getStatusText() {
    switch (status) {
      case 'pending': return '대기 중';
      case 'approved': return '승인됨';
      case 'cancelled': return '취소됨';
      case 'rejected': return '거부됨';
      default: return status;
    }
  }
} 