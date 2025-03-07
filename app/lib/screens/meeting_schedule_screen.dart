import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/meeting_schedule.dart';
import '../services/meeting_schedule_service.dart';
import '../utils/constants.dart';
import '../utils/carbon_colors.dart';

class MeetingScheduleScreen extends StatefulWidget {
  const MeetingScheduleScreen({Key? key}) : super(key: key);

  @override
  _MeetingScheduleScreenState createState() => _MeetingScheduleScreenState();
}

class _MeetingScheduleScreenState extends State<MeetingScheduleScreen> {
  final MeetingScheduleService _service = MeetingScheduleService();
  List<MeetingSchedule> _schedules = [];
  bool _isLoading = true;
  String? _error;
  DateTime _selectedDate = DateTime.now();
  String? _selectedStatus;
  String? _selectedRoom;

  @override
  void initState() {
    super.initState();
    _loadSchedules();
  }

  Future<void> _loadSchedules() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final schedules = await _service.getMeetingSchedules(
        startDate: DateFormat('yyyy-MM-dd').format(_selectedDate),
        status: _selectedStatus,
        roomId: _selectedRoom != null ? int.tryParse(_selectedRoom!) : null,
      );
      
      setState(() {
        _schedules = schedules;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      _loadSchedules();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('회의실 예약 현황'),
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: _selectDate,
            tooltip: '날짜 선택',
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadSchedules,
            tooltip: '새로고침',
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilters(),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: Card(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today, size: 16),
                    SizedBox(width: 8),
                    Text(
                      '${DateFormat('yyyy년 MM월 dd일').format(_selectedDate)} (${DateFormat('E', 'ko_KR').format(_selectedDate)})',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: 8),
          _buildStatusDropdown(),
        ],
      ),
    );
  }

  Widget _buildStatusDropdown() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedStatus,
          hint: Text('상태 필터'),
          icon: Icon(Icons.arrow_drop_down),
          onChanged: (String? newValue) {
            setState(() {
              _selectedStatus = newValue;
            });
            _loadSchedules();
          },
          items: <String>['승인', '취소', '대기']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('오류가 발생했습니다: $_error'),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadSchedules,
              child: Text('다시 시도'),
            ),
          ],
        ),
      );
    }

    if (_schedules.isEmpty) {
      return Center(child: Text('예약된 회의가 없습니다.'));
    }

    return ListView.builder(
      itemCount: _schedules.length,
      itemBuilder: (context, index) {
        final schedule = _schedules[index];
        return _buildScheduleCard(schedule);
      },
    );
  }

  Widget _buildScheduleCard(MeetingSchedule schedule) {
    Color statusColor;
    switch (schedule.status) {
      case '승인':
        statusColor = CarbonColors.green50;
        break;
      case '취소':
        statusColor = CarbonColors.red50;
        break;
      case '대기':
        statusColor = CarbonColors.yellow40;
        break;
      default:
        statusColor = CarbonColors.gray20;
    }

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: InkWell(
        onTap: () => _showDetailDialog(schedule),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      schedule.meetingTitle,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      schedule.status,
                      style: TextStyle(
                        color: Colors.white, 
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                '📍 ${schedule.location}',
                style: TextStyle(color: Colors.grey[700]),
              ),
              SizedBox(height: 4),
              Text(
                '🕒 ${schedule.dateTimeDisplay}',
                style: TextStyle(color: Colors.grey[700]),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.account_circle, size: 16, color: Colors.grey[600]),
                  SizedBox(width: 4),
                  Text(
                    '${schedule.department}',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ],
              ),
              SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.person, size: 16, color: Colors.grey[600]),
                  SizedBox(width: 4),
                  Text(
                    '${schedule.contactInfo}',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDetailDialog(MeetingSchedule schedule) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('회의 상세 정보'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('제목: ${schedule.meetingTitle}'),
              SizedBox(height: 8),
              Text('장소: ${schedule.location}'),
              SizedBox(height: 8),
              Text('일시: ${schedule.dateTimeDisplay}'),
              SizedBox(height: 8),
              Text('부서: ${schedule.department}'),
              SizedBox(height: 8),
              Text('연락처: ${schedule.contactInfo}'),
              SizedBox(height: 8),
              Text('상태: ${schedule.status}'),
              SizedBox(height: 8),
              Text('ID: ${schedule.id}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('닫기'),
          ),
        ],
      ),
    );
  }
} 