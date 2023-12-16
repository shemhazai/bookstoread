import 'package:freezed_annotation/freezed_annotation.dart';

part 'book.freezed.dart';
part 'book.g.dart';

@freezed
class Book with _$Book {
  const factory Book({
    @JsonKey(name: 'title') required String title,
    @JsonKey(name: 'author_name') required List<String> authorNames,
    @JsonKey(name: 'ratings_average') required double ratingsAverage,
    @JsonKey(name: 'cover_i') required int? coverId,
  }) = _Book;

  factory Book.fromJson(Map<String, dynamic> json) => _$BookFromJson(json);
}
