import 'package:clean_architecture_tdd_course/core/error/failures.dart';
import 'package:clean_architecture_tdd_course/domain/entities/trivia_entity.dart';
//import 'package:dartz/dartz.dart';
import 'package:either_dart/either.dart';

// **************** CONTRACTS *********************
//
// in this abstract class(interface) we have two futures function
// which help us to get the two types of request
// a concrete trivia and a random trivia when it will be implemented
// by usecases
abstract class TriviaRepositoryContract {
  Future<Either<Failure, Trivia>> getTrivia(int number);
  Future<Either<Failure, Trivia>> getRandomTrivia();
}
