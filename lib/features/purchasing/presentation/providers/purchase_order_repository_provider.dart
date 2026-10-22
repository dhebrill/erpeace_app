import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/supabase/supabase_provider.dart';
import '../../data/purchase_order_repository.dart';

/// Provides the [PurchaseOrderRepository].
final purchaseOrderRepositoryProvider = Provider<PurchaseOrderRepository>((
  ref,
) {
  return PurchaseOrderRepository(ref.watch(supabaseClientProvider));
});
