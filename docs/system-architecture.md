# AcoustoFlow 시스템 아키텍처

## 1. 개요
AcoustoFlow는 Flutter 기반 모바일 앱과 PHP 백엔드로 구성된 음향실 관리 시스템입니다.

## 2. 시스템 구성

### 2.1 전체 구조
[Flutter App] <--> [PHP API 서버] <--> [MySQL DB]

### 2.2 기술 스택
| 구성 요소  | 기술 |
|------------|------|
| 모바일 앱  | Flutter (Dart) |
| 백엔드     | PHP (Laravel) |
| 데이터베이스 | MySQL |
| 인증 방식  | JWT (JSON Web Token) |
| 푸시 알림  | OneSignal |

### 2.3 주요 모듈
- **인증 모듈:** JWT 기반 로그인/회원가입
- **예약 시스템:** 회의실 예약 및 일정 관리
- **장비 관리:** QR 코드 기반 장비 등록 & 관리
- **알림 시스템:** 푸시 알림 전송

## 3. 데이터베이스 설계
### 3.1 주요 테이블
#### `users` (사용자 테이블)
| 필드명 | 타입 | 설명 |
|--------|------|------|
| id | INT | 기본 키 |
| name | VARCHAR | 사용자 이름 |
| email | VARCHAR | 이메일 |
| password | VARCHAR | 해싱된 비밀번호 |

#### `meeting_rooms` (회의실 테이블)
| 필드명 | 타입 | 설명 |
|--------|------|------|
| id | INT | 기본 키 |
| name | VARCHAR | 회의실 이름 |
| location | VARCHAR | 위치 정보 |

#### `reservations` (예약 테이블)
| 필드명 | 타입 | 설명 |
|--------|------|------|
| id | INT | 기본 키 |
| user_id | INT | 예약한 사용자 |
| room_id | INT | 예약한 회의실 |
| start_time | DATETIME | 시작 시간 |
| end_time | DATETIME | 종료 시간 |

## 4. API 흐름
사용자 요청 → API 서버 처리 → 데이터베이스 → 응답 반환
