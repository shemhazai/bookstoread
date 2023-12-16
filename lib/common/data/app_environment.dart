import 'package:freezed_annotation/freezed_annotation.dart';
part 'app_environment.freezed.dart';

/// A configuration for the app which depends on the environment.
@freezed
class AppEnvironment with _$AppEnvironment {
  static const AppEnvironment development = AppEnvironment(
    name: 'development',
    baseUrl: 'https://openlibrary.org/',
    coversUrl: 'https://covers.openlibrary.org/',
  );

  const factory AppEnvironment({
    required String name,
    required String baseUrl,
    required String coversUrl,
  }) = _AppEnvironment;
}
