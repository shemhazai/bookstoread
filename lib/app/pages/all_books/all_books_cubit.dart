import 'dart:async';

import 'package:books_to_read/app/pages/all_books/all_books_state.dart';
import 'package:books_to_read/model/books/books_repository.dart';
import 'package:books_to_read/model/books/entity/book.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AllBooksCubit extends Cubit<AllBooksState> {
  final BooksRepository _booksRepository;

  AllBooksCubit(this._booksRepository) : super(const AllBooksState.noResults());

  Future<void> search(String text) async {
    try {
      // TODO: implement debouncing to not spam server with search queries.
      // TODO: implement pagination to not load all data at once.

      if (text.isEmpty) {
        emit(const AllBooksState.empty());
        return;
      }

      emit(const AllBooksState.loading());

      final books = await _booksRepository.searchBooks(text);
      final favoriteBooks = await _booksRepository.getFavoriteBooks();
      if (books.isEmpty) {
        emit(const AllBooksState.noResults());
      } else {
        emit(AllBooksState.content(
          books: books.docs,
          favoriteBooks: favoriteBooks,
        ));
      }
    } on Exception catch (ex) {
      emit(AllBooksState.error(ex));
    }
  }

  Future<void> saveFavoriteBook(Book book) async {
    // optimistically assume the operation will succeed to refresh UI immediatelly
    final state = this.state;
    if (state is AllBooksStateContent) {
      final updatedState = AllBooksState.content(
        books: state.books,
        favoriteBooks: [...state.favoriteBooks, book],
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
    if (state is AllBooksStateContent) {
      final updatedState = AllBooksState.content(
        books: state.books,
        favoriteBooks: state.favoriteBooks.where((e) => e.key != book.key).toList(),
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
