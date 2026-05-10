import 'package:clean_architecture/core/error/exceptions.dart';
import 'package:clean_architecture/core/storage/local_storage.dart';
import 'package:clean_architecture/core/storage/shared_preferences_storage.dart';

abstract class AuthLocalDataSource {
  Future<void> saveSession(String mobile, String token);

  Future<void> clearSession();

  Future<bool> isLoggedIn();

  Future<String?> getSavedMobile();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final LocalStorage storage;

  const AuthLocalDataSourceImpl({required this.storage});

  @override
  Future<void> saveSession(String mobile, String token) async {
    try {
      await storage.setBool(StorageKeys.isLoggedIn, true);
      await storage.setString(StorageKeys.userMobile, mobile);
      await storage.setString(StorageKeys.authToken, token);
    } catch (e) {
      throw CacheException(message: 'Failed to save session: $e');
    }
  }

  @override
  Future<void> clearSession() async {
    try {
      await storage.remove(StorageKeys.isLoggedIn);
      await storage.remove(StorageKeys.userMobile);
      await storage.remove(StorageKeys.authToken);
    } catch (e) {
      throw CacheException(message: 'Failed to clear session: $e');
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    return (await storage.getBool(StorageKeys.isLoggedIn)) ?? false;
  }

  @override
  Future<String?> getSavedMobile() async {
    return storage.getString(StorageKeys.userMobile);
  }
}
