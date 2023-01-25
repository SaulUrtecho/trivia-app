//import 'package:dartz/dartz.dart';
import 'package:either_dart/either.dart';
import 'package:clean_architecture_tdd_course/core/error/failures.dart';
import 'package:clean_architecture_tdd_course/core/use_cases/use_cases.dart';
import 'package:clean_architecture_tdd_course/domain/entities/trivia_entity.dart';
import 'package:clean_architecture_tdd_course/domain/repositories/trivia_repository_contract.dart';

// this use case implementation require a number(int) trivia like input and return a trivia(Trivia)
class GetTriviaUseCase implements InputUseCase<Trivia, int> {
  final TriviaRepositoryContract _triviaRepositoryContract;

  // here(constructor) we receive the repository
  GetTriviaUseCase(this._triviaRepositoryContract);

  // method call() do the request to API
  // Either type is from dartz package, which is used for error handling
  // it requires two types, Left(L) and Right(R)
  // left side is used for error handling and right side is used for successful responses
  // the method requires an int value which is a concrete number for a trivia
  @override
  Future<Either<Failure, Trivia>> run(int input) async {
    // with repository variable we can to access to getConcreteNumberTrivia() method
    // and after we pass to it the int number parameter
    return await _triviaRepositoryContract.getTrivia(input);
  }
}
