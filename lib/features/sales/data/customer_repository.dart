import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/error/error_handler.dart';
import '../../../core/error/failure.dart';
import '../domain/models/customer.dart';

/// Reads and writes the customers.
class CustomerRepository {
  CustomerRepository(this._client);

  final SupabaseClient _client;

  /// Reads every customer, ordered by name.
  Future<List<Customer>> fetchCustomers({bool onlyActive = true}) async {
    try {
      final builder = _client.from(AppConstants.tCustomers).select('*');
      if (onlyActive) {
        builder.eq('is_active', true);
      }

      final rows = await builder.order('name', ascending: true);

      return rows
          .map((row) => Customer.fromJson(Map<String, dynamic>.from(row)))
          .toList(growable: false);
    } catch (error) {
      throw ErrorHandler.map(error);
    }
  }

  /// Creates a new customer.
  Future<Customer> createCustomer({
    required String name,
    String? phone,
    String? email,
    String? address,
  }) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      throw const Failure('Nama pelanggan wajib diisi.');
    }
    try {
      final row = await _client
          .from(AppConstants.tCustomers)
          .insert({
            'name': trimmed,
            'phone': _emptyToNull(phone),
            'email': _emptyToNull(email),
            'address': _emptyToNull(address),
          })
          .select('*')
          .single();

      return Customer.fromJson(Map<String, dynamic>.from(row));
    } catch (error) {
      throw ErrorHandler.map(error);
    }
  }

  /// Updates an existing customer.
  Future<Customer> updateCustomer(
    String id, {
    required String name,
    String? phone,
    String? email,
    String? address,
    bool isActive = true,
  }) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      throw const Failure('Nama pelanggan wajib diisi.');
    }
    try {
      final row = await _client
          .from(AppConstants.tCustomers)
          .update({
            'name': trimmed,
            'phone': _emptyToNull(phone),
            'email': _emptyToNull(email),
            'address': _emptyToNull(address),
            'is_active': isActive,
          })
          .eq('id', id)
          .select('*')
          .single();

      return Customer.fromJson(Map<String, dynamic>.from(row));
    } catch (error) {
      throw ErrorHandler.map(error);
    }
  }

  /// Deletes a customer.
  Future<void> deleteCustomer(String id) async {
    try {
      await _client.from(AppConstants.tCustomers).delete().eq('id', id);
    } catch (error) {
      throw ErrorHandler.map(error);
    }
  }

  String? _emptyToNull(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) return null;
    return trimmed;
  }
}
