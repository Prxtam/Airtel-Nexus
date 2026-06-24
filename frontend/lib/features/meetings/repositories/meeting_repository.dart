import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/storage/hive_service.dart';
import 'package:frontend/features/meetings/models/meeting.dart';
import 'package:uuid/uuid.dart';

final meetingRepositoryProvider = Provider<MeetingRepository>((ref) {
  return MeetingRepository();
});

class MeetingRepository {
  Future<List<Meeting>> listMeetings({String? customerId}) async {
    final box = HiveService.meetingsBox;
    var meetings = box.values.toList();
    final now = DateTime.now();

    // Auto-transition scheduled meetings that have passed their time
    for (int i = 0; i < meetings.length; i++) {
      var m = meetings[i];
      if (m.status == MeetingStatus.scheduled && m.meetingAt.isBefore(now)) {
        m = Meeting(
          id: m.id,
          customerId: m.customerId,
          createdByUserId: m.createdByUserId,
          title: m.title,
          meetingAt: m.meetingAt,
          createdAt: m.createdAt,
          updatedAt: m.updatedAt,
          status: MeetingStatus.awaitingConfirmation,
        );
        meetings[i] = m;
        await box.put(m.id, m);
      }
    }

    if (customerId != null) {
      meetings = meetings.where((m) => m.customerId == customerId).toList();
    }
    
    // Sort by meeting date ascending (closest upcoming first)
    meetings.sort((a, b) => a.meetingAt.compareTo(b.meetingAt));
    return meetings;
  }

  Future<Meeting> getMeeting(String id) async {
    final box = HiveService.meetingsBox;
    var meeting = box.get(id);
    if (meeting == null) {
      throw Exception('Meeting not found');
    }

    if (meeting.status == MeetingStatus.scheduled && meeting.meetingAt.isBefore(DateTime.now())) {
      meeting = Meeting(
        id: meeting.id,
        customerId: meeting.customerId,
        createdByUserId: meeting.createdByUserId,
        title: meeting.title,
        meetingAt: meeting.meetingAt,
        createdAt: meeting.createdAt,
        updatedAt: meeting.updatedAt,
        status: MeetingStatus.awaitingConfirmation,
      );
      await box.put(meeting.id, meeting);
    }

    return meeting;
  }

  Future<Meeting> createMeeting({
    required String customerId,
    String? title,
    required DateTime meetingAt,
  }) async {
    final box = HiveService.meetingsBox;
    final currentUser = HiveService.userBox.get('current_user');
    final now = DateTime.now();

    final newMeeting = Meeting(
      id: const Uuid().v4(),
      customerId: customerId,
      createdByUserId: currentUser?.id ?? 'unknown_user',
      title: title,
      meetingAt: meetingAt,
      createdAt: now,
      updatedAt: now,
    );

    await box.put(newMeeting.id, newMeeting);
    return newMeeting;
  }

  Future<Meeting> updateMeeting(
    String id, {
    String? title,
    DateTime? meetingAt,
    MeetingStatus? status,
  }) async {
    final box = HiveService.meetingsBox;
    final existing = box.get(id);
    
    if (existing == null) {
      throw Exception('Meeting not found');
    }

    final updated = Meeting(
      id: existing.id,
      customerId: existing.customerId,
      createdByUserId: existing.createdByUserId,
      title: title ?? existing.title,
      meetingAt: meetingAt ?? existing.meetingAt,
      createdAt: existing.createdAt,
      updatedAt: DateTime.now(),
      status: status ?? existing.status,
    );

    await box.put(updated.id, updated);
    return updated;
  }

  Future<void> deleteMeeting(String id) async {
    final box = HiveService.meetingsBox;
    await box.delete(id);
  }
}
