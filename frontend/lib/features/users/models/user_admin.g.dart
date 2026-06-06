// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_admin.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserAdmin _$UserAdminFromJson(Map<String, dynamic> json) => UserAdmin(
  id: json['id'] as String,
  email: json['email'] as String,
  fullName: json['full_name'] as String?,
  isActive: json['is_active'] as bool,
  managerId: json['manager_id'] as String?,
  roles: (json['roles'] as List<dynamic>).map((e) => e as String).toList(),
);

Map<String, dynamic> _$UserAdminToJson(UserAdmin instance) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'full_name': instance.fullName,
  'is_active': instance.isActive,
  'manager_id': instance.managerId,
  'roles': instance.roles,
};
