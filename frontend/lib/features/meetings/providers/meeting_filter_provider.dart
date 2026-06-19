import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/meetings/models/meeting.dart';
import 'package:frontend/features/meetings/providers/meeting_provider.dart';

enum MeetingTimeFilter { all, upcoming, past }

// Search state
final meetingSearchProvider = StateProvider.autoDispose<String>((ref) => '');

// Time filter state
final meetingTimeFilterProvider =
    StateProvider.autoDispose<MeetingTimeFilter>(
        (ref) => MeetingTimeFilter.all);

// Customer filter state
final meetingCustomerFilterProvider =
    StateProvider.autoDispose<String?>((ref) => null);

// Team filter removed as app is now offline-first for individual AM.

// Derived filtered list
final filteredMeetingListProvider =
    Provider.autoDispose<AsyncValue<List<Meeting>>>((ref) {
  final rawAsync = ref.watch(meetingListProvider);
  final search = ref.watch(meetingSearchProvider);
  final timeFilter = ref.watch(meetingTimeFilterProvider);
  final customerId = ref.watch(meetingCustomerFilterProvider);
  return rawAsync.whenData((list) {
    var result = list;

    // 1. Filter by customer
    if (customerId != null) {
      result = result.where((m) => m.customerId == customerId).toList();
    }

    // 2. Filter by time
    if (timeFilter != MeetingTimeFilter.all) {
      final now = DateTime.now();
      result = result.where((m) {
        if (timeFilter == MeetingTimeFilter.upcoming) {
          return m.meetingAt.isAfter(now);
        } else {
          return m.meetingAt.isBefore(now);
        }
      }).toList();
    }

    // 3. Filter by search query
    if (search.isNotEmpty) {
      result = result.where((m) {
        return (m.title ?? '').toLowerCase().contains(search.toLowerCase());
      }).toList();
    }

    return result;
  });
});
