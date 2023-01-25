import 'package:clean_architecture_tdd_course/core/error/failures.dart';
import 'package:either_dart/either.dart';
//import 'package:dartz/dartz.dart';

// templates for use cases

// usecase for numbertrivia hence require a int value
abstract class InputUseCase<Out, Input> {
  Future<Either<Failure, Out>?> run(Input input);
}

//usecase for random trivia hence it doesn't require any number
abstract class NoInputUseCase<Out> {
  Future<Either<Failure, Out>?> run();
}
