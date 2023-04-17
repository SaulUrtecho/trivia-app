import 'package:clean_architecture_tdd_course/core/error/exceptions.dart';
import 'package:clean_architecture_tdd_course/core/error/failures.dart';
import 'package:clean_architecture_tdd_course/core/network/network_info.dart';
import 'package:clean_architecture_tdd_course/data/datasources/trivia_local_data_source.dart';
import 'package:clean_architecture_tdd_course/data/datasources/trivia_remote_data_source.dart';
import 'package:clean_architecture_tdd_course/data/models/trivia_model.dart';
import 'package:clean_architecture_tdd_course/data/repositories/trivia_repository_impl.dart';
import 'package:clean_architecture_tdd_course/domain/entities/trivia_entity.dart';
import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([
  MockSpec<TriviaRemoteDataSource>(),
  MockSpec<TriviaLocalDataSource>(),
  MockSpec<NetworkInfo>(),
])
import 'trivia_repository_impl_test.mocks.dart';

void main() {
  late TriviaRepositoryImpl repository;
  late MockTriviaRemoteDataSource mockTriviaRemoteDataSource;
  late MockTriviaLocalDataSource mockTriviaLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockTriviaRemoteDataSource = MockTriviaRemoteDataSource();
    mockTriviaLocalDataSource = MockTriviaLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();

    repository = TriviaRepositoryImpl(
      remoteDataSource: mockTriviaRemoteDataSource,
      localDataSource: mockTriviaLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  void runTestOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      body();
    });
  }

  void runTestOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      body();
    });
  }

  group('getConcreteNumberTrivia', () {
    const tNumber = 1;
    const tNumberTriviaModel = TriviaModel(text: 'test trivia', number: tNumber);
    const Trivia tNumberTrivia = tNumberTriviaModel;
    test('should check if the device is online', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

      repository.getTrivia(tNumber);

      verify(mockNetworkInfo.isConnected);
    });

    runTestOnline(() {
      test('should return remote data when the call to remote data source is successful', () async {
        when(mockTriviaRemoteDataSource.getTrivia(any)).thenAnswer((_) async => tNumberTriviaModel);

        final result = await repository.getTrivia(tNumber);

        verify(mockTriviaRemoteDataSource.getTrivia(tNumber));
        expect(result, equals(const Right(tNumberTrivia)));
      });

      test('should cache the data locally when the call to remote data source is successful', () async {
        when(mockTriviaRemoteDataSource.getTrivia(any)).thenAnswer((_) async => tNumberTriviaModel);

        await repository.getTrivia(tNumber);

        verify(mockTriviaRemoteDataSource.getTrivia(tNumber));
        verify(mockTriviaLocalDataSource.saveTrivia(tNumberTriviaModel));
      });

      test('should return server failure when the call to remote data source is unsuccessful', () async {
        when(mockTriviaRemoteDataSource.getTrivia(any)).thenThrow(ServerException());

        final result = await repository.getTrivia(tNumber);

        verify(mockTriviaRemoteDataSource.getTrivia(tNumber));
        verifyZeroInteractions(mockTriviaLocalDataSource);
        expect(result, equals(Left(ServerFailure())));
      });
    });

    runTestOffline(() {
      test('should return last locally cached data when the cached data is present', () async {
        when(mockTriviaLocalDataSource.getLastTrivia()).thenAnswer((_) async => tNumberTriviaModel);

        final result = await repository.getTrivia(tNumber);
        verifyZeroInteractions(mockTriviaRemoteDataSource);
        verify(mockTriviaLocalDataSource.getLastTrivia());
        expect(result, equals(const Right(tNumberTrivia)));
      });

      test('should return CacheFailure when there is no cached data present', () async {
        when(mockTriviaLocalDataSource.getLastTrivia()).thenThrow(CacheException());

        final result = await repository.getTrivia(tNumber);
        verifyZeroInteractions(mockTriviaRemoteDataSource);
        verify(mockTriviaLocalDataSource.getLastTrivia());
        expect(result, equals(Left(CacheFailure())));
      });
    });
  });

  group('getRandomNumberTrivia', () {
    const tNumberTriviaModel = TriviaModel(text: 'test trivia', number: 123);
    const Trivia tNumberTrivia = tNumberTriviaModel;
    test('should check if the device is online', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

      repository.getRandomTrivia();

      verify(mockNetworkInfo.isConnected);
    });

    runTestOnline(() {
      test('should return remote data when the call to remote data source is successful', () async {
        when(mockTriviaRemoteDataSource.getRandomTrivia()).thenAnswer((_) async => tNumberTriviaModel);

        final result = await repository.getRandomTrivia();

        verify(mockTriviaRemoteDataSource.getRandomTrivia());
        expect(result, equals(const Right(tNumberTrivia)));
      });

      test('should cache the data locally when the call to remote data source is successful', () async {
        when(mockTriviaRemoteDataSource.getRandomTrivia()).thenAnswer((_) async => tNumberTriviaModel);

        await repository.getRandomTrivia();

        verify(mockTriviaRemoteDataSource.getRandomTrivia());
        verify(mockTriviaLocalDataSource.saveTrivia(tNumberTriviaModel));
      });

      test('should return server failure when the call to remote data source is unsuccessful', () async {
        when(mockTriviaRemoteDataSource.getRandomTrivia()).thenThrow(ServerException());

        final result = await repository.getRandomTrivia();

        verify(mockTriviaRemoteDataSource.getRandomTrivia());
        verifyZeroInteractions(mockTriviaLocalDataSource);
        expect(result, equals(Left(ServerFailure())));
      });
    });

    runTestOffline(() {
      test('should return last locally cached data when the cached data is present', () async {
        when(mockTriviaLocalDataSource.getLastTrivia()).thenAnswer((_) async => tNumberTriviaModel);

        final result = await repository.getRandomTrivia();
        verifyZeroInteractions(mockTriviaRemoteDataSource);
        verify(mockTriviaLocalDataSource.getLastTrivia());
        expect(result, equals(const Right(tNumberTrivia)));
      });

      test('should return CacheFailure when there is no cached data present', () async {
        when(mockTriviaLocalDataSource.getLastTrivia()).thenThrow(CacheException());

        final result = await repository.getRandomTrivia();
        verifyZeroInteractions(mockTriviaRemoteDataSource);
        verify(mockTriviaLocalDataSource.getLastTrivia());
        expect(result, equals(Left(CacheFailure())));
      });
    });
  });
}
