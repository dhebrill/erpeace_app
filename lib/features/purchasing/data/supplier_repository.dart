import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/error/error_handler.dart';
import '../../../core/error/failure.dart';
import '../domain/models/supplier.dart';

/// Reads and writes the suppliers.
class SupplierRepository {
  SupplierRepository(this._client);

  final SupabaseClient _client;

  /// Reads every supplier, ordered by name.
  Future<List<Supplier>> fetchSuppliers({bool onlyActive = true}) async {
    try {
      final builder = _client.from(AppConstants.tSuppliers).select('*');
      if (onlyActive) {
        builder.eq('is_active', true);
      }

      final rows = await builder.order('name', ascending: true);

      return rows
          .map((row) => Supplier.fromJson(Map<String, dynamic>.from(row)))
          .toList(growable: false);
    } catch (error) {
      throw ErrorHandler.map(error);
    }
  }

  /// Creates a new supplier.
  Future<Supplier> createSupplier({
    required String name,
    String? phone,
    String? email,
    String? address,
  }) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      throw const Failure('Nama supplier wajib diisi.');
    }
    try {
      final row = await _client
          .from(AppConstants.tSuppliers)
          .insert({
            'name': trimmed,
            'phone': _emptyToNull(phone),
            'email': _emptyToNull(email),
            'address': _emptyToNull(address),
          })
          .select('*')
          .single();

      return Supplier.fromJson(Map<String, dynamic>.from(row));
    } catch (error) {
      throw ErrorHandler.map(error);
    }
  }

  /// Updates an existing supplier.
  Future<Supplier> updateSupplier(
    String id, {
    required String name,
    String? phone,
    String? email,
    String? address,
    bool isActive = true,
  }) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      throw const Failure('Nama supplier wajib diisi.');
    }
    try {
      final row = await _client
          .from(AppConstants.tSuppliers)
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

      return Supplier.fromJson(Map<String, dynamic>.from(row));
    } catch (error) {
      throw ErrorHandler.map(error);
    }
  }

  /// Deletes a supplier.
  Future<void> deleteSupplier(String id) async {
    try {
      await _client.from(AppConstants.tSuppliers).delete().eq('id', id);
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
