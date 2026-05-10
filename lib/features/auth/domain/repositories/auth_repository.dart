import 'package:clean_architecture/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<void> login(String mobile);

  Future<UserEntity> verifyOtp(String mobile, String otp);

  Future<void> logout();

  Future<bool> isLoggedIn();

  Future<String?> getSavedMobile();
}
