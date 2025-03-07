import 'package:flutter/foundation.dart';

// 유지보수 모델 클래스
class Maintenance {
  final int id;
  final int equipmentId;
  final String? locationDescription;
  final String? reservationId;
  final String actionType;
  final String startTime;
  final String endTime;
  final String date;
  final String time;
  final String duration;
  final String? issuesFound;
  final String? resolution;
  final int? filterHoursUpdated;
  final int? lampHoursUpdated;
  final String? workedBy;
  final String createdAt;
  final String equipmentName;
  final String equipmentModel;
  final String manufacturer;
  final String? meetingName;
  final String? meetingDate;
  final List<MaintenanceImage> images;
  final int commentCount;
  final int likeCount;
  final List<MaintenanceComment>? comments;
  final List<MaintenanceLike>? likes;
  final int? imageCount;

  Maintenance({
    required this.id,
    required this.equipmentId,
    this.locationDescription,
    this.reservationId,
    required this.actionType,
    required this.startTime,
    required this.endTime,
    required this.date,
    required this.time,
    required this.duration,
    this.issuesFound,
    this.resolution,
    this.filterHoursUpdated,
    this.lampHoursUpdated,
    this.workedBy,
    required this.createdAt,
    required this.equipmentName,
    required this.equipmentModel,
    required this.manufacturer,
    this.meetingName,
    this.meetingDate,
    this.images = const [],
    this.commentCount = 0,
    this.likeCount = 0,
    this.comments,
    this.likes,
    this.imageCount,
  });

  // JSON으로부터 객체 생성
  factory Maintenance.fromJson(Map<String, dynamic> json) {
    List<MaintenanceImage> imageList = [];
    if (json['images'] != null) {
      imageList = List<MaintenanceImage>.from(
        json['images'].map((x) => MaintenanceImage.fromJson(x)),
      );
    }

    List<MaintenanceComment>? commentList;
    if (json['comments'] != null) {
      commentList = List<MaintenanceComment>.from(
        json['comments'].map((x) => MaintenanceComment.fromJson(x)),
      );
    }

    List<MaintenanceLike>? likeList;
    if (json['likes'] != null) {
      likeList = List<MaintenanceLike>.from(
        json['likes'].map((x) => MaintenanceLike.fromJson(x)),
      );
    }

    return Maintenance(
      id: json['id'],
      equipmentId: json['equipment_id'],
      locationDescription: json['location_description'],
      reservationId: json['reservation_id'],
      actionType: json['action_type'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      date: json['date'],
      time: json['time'],
      duration: json['duration'],
      issuesFound: json['issues_found'],
      resolution: json['resolution'],
      filterHoursUpdated: json['filter_hours_updated'],
      lampHoursUpdated: json['lamp_hours_updated'],
      workedBy: json['worked_by'],
      createdAt: json['created_at'],
      equipmentName: json['equipment_name'],
      equipmentModel: json['equipment_model'],
      manufacturer: json['manufacturer'],
      meetingName: json['meeting_name'],
      meetingDate: json['meeting_date'],
      images: imageList,
      commentCount: json['comment_count'] ?? 0,
      likeCount: json['like_count'] ?? 0,
      comments: commentList,
      likes: likeList,
      imageCount: json['image_count'],
    );
  }

  // 객체를 JSON으로 변환
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'equipment_id': equipmentId,
      'location_description': locationDescription,
      'reservation_id': reservationId,
      'action_type': actionType,
      'start_time': startTime,
      'end_time': endTime,
      'date': date,
      'time': time,
      'duration': duration,
      'issues_found': issuesFound,
      'resolution': resolution,
      'filter_hours_updated': filterHoursUpdated,
      'lamp_hours_updated': lampHoursUpdated,
      'worked_by': workedBy,
      'created_at': createdAt,
      'equipment_name': equipmentName,
      'equipment_model': equipmentModel,
      'manufacturer': manufacturer,
      'meeting_name': meetingName,
      'meeting_date': meetingDate,
      'images': images.map((x) => x.toJson()).toList(),
      'comment_count': commentCount,
      'like_count': likeCount,
      if (comments != null) 'comments': comments!.map((x) => x.toJson()).toList(),
      if (likes != null) 'likes': likes!.map((x) => x.toJson()).toList(),
      if (imageCount != null) 'image_count': imageCount,
    };
  }

  // 수정된 유지보수 객체 생성
  Maintenance copyWith({
    int? id,
    int? equipmentId,
    String? locationDescription,
    String? reservationId,
    String? actionType,
    String? startTime,
    String? endTime,
    String? date,
    String? time,
    String? duration,
    String? issuesFound,
    String? resolution,
    int? filterHoursUpdated,
    int? lampHoursUpdated,
    String? workedBy,
    String? createdAt,
    String? equipmentName,
    String? equipmentModel,
    String? manufacturer,
    String? meetingName,
    String? meetingDate,
    List<MaintenanceImage>? images,
    int? commentCount,
    int? likeCount,
    List<MaintenanceComment>? comments,
    List<MaintenanceLike>? likes,
    int? imageCount,
  }) {
    return Maintenance(
      id: id ?? this.id,
      equipmentId: equipmentId ?? this.equipmentId,
      locationDescription: locationDescription ?? this.locationDescription,
      reservationId: reservationId ?? this.reservationId,
      actionType: actionType ?? this.actionType,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      date: date ?? this.date,
      time: time ?? this.time,
      duration: duration ?? this.duration,
      issuesFound: issuesFound ?? this.issuesFound,
      resolution: resolution ?? this.resolution,
      filterHoursUpdated: filterHoursUpdated ?? this.filterHoursUpdated,
      lampHoursUpdated: lampHoursUpdated ?? this.lampHoursUpdated,
      workedBy: workedBy ?? this.workedBy,
      createdAt: createdAt ?? this.createdAt,
      equipmentName: equipmentName ?? this.equipmentName,
      equipmentModel: equipmentModel ?? this.equipmentModel,
      manufacturer: manufacturer ?? this.manufacturer,
      meetingName: meetingName ?? this.meetingName,
      meetingDate: meetingDate ?? this.meetingDate,
      images: images ?? this.images,
      commentCount: commentCount ?? this.commentCount,
      likeCount: likeCount ?? this.likeCount,
      comments: comments ?? this.comments,
      likes: likes ?? this.likes,
      imageCount: imageCount ?? this.imageCount,
    );
  }
}

// 유지보수 이미지 모델
class MaintenanceImage {
  final int id;
  final String? imagePath; // 기존 URL 방식 (하위 호환성 유지)
  final String? imageData; // Base64 인코딩된 이미지 데이터 (data:image/jpeg;base64,...)
  final String? fileName;  // 파일 이름
  final String? caption;
  final String uploadTime;

  MaintenanceImage({
    required this.id,
    this.imagePath,
    this.imageData,
    this.fileName,
    this.caption,
    required this.uploadTime,
  }) : assert(imagePath != null || imageData != null, 'Either imagePath or imageData must be provided');

  factory MaintenanceImage.fromJson(Map<String, dynamic> json) {
    return MaintenanceImage(
      id: json['id'],
      imagePath: json['image_path'],
      imageData: json['imageData'],
      fileName: json['fileName'],
      caption: json['caption'],
      uploadTime: json['upload_time'] ?? json['uploadTime'] ?? DateTime.now().toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (imagePath != null) 'image_path': imagePath,
      if (imageData != null) 'imageData': imageData,
      if (fileName != null) 'fileName': fileName,
      if (caption != null) 'caption': caption,
      'upload_time': uploadTime,
    };
  }
}

// 유지보수 댓글 모델
class MaintenanceComment {
  final int id;
  final String userId;
  final String content;
  final String createdAt;
  final String date;
  final String time;

  MaintenanceComment({
    required this.id,
    required this.userId,
    required this.content,
    required this.createdAt,
    required this.date,
    required this.time,
  });

  factory MaintenanceComment.fromJson(Map<String, dynamic> json) {
    return MaintenanceComment(
      id: json['id'],
      userId: json['user_id'],
      content: json['content'],
      createdAt: json['created_at'],
      date: json['date'],
      time: json['time'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'content': content,
      'created_at': createdAt,
      'date': date,
      'time': time,
    };
  }
}

// 유지보수 좋아요 모델
class MaintenanceLike {
  final int id;
  final String userId;
  final String createdAt;

  MaintenanceLike({
    required this.id,
    required this.userId,
    required this.createdAt,
  });

  factory MaintenanceLike.fromJson(Map<String, dynamic> json) {
    return MaintenanceLike(
      id: json['id'],
      userId: json['user_id'],
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'created_at': createdAt,
    };
  }
} 