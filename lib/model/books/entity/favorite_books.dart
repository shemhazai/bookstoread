import 'dart:convert';

import 'package:books_to_read/model/books/entity/book.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'favorite_books.freezed.dart';
part 'favorite_books.g.dart';

@freezed
class FavoriteBooks with _$FavoriteBooks {
  const FavoriteBooks._();
  
  const factory FavoriteBooks({
    @JsonKey(name: 'favorites') required List<Book> favorites,
  }) = _FavoriteBooks;

  factory FavoriteBooks.fromJson(Map<String, dynamic> json) => _$FavoriteBooksFromJson(json);

  /// Ensures all fields, including children are serialized into a json map.
  Map<String, dynamic> toFullJson() {
    return jsonDecode(jsonEncode(toJson()));
  }
}
