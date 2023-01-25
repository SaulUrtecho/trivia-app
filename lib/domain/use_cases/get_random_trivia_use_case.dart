import 'package:clean_architecture_tdd_course/core/error/failures.dart';
import 'package:clean_architecture_tdd_course/core/use_cases/use_cases.dart';
import 'package:clean_architecture_tdd_course/domain/entities/trivia_entity.dart';
import 'package:clean_architecture_tdd_course/domain/repositories/trivia_repository_contract.dart';
//import 'package:dartz/dartz.dart';
import 'package:either_dart/either.dart';

class GetRandomTriviaUseCase implements NoInputUseCase<Trivia> {
  final TriviaRepositoryContract _triviaRepositoryContract;

  // here(constructor) we receive the repository
  GetRandomTriviaUseCase(this._triviaRepositoryContract);

  @override
  Future<Either<Failure, Trivia>> run() async {
    return await _triviaRepositoryContract.getRandomTrivia();
  }
}
