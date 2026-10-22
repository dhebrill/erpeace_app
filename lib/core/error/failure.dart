/// Domain level error carrying a friendly Indonesian message.
class Failure implements Exception {
  const Failure(this.message, {this.code, this.cause});

  /// Message that is safe to display to the end user.
  final String message;

  /// Technical error code (Postgres / Auth) when available.
  final String? code;

  /// Original error object, kept for logging purposes.
  final Object? cause;

  @override
  String toString() => message;
}
