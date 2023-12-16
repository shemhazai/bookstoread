import 'dart:io';

import 'package:books_to_read/common/data/app_environment.dart';
import 'package:books_to_read/common/logger/logger.dart';
import 'package:books_to_read/model/books/api/books_api.dart';
import 'package:books_to_read/model/books/books_repository.dart';
import 'package:books_to_read/model/books/entity/book.dart';
import 'package:books_to_read/model/books/entity/favorite_books.dart';
import 'package:books_to_read/model/books/entity/paged.dart';
import 'package:books_to_read/model/books/exception/book_search_exceptions.dart';
import 'package:books_to_read/model/identity/identity_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';

const Logger _logger = Logger('BooksRepository');
const String _favoriteBooksCollection = 'favorite_books_by_users';

class BooksRepositoryImpl implements BooksRepository {
  final BooksApi _api;
  final FirebaseFirestore _firestore;
  final IdentityRepository _identity;
  final AppEnvironment _environment;

  const BooksRepositoryImpl(
    this._api,
    this._firestore,
    this._identity,
    this._environment,
  );

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
  Future<List<Book>> getFavoriteBooks() async {
    _logger.log('getFavoriteBooks');

    final identity = await _identity.identify();
    final document = await _firestore.collection(_favoriteBooksCollection).doc(identity).get();
    final books = _mapFavoriteBooks(document.data());
    return books.favorites;
  }

  @override
  Future<void> saveFavoriteBook(Book book) async {
    _logger.log('saveFavoriteBook: ${book.key}');

    final identity = await _identity.identify();
    final document = await _firestore.collection(_favoriteBooksCollection).doc(identity).get();
    final books = _mapFavoriteBooks(document.data());
    final newBooks = books.copyWith(favorites: [...books.favorites, book]);

    await _firestore.collection(_favoriteBooksCollection).doc(identity).set(newBooks.toFullJson());
  }

  @override
  Future<void> removeFavoriteBook(Book book) async {
    _logger.log('removeFavoriteBook: ${book.key}');

    final identity = await _identity.identify();
    final document = await _firestore.collection(_favoriteBooksCollection).doc(identity).get();
    final books = _mapFavoriteBooks(document.data());
    final newBooks = books.copyWith(favorites: books.favorites.where((e) => e.key != book.key).toList());

    await _firestore.collection(_favoriteBooksCollection).doc(identity).set(newBooks.toFullJson());
  }

  @override
  String buildCoverUrl(int coverId) {
    return _environment.coversUrl + 'b/id/$coverId-M.jpg';
  }

  FavoriteBooks _mapFavoriteBooks(Map<String, dynamic>? data) {
    if (data == null) {
      return const FavoriteBooks(favorites: []);
    }

    return FavoriteBooks.fromJson(data);
  }
}
