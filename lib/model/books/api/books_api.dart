import 'package:books_to_read/model/books/entity/book.dart';
import 'package:books_to_read/model/books/entity/paged.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'books_api.g.dart';

@RestApi()
abstract class BooksApi {
  factory BooksApi(Dio dio) = _BooksApi;

  @GET('/search.json')
  Future<Paged<Book>> getBooks({
    @Query('q') required String query,
    @Query('fields') required String fields,
  });
}
