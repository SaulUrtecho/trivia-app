import 'package:clean_architecture_tdd_course/core/error/failures.dart';
import 'package:clean_architecture_tdd_course/core/util/input_converter.dart';
import 'package:clean_architecture_tdd_course/domain/entities/trivia_entity.dart';
import 'package:clean_architecture_tdd_course/domain/use_cases/get_trivia_use_case.dart';
import 'package:clean_architecture_tdd_course/domain/use_cases/get_random_trivia_use_case.dart';
import 'package:clean_architecture_tdd_course/presentation/bloc/trivia_bloc.dart';

import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([
  MockSpec<GetTriviaUseCase>(),
  MockSpec<GetRandomTriviaUseCase>(),
  MockSpec<InputConverter>(),
])
import 'trivia_bloc_test.mocks.dart';

void main() {
  late TriviaBloc bloc;
  late MockGetTriviaUseCase mockGetTriviaUseCase;
  late MockGetRandomTriviaUseCase mockGetRandomTriviaUseCase;
  late MockInputConverter mockInputConverter;

  setUp(() {
    mockGetTriviaUseCase = MockGetTriviaUseCase();
    mockGetRandomTriviaUseCase = MockGetRandomTriviaUseCase();
    mockInputConverter = MockInputConverter();

    bloc = TriviaBloc(
      mockGetTriviaUseCase,
      mockGetRandomTriviaUseCase,
      mockInputConverter,
    );
  });

  test('initialState should be empty', () {
    expect(bloc.state, equals(Empty()));
  });

  // TODO(Saul): search how to do bloc testing
  group('GetTriviaForConcreteNumber', () {
    const tNumberString = '1';
    const tNumberParsed = 1;
    const tNumberTrivia = Trivia(text: 'test trivia', number: 1);

    /* test('should call the InputConverter to validate and convert the string to an unsigned integer', () async {
      when(mockInputConverterTest.stringToUnsignedInteger(any)).thenReturn(const Right(tNumberParsed));

      bloc.add(const GetTriviaForConcreteNumber(tNumberString));
      await untilCalled(mockInputConverterTest.stringToUnsignedInteger(any));
      verify(mockInputConverterTest.stringToUnsignedInteger(tNumberString));
    }); */

    test('should emit [Error] when the input is invalid', () async {
      when(mockInputConverter.stringToUnsignedInteger(any)).thenReturn(Left(InvalidInputFailure()));

      final expected = [
        //Empty(),
        const Error(message: INVALID_INPUT_FAILURE_MESSAGE),
      ];
      bloc.add(const GetTriviaByNumber(tNumberString));
      expectLater(bloc.stream.asBroadcastStream(), emitsInOrder(expected));
    });

    test('should get data from the concrete use case', () async {
      when(mockInputConverter.stringToUnsignedInteger(any)).thenReturn(const Right(tNumberParsed));
      when(mockGetTriviaUseCase.run(any)).thenAnswer((_) async => const Right(tNumberTrivia));

      bloc.add(const GetTriviaByNumber(tNumberString));
      await untilCalled(mockGetTriviaUseCase.run(any));
      verify(mockGetTriviaUseCase.run(tNumberParsed));
    });

    test('should emit [Loading, Loaded] when data is gotten successfully', () async {
      when(mockInputConverter.stringToUnsignedInteger(any)).thenReturn(const Right(tNumberParsed));
      when(mockGetTriviaUseCase.run(any)).thenAnswer((_) async => const Right(tNumberTrivia));

      final expected = [
        //Empty(),
        Loading(),
        const Loaded(trivia: tNumberTrivia),
      ];
      bloc.add(const GetTriviaByNumber(tNumberString));
      expectLater(bloc.stream.asBroadcastStream(), emitsInOrder(expected));
    });

    test('should emit [Loading, Error] when getting data fails', () async {
      when(mockInputConverter.stringToUnsignedInteger(any)).thenReturn(const Right(tNumberParsed));
      when(mockGetTriviaUseCase.run(any)).thenAnswer((_) async => Left(ServerFailure()));

      final expected = [
        //Empty(),
        Loading(),
        const Error(message: SERVER_FAILURE_MESSAGE),
      ];
      bloc.add(const GetTriviaByNumber(tNumberString));
      expectLater(bloc.stream.asBroadcastStream(), emitsInOrder(expected));
    });

    test('should emit [Loading, Error] whit a proper message for the error when getting data fails', () async {
      when(mockInputConverter.stringToUnsignedInteger(any)).thenReturn(const Right(tNumberParsed));
      when(mockGetTriviaUseCase.run(any)).thenAnswer((_) async => Left(CacheFailure()));

      final expected = [
        //Empty(),
        Loading(),
        const Error(message: CACHE_FAILURE_MESSAGE),
      ];
      bloc.add(const GetTriviaByNumber(tNumberString));
      expectLater(bloc.stream.asBroadcastStream(), emitsInOrder(expected));
    });
  });

  group('GetTriviaForRandomNumber', () {
    const tNumberTrivia = Trivia(text: 'test trivia', number: 1);

    test('should get data from the random use case', () async {
      when(mockGetRandomTriviaUseCase.run()).thenAnswer((_) async => const Right(tNumberTrivia));

      bloc.add(GetTriviaByRandomNumber());
      await untilCalled(mockGetRandomTriviaUseCase.run());
      verify(mockGetRandomTriviaUseCase.run());
    });

    test('should emit [Loading, Loaded] when data is gotten successfully', () async {
      when(mockGetRandomTriviaUseCase.run()).thenAnswer((_) async => const Right(tNumberTrivia));

      final expected = [
        //Empty(),
        Loading(),
        const Loaded(trivia: tNumberTrivia),
      ];
      bloc.add(GetTriviaByRandomNumber());
      expectLater(bloc.stream.asBroadcastStream(), emitsInOrder(expected));
    });

    test('should emit [Loading, Error] when getting data fails', () async {
      when(mockGetRandomTriviaUseCase.run()).thenAnswer((_) async => Left(ServerFailure()));

      final expected = [
        //Empty(),
        Loading(),
        const Error(message: SERVER_FAILURE_MESSAGE),
      ];
      bloc.add(GetTriviaByRandomNumber());
      expectLater(bloc.stream.asBroadcastStream(), emitsInOrder(expected));
    });

    test('should emit [Loading, Error] whit a proper message for the error when getting data fails', () async {
      when(mockGetRandomTriviaUseCase.run()).thenAnswer((_) async => Left(CacheFailure()));

      final expected = [
        //Empty(),
        Loading(),
        const Error(message: CACHE_FAILURE_MESSAGE),
      ];
      bloc.add(GetTriviaByRandomNumber());
      expectLater(bloc.stream.asBroadcastStream(), emitsInOrder(expected));
    });
  });
}
