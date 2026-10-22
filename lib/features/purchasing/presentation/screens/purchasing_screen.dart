import 'package:flutter/material.dart';

import '../../../../core/widgets/app_empty_state.dart';

/// Placeholder replaced in the purchasing phase.
class PurchasingScreen extends StatelessWidget {
  const PurchasingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: AppEmptyState(
        title: 'Pembelian',
        message: 'Daftar purchase order akan tampil di sini.',
        icon: Icons.shopping_cart_rounded,
      ),
    );
  }
}
