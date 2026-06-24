import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/meetings/models/meeting.dart';
import 'package:frontend/features/meetings/repositories/meeting_repository.dart';

// ---------------------------------------------------------------------------
// Meeting List Provider
// ---------------------------------------------------------------------------

class MeetingListNotifier extends StateNotifier<AsyncValue<List<Meeting>>> {
  final MeetingRepository _repository;

  MeetingListNotifier(this._repository) : super(const AsyncValue.loading()) {
    load();
  }

  Future<void> load() async {
    state = const AsyncValue.loading();
    try {
      final meetings = await _repository.listMeetings();
      state = AsyncValue.data(meetings);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> refresh() => load();

  Future<void> createMeeting({
    required String customerId,
    String? title,
    required DateTime meetingAt,
  }) async {
    await _repository.createMeeting(
      customerId: customerId,
      title: title,
      meetingAt: meetingAt,
    );
    await load();
  }

  Future<void> deleteMeeting(String id) async {
    await _repository.deleteMeeting(id);
    await load();
  }
}

final meetingListProvider =
    StateNotifierProvider<MeetingListNotifier, AsyncValue<List<Meeting>>>(
  (ref) {
    final repository = ref.watch(meetingRepositoryProvider);
    return MeetingListNotifier(repository);
  },
);

// ---------------------------------------------------------------------------
// Meeting Detail Provider (family — keyed by meeting ID)
// ---------------------------------------------------------------------------

class MeetingDetailNotifier extends StateNotifier<AsyncValue<Meeting>> {
  final MeetingRepository _repository;
  final String meetingId;

  MeetingDetailNotifier(this._repository, this.meetingId)
      : super(const AsyncValue.loading()) {
    load();
  }

  Future<void> load() async {
    state = const AsyncValue.loading();
    try {
      final meeting = await _repository.getMeeting(meetingId);
      state = AsyncValue.data(meeting);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> update({String? title, DateTime? meetingAt, MeetingStatus? status}) async {
    try {
      final updated = await _repository.updateMeeting(
        meetingId,
        title: title,
        meetingAt: meetingAt,
        status: status,
      );
      state = AsyncValue.data(updated);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final meetingDetailProvider = StateNotifierProvider.family<
    MeetingDetailNotifier, AsyncValue<Meeting>, String>(
  (ref, meetingId) {
    final repository = ref.watch(meetingRepositoryProvider);
    return MeetingDetailNotifier(repository, meetingId);
  },
);
