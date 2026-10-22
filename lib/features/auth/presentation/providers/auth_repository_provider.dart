import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/supabase/supabase_provider.dart';
import '../../data/auth_repository.dart';

/// Provides the [AuthRepository].
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.watch(supabaseClientProvider));
});
