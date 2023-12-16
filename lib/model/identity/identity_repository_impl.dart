import 'package:books_to_read/model/identity/identity_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

const String _identityKey = 'identity';

class IdentityRepositoryImpl implements IdentityRepository {
  // TODO: make it safe to run in async, currently it's possible
  // but unlikely that two identities will be generated for a single user.
  @override
  Future<String> identify() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_identityKey) ?? await _generateIdentity();
  }

  Future<String> _generateIdentity() async {
    final identity = const Uuid().v4();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_identityKey, identity);
    return identity;
  }
}
