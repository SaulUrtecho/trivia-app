import 'package:equatable/equatable.dart';

// this class extends from equatable for can testing
abstract class Failure extends Equatable {
  const Failure();

  @override
  List<Object?> get props => [];
}

// General failures
class ServerFailure extends Failure {}

class CacheFailure extends Failure {}
