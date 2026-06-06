import 'package:json_annotation/json_annotation.dart';

part 'user_admin.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class UserAdmin {
  final String id;
  final String email;
  final String? fullName;
  final bool isActive;
  final String? managerId;
  final List<String> roles;

  UserAdmin({
    required this.id,
    required this.email,
    this.fullName,
    required this.isActive,
    this.managerId,
    required this.roles,
  });

  factory UserAdmin.fromJson(Map<String, dynamic> json) => _$UserAdminFromJson(json);
  Map<String, dynamic> toJson() => _$UserAdminToJson(this);
}
