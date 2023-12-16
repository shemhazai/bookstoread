import 'package:books_to_read/model/books/entity/book.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'favorite_books_state.freezed.dart';

@freezed
class FavoriteBooksState with _$FavoriteBooksState {
  const factory FavoriteBooksState.loading() = FavoriteBooksStateLoading;
  const factory FavoriteBooksState.empty() = FavoriteBooksStateEmpty;
  const factory FavoriteBooksState.content({required List<Book> books}) = FavoriteBooksStateContent;
  const factory FavoriteBooksState.error(Object error) = AllBooksStateError;
}
