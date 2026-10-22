import 'package:flutter/material.dart';

import '../../../../core/widgets/app_empty_state.dart';

/// Placeholder replaced in the inventory phase.
class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: AppEmptyState(
        title: 'Inventori',
        message: 'Daftar produk akan tampil di sini.',
        icon: Icons.inventory_2_rounded,
      ),
    );
  }
}
