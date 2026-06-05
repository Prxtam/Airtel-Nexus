import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/core/constants/app_constants.dart';
import 'package:frontend/features/meeting_notes/providers/meeting_note_provider.dart';
import 'package:gap/gap.dart';

class NoteCreateScreen extends ConsumerStatefulWidget {
  final String meetingId;
  const NoteCreateScreen({super.key, required this.meetingId});

  @override
  ConsumerState<NoteCreateScreen> createState() => _NoteCreateScreenState();
}

class _NoteCreateScreenState extends ConsumerState<NoteCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _noteController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await ref
          .read(meetingNoteListProvider(widget.meetingId).notifier)
          .createNote(_noteController.text.trim());
      if (mounted) context.pop();
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
      });
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Add Note'),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.note_add,
                  size: 64, color: AppConstants.primaryColor),
              const Gap(24),
              const Text('New Note',
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              const Gap(4),
              const Text('Add a note to this meeting.',
                  style: TextStyle(color: Colors.grey)),
              const Gap(24),
              TextFormField(
                controller: _noteController,
                decoration: const InputDecoration(
                  labelText: 'Note *',
                  hintText: 'Write your meeting notes here...',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: 8,
                textCapitalization: TextCapitalization.sentences,
                autofocus: true,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Note text is required';
                  }
                  return null;
                },
              ),
              if (_errorMessage != null) ...[
                const Gap(16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline,
                          color: Colors.red, size: 20),
                      const Gap(8),
                      Expanded(
                        child: Text(_errorMessage!,
                            style: const TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                ),
              ],
              const Gap(32),
              ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstants.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2),
                      )
                    : const Text('Save Note',
                        style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
