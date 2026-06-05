// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meeting_note.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MeetingNote _$MeetingNoteFromJson(Map<String, dynamic> json) => MeetingNote(
  id: json['id'] as String,
  meetingId: json['meeting_id'] as String,
  authorUserId: json['author_user_id'] as String,
  noteText: json['note_text'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$MeetingNoteToJson(MeetingNote instance) =>
    <String, dynamic>{
      'id': instance.id,
      'meeting_id': instance.meetingId,
      'author_user_id': instance.authorUserId,
      'note_text': instance.noteText,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
