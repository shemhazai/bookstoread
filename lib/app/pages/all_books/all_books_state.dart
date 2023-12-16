import 'package:books_to_read/model/books/entity/book.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'all_books_state.freezed.dart';

@freezed
class AllBooksState with _$AllBooksState {
  const factory AllBooksState.loading() = _Loading;
  const factory AllBooksState.empty() = _Empty;
  const factory AllBooksState.noResults() = _NoResults;
  const factory AllBooksState.content({required List<Book> books}) = _Content;
  const factory AllBooksState.error(Object error) = _Error;
}
