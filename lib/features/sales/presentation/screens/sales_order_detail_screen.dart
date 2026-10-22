import 'package:flutter/material.dart';

import '../../../../core/widgets/app_empty_state.dart';

/// Placeholder replaced in the sales phase.
class SalesOrderDetailScreen extends StatelessWidget {
  const SalesOrderDetailScreen({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail SO')),
      body: AppEmptyState(
        title: 'Sales order',
        message: orderId,
        icon: Icons.point_of_sale_rounded,
      ),
    );
  }
}
