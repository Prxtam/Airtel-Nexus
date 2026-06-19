// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meeting_note.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MeetingNoteAdapter extends TypeAdapter<MeetingNote> {
  @override
  final int typeId = 6;

  @override
  MeetingNote read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MeetingNote(
      id: fields[0] as String,
      meetingId: fields[1] as String,
      authorUserId: fields[2] as String,
      noteText: fields[3] as String,
      createdAt: fields[4] as DateTime,
      updatedAt: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, MeetingNote obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.meetingId)
      ..writeByte(2)
      ..write(obj.authorUserId)
      ..writeByte(3)
      ..write(obj.noteText)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MeetingNoteAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

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
