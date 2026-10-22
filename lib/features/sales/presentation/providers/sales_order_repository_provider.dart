import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/supabase/supabase_provider.dart';
import '../../data/sales_order_repository.dart';

/// Provides the [SalesOrderRepository].
final salesOrderRepositoryProvider = Provider<SalesOrderRepository>((ref) {
  return SalesOrderRepository(ref.watch(supabaseClientProvider));
});
