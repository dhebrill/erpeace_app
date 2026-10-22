// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Profile _$ProfileFromJson(Map<String, dynamic> json) => _Profile(
  id: json['id'] as String,
  fullName: json['fullName'] as String? ?? '',
  role: $enumDecodeNullable(_$UserRoleEnumMap, json['role']) ?? UserRole.sales,
  isActive: json['isActive'] as bool? ?? false,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$ProfileToJson(_Profile instance) => <String, dynamic>{
  'id': instance.id,
  'fullName': instance.fullName,
  'role': _$UserRoleEnumMap[instance.role]!,
  'isActive': instance.isActive,
  'createdAt': instance.createdAt?.toIso8601String(),
};

const _$UserRoleEnumMap = {
  UserRole.admin: 'admin',
  UserRole.manager: 'manager',
  UserRole.warehouse: 'warehouse',
  UserRole.sales: 'sales',
  UserRole.purchasing: 'purchasing',
};
