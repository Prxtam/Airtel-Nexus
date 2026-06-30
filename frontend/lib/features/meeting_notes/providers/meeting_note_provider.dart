import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/meeting_notes/models/meeting_note.dart';
import 'package:frontend/features/meeting_notes/repositories/meeting_note_repository.dart';

// ---------------------------------------------------------------------------
// Meeting Note List Provider (family — keyed by meetingId)
// ---------------------------------------------------------------------------

class MeetingNoteListNotifier
    extends StateNotifier<AsyncValue<List<MeetingNote>>> {
  final MeetingNoteRepository _repository;
  final String meetingId;

  MeetingNoteListNotifier(this._repository, this.meetingId)
    : super(const AsyncValue.loading()) {
    load();
  }

  Future<void> load() async {
    state = const AsyncValue.loading();
    try {
      final notes = await _repository.listNotes(meetingId: meetingId);
      state = AsyncValue.data(notes);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> refresh() => load();

  Future<void> createNote(String noteText) async {
    await _repository.createNote(meetingId: meetingId, noteText: noteText);
    await load();
  }

  Future<void> deleteNote(String noteId) async {
    await _repository.deleteNote(noteId);
    await load();
  }
}

final meetingNoteListProvider =
    StateNotifierProvider.family<
      MeetingNoteListNotifier,
      AsyncValue<List<MeetingNote>>,
      String
    >((ref, meetingId) {
      final repository = ref.watch(meetingNoteRepositoryProvider);
      return MeetingNoteListNotifier(repository, meetingId);
    });

final allMeetingNotesProvider = FutureProvider<List<MeetingNote>>((ref) async {
  final repository = ref.watch(meetingNoteRepositoryProvider);
  return repository.listAllNotes();
});

// ---------------------------------------------------------------------------
// Meeting Note Detail Provider (family — keyed by noteId)
// ---------------------------------------------------------------------------

class MeetingNoteDetailNotifier extends StateNotifier<AsyncValue<MeetingNote>> {
  final MeetingNoteRepository _repository;
  final String noteId;

  MeetingNoteDetailNotifier(this._repository, this.noteId)
    : super(const AsyncValue.loading()) {
    load();
  }

  Future<void> load() async {
    state = const AsyncValue.loading();
    try {
      final note = await _repository.getNote(noteId);
      state = AsyncValue.data(note);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> update(String noteText) async {
    try {
      final updated = await _repository.updateNote(noteId, noteText: noteText);
      state = AsyncValue.data(updated);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final meetingNoteDetailProvider =
    StateNotifierProvider.family<
      MeetingNoteDetailNotifier,
      AsyncValue<MeetingNote>,
      String
    >((ref, noteId) {
      final repository = ref.watch(meetingNoteRepositoryProvider);
      return MeetingNoteDetailNotifier(repository, noteId);
    });
