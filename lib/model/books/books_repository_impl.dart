import 'dart:io';

import 'package:books_to_read/common/data/app_environment.dart';
import 'package:books_to_read/common/logger/logger.dart';
import 'package:books_to_read/model/books/api/books_api.dart';
import 'package:books_to_read/model/books/books_repository.dart';
import 'package:books_to_read/model/books/entity/book.dart';
import 'package:books_to_read/model/books/entity/paged.dart';
import 'package:books_to_read/model/books/exception/book_search_exceptions.dart';
import 'package:dio/dio.dart';

const Logger _logger = Logger('BooksRepository');

class BooksRepositoryImpl implements BooksRepository {
  final BooksApi _api;
  final AppEnvironment _environment;

  const BooksRepositoryImpl(this._api, this._environment);

  @override
  Future<Paged<Book>> searchBooks(String query) async {
    try {
      return await _api.getBooks(
        query: query,
        fields: Book.fields.join(','),
      );
    } on DioException catch (error, stackTrace) {
      _logger.logError(error, stackTrace);

      final statusCode = error.response?.statusCode ?? HttpStatus.ok;
      if (statusCode >= HttpStatus.badRequest && statusCode < HttpStatus.internalServerError) {
        throw const BookSearchInvalidQueryException();
      } else {
        throw const BookSearchUnknownException();
      }
    }
  }

  @override
  String buildCoverUrl(int coverId) {
    return _environment.coversUrl + 'b/id/$coverId-M.jpg';
  }
}
