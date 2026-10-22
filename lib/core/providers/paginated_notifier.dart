import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/app_constants.dart';
import '../error/error_handler.dart';
import 'paginated_state.dart';

/// Base class of every paginated list in ERPeace.
///
/// Subclasses only have to provide the query provider and the repository
/// call that loads a single page. Searching and filtering is done by
/// changing the query, which automatically reloads the list.
abstract class PaginatedNotifier<T, Q> extends Notifier<PaginatedState<T>> {
  /// Provider that holds the current query (search term, filters, ...).
  NotifierProvider<Notifier<Q>, Q> get queryProvider;

  /// Loads one page of results.
  Future<PaginatedResult<T>> fetchPage(Q query, int offset, int limit);

  /// Number of rows loaded per page.
  int get pageSize => AppConstants.pageSize;

  @override
  PaginatedState<T> build() {
    ref.listen(queryProvider, (previous, next) {
      if (previous != next) {
        unawaited(reload());
      }
    });
    scheduleMicrotask(() => unawaited(reload()));
    return PaginatedState<T>();
  }

  /// Reloads the list starting from the first page.
  Future<void> reload() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final result = await fetchPage(ref.read(queryProvider), 0, pageSize);
      state = PaginatedState<T>(
        items: result.items,
        isLoading: false,
        hasMore: result.hasMore,
      );
    } catch (error) {
      state = PaginatedState<T>(
        isLoading: false,
        errorMessage: ErrorHandler.message(error),
      );
    }
  }

  /// Loads the next page and appends it to the current list.
  Future<void> loadMore() async {
    final current = state;
    if (current.isLoading || current.isLoadingMore || !current.hasMore) {
      return;
    }
    state = current.copyWith(isLoadingMore: true, clearError: true);
    try {
      final result = await fetchPage(
        ref.read(queryProvider),
        current.items.length,
        pageSize,
      );
      state = state.copyWith(
        items: [...current.items, ...result.items],
        isLoadingMore: false,
        hasMore: result.hasMore,
      );
    } catch (error) {
      state = state.copyWith(
        isLoadingMore: false,
        errorMessage: ErrorHandler.message(error),
      );
    }
  }

  /// Replaces a single row without reloading the whole list.
  void replaceItem(bool Function(T item) test, T updated) {
    final items = [...state.items];
    final index = items.indexWhere(test);
    if (index == -1) return;
    items[index] = updated;
    state = state.copyWith(items: items);
  }

  /// Removes a single row from the list.
  void removeItem(bool Function(T item) test) {
    state = state.copyWith(
      items: state.items.where((item) => !test(item)).toList(),
    );
  }
}
