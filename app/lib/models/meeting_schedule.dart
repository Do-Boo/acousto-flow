class MeetingSchedule {
  final String id;
  final String location;
  final String dateTimeDisplay;
  final String meetingTitle;
  final String department;
  final String contactInfo;
  final String status;
  final DateTime startTime;
  final int roomId;
  final String category;

  MeetingSchedule({
    required this.id,
    required this.location,
    required this.dateTimeDisplay,
    required this.meetingTitle,
    required this.department,
    required this.contactInfo,
    required this.status,
    required this.startTime,
    required this.roomId,
    this.category = 'meeting',
  });

  factory MeetingSchedule.fromJson(Map<String, dynamic> json) {
    return MeetingSchedule(
      id: json['id'].toString(),
      location: json['location'] ?? '',
      dateTimeDisplay: json['date_time_display'] ?? '',
      meetingTitle: json['meeting_title'] ?? '',
      department: json['department'] ?? '',
      contactInfo: json['contact_info'] ?? '',
      status: json['status'] ?? '승인',
      startTime: DateTime.parse(json['start_time']),
      roomId: json['room_id'] is String 
        ? int.parse(json['room_id']) 
        : (json['room_id'] ?? 0),
      category: json['category'] ?? 'meeting',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'location': location,
      'date_time_display': dateTimeDisplay,
      'meeting_title': meetingTitle,
      'department': department,
      'contact_info': contactInfo,
      'status': status,
      'start_time': startTime.toIso8601String(),
      'room_id': roomId,
      'category': category,
    };
  }

  // For debugging purposes
  @override
  String toString() {
    return 'MeetingSchedule{id: $id, meetingTitle: $meetingTitle, startTime: $startTime, status: $status}';
  }
} 