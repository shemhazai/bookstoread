import 'dart:async';

import 'package:books_to_read/app/pages/favorite_books/favorite_books_state.dart';
import 'package:books_to_read/model/books/books_repository.dart';
import 'package:books_to_read/model/books/entity/book.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoriteBooksCubit extends Cubit<FavoriteBooksState> {
  final BooksRepository _booksRepository;

  FavoriteBooksCubit(this._booksRepository) : super(const FavoriteBooksState.empty());

  Future<void> loadData() async {
    try {
      emit(const FavoriteBooksState.loading());

      final books = await _booksRepository.getFavoriteBooks();
      if (books.isEmpty) {
        emit(const FavoriteBooksState.empty());
      } else {
        emit(FavoriteBooksState.content(books: books));
      }
    } on Exception catch (ex) {
      emit(FavoriteBooksState.error(ex));
    }
  }

  Future<void> saveFavoriteBook(Book book) async {
    // optimistically assume the operation will succeed to refresh UI immediatelly
    final state = this.state;
    if (state is FavoriteBooksStateContent) {
      final updatedState = FavoriteBooksState.content(
        books: [...state.books, book],
      );

      emit(updatedState);
    }

    try {
      await _booksRepository.saveFavoriteBook(book);
    } catch (error) {
      // TODO: show error and revert state update
    }
  }

  Future<void> removeFavoriteBook(Book book) async {
    // optimistically assume the operation will succeed to refresh UI immediatelly
    final state = this.state;
    if (state is FavoriteBooksStateContent) {
      final updatedState = FavoriteBooksState.content(
        books: state.books.where((e) => e.key != book.key).toList(),
      );

      emit(updatedState);
    }

    try {
      await _booksRepository.removeFavoriteBook(book);
    } catch (error) {
      // TODO: show error and revert state update
    }
  }
}
