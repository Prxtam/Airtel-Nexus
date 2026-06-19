import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/storage/hive_service.dart';
import 'package:frontend/features/meeting_notes/models/meeting_note.dart';
import 'package:uuid/uuid.dart';

final meetingNoteRepositoryProvider =
    Provider<MeetingNoteRepository>((ref) {
  return MeetingNoteRepository();
});

class MeetingNoteRepository {
  Future<List<MeetingNote>> listNotes({required String meetingId}) async {
    final box = HiveService.meetingNotesBox;
    final notes = box.values.where((n) => n.meetingId == meetingId).toList();
    // Sort ascending by creation time
    notes.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return notes;
  }

  Future<MeetingNote> getNote(String id) async {
    final box = HiveService.meetingNotesBox;
    final note = box.get(id);
    if (note == null) {
      throw Exception('Note not found');
    }
    return note;
  }

  Future<MeetingNote> createNote({
    required String meetingId,
    required String noteText,
  }) async {
    final box = HiveService.meetingNotesBox;
    final currentUser = HiveService.userBox.get('current_user');
    final now = DateTime.now();

    final newNote = MeetingNote(
      id: const Uuid().v4(),
      meetingId: meetingId,
      authorUserId: currentUser?.id ?? 'unknown_user',
      noteText: noteText,
      createdAt: now,
      updatedAt: now,
    );

    await box.put(newNote.id, newNote);
    return newNote;
  }

  Future<MeetingNote> updateNote(String id, {required String noteText}) async {
    final box = HiveService.meetingNotesBox;
    final existing = box.get(id);

    if (existing == null) {
      throw Exception('Note not found');
    }

    final updated = MeetingNote(
      id: existing.id,
      meetingId: existing.meetingId,
      authorUserId: existing.authorUserId,
      noteText: noteText,
      createdAt: existing.createdAt,
      updatedAt: DateTime.now(),
    );

    await box.put(updated.id, updated);
    return updated;
  }

  Future<void> deleteNote(String id) async {
    final box = HiveService.meetingNotesBox;
    await box.delete(id);
  }
}
