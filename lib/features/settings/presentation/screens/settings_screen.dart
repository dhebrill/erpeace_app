import 'package:flutter/material.dart';

import '../../../../core/widgets/app_empty_state.dart';

/// Placeholder replaced in the settings phase.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: AppEmptyState(
        title: 'Pengaturan',
        message: 'Profil, tema, dan keluar akan tampil di sini.',
        icon: Icons.settings_rounded,
      ),
    );
  }
}
