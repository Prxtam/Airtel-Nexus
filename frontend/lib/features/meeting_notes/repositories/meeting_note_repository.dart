import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/api/dio_client.dart';
import 'package:frontend/features/meeting_notes/models/meeting_note.dart';

final meetingNoteRepositoryProvider =
    Provider<MeetingNoteRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return MeetingNoteRepository(dio);
});

class MeetingNoteRepository {
  final Dio _dio;
  MeetingNoteRepository(this._dio);

  Future<List<MeetingNote>> listNotes({required String meetingId}) async {
    final response = await _dio
        .get('/meeting-notes', queryParameters: {'meeting_id': meetingId});
    if (response.statusCode == 200) {
      final list = response.data['notes'] as List<dynamic>;
      return list
          .map((e) => MeetingNote.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    throw Exception(response.data['detail'] ?? 'Failed to load notes');
  }

  Future<MeetingNote> getNote(String id) async {
    final response = await _dio.get('/meeting-notes/$id');
    if (response.statusCode == 200) {
      return MeetingNote.fromJson(response.data as Map<String, dynamic>);
    }
    throw Exception(response.data['detail'] ?? 'Note not found');
  }

  Future<MeetingNote> createNote({
    required String meetingId,
    required String noteText,
  }) async {
    final response = await _dio.post('/meeting-notes', data: {
      'meeting_id': meetingId,
      'note_text': noteText,
    });
    if (response.statusCode == 201) {
      return MeetingNote.fromJson(response.data as Map<String, dynamic>);
    }
    throw Exception(response.data['detail'] ?? 'Failed to create note');
  }

  Future<MeetingNote> updateNote(String id, {required String noteText}) async {
    final response = await _dio.patch('/meeting-notes/$id', data: {
      'note_text': noteText,
    });
    if (response.statusCode == 200) {
      return MeetingNote.fromJson(response.data as Map<String, dynamic>);
    }
    throw Exception(response.data['detail'] ?? 'Failed to update note');
  }

  Future<void> deleteNote(String id) async {
    final response = await _dio.delete('/meeting-notes/$id');
    if (response.statusCode != 204) {
      throw Exception(response.data['detail'] ?? 'Failed to delete note');
    }
  }
}
