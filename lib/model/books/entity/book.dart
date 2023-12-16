import 'package:freezed_annotation/freezed_annotation.dart';

part 'book.freezed.dart';
part 'book.g.dart';

@freezed
class Book with _$Book {
  /// A list of fields to be fetched from the API,
  /// helps to reduce the response size.
  static const List<String> fields = ['key', 'title', 'author_name', 'cover_i'];

  const factory Book({
    @JsonKey(name: 'key') required String key,
    @JsonKey(name: 'title') required String title,
    @JsonKey(name: 'author_name') required List<String>? authorNames,
    @JsonKey(name: 'cover_i') required int? coverId,
  }) = _Book;

  factory Book.fromJson(Map<String, dynamic> json) => _$BookFromJson(json);
}
