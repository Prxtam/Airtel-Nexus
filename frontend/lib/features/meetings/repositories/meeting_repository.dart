import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/api/dio_client.dart';
import 'package:frontend/features/meetings/models/meeting.dart';

final meetingRepositoryProvider = Provider<MeetingRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return MeetingRepository(dio);
});

class MeetingRepository {
  final Dio _dio;
  MeetingRepository(this._dio);

  Future<List<Meeting>> listMeetings({String? customerId}) async {
    final queryParams = customerId != null ? {'customer_id': customerId} : null;
    final response =
        await _dio.get('/meetings', queryParameters: queryParams);
    if (response.statusCode == 200) {
      final list = response.data['meetings'] as List<dynamic>;
      return list
          .map((e) => Meeting.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    throw Exception(response.data['detail'] ?? 'Failed to load meetings');
  }

  Future<Meeting> getMeeting(String id) async {
    final response = await _dio.get('/meetings/$id');
    if (response.statusCode == 200) {
      return Meeting.fromJson(response.data as Map<String, dynamic>);
    }
    throw Exception(response.data['detail'] ?? 'Meeting not found');
  }

  Future<Meeting> createMeeting({
    required String customerId,
    String? title,
    required DateTime meetingAt,
  }) async {
    final response = await _dio.post('/meetings', data: {
      'customer_id': customerId,
      if (title != null && title.isNotEmpty) 'title': title,
      'meeting_at': meetingAt.toUtc().toIso8601String(),
    });
    if (response.statusCode == 201) {
      return Meeting.fromJson(response.data as Map<String, dynamic>);
    }
    throw Exception(response.data['detail'] ?? 'Failed to create meeting');
  }

  Future<Meeting> updateMeeting(
    String id, {
    String? title,
    DateTime? meetingAt,
  }) async {
    final response = await _dio.patch('/meetings/$id', data: {
      if (title != null) 'title': title,
      if (meetingAt != null) 'meeting_at': meetingAt.toUtc().toIso8601String(),
    });
    if (response.statusCode == 200) {
      return Meeting.fromJson(response.data as Map<String, dynamic>);
    }
    throw Exception(response.data['detail'] ?? 'Failed to update meeting');
  }

  Future<void> deleteMeeting(String id) async {
    final response = await _dio.delete('/meetings/$id');
    if (response.statusCode != 204) {
      throw Exception(response.data['detail'] ?? 'Failed to delete meeting');
    }
  }
}
