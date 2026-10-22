import 'package:flutter/material.dart';

import '../../../../core/widgets/app_empty_state.dart';

/// Placeholder replaced in the inventory phase.
class StockOpnameDetailScreen extends StatelessWidget {
  const StockOpnameDetailScreen({super.key, required this.opnameId});

  final String opnameId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stock opname')),
      body: AppEmptyState(
        title: 'Stock opname',
        message: opnameId,
        icon: Icons.fact_check_rounded,
      ),
    );
  }
}
