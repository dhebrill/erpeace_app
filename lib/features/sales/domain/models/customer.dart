import 'package:freezed_annotation/freezed_annotation.dart';

part 'customer.freezed.dart';
part 'customer.g.dart';

/// A customer of the `customers` table.
@freezed
abstract class Customer with _$Customer {
  const factory Customer({
    required String id,
    required String name,
    String? phone,
    String? email,
    String? address,
    @Default(true) bool isActive,
    DateTime? createdAt,
  }) = _Customer;

  factory Customer.fromJson(Map<String, dynamic> json) =>
      _$CustomerFromJson(json);
}
