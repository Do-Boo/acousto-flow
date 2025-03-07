class ConstructionProject {
  final String id;
  final String projectName;
  final String description;
  final DateTime startTime;
  final DateTime endTime;
  final bool isAllDay;
  final String location;
  final String contractor; // 시공사
  final String contactPerson;
  final String department; // 담당 부서
  final String status; // pending, in_progress, completed, cancelled
  final DateTime createdAt;
  final DateTime updatedAt;

  ConstructionProject({
    required this.id,
    required this.projectName,
    required this.description,
    required this.startTime,
    required this.endTime,
    this.isAllDay = true,
    required this.location,
    required this.contractor,
    required this.contactPerson,
    required this.department,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  // JSON 변환 메서드
  factory ConstructionProject.fromJson(Map<String, dynamic> json) {
    return ConstructionProject(
      id: json['id'],
      projectName: json['project_name'],
      description: json['description'] ?? '',
      startTime: DateTime.parse(json['start_time']),
      endTime: DateTime.parse(json['end_time']),
      isAllDay: json['is_all_day'] ?? true,
      location: json['location'],
      contractor: json['contractor'],
      contactPerson: json['contact_person'] ?? '',
      department: json['department'] ?? '',
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'project_name': projectName,
      'description': description,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime.toIso8601String(),
      'is_all_day': isAllDay,
      'location': location,
      'contractor': contractor,
      'contact_person': contactPerson,
      'department': department,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  // 프로젝트 기간(일) 계산
  int getDurationDays() {
    return endTime.difference(startTime).inDays + 1;
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