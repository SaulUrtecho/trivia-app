import 'dart:convert';

import 'package:clean_architecture_tdd_course/core/error/exceptions.dart';
import 'package:clean_architecture_tdd_course/data/datasources/trivia_remote_data_source.dart';
import 'package:clean_architecture_tdd_course/data/models/trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' show Client, Response;

import '../../fixtures/fixture_reader.dart';
@GenerateNiceMocks([MockSpec<Client>()])
import 'trivia_remote_datasource_test.mocks.dart';

void main() {
  late TriviaRemoteDataSourceImpl dataSource;
  late MockClient mockClient;

  setUp(() {
    mockClient = MockClient();
    dataSource = TriviaRemoteDataSourceImpl(client: mockClient);
  });

  group('getConcreteNumberTrivia', () {
    const tNumber = 1;
    final tNumberTriviaModel = TriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test('''should perform a GET request on a URL with number 
            being the endpoint and with application/json header''', () async {
      when(mockClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => Response(fixture('trivia.json'), 200));

      dataSource.getTrivia(tNumber);

      verify(mockClient.get(Uri.parse('http://numbersapi.com/$tNumber'), headers: {
        'Content-Type': 'application/json',
      }));
    });

    test('should return NumberTrivia when the response code is 200 (success)', () async {
      when(mockClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => Response(fixture('trivia.json'), 200));

      final result = await dataSource.getTrivia(tNumber);

      expect(result, equals(tNumberTriviaModel));
    });

    test('should throw a ServerException when the response code is 404 or other', () async {
      when(mockClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => Response('Something went wrong', 404));

      final call = dataSource.getTrivia;
      expect(() => call(tNumber), throwsA(const TypeMatcher<ServerException>()));
    });
  });

  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel = TriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test('''should perform a GET request on a URL with number 
            being the endpoint and with application/json header''', () async {
      when(mockClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => Response(fixture('trivia.json'), 200));

      dataSource.getRandomTrivia();

      verify(mockClient.get(Uri.parse('http://numbersapi.com/random'), headers: {
        'Content-Type': 'application/json',
      }));
    });

    test('should return NumberTrivia when the response code is 200 (success)', () async {
      when(mockClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => Response(fixture('trivia.json'), 200));

      final result = await dataSource.getRandomTrivia();

      expect(result, equals(tNumberTriviaModel));
    });

    test('should throw a ServerException when the response code is 404 or other', () async {
      when(mockClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => Response('Something went wrong', 404));

      final call = dataSource.getRandomTrivia;
      expect(() => call(), throwsA(const TypeMatcher<ServerException>()));
    });
  });
}
