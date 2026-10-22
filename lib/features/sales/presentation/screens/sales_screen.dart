import 'package:flutter/material.dart';

import '../../../../core/widgets/app_empty_state.dart';

/// Placeholder replaced in the sales phase.
class SalesScreen extends StatelessWidget {
  const SalesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: AppEmptyState(
        title: 'Penjualan',
        message: 'Daftar sales order akan tampil di sini.',
        icon: Icons.point_of_sale_rounded,
      ),
    );
  }
}
