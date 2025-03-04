# AcoustoFlow

## 1. 소개
AcoustoFlow는 회의실 예약, 장비 관리, 작업 보고 기능을 제공하는 음향실 관리 시스템입니다.

## 2. 주요 기능
- 소셜 로그인 (Google, Naver, Kakao)
- 회의실 예약 및 일정 관리
- 장비 관리 (QR 코드 등록)
- 푸시 알림 기능

## 3. 기술 스택
| 구성 요소  | 기술 |
|------------|------|
| **모바일**  | Flutter (Dart) |
| **백엔드**  | PHP (Laravel) |
| **데이터베이스** | MySQL |
| **알림 시스템** | OneSignal |
| **API 문서** | Swagger (OpenAPI) |

## 4. 프로젝트 설정
### 4.1 백엔드 설치
cd backend  
composer install  
php artisan migrate  
php artisan serve  

### 4.2 모바일 앱 실행
cd mobile  
flutter pub get  
flutter run  

## 5. 기여 방법
1. 이 저장소를 포크  
2. **새 브랜치 생성** (`feature/new-feature`)  
3. **변경 사항 커밋** (`git commit -m "Add new feature"`)  
4. **PR 생성 후 리뷰 요청**  

## 6. 라이선스
이 프로젝트는 **MIT 라이선스**를 따릅니다.
