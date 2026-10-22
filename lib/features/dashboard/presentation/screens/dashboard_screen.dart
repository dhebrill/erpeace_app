import 'package:flutter/material.dart';

import '../../../../core/widgets/app_empty_state.dart';

/// Placeholder replaced in the dashboard phase.
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: AppEmptyState(
        title: 'Beranda',
        message: 'Ringkasan bisnis akan tampil di sini.',
        icon: Icons.space_dashboard_rounded,
      ),
    );
  }
}
