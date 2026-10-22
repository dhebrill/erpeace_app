import 'package:flutter/material.dart';

import '../../../../core/widgets/app_empty_state.dart';

/// Placeholder replaced in the inventory phase.
class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key, required this.productId});

  final String productId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail produk')),
      body: AppEmptyState(
        title: 'Detail produk',
        message: productId,
        icon: Icons.inventory_2_rounded,
      ),
    );
  }
}
