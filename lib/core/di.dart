import 'package:codebase_assignment/core/services/api_service/api_service.dart';
import 'package:codebase_assignment/core/services/network_connectivity/network_connectitvity.dart';
import 'package:codebase_assignment/core/utils/api_interceptor.dart';
import 'package:codebase_assignment/db/user_db.dart';
import 'package:codebase_assignment/features/users/data/datasource/user_data_source.dart';
import 'package:codebase_assignment/features/users/data/repository/user_repository_impl.dart';
import 'package:codebase_assignment/features/users/domain/repository/user_repository.dart';
import 'package:codebase_assignment/features/users/domain/usecases/fetch_users_usecase.dart';
import 'package:codebase_assignment/features/users/presentation/cubit/user_cubit.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

final di = GetIt.instance;

diSetup() {
  di.registerLazySingleton(
    () => PrettyDioLogger(
      request: true,
      requestBody: true,
      requestHeader: true,
      responseBody: true,
      responseHeader: true,
      logPrint: (log) {
        return debugPrint(log as String);
      },
    ),
  );

  di.registerLazySingleton(() => ApiInterceptor());

  di.registerLazySingleton(
    () => Dio()
      ..interceptors.addAll([
        di.get<PrettyDioLogger>(),
        di.get<ApiInterceptor>(),
      ]),
  );

  di.registerLazySingleton(() => UserDb());
  di.registerLazySingleton(() => Connectivity());
  di.registerLazySingleton(() => ApiService(di.get<Dio>()));

  di.registerLazySingleton<NetworkConnectivityService>(
    () => NetworkConnectivityService(),
  );

  di.registerLazySingleton<UserDatasource>(
    () => UserLocalDatasourceImpl(di.get<UserDb>()),
    instanceName: "local",
  );

  di.registerLazySingleton<UserDatasource>(
    () => UserRemoteDatasourceImpl(
      di.get<ApiService>(),
      di.get<UserDb>(),
    ),
    instanceName: "remote",
  );

  di.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(
      local: di.get<UserDatasource>(instanceName: "local"),
      remote: di.get<UserDatasource>(instanceName: "remote"),
      network: di.get<NetworkConnectivityService>(),
    ),
  );

  di.registerLazySingleton<FetchUsersUseCase>(
    () => FetchUsersUseCase(di.get<UserRepository>()),
  );

  di.registerFactory<UserCubit>(
    () => UserCubit(usecase: di.get<FetchUsersUseCase>()),
  );
}
