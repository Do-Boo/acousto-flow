import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/meeting_note_model.dart';
import '../utils/api_constants.dart';

class MeetingNoteService {
  // API 기본 URL
  final String baseUrl = ApiConstants.baseUrl;
  final Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  
  Future<List<MeetingNote>> getNotes({String? reportId}) async {
    try {
      final url = reportId != null 
          ? '$baseUrl${ApiConstants.meetingNotesEndpoint}?report_id=$reportId'
          : '$baseUrl${ApiConstants.meetingNotesEndpoint}';
      
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        // 'success' 또는 'status'가 'success'인 경우 모두 처리
        if ((data['success'] == true || data['status'] == 'success') && data['data'] != null) {
          return List<MeetingNote>.from(
            data['data'].map((x) => MeetingNote.fromJson(x))
          );
        }
        
        print('API 응답 형식이 예상과 다릅니다: $data');
        return [];
      } else {
        print('API 호출 실패: 상태 코드 ${response.statusCode}');
        // 샘플 데이터 반환 및 예외 처리 일관성 유지
        return [];
      }
    } catch (e) {
      print('회의 메모 조회 오류: $e');
      return [];
    }
  }
  
  // 노트 추가
  Future<bool> addNote(MeetingNote note) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl${ApiConstants.addMeetingNoteEndpoint}'),
        headers: headers,
        body: json.encode(note.toJson()),
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['status'] == 'success';
      } else {
        throw Exception('Failed to add meeting note: ${response.statusCode}');
      }
    } catch (e) {
      print('Error adding meeting note: $e');
      return false;
    }
  }
  
  Future<bool> updateNoteStatus(int noteId, NoteStatus status) async {
    try {
      final url = '$baseUrl${ApiConstants.updateNoteStatusEndpoint}';
      
      String statusStr;
      switch (status) {
        case NoteStatus.inProgress:
          statusStr = '처리중';
          break;
        case NoteStatus.completed:
          statusStr = '완료';
          break;
        default:
          statusStr = '신규';
      }
      
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          'id': noteId,
          'status': statusStr,
        }),
        headers: headers,
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['status'] == 'success';
      } else {
        throw Exception('Failed to update note status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating note status: $e');
      return false;
    }
  }
  
  Future<bool> deleteNote(int noteId) async {
    try {
      final url = '$baseUrl${ApiConstants.deleteMeetingNoteEndpoint}?id=$noteId';
      
      final response = await http.delete(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['status'] == 'success';
      } else {
        throw Exception('Failed to delete meeting note: ${response.statusCode}');
      }
    } catch (e) {
      print('Error deleting meeting note: $e');
      return false;
    }
  }
} 