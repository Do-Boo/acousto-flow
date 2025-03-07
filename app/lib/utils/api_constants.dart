class ApiConstants {
  // API 기본 URL - 서버 루트 경로로 변경
  static const String baseUrl = 'https://doboo.tplinkdns.com/Web/acousto-flow/server/api/v1';
  
  // API 키
  static const String apiKey = 'your_api_key_here_change_me_in_production';
  
  // API 타임아웃 설정
  static const int defaultTimeout = 30; // 초 단위
  static const bool loggingEnabled = true;
  
  // 직접 PHP 파일 호출을 위한 엔드포인트 (실제 API 파일)
  static const String equipmentTasksEndpoint = '/equipment/get_tasks.php';
  static const String equipmentMaintenanceEndpoint = '/equipment/get_maintenance.php';
  static const String meetingRoomsEndpoint = '/meetings/get_rooms.php';
  static const String meetingSchedulesEndpoint = '/meetings/get_schedules.php';
  static const String restaurantMenuEndpoint = '/restaurant/get_menu.php';
  
  // 추후 개발 예정인 API들의 엔드포인트 (임시)
  static const String feedEndpoint = '/feed/get_posts.php';
  static const String usersEndpoint = '/users/get_vacations.php';
  static const String calendarEndpoint = '/calendar/get_events.php';
  static const String constructionEndpoint = '/construction/get_projects.php';
  
  // 회의 관련 추가 엔드포인트
  static const String meetingNotesEndpoint = '/meetings/get_notes.php';
  static const String addMeetingNoteEndpoint = '/meetings/add_note.php';
  static const String updateNoteStatusEndpoint = '/meetings/update_note.php';
  static const String deleteMeetingNoteEndpoint = '/meetings/delete_note.php';
  static const String reportsEndpoint = '/meetings/get_reports.php';
  
  // 캘린더 관련 추가 엔드포인트
  static const String calendarEventsEndpoint = '/calendar/get_events.php';
  static const String allCalendarEventsEndpoint = '/calendar/get_all_events.php';
  
  // 유저 관련 추가 엔드포인트
  static const String vacationsEndpoint = '/users/get_vacations.php';
  static const String addVacationEndpoint = '/users/add_vacation.php';
  static const String updateVacationStatusEndpoint = '/users/update_vacation_status.php';
  
  // 장비 관련 추가 엔드포인트
  static const String addEquipmentTaskEndpoint = '/equipment/add_task.php';
  static const String updateEquipmentTaskStatusEndpoint = '/equipment/update_task_status.php';
  
  // 공사 관련 추가 엔드포인트
  static const String constructionProjectsEndpoint = '/construction/get_projects.php';
  static const String addConstructionProjectEndpoint = '/construction/add_project.php';
  static const String updateConstructionStatusEndpoint = '/construction/update_project_status.php';
  
  // URL 생성 헬퍼 메서드
  static String buildUrl(String endpoint, [Map<String, dynamic>? queryParams]) {
    if (endpoint.startsWith('http')) {
      return endpoint; // 이미 완전한 URL인 경우
    }
    
    // 기본 URL 구성
    String url = baseUrl;
    
    // 경로 연결
    if (!url.endsWith('/') && !endpoint.startsWith('/')) {
      url += '/';
    } else if (url.endsWith('/') && endpoint.startsWith('/')) {
      endpoint = endpoint.substring(1);
    }
    
    url += endpoint;
    
    // 쿼리 파라미터 추가
    if (queryParams != null && queryParams.isNotEmpty) {
      // 이미 쿼리 파라미터가 있는지 확인
      bool hasQueryParams = endpoint.contains('?');
      
      queryParams.forEach((key, value) {
        if (value != null) {
          // 첫 번째 파라미터인지 체크
          if (!hasQueryParams) {
            url += '?';
            hasQueryParams = true;
          } else {
            url += '&';
          }
          url += '$key=$value';
        }
      });
    }
    
    return url;
  }
} 