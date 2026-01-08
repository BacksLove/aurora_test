/// Base class for all failures in the application
abstract class Failure {
  final String message;
  final dynamic error;

  const Failure(this.message, [this.error]);

  @override
  String toString() => message;
}

/// Network-related failures (no connection, DNS error, etc.)
class NetworkFailure extends Failure {
  const NetworkFailure([String message = 'Network error', dynamic error])
    : super(message, error);
}

/// Server-side errors (4xx, 5xx HTTP codes)
class ServerFailure extends Failure {
  final int? statusCode;

  const ServerFailure(String message, {this.statusCode, dynamic error})
    : super(message, error);
}

/// Timeout failures (connection timeout, receive timeout)
class TimeoutFailure extends Failure {
  const TimeoutFailure([String message = 'Connection timeout', dynamic error])
    : super(message, error);
}

/// Request cancelled failures
class CancelledFailure extends Failure {
  const CancelledFailure([String message = 'Request cancelled', dynamic error])
    : super(message, error);
}

/// Unexpected failures (parsing errors, unknown errors)
class UnexpectedFailure extends Failure {
  const UnexpectedFailure([
    String message = 'An unexpected error occurred',
    dynamic error,
  ]) : super(message, error);
}
