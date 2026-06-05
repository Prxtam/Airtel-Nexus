import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/core/constants/app_constants.dart';
import 'package:frontend/core/widgets/app_error_widget.dart';
import 'package:frontend/features/meeting_notes/models/meeting_note.dart';
import 'package:frontend/features/meeting_notes/providers/meeting_note_provider.dart';
import 'package:gap/gap.dart';

class NoteDetailScreen extends ConsumerWidget {
  final String meetingId;
  final String noteId;
  const NoteDetailScreen(
      {super.key, required this.meetingId, required this.noteId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final noteAsync = ref.watch(meetingNoteDetailProvider(noteId));

    return Scaffold(
      backgroundColor: AppConstants.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Note'),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: noteAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => AppErrorWidget(
          message: e.toString(),
          onRetry: () =>
              ref.read(meetingNoteDetailProvider(noteId).notifier).load(),
        ),
        data: (note) =>
            _NoteDetailBody(note: note, noteId: noteId, meetingId: meetingId),
      ),
    );
  }
}

class _NoteDetailBody extends ConsumerStatefulWidget {
  final MeetingNote note;
  final String noteId;
  final String meetingId;
  const _NoteDetailBody(
      {required this.note, required this.noteId, required this.meetingId});

  @override
  ConsumerState<_NoteDetailBody> createState() => _NoteDetailBodyState();
}

class _NoteDetailBodyState extends ConsumerState<_NoteDetailBody> {
  bool _isEditing = false;
  late TextEditingController _noteController;
  bool _isSaving = false;
  bool _isDeleting = false;
  String? _editError;

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController(text: widget.note.noteText);
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_noteController.text.trim().isEmpty) {
      setState(() => _editError = 'Note text cannot be empty');
      return;
    }
    setState(() {
      _isSaving = true;
      _editError = null;
    });
    try {
      await ref
          .read(meetingNoteDetailProvider(widget.noteId).notifier)
          .update(_noteController.text.trim());
      ref.invalidate(meetingNoteListProvider(widget.meetingId));
      if (mounted) setState(() => _isEditing = false);
    } catch (e) {
      setState(() =>
          _editError = e.toString().replaceAll('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Note'),
        content:
            const Text('This note will be permanently deleted.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    setState(() => _isDeleting = true);
    try {
      await ref
          .read(meetingNoteListProvider(widget.meetingId).notifier)
          .deleteNote(widget.noteId);
      if (mounted) context.pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.toString().replaceAll('Exception: ', '')),
          backgroundColor: Colors.red,
        ));
      }
    } finally {
      if (mounted) setState(() => _isDeleting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.note, color: Colors.purple, size: 28),
                      const Gap(12),
                      const Expanded(
                        child: Text('Note Content',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                      ),
                      if (!_isEditing)
                        IconButton(
                          icon: const Icon(Icons.edit_outlined),
                          color: AppConstants.primaryColor,
                          onPressed: () => setState(() => _isEditing = true),
                        ),
                    ],
                  ),
                  const Gap(12),
                  if (!_isEditing)
                    Text(widget.note.noteText,
                        style: const TextStyle(height: 1.6))
                  else ...[
                    TextField(
                      controller: _noteController,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        errorText: _editError,
                      ),
                      maxLines: 8,
                      textCapitalization: TextCapitalization.sentences,
                      autofocus: true,
                    ),
                    const Gap(12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: _isSaving
                              ? null
                              : () {
                                  _noteController.text =
                                      widget.note.noteText;
                                  setState(() {
                                    _isEditing = false;
                                    _editError = null;
                                  });
                                },
                          child: const Text('Cancel'),
                        ),
                        const Gap(8),
                        ElevatedButton(
                          onPressed: _isSaving ? null : _save,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppConstants.primaryColor,
                            foregroundColor: Colors.white,
                          ),
                          child: _isSaving
                              ? const SizedBox(
                                  height: 18,
                                  width: 18,
                                  child: CircularProgressIndicator(
                                      color: Colors.white, strokeWidth: 2),
                                )
                              : const Text('Save'),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
          const Gap(16),
          Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Details',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                  const Gap(12),
                  _InfoRow(
                      label: 'Created',
                      value: _formatDate(widget.note.createdAt)),
                  const Divider(height: 24),
                  _InfoRow(
                      label: 'Updated',
                      value: _formatDate(widget.note.updatedAt)),
                ],
              ),
            ),
          ),
          const Gap(32),
          OutlinedButton.icon(
            onPressed: _isDeleting ? null : _confirmDelete,
            icon: _isDeleting
                ? const SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(
                        color: Colors.red, strokeWidth: 2),
                  )
                : const Icon(Icons.delete_outline, color: Colors.red),
            label: Text(
              _isDeleting ? 'Deleting...' : 'Delete Note',
              style: const TextStyle(color: Colors.red),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.red),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) {
    final local = dt.toLocal();
    return '${local.day}/${local.month}/${local.year}  ${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(label,
              style:
                  const TextStyle(color: Colors.grey, fontSize: 13)),
        ),
        Expanded(
          child: Text(value,
              style: const TextStyle(
                  fontWeight: FontWeight.w500, fontSize: 13)),
        ),
      ],
    );
  }
}
