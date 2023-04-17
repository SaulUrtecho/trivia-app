// ignore_for_file: constant_identifier_names

import 'dart:convert';

import 'package:clean_architecture_tdd_course/core/error/exceptions.dart';
import 'package:clean_architecture_tdd_course/data/models/trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

// abstract class is a contract
abstract class TriviaLocalDataSource {
  /// Gets the cached [TriviaModel] which was gotten the last time
  /// the user had an internet connection
  ///
  /// Throws [CacheException] if no cached data is present
  Future<TriviaModel> getLastTrivia();
  Future<void> saveTrivia(TriviaModel triviaToCache);
}

const CACHED_NUMBER_TRIVIA = 'CACHED_NUMBER_TRIVIA';

class TriviaLocalDataSourceImpl implements TriviaLocalDataSource {
  final SharedPreferences sharedPreferences;

  TriviaLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<TriviaModel> getLastTrivia() {
    final jsonString = sharedPreferences.getString(CACHED_NUMBER_TRIVIA);
    if (jsonString != null) {
      return Future.value(TriviaModel.fromJson(json.decode(jsonString)));
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> saveTrivia(TriviaModel triviaToCache) {
    return sharedPreferences.setString(CACHED_NUMBER_TRIVIA, json.encode(triviaToCache.toJson()));
  }
}
