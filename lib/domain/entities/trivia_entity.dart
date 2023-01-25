import 'package:equatable/equatable.dart';

class Trivia extends Equatable {
  final String text;
  final int number;

  const Trivia({required this.text, required this.number});

  @override
  List<Object?> get props => [text, number];
}
