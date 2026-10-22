import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/dashboard_repository.dart';
import 'dashboard_repository_provider.dart';

/// Loads the dashboard snapshot.
final dashboardProvider = FutureProvider<DashboardSnapshot>((ref) {
  return ref.watch(dashboardRepositoryProvider).load();
});
