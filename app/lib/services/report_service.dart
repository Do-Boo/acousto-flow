import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../models/report_model.dart';
import '../utils/api_constants.dart';

class ReportService {
  // API 기본 URL
  final String baseUrl = ApiConstants.baseUrl;
  final Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  
  Future<List<Report>> getAllReports() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl${ApiConstants.reportsEndpoint}'),
        headers: headers,
      ).timeout(const Duration(seconds: ApiConstants.defaultTimeout));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['status'] == 'success' && data['data'] != null) {
          return List<Report>.from(
            data['data'].map((x) => Report.fromJson(x))
          );
        }
        return [];
      } else {
        throw Exception('Failed to load reports: ${response.statusCode}');
      }
    } on TimeoutException {
      print('Connection timeout while loading reports');
      return [];
    } on SocketException {
      print('Network error while loading reports');
      return [];
    } catch (e) {
      print('Error fetching reports: $e');
      return [];
    }
  }
  
  Future<List<Report>> getReportsByDate(DateTime date) async {
    try {
      final dateStr = DateFormat('yyyy-MM-dd').format(date);
      final response = await http.get(
        Uri.parse('$baseUrl${ApiConstants.reportsEndpoint}?date=$dateStr'),
        headers: headers,
      ).timeout(const Duration(seconds: ApiConstants.defaultTimeout));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['status'] == 'success' && data['data'] != null) {
          return List<Report>.from(
            data['data'].map((x) => Report.fromJson(x))
          );
        }
        return [];
      } else {
        throw Exception('Failed to load reports by date: ${response.statusCode}');
      }
    } on TimeoutException {
      print('Connection timeout while loading reports by date');
      return [];
    } on SocketException {
      print('Network error while loading reports by date');
      return [];
    } catch (e) {
      print('Error fetching reports by date: $e');
      return [];
    }
  }
  
  Future<List<Report>> getReportsByRoom(String roomName) async {
    try {
      final encodedRoomName = Uri.encodeComponent(roomName);
      final response = await http.get(
        Uri.parse('$baseUrl${ApiConstants.reportsEndpoint}?room=$encodedRoomName'),
        headers: headers,
      ).timeout(const Duration(seconds: ApiConstants.defaultTimeout));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['status'] == 'success' && data['data'] != null) {
          return List<Report>.from(
            data['data'].map((x) => Report.fromJson(x))
          );
        }
        return [];
      } else {
        throw Exception('Failed to load reports by room: ${response.statusCode}');
      }
    } on TimeoutException {
      print('Connection timeout while loading reports by room');
      return [];
    } on SocketException {
      print('Network error while loading reports by room');
      return [];
    } catch (e) {
      print('Error fetching reports by room: $e');
      return [];
    }
  }
} 