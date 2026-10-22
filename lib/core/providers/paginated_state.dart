/// A single page of results returned by a repository.
class PaginatedResult<T> {
  const PaginatedResult({
    required this.items,
    required this.hasMore,
    this.total = 0,
  });

  final List<T> items;

  /// Whether more rows are available after [items].
  final bool hasMore;

  /// Total number of rows matching the query (when known).
  final int total;
}

/// State of a paginated list in the presentation layer.
class PaginatedState<T> {
  const PaginatedState({
    this.items = const [],
    this.isLoading = true,
    this.isLoadingMore = false,
    this.hasMore = false,
    this.errorMessage,
  });

  final List<T> items;

  /// The first page is being loaded.
  final bool isLoading;

  /// A following page is being loaded.
  final bool isLoadingMore;

  /// Whether more rows are available.
  final bool hasMore;

  /// Friendly error message when the list could not be loaded.
  final String? errorMessage;

  bool get isEmpty =>
      items.isEmpty && !isLoading && !isLoadingMore && errorMessage == null;

  PaginatedState<T> copyWith({
    List<T>? items,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    String? errorMessage,
    bool clearError = false,
  }) {
    return PaginatedState<T>(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
