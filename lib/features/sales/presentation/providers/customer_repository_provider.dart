import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/supabase/supabase_provider.dart';
import '../../data/customer_repository.dart';

/// Provides the [CustomerRepository].
final customerRepositoryProvider = Provider<CustomerRepository>((ref) {
  return CustomerRepository(ref.watch(supabaseClientProvider));
});
