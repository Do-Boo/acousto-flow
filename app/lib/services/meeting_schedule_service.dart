import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/meeting_schedule.dart';
import '../utils/api_constants.dart';

class MeetingScheduleService {
  // API 요청용 헤더
  final Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  Future<List<MeetingSchedule>> getMeetingSchedules({
    String? startDate,
    String? endDate,
    int? roomId,
    String? department,
    String? status,
  }) async {
    try {
      Map<String, dynamic> queryParams = {};
      
      if (startDate != null) queryParams['start_date'] = startDate;
      if (endDate != null) queryParams['end_date'] = endDate;
      if (roomId != null) queryParams['room_id'] = roomId.toString();
      if (department != null) queryParams['department'] = department;
      if (status != null) queryParams['status'] = status;
      
      final url = ApiConstants.buildUrl(ApiConstants.meetingSchedulesEndpoint, queryParams);
      
      if (ApiConstants.loggingEnabled) {
        print('API 요청 URL: $url');
        print('모듈: meeting, 액션: schedules');
      }
      
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(utf8.decode(response.bodyBytes));
        final List<dynamic> schedulesJson = jsonData['data'] ?? [];
        
        return schedulesJson
            .map((json) => MeetingSchedule.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to load meeting schedules: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in MeetingScheduleService: $e');
      return [];
    }
  }
} 