import 'package:books_to_read/app/di/di.dart';
import 'package:books_to_read/common/data/app_environment.dart';
import 'package:books_to_read/model/books/api/books_api.dart';
import 'package:books_to_read/model/books/books_repository.dart';
import 'package:books_to_read/model/books/books_repository_impl.dart';
import 'package:books_to_read/model/identity/identity_repository.dart';
import 'package:books_to_read/model/identity/identity_repository_impl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

/// A module that provides apis/repositories/data sources for DI.
abstract class RepositoriesModule {
  static void register(GetIt locator) {
    locator.registerLazySingleton(() => _buildDio(inject<AppEnvironment>()));
    locator.registerLazySingleton<IdentityRepository>(IdentityRepositoryImpl.new);
    locator.registerLazySingleton(() => BooksApi(inject<Dio>()));
    locator.registerLazySingleton<BooksRepository>(() => BooksRepositoryImpl(
          inject<BooksApi>(),
          FirebaseFirestore.instance,
          inject<IdentityRepository>(),
          inject<AppEnvironment>(),
        ));
  }
}

Dio _buildDio(AppEnvironment environment) {
  return Dio()
    ..options = BaseOptions(baseUrl: environment.baseUrl)
    ..interceptors.addAll([
      if (kDebugMode) PrettyDioLogger(requestHeader: true, requestBody: true),
    ]);
}
