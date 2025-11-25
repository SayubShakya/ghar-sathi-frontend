// dart
import 'package:get_storage/get_storage.dart';
import 'package:loginappv2/src/utils/get_storage_key.dart';

// token_manager.dart
class TokenManager {
  static final TokenManager _inst = TokenManager._internal();
  factory TokenManager() => _inst;
  TokenManager._internal();

  final GetStorage _storage = GetStorage();

  Future<void> saveAccessToken(String token) async {
    await _storage.write(GetStorageKey.accessToken, token);
  }

  Future<String?> getAccessToken() async {
    // FIX: Remove the unnecessary async/await that was causing Future<Future<String?>>
    return _storage.read(GetStorageKey.accessToken) as String?;
  }

  Future<void> clearAccessToken() async {
    await _storage.remove(GetStorageKey.accessToken);
  }
}