// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meeting.dart';

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
);

Map<String, dynamic> _$MeetingToJson(Meeting instance) => <String, dynamic>{
  'id': instance.id,
  'customer_id': instance.customerId,
  'created_by_user_id': instance.createdByUserId,
  'title': instance.title,
  'meeting_at': instance.meetingAt.toIso8601String(),
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
};
