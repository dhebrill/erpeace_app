import 'package:flutter/material.dart';

import '../../../../core/widgets/app_empty_state.dart';

/// Placeholder replaced in the purchasing phase.
class PurchaseOrderDetailScreen extends StatelessWidget {
  const PurchaseOrderDetailScreen({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail PO')),
      body: AppEmptyState(
        title: 'Purchase order',
        message: orderId,
        icon: Icons.shopping_cart_rounded,
      ),
    );
  }
}
