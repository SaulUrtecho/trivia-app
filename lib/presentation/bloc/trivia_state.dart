part of 'trivia_bloc.dart';

abstract class TriviaState extends Equatable {
  const TriviaState();

  @override
  List<Object> get props => [];
}

class Empty extends TriviaState {}

class Loading extends TriviaState {}

class Loaded extends TriviaState {
  final Trivia trivia;

  const Loaded({required this.trivia});

  @override
  List<Object> get props => [trivia];
}

class Error extends TriviaState {
  final String message;

  const Error({required this.message});

  @override
  List<Object> get props => [message];
}
