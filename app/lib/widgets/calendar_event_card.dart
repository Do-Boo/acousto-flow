import 'package:flutter/material.dart';
import '../models/calendar_event.dart';
import '../utils/carbon_colors.dart';
import 'package:intl/intl.dart';

class CalendarEventCard extends StatelessWidget {
  final CalendarEvent event;

  const CalendarEventCard({
    Key? key,
    required this.event,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 이벤트 유형별 아이콘 설정
    IconData eventIcon;
    switch (event.eventType) {
      case 'meeting':
        eventIcon = Icons.meeting_room;
        break;
      case 'vacation':
        eventIcon = Icons.beach_access;
        break;
      case 'equipment':
        eventIcon = Icons.build;
        break;
      case 'construction':
        eventIcon = Icons.construction;
        break;
      default:
        eventIcon = Icons.event;
    }

    // 시간 포맷
    final timeFormat = DateFormat('HH:mm');
    final dateFormat = DateFormat('yyyy-MM-dd');
    
    String timeText;
    if (event.isAllDay) {
      if (event.startTime.day == event.endTime.day &&
          event.startTime.month == event.endTime.month &&
          event.startTime.year == event.endTime.year) {
        timeText = '종일';
      } else {
        timeText = '${dateFormat.format(event.startTime)} ~ ${dateFormat.format(event.endTime)}';
      }
    } else {
      if (event.startTime.day == event.endTime.day &&
          event.startTime.month == event.endTime.month &&
          event.startTime.year == event.endTime.year) {
        timeText = '${timeFormat.format(event.startTime)} ~ ${timeFormat.format(event.endTime)}';
      } else {
        timeText = '${dateFormat.format(event.startTime)} ${timeFormat.format(event.startTime)} ~ '
                 '${dateFormat.format(event.endTime)} ${timeFormat.format(event.endTime)}';
      }
    }

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: event.eventColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showEventDetails(context),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: event.eventColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      eventIcon,
                      color: event.eventColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          timeText,
                          style: TextStyle(
                            color: CarbonColors.gray60,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (event.description.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  event.description,
                  style: const TextStyle(fontSize: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              if (event.location != null && event.location!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 16,
                      color: CarbonColors.gray60,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        event.location!,
                        style: const TextStyle(
                          fontSize: 14,
                          color: CarbonColors.gray60,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showEventDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(event.title),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDetailItem('유형', _getEventTypeText()),
                _buildDetailItem('시간', _getFormattedTime()),
                if (event.location != null && event.location!.isNotEmpty)
                  _buildDetailItem('장소', event.location!),
                _buildDetailItem('기간', event.formattedDuration),
                if (event.description.isNotEmpty)
                  _buildDetailItem('설명', event.description),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('닫기'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: CarbonColors.gray60,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  String _getEventTypeText() {
    switch (event.eventType) {
      case 'meeting':
        return '회의';
      case 'vacation':
        return '휴가';
      case 'equipment':
        return '장비 관리';
      case 'construction':
        return '공사';
      default:
        return '기타';
    }
  }

  String _getFormattedTime() {
    final dateFormat = DateFormat('yyyy년 MM월 dd일');
    final timeFormat = DateFormat('HH:mm');
    
    if (event.isAllDay) {
      if (event.startTime.day == event.endTime.day &&
          event.startTime.month == event.endTime.month &&
          event.startTime.year == event.endTime.year) {
        return '${dateFormat.format(event.startTime)} (종일)';
      } else {
        return '${dateFormat.format(event.startTime)} ~ ${dateFormat.format(event.endTime)} (종일)';
      }
    } else {
      if (event.startTime.day == event.endTime.day &&
          event.startTime.month == event.endTime.month &&
          event.startTime.year == event.endTime.year) {
        return '${dateFormat.format(event.startTime)} ${timeFormat.format(event.startTime)} ~ ${timeFormat.format(event.endTime)}';
      } else {
        return '${dateFormat.format(event.startTime)} ${timeFormat.format(event.startTime)} ~ '
               '${dateFormat.format(event.endTime)} ${timeFormat.format(event.endTime)}';
      }
    }
  }
} 