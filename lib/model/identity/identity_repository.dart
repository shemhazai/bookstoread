abstract class IdentityRepository {
  /// Provides a user ID that stay stable as long as the app is installed.
  Future<String> identify();
}
