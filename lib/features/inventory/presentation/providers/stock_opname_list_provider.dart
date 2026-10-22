import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/paginated_notifier.dart';
import '../../../../core/providers/paginated_state.dart';
import '../../data/stock_opname_repository.dart';
import '../../domain/models/stock_opname.dart';
import 'stock_opname_repository_provider.dart';

/// Query of the stock opname list.
class StockOpnameQuery {
  const StockOpnameQuery({this.status});

  final StockOpnameStatus? status;

  StockOpnameQuery copyWith({
    StockOpnameStatus? status,
    bool clearStatus = false,
  }) {
    return StockOpnameQuery(
      status: clearStatus ? null : (status ?? this.status),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is StockOpnameQuery && other.status == status;
  }

  @override
  int get hashCode => status.hashCode;
}

/// Holds the current query of the stock opname list.
class StockOpnameQueryNotifier extends Notifier<StockOpnameQuery> {
  @override
  StockOpnameQuery build() => const StockOpnameQuery();

  void setStatus(StockOpnameStatus? status) {
    if (status == null) {
      if (state.status == null) return;
      state = state.copyWith(clearStatus: true);
      return;
    }
    if (status == state.status) return;
    state = state.copyWith(status: status);
  }
}

/// The query used by the stock opname list.
final stockOpnameQueryProvider =
    NotifierProvider<StockOpnameQueryNotifier, StockOpnameQuery>(
      StockOpnameQueryNotifier.new,
    );

/// Loads the paginated stock opname list.
class StockOpnameListNotifier
    extends PaginatedNotifier<StockOpname, StockOpnameQuery> {
  @override
  NotifierProvider<Notifier<StockOpnameQuery>, StockOpnameQuery>
  get queryProvider => stockOpnameQueryProvider;

  @override
  Future<PaginatedResult<StockOpname>> fetchPage(
    StockOpnameQuery query,
    int offset,
    int limit,
  ) {
    return ref
        .read(stockOpnameRepositoryProvider)
        .fetchOpnames(offset: offset, limit: limit, status: query.status);
  }
}

/// The paginated stock opname list.
final stockOpnameListProvider =
    NotifierProvider<StockOpnameListNotifier, PaginatedState<StockOpname>>(
      StockOpnameListNotifier.new,
    );

/// Reads a stock opname session with its counted lines.
final stockOpnameDetailProvider =
    FutureProvider.family<StockOpnameDetail, String>((ref, id) {
      return ref.watch(stockOpnameRepositoryProvider).fetchOpnameDetail(id);
    });

/// Mutations of the stock opname module.
class StockOpnameActions {
  StockOpnameActions({required this.repository, required this.onChanged});

  final StockOpnameRepository repository;
  final VoidCallback onChanged;

  Future<StockOpname> createOpname({
    String? note,
    List<String>? productIds,
  }) async {
    final opname = await repository.createOpname(
      note: note,
      productIds: productIds,
    );
    onChanged();
    return opname;
  }

  Future<StockOpnameItem> setCount(String itemId, double countedQty) async {
    final item = await repository.setCount(itemId, countedQty);
    onChanged();
    return item;
  }

  Future<StockOpname> finalizeOpname(String id) async {
    final opname = await repository.finalizeOpname(id);
    onChanged();
    return opname;
  }

  Future<StockOpname> cancelOpname(String id) async {
    final opname = await repository.cancelOpname(id);
    onChanged();
    return opname;
  }
}

/// Provides the [StockOpnameActions].
final stockOpnameActionsProvider = Provider<StockOpnameActions>((ref) {
  return StockOpnameActions(
    repository: ref.watch(stockOpnameRepositoryProvider),
    onChanged: () {
      ref.invalidate(stockOpnameListProvider);
      ref.invalidate(stockOpnameDetailProvider);
    },
  );
});
