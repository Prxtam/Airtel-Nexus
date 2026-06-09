import 'dart:developer';
import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:frontend/features/customers/models/customer.dart';
import 'package:frontend/features/meetings/models/meeting.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class MeetingNotificationService {
  static final MeetingNotificationService _instance = MeetingNotificationService._internal();
  factory MeetingNotificationService() => _instance;

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  MeetingNotificationService._internal();

  Future<void> initialize() async {
    if (_initialized) return;

    tz.initializeTimeZones();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
        
    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        log('Notification clicked: ${response.payload}');
      },
    );
    
    _initialized = true;
  }

  Future<void> requestPermissions() async {
    if (Platform.isIOS) {
      await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    } else if (Platform.isAndroid) {
      final androidImplementation = _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      await androidImplementation?.requestNotificationsPermission();
      await androidImplementation?.requestExactAlarmsPermission();
    }
  }

  /// Generates a stable integer ID for the meeting using its UUID.
  /// Parses the first 8 hex characters to ensure determinism across restarts.
  int _generateNotificationId(String meetingId) {
    final hexString = meetingId.replaceAll('-', '').substring(0, 8);
    // Parse as 32-bit int, modulo to ensure it fits in positive 32-bit int space for Android
    return int.parse(hexString, radix: 16) % 2147483647;
  }

  Future<void> scheduleMeetingReminder(Meeting meeting, Customer? customer) async {
    if (meeting.meetingAt.isBefore(DateTime.now())) {
      return; // Do not schedule for past meetings
    }

    final reminderTime = meeting.meetingAt.subtract(const Duration(minutes: 30));
    
    if (reminderTime.isBefore(DateTime.now())) {
      return; // Reminder time has already passed
    }

    final int notificationId = _generateNotificationId(meeting.id);

    // Cancel existing notification for this meeting just in case
    await _flutterLocalNotificationsPlugin.cancel(id: notificationId);

    final title = 'Meeting Reminder';
    final customerName = customer?.name ?? 'Unknown Customer';
    
    final localTime = meeting.meetingAt.toLocal();
    final timeString = '${localTime.hour > 12 ? localTime.hour - 12 : (localTime.hour == 0 ? 12 : localTime.hour)}:${localTime.minute.toString().padLeft(2, '0')} ${localTime.hour >= 12 ? 'PM' : 'AM'}';
    
    final meetingTitle = meeting.title ?? 'Meeting';
    final body = '$meetingTitle - $customerName\nStarts in 30 minutes at $timeString';

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id: notificationId,
      title: title,
      body: body,
      scheduledDate: tz.TZDateTime.from(reminderTime, tz.local),
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'meeting_reminders',
          'Meeting Reminders',
          channelDescription: 'Notifications for upcoming meetings',
          importance: Importance.max,
          priority: Priority.high,
          styleInformation: BigTextStyleInformation(''),
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
      payload: meeting.id,
    );
    
    log('Scheduled notification for meeting ${meeting.id} at $reminderTime');
  }

  Future<void> cancelMeetingReminder(String meetingId) async {
    final int notificationId = _generateNotificationId(meetingId);
    await _flutterLocalNotificationsPlugin.cancel(id: notificationId);
    log('Cancelled notification for meeting $meetingId');
  }
}
