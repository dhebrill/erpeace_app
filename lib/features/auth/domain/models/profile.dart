import 'package:freezed_annotation/freezed_annotation.dart';

import 'user_role.dart';

part 'profile.freezed.dart';
part 'profile.g.dart';

/// A user profile stored in the `profiles` table.
@freezed
abstract class Profile with _$Profile {
  const factory Profile({
    required String id,
    @Default('') String fullName,
    @Default(UserRole.sales) UserRole role,
    @Default(false) bool isActive,
    DateTime? createdAt,
  }) = _Profile;

  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);
}
