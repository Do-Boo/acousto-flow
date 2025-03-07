// API 관련 상수는 api_constants.dart로 이동했습니다.
// 이 파일은 앱 전반에 걸친 다른 상수들을 정의합니다.

class AppConstants {
  // 앱 전역 설정
  static const String appName = 'AcoustoFlow';
  static const String appVersion = '1.0.0';
  
  // 페이지 타이틀
  static const String homeTitle = '홈';
  static const String calendarTitle = '캘린더';
  static const String feedTitle = '피드';
  static const String meetingRoomsTitle = '회의실';
  static const String restaurantTitle = '식당';
  
  // 알림 메시지
  static const String errorMessage = '오류가 발생했습니다.';
  static const String noDataMessage = '데이터가 없습니다.';
  static const String loadingMessage = '로딩 중...';
  
  // 데이터 필터 옵션
  static const Map<String, String> statusOptions = {
    '승인': '승인',
    '취소': '취소',
    '대기': '대기',
  };
}

class ColorConstants {
  // 색상 이름과 HEX 코드 정의
  static const Map<String, String> colorNames = {
    'meeting': '#4589FF',   // 파란색
    'vacation': '#08BDBA',  // 청록색
    'equipment': '#6929C4', // 보라색
    'construction': '#FA4D56', // 빨간색
    'approved': '#24A148',  // 초록색
    'pending': '#FDD13A',   // 노란색
    'cancelled': '#DA1E28', // 빨간색
  };
} 