import 'package:books_to_read/model/books/entity/book.dart';
import 'package:books_to_read/model/books/entity/paged.dart';
import 'package:books_to_read/model/books/exception/book_search_exceptions.dart';

/// An abstraction over a concrete data source for books.
abstract class BooksRepository {
  /// Searchs for books with given [query].
  ///
  /// Throws [BookSearchInvalidQueryException] if the query is invalid or not supported.
  /// Throws [BookSearchUnknownException] if there is an unknown failure.
  Future<Paged<Book>> searchBooks(String query);

  /// Builds a url to fetch a network image representing a cover of the book with [coverId].
  String buildCoverUrl(int coverId);
}
