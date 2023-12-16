import 'package:books_to_read/model/books/entity/book.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'all_books_state.freezed.dart';

@freezed
class AllBooksState with _$AllBooksState {
  const factory AllBooksState.loading() = AllBooksStateLoading;
  const factory AllBooksState.empty() = AllBooksStateEmpty;
  const factory AllBooksState.noResults() = AllBooksStateNoResults;
  const factory AllBooksState.content({
    required List<Book> books,
    required List<Book> favoriteBooks,
  }) = AllBooksStateContent;
  const factory AllBooksState.error(Object error) = AllBooksStateError;
}
