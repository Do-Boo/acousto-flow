-- 회의실 데이터 추가
INSERT INTO meeting_rooms (building_name, floor, room_name) VALUES
('서소문청사 제1동', '지상13층', '대회의실'),
('서소문청사 후생동', '지상4층', '강당'),
('서소문청사 제1동', '지상4층', '디지털공용회의실'),
('서소문청사 제1동', '지상3층', '스마트정보지원센터 회의실'),
('서소문2청사 본관', '지상12층', '공용회의실1'),
('서소문2청사 본관', '지상20층', '대회의실'),
('서소문2청사 본관', '지상20층', '소회의실1'),
('서소문2청사 본관', '지상20층', '스마트회의실'),
('서소문2청사 본관', '지상20층', '세미나실'),
('서소문2청사 본관', '지상20층', '소회의실2'),
('서소문2청사 본관', '지상18층', '공용회의실'),
('서소문2청사 본관', '지상20층', '소회의실3'),
('서소문2청사 본관', '지상20층', '소회의실4'),
('서소문2청사 본관', '지상16층', '공용회의실');

-- 장비 데이터 추가
-- 서소문청사 제1동 대회의실 장비
INSERT INTO equipment (room_id, name, description, equipment_model, manufacturer, filter_hours, lamp_hours, quantity) VALUES
(1, '빔프로젝터', '천장 설치형 고해상도 프로젝터', 'EPSON-EB-4K01', 'EPSON', 120, 530, 1),
(1, '화상회의 카메라', '고화질 화상회의용 카메라', 'LOGITECH-BRIO', 'Logitech', NULL, NULL, 1),
(1, '무선마이크 세트', '핸드/핀 마이크 포함', 'SHURE-ULX-D', 'SHURE', NULL, NULL, 2),
(1, '음향시스템', '회의실 전용 음향 시스템', 'YAMAHA-MG12XU', 'Yamaha', NULL, NULL, 1);

-- 서소문청사 후생동 강당 장비
INSERT INTO equipment (room_id, name, description, equipment_model, manufacturer, filter_hours, lamp_hours, quantity) VALUES
(2, '대형 빔프로젝터', '대형 스크린용 고출력 프로젝터', 'EPSON-EB-L1755U', 'EPSON', 200, 820, 1),
(2, '무선마이크 세트', '대규모 행사용 마이크 시스템', 'SHURE-ULX-D', 'SHURE', NULL, NULL, 4),
(2, '음향믹서', '8채널 디지털 믹서', 'YAMAHA-MG12XU', 'Yamaha', NULL, NULL, 1);

-- 서소문청사 제1동 디지털공용회의실 장비
INSERT INTO equipment (room_id, name, description, equipment_model, manufacturer, filter_hours, lamp_hours, quantity) VALUES
(3, '스마트보드', '터치스크린 기능 디지털 보드', 'SAMSUNG-FLIP-WM85R', 'Samsung', NULL, NULL, 1),
(3, '화상회의 카메라', '화상회의용 카메라', 'LOGITECH-BRIO', 'Logitech', NULL, NULL, 1),
(3, '노트북', '회의용 고성능 노트북', 'LG-Gram-2023', 'LG', NULL, NULL, 2);

-- 서소문청사 제1동 스마트정보지원센터 회의실 장비
INSERT INTO equipment (room_id, name, description, equipment_model, manufacturer, filter_hours, lamp_hours, quantity) VALUES
(4, '태블릿', '회의용 태블릿', 'Galaxy-Tab-S8', 'Samsung', NULL, NULL, 5),
(4, '화상회의 카메라', '화상회의용 카메라', 'LOGITECH-BRIO', 'Logitech', NULL, NULL, 1),
(4, '노트북', '업무용 고성능 노트북', 'LG-Gram-2023', 'LG', NULL, NULL, 3);

-- 서소문2청사 본관 12층 공용회의실1 장비
INSERT INTO equipment (room_id, name, description, equipment_model, manufacturer, filter_hours, lamp_hours, quantity) VALUES
(5, '빔프로젝터', '천장 설치형 프로젝터', 'EPSON-EB-2250U', 'EPSON', 350, 1200, 1),
(5, '스크린', '전동식 스크린', 'ITECHEL ES-WS120', 'ITECHEL', NULL, NULL, 1);

-- 서소문2청사 본관 20층 대회의실 장비
INSERT INTO equipment (room_id, name, description, equipment_model, manufacturer, filter_hours, lamp_hours, quantity) VALUES
(6, '빔프로젝터', '고해상도 프로젝터', 'EPSON-EB-L615U', 'EPSON', 80, 320, 1),
(6, '무선마이크 세트', '회의용 마이크', 'SHURE-ULX-D', 'SHURE', NULL, NULL, 2),
(6, '화상회의 시스템', '통합 화상회의 시스템', 'Polycom-Group700', 'Polycom', NULL, NULL, 1);

-- 서소문2청사 본관 20층 소회의실1 장비
INSERT INTO equipment (room_id, name, description, equipment_model, manufacturer, filter_hours, lamp_hours, quantity) VALUES
(7, '소형 프로젝터', '소회의실용 프로젝터', 'EPSON-EB-W05', 'EPSON', 150, 600, 1),
(7, '스크린', '벽면 고정형 스크린', 'ITECHEL ES-WS80', 'ITECHEL', NULL, NULL, 1);

-- 서소문2청사 본관 20층 스마트회의실 장비
INSERT INTO equipment (room_id, name, description, equipment_model, manufacturer, filter_hours, lamp_hours, quantity) VALUES
(8, '스마트보드', '터치스크린 기능 디지털 보드', 'SAMSUNG-FLIP-WM85R', 'Samsung', NULL, NULL, 1),
(8, '화상회의 카메라', '고화질 화상회의 카메라', 'LOGITECH-BRIO', 'Logitech', NULL, NULL, 1),
(8, '태블릿', '회의용 태블릿', 'Galaxy-Tab-S8', 'Samsung', NULL, NULL, 2);

-- 서소문2청사 본관 추가 회의실 장비 (9~14번 회의실)
INSERT INTO equipment (room_id, name, description, equipment_model, manufacturer, filter_hours, lamp_hours, quantity) VALUES
(9, '빔프로젝터', '세미나용 프로젝터', 'EPSON-EB-2250U', 'EPSON', 180, 720, 1),
(9, '음향시스템', '세미나용 음향 장비', 'YAMAHA-EMX5', 'Yamaha', NULL, NULL, 1),
(10, '소형 프로젝터', '소회의실용 프로젝터', 'EPSON-EB-W05', 'EPSON', 100, 420, 1),
(11, '빔프로젝터', '회의실용 프로젝터', 'EPSON-EB-2155W', 'EPSON', 220, 880, 1),
(12, '소형 프로젝터', '소회의실용 프로젝터', 'EPSON-EB-W05', 'EPSON', 80, 350, 1),
(13, '소형 프로젝터', '소회의실용 프로젝터', 'EPSON-EB-W05', 'EPSON', 90, 380, 1),
(14, '빔프로젝터', '회의실용 프로젝터', 'EPSON-EB-2155W', 'EPSON', 200, 800, 1);

-- 예약 데이터 추가 (가정: reservations 테이블 존재)
INSERT INTO reservations (id, room_id, meeting_name, department, contact_person, contact_number, start_time, end_time, approval_status) VALUES
('1738887170753', 1, '세계소비자의날 기념행사', '공정경제과', '최은희', '02-2133-5372', '2025-03-14 09:00:00', '2025-03-14 12:00:00', '승인'),
('1738887170754', 3, '디지털 혁신 회의', '정보화담당관', '김철수', '02-2133-4568', '2025-03-15 13:00:00', '2025-03-15 15:00:00', '승인'),
('1738887170755', 6, '연간 사업계획 수립', '기획담당관', '이지원', '02-2133-4573', '2025-03-16 10:00:00', '2025-03-16 16:00:00', '신청'),
('1738887170756', 2, '직원 워크숍', '인사과', '박민수', '02-2133-4571', '2025-03-20 09:00:00', '2025-03-20 17:00:00', '승인'),
('1738887170757', 8, '스마트 서울 전략 회의', '정보화담당관', '홍길동', '02-2133-4567', '2025-03-22 14:00:00', '2025-03-22 16:00:00', '승인');

-- 보고서 데이터 추가 (가정: reports 테이블 존재)
INSERT INTO reports (reservation_id, meeting_room, usage_date, start_time, end_time, attendees, notes) VALUES
('1738887170753', '서소문청사 제1동 지상13층 대회의실', '2025-03-14', '09:00:00', '12:00:00', '경제진흥본부 직원 30명, 외부 참석자 10명', '행사 진행 원활했으나 마이크 간헐적 잡음 발생'),
('1738887170754', '서소문청사 제1동 지상4층 디지털공용회의실', '2025-03-15', '13:00:00', '15:00:00', '정보화담당관 직원 8명', '스마트보드 터치 반응 속도 개선 필요'),
('1738887170756', '서소문청사 후생동 지상4층 강당', '2025-03-20', '09:00:00', '17:00:00', '인사과 직원 25명', '점심 시간 이후 에어컨 문제로 실내 온도 높았음');

-- 보고서 사용 장비 데이터 추가 (가정: report_used_equipment 테이블 존재)
INSERT INTO report_used_equipment (report_id, room_equipment_id, quantity) VALUES
(1, 1, 1),
(1, 2, 2),
(1, 3, 1),
(2, 1, 1),
(2, 4, 3),
(3, 2, 1),
(3, 3, 4),
(3, 5, 1);

-- 회의 메모 데이터 추가 (가정: meeting_memo 테이블 존재)
INSERT INTO meeting_memo (report_id, title, content, attachments) VALUES
(1, '세계소비자의날 기념행사 결과', '소비자권익 증진을 위한 새로운 정책 방향 논의\n- 온라인 플랫폼 관련 소비자 보호 강화\n- 취약계층 소비자 지원 확대\n- 지역 소비자센터 활성화 방안', 'presentation.pdf, statistics.xlsx'),
(2, '디지털 혁신 회의 내용', '스마트 워크 환경 구축을 위한 솔루션 검토\n- 클라우드 기반 협업 툴 도입 검토\n- 모바일 결재 시스템 고도화\n- AI 기반 민원 처리 시스템 시범 운영 계획', 'digital_innovation_plan.docx'),
(3, '직원 워크숍 결과보고', '팀빌딩 및 업무 혁신 아이디어 도출\n- 부서간 협업 강화를 위한 정기 미팅 제안\n- 업무 프로세스 개선 아이디어 15건 수렴\n- 직원 복지 개선 요청사항 정리', 'workshop_photos.zip, ideas_list.xlsx');
