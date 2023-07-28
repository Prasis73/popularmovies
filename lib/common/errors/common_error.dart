abstract class Failure {
  final String message;
  Failure({
    required this.message,
  });
}

class NetworkFailure extends Failure {
  NetworkFailure({required super.message});
}

class AppFailure extends Failure {
  AppFailure({required super.message});
}
