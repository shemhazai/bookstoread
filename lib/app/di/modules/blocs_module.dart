import 'package:books_to_read/app/di/di.dart';
import 'package:books_to_read/app/pages/all_books/all_books_cubit.dart';
import 'package:books_to_read/app/pages/favorite_books/favorite_books_cubit.dart';
import 'package:books_to_read/model/books/books_repository.dart';
import 'package:get_it/get_it.dart';

/// A module that provides blocs/cubit for DI.
abstract class BlocsModule {
  static void register(GetIt locator) {
    locator.registerFactory(() => AllBooksCubit(inject<BooksRepository>()));
    locator.registerFactory(() => FavoriteBooksCubit(inject<BooksRepository>()));
  }
}
