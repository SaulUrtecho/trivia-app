import 'package:clean_architecture_tdd_course/domain/entities/trivia_entity.dart';
import 'package:clean_architecture_tdd_course/domain/repositories/trivia_repository_contract.dart';
import 'package:clean_architecture_tdd_course/domain/use_cases/get_trivia_use_case.dart';

import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// GenerateNiceMocks requires than we passed the class
// than will be Mocked, in this case that class is NumberTriviaRepositoryTest
@GenerateNiceMocks([MockSpec<TriviaRepositoryContract>()])
import 'get_trivia_test.mocks.dart';

void main() {
  // we create a variable of type GetConcreteNumberTrivia
  // which is a usecase
  late GetTriviaUseCase getNumberTriviaUseCase;

  // also we create a variable of type MockNumberTriviaRepository
  // which help us to create a Mock instance from MockNumberTriviaRepositoryTest
  // at the same time it will be our "mirror repository"
  late MockTriviaRepositoryContract mockTriviaRepositoryContract;

  // setUp() Registers a function to be run before tests.
  // This function will be called before each test is run.
  setUp(() {
    // we create the Mock object and add it to variable declared above
    mockTriviaRepositoryContract = MockTriviaRepositoryContract();
    // after, this variable(repository) will be assigned at the same time that the
    // GetConcreteNumberTrivia object is created
    getNumberTriviaUseCase = GetTriviaUseCase(mockTriviaRepositoryContract);
  });

  test(
    'should get trivia for the number from the repository',
    () async {
      // concrete number
      const triviaId = 20;

      // we create an object of NumberTrivia
      // and assign this inside "trivia" variable
      const trivia = Trivia(text: 'test', number: 1);
      // when we request any number of trivia, then
      // we should to return a right trivia
      when(mockTriviaRepositoryContract.getTrivia(any)).thenAnswer((_) async => const Right(trivia));
      // we call to "execute" function which is a Future async function
      // and pass inside it the value 20
      final result = await getNumberTriviaUseCase.run(triviaId);

      // the result expect is successful trivia contained in Right function
      // here we compare two values between the result of the execute function
      // declared above and the mock which is Right function
      expect(result, const Right(trivia));
      // Verify that a method on a mock object was called with the given arguments.
      verify(mockTriviaRepositoryContract.getTrivia(triviaId));
      // Checks if any of given mocks has any unverified interaction.
      verifyNoMoreInteractions(mockTriviaRepositoryContract);
    },
  );
}
