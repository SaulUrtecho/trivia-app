import 'dart:convert';

import 'package:clean_architecture_tdd_course/core/error/exceptions.dart';
import 'package:clean_architecture_tdd_course/data/models/trivia_model.dart';
import 'package:http/http.dart' as http;

abstract class TriviaRemoteDataSource {
  /// Calls the http://numbersapi.com/{number} endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<TriviaModel> getTrivia(int number);

  /// Calls the http://numbersapi.com/random endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<TriviaModel> getRandomTrivia();
}

class TriviaRemoteDataSourceImpl implements TriviaRemoteDataSource {
  final http.Client client;

  TriviaRemoteDataSourceImpl({required this.client});

  @override
  Future<TriviaModel> getTrivia(int number) => _getTriviaFromUrl('http://numbersapi.com/$number');

  @override
  Future<TriviaModel> getRandomTrivia() => _getTriviaFromUrl('http://numbersapi.com/random');

  // private method for make the request for both cases above (random & concrete)
  Future<TriviaModel> _getTriviaFromUrl(String url) async {
    final response = await client.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      return TriviaModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }
}
