class MeetingRoom {
  final int id;
  final String name;
  final int capacity;
  final String location;
  final List<String> facilities;
  final String status; // available, maintenance, etc.

  MeetingRoom({
    required this.id,
    required this.name,
    required this.capacity,
    required this.location,
    required this.facilities,
    required this.status,
  });

  // JSON 변환 메서드
  factory MeetingRoom.fromJson(Map<String, dynamic> json) {
    return MeetingRoom(
      id: json['id'],
      name: json['name'],
      capacity: json['capacity'] ?? 0,
      location: json['location'] ?? '',
      facilities: List<String>.from(json['facilities'] ?? []),
      status: json['status'] ?? 'available',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'capacity': capacity,
      'location': location,
      'facilities': facilities,
      'status': status,
    };
  }
} 