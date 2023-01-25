import 'dart:convert';

import 'package:clean_architecture_tdd_course/domain/entities/trivia_entity.dart';
import 'package:clean_architecture_tdd_course/data/models/trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fixtures/fixture_reader.dart';

void main() {
  const tNumberTriviaModel = TriviaModel(number: 1, text: 'Test Text');

  test(
    'should be a subclass of a NumberTrivia entity',
    () async {
      expect(tNumberTriviaModel, isA<Trivia>());
    },
  );

  group('fromJSON', () {
    test(
      'should return a valid model when the JSON number is an integer',
      () async {
        final Map<String, dynamic> jsonMap = json.decode(fixture('trivia.json'));

        final result = TriviaModel.fromJson(jsonMap);

        expect(result, tNumberTriviaModel);
      },
    );

    test(
      'should return a valid model when the JSON number is regarded as a double',
      () async {
        final Map<String, dynamic> jsonMap = json.decode(fixture('trivia_double.json'));

        final result = TriviaModel.fromJson(jsonMap);

        expect(result, tNumberTriviaModel);
      },
    );
  });

  group(
    'toJSON',
    () {
      test('should return a JSON map containing the proper data', () async {
        final result = tNumberTriviaModel.toJson();

        final expectedMap = {
          "text": "Test Text",
          "number": 1,
        };
        expect(result, expectedMap);
      });
    },
  );
}
