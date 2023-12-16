import 'dart:async';

import 'package:books_to_read/app/pages/all_books/all_books_state.dart';
import 'package:books_to_read/model/books/books_repository.dart';
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
      if (books.isEmpty) {
        emit(const AllBooksState.noResults());
      } else {
        emit(AllBooksState.content(books: books.docs));
      }
    } on Exception catch (ex) {
      emit(AllBooksState.error(ex));
    }
  }
}
