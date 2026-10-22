import 'package:flutter/material.dart';

import '../../../../core/widgets/app_empty_state.dart';

/// Placeholder replaced in the inventory phase.
class ProductStockHistoryScreen extends StatelessWidget {
  const ProductStockHistoryScreen({super.key, required this.productId});

  final String productId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat stok')),
      body: AppEmptyState(
        title: 'Riwayat stok',
        message: productId,
        icon: Icons.history_rounded,
      ),
    );
  }
}
