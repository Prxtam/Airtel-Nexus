// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meeting.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MeetingAdapter extends TypeAdapter<Meeting> {
  @override
  final int typeId = 2;

  @override
  Meeting read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Meeting(
      id: fields[0] as String,
      customerId: fields[1] as String,
      createdByUserId: fields[2] as String,
      title: fields[3] as String?,
      meetingAt: fields[4] as DateTime,
      createdAt: fields[5] as DateTime,
      updatedAt: fields[6] as DateTime,
      status: fields[7] == null
          ? MeetingStatus.scheduled
          : fields[7] as MeetingStatus,
    );
  }

  @override
  void write(BinaryWriter writer, Meeting obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.customerId)
      ..writeByte(2)
      ..write(obj.createdByUserId)
      ..writeByte(3)
      ..write(obj.title)
      ..writeByte(4)
      ..write(obj.meetingAt)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.updatedAt)
      ..writeByte(7)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MeetingAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MeetingStatusAdapter extends TypeAdapter<MeetingStatus> {
  @override
  final int typeId = 7;

  @override
  MeetingStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return MeetingStatus.scheduled;
      case 1:
        return MeetingStatus.awaitingConfirmation;
      case 2:
        return MeetingStatus.conducted;
      default:
        return MeetingStatus.scheduled;
    }
  }

  @override
  void write(BinaryWriter writer, MeetingStatus obj) {
    switch (obj) {
      case MeetingStatus.scheduled:
        writer.writeByte(0);
        break;
      case MeetingStatus.awaitingConfirmation:
        writer.writeByte(1);
        break;
      case MeetingStatus.conducted:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MeetingStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Meeting _$MeetingFromJson(Map<String, dynamic> json) => Meeting(
  id: json['id'] as String,
  customerId: json['customer_id'] as String,
  createdByUserId: json['created_by_user_id'] as String,
  title: json['title'] as String?,
  meetingAt: DateTime.parse(json['meeting_at'] as String),
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
  status:
      $enumDecodeNullable(_$MeetingStatusEnumMap, json['status']) ??
      MeetingStatus.scheduled,
);

Map<String, dynamic> _$MeetingToJson(Meeting instance) => <String, dynamic>{
  'id': instance.id,
  'customer_id': instance.customerId,
  'created_by_user_id': instance.createdByUserId,
  'title': instance.title,
  'meeting_at': instance.meetingAt.toIso8601String(),
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
  'status': _$MeetingStatusEnumMap[instance.status]!,
};

const _$MeetingStatusEnumMap = {
  MeetingStatus.scheduled: 'scheduled',
  MeetingStatus.awaitingConfirmation: 'awaitingConfirmation',
  MeetingStatus.conducted: 'conducted',
};
