class EquipmentTask {
  final String id;
  final String taskName;
  final String description;
  final DateTime startTime;
  final DateTime endTime;
  final String location;
  final String equipmentId;
  final String equipmentName;
  final String assignedTo; // 담당자
  final String department;
  final String status; // pending, in_progress, completed, cancelled
  final DateTime createdAt;
  final DateTime updatedAt;

  EquipmentTask({
    required this.id,
    required this.taskName,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.location,
    required this.equipmentId,
    required this.equipmentName,
    required this.assignedTo,
    required this.department,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  // JSON 변환 메서드
  factory EquipmentTask.fromJson(Map<String, dynamic> json) {
    return EquipmentTask(
      id: json['id'],
      taskName: json['task_name'],
      description: json['description'] ?? '',
      startTime: DateTime.parse(json['start_time']),
      endTime: DateTime.parse(json['end_time']),
      location: json['location'] ?? '',
      equipmentId: json['equipment_id'],
      equipmentName: json['equipment_name'],
      assignedTo: json['assigned_to'],
      department: json['department'] ?? '',
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'task_name': taskName,
      'description': description,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime.toIso8601String(),
      'location': location,
      'equipment_id': equipmentId,
      'equipment_name': equipmentName,
      'assigned_to': assignedTo,
      'department': department,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  // 작업 기간(분) 계산
  int getDurationMinutes() {
    return endTime.difference(startTime).inMinutes;
  }

  // 상태 텍스트 반환 (한글)
  String getStatusText() {
    switch (status) {
      case 'pending': return '대기 중';
      case 'in_progress': return '진행 중';
      case 'completed': return '완료됨';
      case 'cancelled': return '취소됨';
      default: return status;
    }
  }
} 