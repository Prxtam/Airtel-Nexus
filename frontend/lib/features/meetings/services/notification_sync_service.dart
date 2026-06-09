import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/services/meeting_notification_service.dart';
import 'package:frontend/features/customers/providers/customer_provider.dart';
import 'package:frontend/features/meetings/providers/meeting_provider.dart';

final notificationSyncProvider = Provider<NotificationSyncService>((ref) {
  return NotificationSyncService(ref);
});

class NotificationSyncService {
  final Ref _ref;
  
  NotificationSyncService(this._ref) {
    _init();
  }

  void _init() {
    _ref.listen(meetingListProvider, (previous, next) {
      if (next.hasValue && next.value != null) {
        _syncMeetings(next.value!);
      }
    });
  }

  Future<void> _syncMeetings(List<dynamic> meetings) async {
    final notificationService = MeetingNotificationService();
    
    // We need customers to enrich the notification
    final customersAsync = _ref.read(customerListProvider);
    final customers = customersAsync.hasValue ? customersAsync.value : [];
    
    int scheduledCount = 0;
    
    for (final meeting in meetings) {
      // Find associated customer
      final customer = customers?.where((c) => c.id == meeting.customerId).firstOrNull;
      
      // The service internal logic handles skipping past meetings and duplicates
      await notificationService.scheduleMeetingReminder(meeting, customer);
      scheduledCount++;
    }
    
    log('Synchronized notifications for $scheduledCount upcoming meetings.');
  }
}
