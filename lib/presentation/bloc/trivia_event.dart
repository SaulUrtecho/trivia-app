part of 'trivia_bloc.dart';

abstract class TriviaEvent extends Equatable {
  const TriviaEvent();

  @override
  List<Object> get props => [];
}

class GetTriviaByNumber extends TriviaEvent {
  final String numberString;
  @override
  List<Object> get props => [numberString];

  const GetTriviaByNumber(this.numberString);
}

class GetTriviaByRandomNumber extends TriviaEvent {}
