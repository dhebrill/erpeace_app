import 'package:flutter/material.dart';

import '../../../../core/widgets/status_chip.dart';
import '../../domain/models/user_role.dart';

/// Returns the color used to render a user role.
Color userRoleColor(UserRole role, ColorScheme scheme) {
  switch (role) {
    case UserRole.admin:
      return scheme.error;
    case UserRole.manager:
      return Colors.blue.shade700;
    case UserRole.warehouse:
      return Colors.teal.shade700;
    case UserRole.sales:
      return Colors.green.shade700;
    case UserRole.purchasing:
      return Colors.purple.shade700;
  }
}

/// Small colored pill that shows the role of a user.
class RoleChip extends StatelessWidget {
  const RoleChip({super.key, required this.role, this.dense = false});

  final UserRole role;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    return StatusChip(
      label: role.label,
      color: userRoleColor(role, Theme.of(context).colorScheme),
      icon: Icons.shield_outlined,
      dense: dense,
    );
  }
}
