import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../features/auth/domain/models/user_role.dart';
import '../../../features/auth/presentation/providers/auth_controller.dart';
import '../constants/app_module.dart';

/// Scaffold that hosts the bottom navigation bar.
class AppShell extends ConsumerWidget {
  const AppShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authControllerProvider);
    final role = auth.role ?? UserRole.sales;

    final modules = AppModule.values
        .where((module) => module.inNavigation && role.canAccess(module))
        .toList(growable: false);

    final location = GoRouterState.of(context).uri.path;
    final currentModule = AppModule.fromPath(location);
    final showNavigation =
        currentModule != null &&
        currentModule.inNavigation &&
        modules.isNotEmpty;

    final selectedIndex = currentModule == null
        ? 0
        : modules.indexOf(currentModule).clamp(0, modules.length - 1);

    return Scaffold(
      body: child,
      bottomNavigationBar: showNavigation
          ? NavigationBar(
              selectedIndex: selectedIndex,
              onDestinationSelected: (index) =>
                  GoRouter.of(context).go(modules[index].path),
              destinations: [
                for (final module in modules)
                  NavigationDestination(
                    icon: Icon(module.icon),
                    selectedIcon: Icon(module.icon),
                    label: module.label,
                  ),
              ],
            )
          : null,
    );
  }
}
