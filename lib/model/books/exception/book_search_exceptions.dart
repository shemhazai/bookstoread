/// An exception raised when books could not be fetched due to invalid search query.
class BookSearchInvalidQueryException implements Exception {
  const BookSearchInvalidQueryException();
}

/// An exception raised when books could not be fetched due to unknown reason.
class BookSearchUnknownException implements Exception {
  const BookSearchUnknownException();
}
