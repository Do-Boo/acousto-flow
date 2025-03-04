import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:intl/intl.dart';
import '../utils/carbon_colors.dart';

class MeetingRoomsScreen extends StatefulWidget {
  @override
  _MeetingRoomsScreenState createState() => _MeetingRoomsScreenState();
}

class _MeetingRoomsScreenState extends State<MeetingRoomsScreen> {
  // Mock data for meeting rooms
  final List<MeetingRoom> _rooms = [];
  String _searchQuery = '';
  String _selectedBuilding = '전체';
  final List<String> _buildings = ['전체', 'A동', 'B동', 'C동', 'D동'];
  
  // API 호출 상태 (실제 앱에서는 API 응답에 따라 처리)
  bool _isLoading = false;
  
  @override
  void initState() {
    super.initState();
    
    // Generate sample meeting rooms
    _generateSampleRooms();
  }
  
  void _generateSampleRooms() {
    // A동 회의실
    _rooms.add(
      MeetingRoom(
        id: '1',
        name: '대회의실',
        building: 'A동',
        capacity: 30,
        floor: 2,
        roomNumber: 'A201',
        equipment: [
          Equipment(
            id: '1',
            name: '무선 마이크',
            type: EquipmentType.audio,
            status: EquipmentStatus.available,
            lastChecked: DateTime.now().subtract(const Duration(days: 2)),
          ),
          Equipment(
            id: '2',
            name: '빔프로젝터',
            type: EquipmentType.visual,
            status: EquipmentStatus.available,
            lastChecked: DateTime.now().subtract(const Duration(days: 3)),
          ),
          Equipment(
            id: '3',
            name: '화상회의 시스템',
            type: EquipmentType.conferencing,
            status: EquipmentStatus.available,
            lastChecked: DateTime.now().subtract(const Duration(days: 1)),
          ),
        ],
        status: RoomStatus.available,
        currentReservation: null,
        nextReservation: Reservation(
          id: '1',
          title: '경영진 회의',
          startTime: DateTime.now().add(const Duration(hours: 3)),
          endTime: DateTime.now().add(const Duration(hours: 5)),
          requesterName: '김상무',
          requesterDepartment: '경영지원팀',
          requesterContactNumber: '010-1234-5678',
          equipment: ['무선 마이크 2개', '화상회의 시스템'],
          supportRequested: true,
        ),
      ),
    );
    
    // B동 회의실
    _rooms.add(
      MeetingRoom(
        id: '2',
        name: '세미나실',
        building: 'B동',
        capacity: 20,
        floor: 3,
        roomNumber: 'B302',
        equipment: [
          Equipment(
            id: '4',
            name: '유선 마이크',
            type: EquipmentType.audio,
            status: EquipmentStatus.needsMaintenance,
            lastChecked: DateTime.now().subtract(const Duration(days: 10)),
          ),
          Equipment(
            id: '5',
            name: '빔프로젝터',
            type: EquipmentType.visual,
            status: EquipmentStatus.available,
            lastChecked: DateTime.now().subtract(const Duration(days: 5)),
          ),
        ],
        status: RoomStatus.occupied,
        currentReservation: Reservation(
          id: '2',
          title: '신입사원 교육',
          startTime: DateTime.now().subtract(const Duration(hours: 1)),
          endTime: DateTime.now().add(const Duration(hours: 2)),
          requesterName: '이과장',
          requesterDepartment: '인사팀',
          requesterContactNumber: '010-2345-6789',
          equipment: ['빔프로젝터'],
          supportRequested: false,
        ),
        nextReservation: null,
      ),
    );
    
    // C동 회의실
    for (int i = 1; i <= 5; i++) {
      _rooms.add(
        MeetingRoom(
          id: '${i+2}',
          name: '회의실 $i',
          building: 'C동',
          capacity: 8,
          floor: 4,
          roomNumber: 'C40$i',
          equipment: [
            Equipment(
              id: '${5+i}',
              name: 'TV 모니터',
              type: EquipmentType.visual,
              status: EquipmentStatus.available,
              lastChecked: DateTime.now().subtract(Duration(days: i)),
            ),
          ],
          status: i % 3 == 0 ? RoomStatus.occupied : RoomStatus.available,
          currentReservation: i % 3 == 0 ? Reservation(
            id: '${i+2}',
            title: '팀 회의',
            startTime: DateTime.now().subtract(const Duration(minutes: 30)),
            endTime: DateTime.now().add(const Duration(minutes: 30)),
            requesterName: '박부장',
            requesterDepartment: '개발팀',
            requesterContactNumber: '010-3456-7890',
            equipment: [],
            supportRequested: false,
          ) : null,
          nextReservation: i % 2 == 0 ? Reservation(
            id: '${i+7}',
            title: '협력사 미팅',
            startTime: DateTime.now().add(Duration(hours: i)),
            endTime: DateTime.now().add(Duration(hours: i+1)),
            requesterName: '최대리',
            requesterDepartment: '영업팀',
            requesterContactNumber: '010-4567-8901',
            equipment: [],
            supportRequested: false,
          ) : null,
        ),
      );
    }
  }
  
  List<MeetingRoom> get _filteredRooms {
    return _rooms.where((room) {
      final matchesSearch = _searchQuery.isEmpty || 
          room.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          room.roomNumber.toLowerCase().contains(_searchQuery.toLowerCase());
      
      final matchesBuilding = _selectedBuilding == '전체' ||
          room.building == _selectedBuilding;
          
      return matchesSearch && matchesBuilding;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? CarbonColors.gray100 : Colors.white;
    final textColor = isDarkMode ? Colors.white : CarbonColors.gray100;
    final dividerColor = isDarkMode ? CarbonColors.gray80 : CarbonColors.gray20;
    
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: isDarkMode
          ? SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.transparent)
          : SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent),
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          title: Text(
            '회의실',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: textColor,
              fontSize: 16,
            ),
          ),
          backgroundColor: backgroundColor,
          elevation: 0,
          systemOverlayStyle: isDarkMode
              ? SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.transparent)
              : SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Divider(
              height: 1,
              color: dividerColor,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.qr_code_scanner, color: isDarkMode ? Colors.white : CarbonColors.gray80),
              onPressed: () {
                // Open QR code scanner
                _showQRScanner();
              },
            ),
            IconButton(
              icon: Icon(HugeIcons.strokeRoundedFilterHorizontal, color: isDarkMode ? Colors.white : CarbonColors.gray80),
              onPressed: () {
                // Show filter options
                _showFilterOptions();
              },
            ),
          ],
        ),
        body: Column(
          children: [
            // Search and filter bar
            _buildSearchBar(),
            
            // Room list
            Expanded(
              child: _filteredRooms.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      itemCount: _filteredRooms.length,
                      itemBuilder: (context, index) {
                        final room = _filteredRooms[index];
                        return _buildRoomCard(room);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? CarbonColors.gray100 : Colors.white;
    final textColor = isDarkMode ? Colors.white : CarbonColors.gray100;
    final borderColor = isDarkMode ? CarbonColors.gray80 : CarbonColors.gray20;
    final inputBackgroundColor = isDarkMode ? CarbonColors.gray100 : CarbonColors.gray10;
    
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            style: TextStyle(color: textColor),
            decoration: InputDecoration(
              hintText: '회의실 검색',
              hintStyle: TextStyle(color: CarbonColors.gray60),
              prefixIcon: Icon(Icons.search, color: CarbonColors.gray60),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(color: borderColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(color: borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(color: CarbonColors.blue60),
              ),
              filled: true,
              fillColor: inputBackgroundColor,
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _buildings.length,
              itemBuilder: (context, index) {
                final building = _buildings[index];
                final isSelected = building == _selectedBuilding;
                
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(building),
                    selected: isSelected,
                    selectedColor: CarbonColors.blue60.withOpacity(0.1),
                    labelStyle: TextStyle(
                      color: isSelected ? CarbonColors.blue60 : textColor,
                      fontSize: 12,
                    ),
                    backgroundColor: inputBackgroundColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: isSelected ? CarbonColors.blue60 : borderColor,
                      ),
                    ),
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedBuilding = building;
                        });
                      }
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : CarbonColors.gray100;
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.meeting_room_outlined,
            size: 64,
            color: CarbonColors.gray60,
          ),
          const SizedBox(height: 16),
          Text(
            '회의실을 찾을 수 없습니다',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '검색 조건을 변경해보세요',
            style: TextStyle(
              fontSize: 14,
              color: CarbonColors.gray60,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoomCard(MeetingRoom room) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : CarbonColors.gray100;
    final borderColor = isDarkMode ? CarbonColors.gray80 : CarbonColors.gray20;
    final cardColor = isDarkMode ? CarbonColors.gray100 : Colors.white;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: borderColor),
      ),
      child: InkWell(
        onTap: () {
          // Show meeting room details
          _showRoomDetails(room);
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Room name and status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '${room.building} ${room.name}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                  ),
                  _buildStatusBadge(room.status),
                ],
              ),
              const SizedBox(height: 8),
              // Room info
              Row(
                children: [
                  Icon(Icons.meeting_room, size: 16, color: CarbonColors.gray60),
                  const SizedBox(width: 4),
                  Text(
                    room.roomNumber,
                    style: TextStyle(
                      fontSize: 14,
                      color: CarbonColors.gray60,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(Icons.people, size: 16, color: CarbonColors.gray60),
                  const SizedBox(width: 4),
                  Text(
                    '${room.capacity}명',
                    style: TextStyle(
                      fontSize: 14,
                      color: CarbonColors.gray60,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(Icons.devices, size: 16, color: CarbonColors.gray60),
                  const SizedBox(width: 4),
                  Text(
                    '장비 ${room.equipment.length}개',
                    style: TextStyle(
                      fontSize: 14,
                      color: CarbonColors.gray60,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Current or next reservation
              if (room.currentReservation != null)
                _buildReservationInfo(
                  '현재 예약',
                  room.currentReservation!,
                  CarbonColors.red60.withOpacity(0.1),
                  CarbonColors.red60,
                )
              else if (room.nextReservation != null)
                _buildReservationInfo(
                  '다음 예약',
                  room.nextReservation!,
                  CarbonColors.blue60.withOpacity(0.1),
                  CarbonColors.blue60,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(RoomStatus status) {
    Color color;
    String text;
    
    switch (status) {
      case RoomStatus.available:
        color = CarbonColors.green50;
        text = '이용 가능';
        break;
      case RoomStatus.occupied:
        color = CarbonColors.red60;
        text = '사용 중';
        break;
      case RoomStatus.maintenance:
        color = CarbonColors.yellow30;
        text = '점검 중';
        break;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildReservationInfo(
    String label,
    Reservation reservation,
    Color backgroundColor,
    Color textColor,
  ) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final contentTextColor = isDarkMode ? Colors.white : CarbonColors.gray100;
    final secondaryTextColor = CarbonColors.gray60;
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
              if (reservation.supportRequested)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: isDarkMode ? CarbonColors.gray90 : Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: textColor),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.support_agent,
                        size: 12,
                        color: textColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '지원 요청',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            reservation.title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: contentTextColor,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.access_time, size: 14, color: secondaryTextColor),
              const SizedBox(width: 4),
              Text(
                '${DateFormat('HH:mm').format(reservation.startTime)} - ${DateFormat('HH:mm').format(reservation.endTime)}',
                style: TextStyle(
                  fontSize: 12,
                  color: secondaryTextColor,
                ),
              ),
              const SizedBox(width: 16),
              Icon(Icons.person, size: 14, color: secondaryTextColor),
              const SizedBox(width: 4),
              Text(
                '${reservation.requesterName} (${reservation.requesterDepartment})',
                style: TextStyle(
                  fontSize: 12,
                  color: secondaryTextColor,
                ),
              ),
            ],
          ),
          if (reservation.equipment.isNotEmpty) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.devices, size: 14, color: secondaryTextColor),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    reservation.equipment.join(', '),
                    style: TextStyle(
                      fontSize: 12,
                      color: secondaryTextColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  void _showRoomDetails(MeetingRoom room) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? CarbonColors.gray100 : Colors.white;
    final textColor = isDarkMode ? Colors.white : CarbonColors.gray100;
    final dividerColor = isDarkMode ? CarbonColors.gray80 : CarbonColors.gray20;
    final cardColor = isDarkMode ? CarbonColors.gray90 : CarbonColors.gray10;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.8,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Room title and QR code
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${room.building} ${room.name}',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: textColor,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  _buildStatusBadge(room.status),
                                  const SizedBox(width: 8),
                                  Text(
                                    room.roomNumber,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: CarbonColors.gray60,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // QR Code for the room
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: dividerColor),
                          ),
                          child: Center(
                            child: QrImageView(
                              data: 'room:${room.id}',
                              version: QrVersions.auto,
                              size: 80,
                              foregroundColor: textColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    
                    // Room details
                    Text(
                      '회의실 정보',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildDetailItem(
                      Icons.location_on,
                      '위치',
                      '${room.building} ${room.floor}층',
                    ),
                    _buildDetailItem(
                      Icons.people,
                      '수용 인원',
                      '${room.capacity}명',
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Equipment
                    Text(
                      '장비 정보',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Column(
                      children: room.equipment.map((equipment) {
                        return _buildEquipmentItem(equipment);
                      }).toList(),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Reservations
                    Text(
                      '예약 현황',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (room.currentReservation != null) ...[
                      _buildReservationInfo(
                        '현재 예약',
                        room.currentReservation!,
                        CarbonColors.red60.withOpacity(0.1),
                        CarbonColors.red60,
                      ),
                      const SizedBox(height: 16),
                    ],
                    if (room.nextReservation != null) ...[
                      _buildReservationInfo(
                        '다음 예약',
                        room.nextReservation!,
                        CarbonColors.blue60.withOpacity(0.1),
                        CarbonColors.blue60,
                      ),
                      const SizedBox(height: 16),
                    ],
                    if (room.currentReservation == null && room.nextReservation == null)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Center(
                          child: Text(
                            '예약된 회의가 없습니다',
                            style: TextStyle(
                              color: CarbonColors.gray60,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      
                    const SizedBox(height: 32),
                    
                    // Action buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              // Show equipment checklist
                            },
                            icon: const Icon(Icons.checklist),
                            label: const Text('장비 점검'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: CarbonColors.blue60,
                              side: BorderSide(color: CarbonColors.blue60),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              // Process reservation
                            },
                            icon: const Icon(Icons.event_available, color: Colors.white),
                            label: const Text('일정 확인'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: CarbonColors.blue60,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : CarbonColors.gray100;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: CarbonColors.gray60),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: CarbonColors.gray60,
                  fontSize: 12,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  color: textColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEquipmentItem(Equipment equipment) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : CarbonColors.gray100;
    final cardColor = isDarkMode ? CarbonColors.gray90 : CarbonColors.gray10;
    
    Color statusColor;
    IconData statusIcon;
    
    switch (equipment.status) {
      case EquipmentStatus.available:
        statusColor = CarbonColors.green50;
        statusIcon = Icons.check_circle;
        break;
      case EquipmentStatus.needsMaintenance:
        statusColor = CarbonColors.yellow30;
        statusIcon = Icons.warning;
        break;
      case EquipmentStatus.unavailable:
        statusColor = CarbonColors.red60;
        statusIcon = Icons.error;
        break;
    }
    
    IconData typeIcon;
    
    switch (equipment.type) {
      case EquipmentType.audio:
        typeIcon = Icons.mic;
        break;
      case EquipmentType.visual:
        typeIcon = Icons.videocam;
        break;
      case EquipmentType.conferencing:
        typeIcon = Icons.video_call;
        break;
      case EquipmentType.other:
        typeIcon = Icons.devices_other;
        break;
    }
    
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDarkMode ? CarbonColors.gray80 : Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: isDarkMode ? CarbonColors.gray70 : CarbonColors.gray20),
            ),
            child: Icon(typeIcon, color: CarbonColors.gray60, size: 16),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  equipment.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: textColor,
                  ),
                ),
                Text(
                  '마지막 점검: ${DateFormat('yyyy-MM-dd').format(equipment.lastChecked)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: CarbonColors.gray60,
                  ),
                ),
              ],
            ),
          ),
          Icon(statusIcon, color: statusColor, size: 20),
        ],
      ),
    );
  }

  void _showQRScanner() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? CarbonColors.gray90 : Colors.white;
    final textColor = isDarkMode ? Colors.white : CarbonColors.gray100;
    
    // In a real app, show a QR code scanner
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          title: Text(
            'QR 코드 스캔',
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          content: Text(
            '이 기능은 실제 앱에서 QR 코드 스캐너를 열어 회의실에 빠르게 접근할 수 있게 합니다.',
            style: TextStyle(
              color: textColor,
              fontSize: 14,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                '확인',
                style: TextStyle(
                  color: CarbonColors.blue60,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showFilterOptions() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? CarbonColors.gray100 : Colors.white;
    final textColor = isDarkMode ? Colors.white : CarbonColors.gray100;
    final dividerColor = isDarkMode ? CarbonColors.gray80 : CarbonColors.gray20;
    final inputBackgroundColor = isDarkMode ? CarbonColors.gray90 : CarbonColors.gray10;
    
    showModalBottomSheet(
      context: context,
      backgroundColor: backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Text(
                      '필터',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        '적용',
                        style: TextStyle(
                          color: CarbonColors.blue60,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(height: 0, color: dividerColor),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          '건물',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                        ),
                      ),
                      Wrap(
                        spacing: 8,
                        children: _buildings.map((building) {
                          final isSelected = _selectedBuilding == building;
                          return Padding(
                            padding: const EdgeInsets.only(left: 16, bottom: 8),
                            child: ChoiceChip(
                              label: Text(building),
                              selected: isSelected,
                              selectedColor: CarbonColors.blue60.withOpacity(0.1),
                              labelStyle: TextStyle(
                                color: isSelected ? CarbonColors.blue60 : textColor,
                                fontSize: 12,
                              ),
                              backgroundColor: inputBackgroundColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                                side: BorderSide(
                                  color: isSelected ? CarbonColors.blue60 : dividerColor,
                                ),
                              ),
                              onSelected: (selected) {
                                if (selected) {
                                  setState(() {
                                    _selectedBuilding = building;
                                  });
                                  Navigator.pop(context);
                                }
                              },
                            ),
                          );
                        }).toList(),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          '상태',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16, bottom: 16),
                        child: Wrap(
                          spacing: 8,
                          children: [
                            _buildFilterChip('전체', true),
                            _buildFilterChip('이용 가능', false),
                            _buildFilterChip('사용 중', false),
                            _buildFilterChip('점검 중', false),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          '수용 인원',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16, bottom: 16),
                        child: Wrap(
                          spacing: 8,
                          children: [
                            _buildFilterChip('전체', true),
                            _buildFilterChip('~8명', false),
                            _buildFilterChip('8~20명', false),
                            _buildFilterChip('20명~', false),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : CarbonColors.gray100;
    final dividerColor = isDarkMode ? CarbonColors.gray80 : CarbonColors.gray20;
    final inputBackgroundColor = isDarkMode ? CarbonColors.gray100 : CarbonColors.gray10;
    
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: CarbonColors.blue60.withOpacity(0.1),
      labelStyle: TextStyle(
        color: isSelected ? CarbonColors.blue60 : textColor,
        fontSize: 12,
      ),
      backgroundColor: inputBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isSelected ? CarbonColors.blue60 : dividerColor,
        ),
      ),
      onSelected: (selected) {
        if (selected) {
          Navigator.pop(context);
        }
      },
    );
  }

  // 내보내기 다이얼로그 다시 추가
  void _showExportDialog() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? CarbonColors.gray90 : Colors.white;
    final textColor = isDarkMode ? Colors.white : CarbonColors.gray100;
    final dividerColor = isDarkMode ? CarbonColors.gray80 : CarbonColors.gray20;
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          title: Text(
            '데이터 내보내기',
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '회의실 데이터를 내보낼 형식을 선택하세요:',
                style: TextStyle(
                  color: textColor,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 16),
              _buildExportOption(
                Icons.table_chart,
                'Excel (.xlsx)',
                () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    _buildCarbonSnackBar('Excel 파일로 내보내기가 시작되었습니다.'),
                  );
                },
              ),
              Divider(height: 1, color: dividerColor),
              _buildExportOption(
                Icons.article,
                'CSV (.csv)',
                () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    _buildCarbonSnackBar('CSV 파일로 내보내기가 시작되었습니다.'),
                  );
                },
              ),
              Divider(height: 1, color: dividerColor),
              _buildExportOption(
                Icons.picture_as_pdf,
                'PDF (.pdf)',
                () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    _buildCarbonSnackBar('PDF 파일로 내보내기가 시작되었습니다.'),
                  );
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                '취소',
                style: TextStyle(
                  color: CarbonColors.blue60,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildExportOption(IconData icon, String text, VoidCallback onTap) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : CarbonColors.gray100;
    
    return ListTile(
      leading: Icon(icon, color: CarbonColors.gray60),
      title: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 14,
        ),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      dense: true,
    );
  }

  SnackBar _buildCarbonSnackBar(String message) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? CarbonColors.gray90 : CarbonColors.gray10;
    final textColor = isDarkMode ? Colors.white : CarbonColors.gray100;
    
    return SnackBar(
      content: Text(
        message,
        style: TextStyle(
          color: textColor,
          fontSize: 14,
        ),
      ),
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      action: SnackBarAction(
        label: '확인',
        textColor: CarbonColors.blue60,
        onPressed: () {},
      ),
    );
  }
}

enum RoomStatus {
  available,
  occupied,
  maintenance,
}

enum EquipmentType {
  audio,
  visual,
  conferencing,
  other,
}

enum EquipmentStatus {
  available,
  needsMaintenance,
  unavailable,
}

class MeetingRoom {
  final String id;
  final String name;
  final String building;
  final int capacity;
  final int floor;
  final String roomNumber;
  final List<Equipment> equipment;
  final RoomStatus status;
  final Reservation? currentReservation;
  final Reservation? nextReservation;
  
  const MeetingRoom({
    required this.id,
    required this.name,
    required this.building,
    required this.capacity,
    required this.floor,
    required this.roomNumber,
    required this.equipment,
    required this.status,
    this.currentReservation,
    this.nextReservation,
  });
}

class Equipment {
  final String id;
  final String name;
  final EquipmentType type;
  final EquipmentStatus status;
  final DateTime lastChecked;
  
  const Equipment({
    required this.id,
    required this.name,
    required this.type,
    required this.status,
    required this.lastChecked,
  });
}

class Reservation {
  final String id;
  final String title;
  final DateTime startTime;
  final DateTime endTime;
  final String requesterName;
  final String requesterDepartment;
  final String requesterContactNumber;
  final List<String> equipment;
  final bool supportRequested;
  
  const Reservation({
    required this.id,
    required this.title,
    required this.startTime,
    required this.endTime,
    required this.requesterName,
    required this.requesterDepartment,
    required this.requesterContactNumber,
    required this.equipment,
    required this.supportRequested,
  });
} 