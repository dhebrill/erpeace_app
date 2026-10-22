import 'package:flutter/material.dart';

import '../../../../core/widgets/app_empty_state.dart';

/// Placeholder replaced in the admin phase.
class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: AppEmptyState(
        title: 'Panel Admin',
        message: 'Kelola pengguna dan data master di sini.',
        icon: Icons.admin_panel_settings_rounded,
      ),
    );
  }
}
