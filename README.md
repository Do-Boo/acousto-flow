# AcoustoFlow

AcoustoFlow는 회사 내 다양한 일정과 시설을 관리하기 위한 통합 애플리케이션입니다.

## 주요 기능

- **통합 캘린더**: 휴가, 회의실 예약, 장비 관리, 공사 일정을 한 화면에서 확인
- **회의실 예약**: 회의실 예약 및 관리
- **휴가 관리**: 직원 휴가 신청 및 관리
- **장비 관리**: 음향 장비 관리 및 점검 일정
- **공사 일정**: 시설 공사 일정 관리
- **식당 메뉴**: 사내 식당 메뉴 확인

## 프로젝트 구조

```
acoustoflow/
├── app/                  # Flutter 애플리케이션
│   ├── lib/
│   │   ├── models/       # 데이터 모델
│   │   ├── screens/      # 화면 UI
│   │   ├── services/     # API 서비스
│   │   ├── utils/        # 유틸리티 클래스
│   │   ├── widgets/      # 재사용 가능한 위젯
│   │   └── main.dart     # 앱 진입점
├── database/             # 데이터베이스 스키마 및 샘플 데이터
│   ├── db_schema.sql     # 데이터베이스 스키마
│   └── sample_data.sql   # 샘플 데이터
└── server/               # 서버 API
    └── api/              # PHP API 엔드포인트
```

## 설치 및 실행 방법

### 1. 데이터베이스 설정

1. MySQL 서버에 접속합니다.
2. `database/db_schema.sql` 파일을 실행하여 데이터베이스와 테이블을 생성합니다.
3. `database/sample_data.sql` 파일을 실행하여 샘플 데이터를 추가합니다.

```sql
mysql -u root -p < database/db_schema.sql
mysql -u root -p < database/sample_data.sql
```

### 2. 서버 설정

1. PHP가 설치된 웹 서버(Apache 또는 Nginx)를 준비합니다.
2. `server` 디렉토리를 웹 서버의 문서 루트 디렉토리에 복사합니다.
3. `server/api/db_config.php` 파일에서 데이터베이스 연결 정보를 수정합니다.

```php
$host = 'localhost';     // 데이터베이스 호스트
$dbname = 'acoustoflow'; // 데이터베이스 이름
$username = 'root';      // 데이터베이스 사용자 이름
$password = '';          // 데이터베이스 비밀번호
```

### 3. Flutter 앱 실행

1. Flutter 개발 환경을 설정합니다.
2. 프로젝트 디렉토리로 이동합니다.
3. 필요한 패키지를 설치합니다.
4. 앱을 실행합니다.

```bash
cd app
flutter pub get
flutter run
```

## API 엔드포인트

### 1. 휴가 데이터

- **GET** `/api/get_vacations.php`: 휴가 데이터 조회
  - 파라미터:
    - `start_date`: 시작 날짜 (YYYY-MM-DD)
    - `end_date`: 종료 날짜 (YYYY-MM-DD)
    - `user_id`: 사용자 ID
    - `department`: 부서명

### 2. 회의실 예약

- **GET** `/api/get_meeting_rooms.php`: 회의실 예약 데이터 조회
  - 파라미터:
    - `start_date`: 시작 날짜 (YYYY-MM-DD)
    - `end_date`: 종료 날짜 (YYYY-MM-DD)
    - `room_id`: 회의실 ID
    - `user_id`: 사용자 ID

### 3. 장비 관리 일정

- **GET** `/api/get_equipment_tasks.php`: 장비 관리 일정 조회
  - 파라미터:
    - `start_date`: 시작 날짜 (YYYY-MM-DD)
    - `end_date`: 종료 날짜 (YYYY-MM-DD)
    - `equipment_id`: 장비 ID
    - `assigned_to`: 담당자 ID
    - `department`: 부서명
    - `status`: 상태

### 4. 공사 일정

- **GET** `/api/get_construction_projects.php`: 공사 일정 조회
  - 파라미터:
    - `start_date`: 시작 날짜 (YYYY-MM-DD)
    - `end_date`: 종료 날짜 (YYYY-MM-DD)
    - `contractor`: 시공사
    - `department`: 부서명
    - `status`: 상태

### 5. 통합 캘린더 이벤트

- **GET** `/api/get_all_calendar_events.php`: 모든 일정 데이터 통합 조회
  - 파라미터:
    - `start_date`: 시작 날짜 (YYYY-MM-DD)
    - `end_date`: 종료 날짜 (YYYY-MM-DD)
    - `user_id`: 사용자 ID
    - `department`: 부서명
    - `event_types`: 이벤트 유형 (쉼표로 구분, 예: 'vacations,meetings,equipment,construction')

## 기술 스택

- **프론트엔드**: Flutter
- **백엔드**: PHP
- **데이터베이스**: MySQL 