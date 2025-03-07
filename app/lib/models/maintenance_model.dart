import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'equipment_maintenance.dart';

class EquipmentInfo {
  final int id;
  final String name;
  final String model;
  final String manufacturer;
  final String type;

  EquipmentInfo({
    required this.id,
    required this.name,
    required this.model,
    required this.manufacturer,
    required this.type,
  });

  factory EquipmentInfo.fromJson(Map<String, dynamic> json) {
    return EquipmentInfo(
      id: json['id'],
      name: json['name'] ?? '',
      model: json['model'] ?? '',
      manufacturer: json['manufacturer'] ?? '',
      type: json['type'] ?? '',
    );
  }
}

class MaintenanceInfo {
  final String actionType;
  final DateTime startTime;
  final DateTime endTime;
  final String? issuesFound;
  final String? resolution;
  final int? filterHoursUpdated;
  final int? lampHoursUpdated;

  MaintenanceInfo({
    required this.actionType,
    required this.startTime,
    required this.endTime,
    this.issuesFound,
    this.resolution,
    this.filterHoursUpdated,
    this.lampHoursUpdated,
  });

  factory MaintenanceInfo.fromJson(Map<String, dynamic> json) {
    return MaintenanceInfo(
      actionType: json['action_type'],
      startTime: DateTime.parse(json['start_time']),
      endTime: DateTime.parse(json['end_time']),
      issuesFound: json['issues_found'],
      resolution: json['resolution'],
      filterHoursUpdated: json['filter_hours_updated'],
      lampHoursUpdated: json['lamp_hours_updated'],
    );
  }
}

class MaintenancePost {
  final int id;
  final Map<String, dynamic> user;
  final String content;
  final String location;
  final DateTime timestamp;
  final List<String> images;
  final EquipmentInfo equipment;
  final MaintenanceInfo maintenance;
  final List<MaintenanceComment> comments;
  final int likes;

  MaintenancePost({
    required this.id,
    required this.user,
    required this.content,
    required this.location,
    required this.timestamp,
    required this.images,
    required this.equipment,
    required this.maintenance,
    required this.comments,
    required this.likes,
  });

  factory MaintenancePost.fromJson(Map<String, dynamic> json) {
    // 이미지 처리
    List<String> imagesList = [];
    if (json['images'] != null) {
      imagesList = List<String>.from(json['images']);
    }

    // 댓글 처리
    List<MaintenanceComment> commentsList = [];
    if (json['comments'] != null) {
      commentsList = List<MaintenanceComment>.from(
        json['comments'].map((comment) => MaintenanceComment.fromJson(comment))
      );
    }

    return MaintenancePost(
      id: json['id'],
      user: json['user'],
      content: json['content'],
      location: json['location'],
      timestamp: DateTime.parse(json['timestamp']),
      images: imagesList,
      equipment: EquipmentInfo.fromJson(json['equipment']),
      maintenance: MaintenanceInfo.fromJson(json['maintenance']),
      comments: commentsList,
      likes: json['likes'] ?? 0,
    );
  }

  static List<MaintenancePost> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => MaintenancePost.fromJson(json)).toList();
  }
} 