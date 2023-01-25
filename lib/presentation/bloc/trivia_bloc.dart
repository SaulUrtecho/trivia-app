// ignore_for_file: constant_identifier_names

import 'package:clean_architecture_tdd_course/core/error/failures.dart';
import 'package:clean_architecture_tdd_course/core/util/input_converter.dart';
import 'package:clean_architecture_tdd_course/domain/entities/trivia_entity.dart';
import 'package:clean_architecture_tdd_course/domain/use_cases/get_trivia_use_case.dart';
import 'package:clean_architecture_tdd_course/domain/use_cases/get_random_trivia_use_case.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'trivia_event.dart';
part 'trivia_state.dart';

const SERVER_FAILURE_MESSAGE = 'Server Failure';
const CACHE_FAILURE_MESSAGE = 'Cache Failure';
const INVALID_INPUT_FAILURE_MESSAGE = 'Invalid Input - The number must be a positive integer or zero';

class TriviaBloc extends Bloc<TriviaEvent, TriviaState> {
  final GetTriviaUseCase _getTriviaUseCase;
  final GetRandomTriviaUseCase _getRandomTriviaUseCase;
  final InputConverter inputConverter;

  TriviaBloc(
    this._getTriviaUseCase,
    this._getRandomTriviaUseCase,
    this.inputConverter,
  ) : super(Empty()) {
    on<GetTriviaByNumber>(_getTriviaByNumber);
    on<GetTriviaByRandomNumber>(_getTriviaByRandomNumber);
  }

  void _getTriviaByNumber(GetTriviaByNumber event, Emitter<TriviaState> emit) async {
    final inputResult = inputConverter.stringToUnsignedInteger(event.numberString);
    if (inputResult.isRight) {
      emit(Loading());
      final result = await _getTriviaUseCase.run(inputResult.right);
      if (result.isRight) {
        emit(Loaded(trivia: result.right));
      } else {
        final error = Error(message: result.left is ServerFailure ? SERVER_FAILURE_MESSAGE : CACHE_FAILURE_MESSAGE);
        emit(error);
      }
    } else {
      emit(const Error(message: INVALID_INPUT_FAILURE_MESSAGE));
    }
  }

  void _getTriviaByRandomNumber(GetTriviaByRandomNumber event, Emitter<TriviaState> emit) async {
    emit(Loading()); // we change the state
    final result = await _getRandomTriviaUseCase.run();
    if (result.isRight) {
      emit(Loaded(trivia: result.right)); // we change the state
    } else {
      final error = Error(message: result.left is ServerFailure ? SERVER_FAILURE_MESSAGE : CACHE_FAILURE_MESSAGE);
      emit(error);
    }
  }
}
