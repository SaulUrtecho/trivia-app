import 'package:clean_architecture_tdd_course/domain/entities/trivia_entity.dart';

class TriviaModel extends Trivia {
  const TriviaModel({
    required super.text,
    required super.number,
  });

  factory TriviaModel.fromJson(Map<String, dynamic> json) {
    return TriviaModel(
      text: json['text'],
      number: (json['number'] as num).toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'number': number,
    };
  }
}
