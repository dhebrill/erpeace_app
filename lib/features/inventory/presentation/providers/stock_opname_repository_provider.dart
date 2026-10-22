import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/supabase/supabase_provider.dart';
import '../../data/stock_opname_repository.dart';

/// Provides the [StockOpnameRepository].
final stockOpnameRepositoryProvider = Provider<StockOpnameRepository>((ref) {
  return StockOpnameRepository(ref.watch(supabaseClientProvider));
});
