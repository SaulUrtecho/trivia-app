import 'package:clean_architecture_tdd_course/core/network/network_info.dart';
import 'package:clean_architecture_tdd_course/core/util/bloc_observer.dart';
import 'package:clean_architecture_tdd_course/core/util/input_converter.dart';
import 'package:clean_architecture_tdd_course/data/datasources/push_notifications_manager.dart';
import 'package:clean_architecture_tdd_course/data/datasources/trivia_local_data_source.dart';
import 'package:clean_architecture_tdd_course/data/datasources/trivia_remote_data_source.dart';
import 'package:clean_architecture_tdd_course/data/repositories/trivia_repository_impl.dart';

import 'package:clean_architecture_tdd_course/domain/repositories/trivia_repository_contract.dart';
import 'package:clean_architecture_tdd_course/domain/use_cases/get_trivia_use_case.dart';
import 'package:clean_architecture_tdd_course/firebase_options.dart';
import 'package:clean_architecture_tdd_course/presentation/bloc/trivia_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/use_cases/get_random_trivia_use_case.dart';

part 'firebase_module.dart';

// Service Locator
final getIt = GetIt.instance;

Future<void> init() async {
  // Firebase
  await registerFirebase();

  // BlocObserver
  Bloc.observer = SimpleBlocObserver();

  // Bloc
  getIt.registerFactory(
    () => TriviaBloc(
      getIt<GetTriviaUseCase>(),
      getIt<GetRandomTriviaUseCase>(),
      getIt<InputConverter>(),
    ),
  );

  // Use cases
  getIt.registerFactory(() => GetTriviaUseCase(getIt()));
  getIt.registerFactory(() => GetRandomTriviaUseCase(getIt()));

  // Repository
  getIt.registerLazySingleton<TriviaRepositoryContract>(
    () => TriviaRepositoryImpl(
      remoteDataSource: getIt(),
      localDataSource: getIt(),
      networkInfo: getIt(),
    ),
  );

  // Data Sources
  getIt.registerLazySingleton<TriviaRemoteDataSource>(
    () => TriviaRemoteDataSourceImpl(client: getIt()),
  );

  getIt.registerLazySingleton<TriviaLocalDataSource>(
    () => TriviaLocalDataSourceImpl(sharedPreferences: getIt()),
  );

  //! Core
  getIt.registerFactory(() => InputConverter());
  getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(getIt()));

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton(() => sharedPreferences);
  getIt.registerLazySingleton(() => http.Client());
  getIt.registerLazySingleton(() => InternetConnectionChecker());
}
