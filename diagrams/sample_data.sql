-- 샘플 부서 데이터
INSERT INTO departments (name, code, location) VALUES
('경영지원팀', 'MGT01', '본관 3층'),
('인사팀', 'HR01', '본관 2층'),
('재무팀', 'FIN01', '본관 2층'),
('IT팀', 'IT01', '별관 1층'),
('시설관리팀', 'FAC01', '별관 지하 1층');

-- 샘플 사용자 데이터
INSERT INTO users (name, email, password, department, position, phone) VALUES
('관리자', 'admin@example.com', '$2y$10$abcdefghijklmnopqrstuv', 1, '팀장', '010-1234-5678'),
('김철수', 'kim@example.com', '$2y$10$abcdefghijklmnopqrstuv', 1, '사원', '010-2345-6789'),
('이영희', 'lee@example.com', '$2y$10$abcdefghijklmnopqrstuv', 2, '대리', '010-3456-7890'),
('박지성', 'park@example.com', '$2y$10$abcdefghijklmnopqrstuv', 3, '과장', '010-4567-8901'),
('최민수', 'choi@example.com', '$2y$10$abcdefghijklmnopqrstuv', 4, '차장', '010-5678-9012'),
('정성훈', 'jung@example.com', '$2y$10$abcdefghijklmnopqrstuv', 5, '부장', '010-6789-0123');

-- 샘플 회의실 데이터
INSERT INTO meeting_rooms (name) VALUES
('서소문청사 제1동(지상13층) 대회의실'),
('서소문청사 후생동(지상4층) 강당'),
('서소문청사 제1동(지상4층) 디지털공용회의실'),
('서소문청사 제1동(지상3층) 스마트정보지원센터 회의실'),
('서소문2청사 본관(지상12층) 공용회의실1'),
('서소문2청사 본관(지상20층) 대회의실'),
('서소문2청사 본관(지상20층) 소회의실1'),
('서소문2청사 본관(지상20층) 스마트회의실'),
('서소문2청사 본관(지상20층) 세미나실'),
('서소문2청사 본관(지상20층) 소회의실2'),
('서소문2청사 본관(지상18층) 공용회의실'),
('서소문2청사 본관(지상20층) 소회의실3'),
('서소문2청사 본관(지상20층) 소회의실4'),
('서소문2청사 본관(지상16층) 공용회의실'),

-- 샘플 회의실별 장비 데이터
INSERT INTO room_equipment (room_id, quantity, status, location_in_room, last_checked, checked_by, filter_hours, lamp_hours, notes) VALUES
(1, 1, 1, 'available', '천장', '2023-09-15 10:00:00', '김철수', 120, 530, '정기 점검 완료'),
(1, 3, 1, 'available', '스크린 옆 벽면', '2023-09-15 10:30:00', '김철수', NULL, NULL, '화상회의 기능 이상 없음'),
(1, 4, 2, 'available', '연단', '2023-09-15 11:00:00', '김철수', NULL, NULL, '배터리 교체 필요'),
(2, 1, 1, 'available', '천장 중앙', '2023-08-20 14:00:00', '홍길동', 200, 820, '램프 교체 예정'),
(2, 4, 4, 'available', '무대', '2023-08-20 14:30:00', '홍길동', NULL, NULL, '무선 수신기 정상 작동'),
(2, 6, 1, 'available', '무대 옆 음향부스', '2023-08-20 15:00:00', '홍길동', NULL, NULL, ''),
(3, 5, 1, 'available', '전면 벽', '2023-09-10 09:00:00', '이지원', NULL, NULL, '터치 반응 양호'),
(3, 3, 1, 'needs_maintenance', '스마트보드 위', '2023-09-10 09:30:00', '이지원', NULL, NULL, '화면 깜빡임 현상 발생'),
(3, 2, 2, 'available', '수납장', '2023-09-10 10:00:00', '이지원', NULL, NULL, '충전기와 함께 보관'),
(4, 7, 5, 'available', '보관함', '2023-09-05 13:00:00', '정다운', NULL, NULL, '2대는 충전 중'),
(4, 3, 1, 'available', '벽면 선반', '2023-09-05 13:30:00', '정다운', NULL, NULL, ''),
(4, 2, 3, 'available', '보관함', '2023-09-05 14:00:00', '정다운', NULL, NULL, '1대는 OS 업데이트 필요'),
(5, 1, 1, 'needs_maintenance', '천장', '2023-08-25 09:00:00', '김철수', 350, 1200, '화면 밝기가 어두움, 램프 교체 필요'),
(6, 1, 1, 'available', '천장', '2023-09-20 11:00:00', '홍길동', 80, 320, ''),
(6, 4, 2, 'available', '연단', '2023-09-20 11:30:00', '홍길동', NULL, NULL, ''),
(6, 3, 1, 'available', '스크린 옆', '2023-09-20 12:00:00', '홍길동', NULL, NULL, ''),
(7, 1, 1, 'available', '천장', '2023-09-18 10:00:00', '이지원', 150, 600, ''),
(8, 5, 1, 'available', '벽면', '2023-09-12 14:00:00', '정다운', NULL, NULL, ''),
(8, 3, 1, 'available', '스마트보드 위', '2023-09-12 14:30:00', '정다운', NULL, NULL, ''),
(8, 7, 2, 'available', '보관함', '2023-09-12 15:00:00', '정다운', NULL, NULL, '');

-- 샘플 예약 데이터
INSERT INTO reservations (id, room_id, meeting_name, department, start_time, end_time, contact_person, contact_number, approval_status) VALUES
('1738887170753', 1, '세계소비자의날 기념행사', '공정경제과', '2025-03-14 09:00:00', '2025-03-14 12:00:00', '최은희', '02-2133-5372', '승인'),
('1738887170754', 3, '디지털 혁신 회의', '정보화담당관', '2025-03-15 13:00:00', '2025-03-15 15:00:00', '김철수', '02-2133-4568', '승인'),
('1738887170755', 6, '연간 사업계획 수립', '기획담당관', '2025-03-16 10:00:00', '2025-03-16 16:00:00', '이지원', '02-2133-4573', '신청'),
('1738887170756', 2, '직원 워크숍', '인사과', '2025-03-20 09:00:00', '2025-03-20 17:00:00', '박민수', '02-2133-4571', '승인'),
('1738887170757', 8, '스마트 서울 전략 회의', '정보화담당관', '2025-03-22 14:00:00', '2025-03-22 16:00:00', '홍길동', '02-2133-4567', '승인');

-- 샘플 예약 장비 데이터
INSERT INTO reservation_equipment (reservation_id, equipment_id, quantity, notes) VALUES
('1738887170753', 1, 1, '연사 자료 프로젝션용'),
('1738887170753', 4, 2, '발표자와 사회자용'),
('1738887170754', 5, 1, '협업 작업을 위한 스마트보드 필요'),
('1738887170754', 7, 3, '참석자 작업용'),
('1738887170755', 1, 1, '발표 자료 표시'),
('1738887170755', 3, 1, '원격 참석자를 위한 화상회의'),
('1738887170756', 4, 4, '그룹 활동용'),
('1738887170756', 6, 1, '워크숍 음향 지원'),
('1738887170757', 5, 1, '회의 컨텐츠 작업용'),
('1738887170757', 3, 1, '원격 회의 연결용');

-- 샘플 보고서 데이터
INSERT INTO reports (reservation_id, meeting_room, usage_date, start_time, end_time, organizer, attendees, used_equipment, notes) VALUES
('1738887170753', '서소문청사 제1동(지상13층) 대회의실', '2025-03-14', '09:00:00', '12:00:00', '최은희', '경제진흥본부 직원 30명, 외부 참석자 10명', '빔프로젝터, 무선마이크 2개', '행사 진행 원활했으나 마이크 간헐적 잡음 발생'),
('1738887170754', '서소문청사 제1동(지상4층) 디지털공용회의실', '2025-03-15', '13:00:00', '15:00:00', '김철수', '정보화담당관 직원 8명', '스마트보드, 태블릿 3개', '스마트보드 터치 반응 속도 개선 필요'),
('1738887170756', '서소문청사 후생동(지상4층) 강당', '2025-03-20', '09:00:00', '17:00:00', '박민수', '인사과 직원 25명', '빔프로젝터, 무선마이크 4개, 음향믹서', '점심 시간 이후 에어컨 문제로 실내 온도 높았음');

-- 샘플 회의 노트 데이터
INSERT INTO meeting_notes (reservation_id, user_id, title, content, used_equipment, attachments) VALUES
('1738887170753', 3, '세계소비자의날 기념행사 결과', '소비자권익 증진을 위한 새로운 정책 방향 논의\n- 온라인 플랫폼 관련 소비자 보호 강화\n- 취약계층 소비자 지원 확대\n- 지역 소비자센터 활성화 방안', '빔프로젝터, 무선마이크', 'presentation.pdf, statistics.xlsx'),
('1738887170754', 2, '디지털 혁신 회의 내용', '스마트 워크 환경 구축을 위한 솔루션 검토\n- 클라우드 기반 협업 툴 도입 검토\n- 모바일 결재 시스템 고도화\n- AI 기반 민원 처리 시스템 시범 운영 계획', '스마트보드, 태블릿', 'digital_innovation_plan.docx'),
('1738887170756', 4, '직원 워크숍 결과보고', '팀빌딩 및 업무 혁신 아이디어 도출\n- 부서간 협업 강화를 위한 정기 미팅 제안\n- 업무 프로세스 개선 아이디어 15건 수렴\n- 직원 복지 개선 요청사항 정리', '빔프로젝터, 무선마이크, 음향시스템', 'workshop_photos.zip, ideas_list.xlsx');

-- 샘플 식당 메뉴 데이터
INSERT INTO restaurant_menus (menu_date, meal_type, menu_items, nutritional_info, calories, special_note) VALUES
('2023-09-25', 'lunch', '된장찌개, 제육볶음, 시금치나물, 김치, 흰쌀밥', '단백질 30g, 탄수화물 60g, 지방 15g', 650, '알러지 정보: 대두, 돼지고기'),
('2023-09-25', 'dinner', '미역국, 고등어구이, 애호박볶음, 깍두기, 흰쌀밥', '단백질 35g, 탄수화물 55g, 지방 20g', 620, '알러지 정보: 생선, 대두'),
('2023-09-26', 'lunch', '김치찌개, 소불고기, 콩나물무침, 총각김치, 흰쌀밥', '단백질 32g, 탄수화물 58g, 지방 18g', 680, '알러지 정보: 대두, 소고기'),
('2023-09-26', 'dinner', '북어국, 닭갈비, 깻잎찜, 배추김치, 흰쌀밥', '단백질 38g, 탄수화물 53g, 지방 15g', 640, '알러지 정보: 닭고기, 대두'),
('2023-09-27', 'lunch', '쌀국수, 팟타이, 월남쌈, 피클', '단백질 25g, 탄수화물 70g, 지방 12g', 590, '특별식: 아시안 데이 (알러지: 새우, 땅콩)');

-- 샘플 휴가 데이터
INSERT INTO vacations (user_id, start_date, end_date, type, status, reason, approver_id) VALUES
(2, '2023-10-02', '2023-10-04', 'annual', 'approved', '개인 휴식', 1),
(3, '2023-10-10', '2023-10-10', 'sick', 'approved', '병원 진료', 1),
(4, '2023-10-16', '2023-10-20', 'annual', 'pending', '가족 여행', NULL),
(5, '2023-09-28', '2023-09-29', 'annual', 'approved', '개인 사유', 1),
(6, '2023-10-23', '2023-10-23', 'special', 'approved', '개인 경조사', 1);

INSERT INTO restaurant_menu (id, date, menu) VALUES
(1, '2024-07-29', '클로렐라밥/쌀밥(현미밥/쌀밥)\n쇠고기버섯탕\n메란국물떡볶이\n김말이튀김\n우무묵오이초무침\n포기김치\n파인애플샐러드&요거트,오리엔탈드레싱|잡곡밥/쌀밥\n부대찌개\n통살새우가스&칠리소스\n아보카도샐러드&어니언크림소스\n햄버거빵\n깍두기'),
(2, '2024-07-30', '옥수수밥/쌀밥(현미밥/쌀밥)\n조개미역국\n돈사태김치찜\n토마토카프레제\n명엽채볶음\n열무김치\n딸기&요거트&시리얼|잡곡밥/쌀밥\n일본식쇠고기전골\n양배추계란찜\n그린빈맛살볶음\n도라지양파무침\n포기김치'),
(3, '2024-07-31', '가지노각비빔밥(보리밥/쌀밥)&소고기약고추장\n유부쑥갓국\n계란후라이\n핫도그&케찹\n브로콜리아몬드무침\n포기김치\n적근대샐러드&자몽,발사믹드레싱|*정시퇴근의 날*'),
(4, '2024-08-01', '강낭콩밥/쌀밥(현미밥/쌀밥)\n사골조랭이떡국\n자반고등어찜\n푸실리샐러드\n감자채볶음\n포기김치\n흑당밀크티|잡곡밥/쌀밥\n미니초계국수\n메밀전병\n두부쑥갓무침\n오복채\n포기김치'); 