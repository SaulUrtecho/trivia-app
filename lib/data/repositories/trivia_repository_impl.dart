import 'package:clean_architecture_tdd_course/core/error/exceptions.dart';
import 'package:clean_architecture_tdd_course/core/network/network_info.dart';
import 'package:clean_architecture_tdd_course/data/datasources/trivia_local_data_source.dart';
import 'package:clean_architecture_tdd_course/data/datasources/trivia_remote_data_source.dart';
import 'package:clean_architecture_tdd_course/data/models/trivia_model.dart';
import 'package:clean_architecture_tdd_course/domain/entities/trivia_entity.dart';
import 'package:clean_architecture_tdd_course/core/error/failures.dart';
import 'package:clean_architecture_tdd_course/domain/repositories/trivia_repository_contract.dart';
//import 'package:dartz/dartz.dart';
import 'package:either_dart/either.dart';

class TriviaRepositoryImpl implements TriviaRepositoryContract {
  final TriviaRemoteDataSource remoteDataSource;
  final TriviaLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  TriviaRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, Trivia>> getTrivia(int number) async {
    return _getTrivia(() => remoteDataSource.getTrivia(number));
  }

  @override
  Future<Either<Failure, Trivia>> getRandomTrivia() async {
    return _getTrivia(() => remoteDataSource.getRandomTrivia());
  }

  Future<Either<Failure, Trivia>> _getTrivia(Future<TriviaModel> Function() getConcreteOrRandom) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteTrivia = await getConcreteOrRandom();
        localDataSource.cacheTrivia(remoteTrivia);
        return Right(remoteTrivia);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localTrivia = await localDataSource.getLastTrivia();
        return Right(localTrivia);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
