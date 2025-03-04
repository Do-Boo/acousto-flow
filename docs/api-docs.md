# AcoustoFlow API 문서

## 1. 개요
AcoustoFlow의 API는 회의실 예약, 장비 관리, 작업 보고 등의 기능을 제공하는 RESTful API입니다.

## 2. 인증 (Authentication)
- **방식:** JWT (JSON Web Token)
- **헤더 사용:** `Authorization: Bearer <token>`

### 로그인 API
- `POST /api/auth/login`
- 요청 예시:
  {
    "email": "user@example.com",
    "password": "password123"
  }
- 응답 예시:
  {
    "token": "eyJhbGciOiJIUzI1NiIsIn..."
  }

## 3. API 엔드포인트

### 3.1 사용자 관련 API
- **회원가입:** `POST /api/auth/register`
- **로그인:** `POST /api/auth/login`
- **프로필 조회:** `GET /api/user/profile`

### 3.2 회의실 예약 API
- **예약 목록 조회:** `GET /api/meeting-room/reservations`
- **예약 생성:** `POST /api/meeting-room/reservations`
- **예약 취소:** `DELETE /api/meeting-room/reservations/{id}`

### 3.3 장비 관리 API
- **장비 목록 조회:** `GET /api/equipment`
- **장비 추가:** `POST /api/equipment`
- **장비 삭제:** `DELETE /api/equipment/{id}`

## 4. 응답 코드
| 코드 | 의미 |
|------|------|
| 200  | 성공 |
| 400  | 잘못된 요청 |
| 401  | 인증 필요 |
| 403  | 접근 거부 |
| 404  | 리소스 없음 |
| 500  | 서버 오류 |