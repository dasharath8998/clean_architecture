import 'package:clean_architecture/core/error/exceptions.dart';
import 'package:clean_architecture/core/error/failures.dart';
import 'package:clean_architecture/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:clean_architecture/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:clean_architecture/features/auth/domain/entities/user_entity.dart';
import 'package:clean_architecture/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  const AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<void> login(String mobile) async {
    try {
      await remoteDataSource.login(mobile);
    } on ServerException catch (e) {
      throw ServerFailure(message: e.message, statusCode: e.statusCode);
    } on NetworkException catch (e) {
      throw NetworkFailure(message: e.message);
    } catch (e) {
      throw UnknownFailure(message: e.toString());
    }
  }

  @override
  Future<UserEntity> verifyOtp(String mobile, String otp) async {
    try {
      final userModel = await remoteDataSource.verifyOtp(mobile, otp);

      // Persist login session locally after successful OTP verification
      await localDataSource.saveSession(mobile, userModel.token ?? '');

      return userModel.toEntity();
    } on ServerException catch (e) {
      throw ServerFailure(message: e.message, statusCode: e.statusCode);
    } on NetworkException catch (e) {
      throw NetworkFailure(message: e.message);
    } on CacheException catch (e) {
      throw CacheFailure(message: e.message);
    } catch (e) {
      throw UnknownFailure(message: e.toString());
    }
  }

  @override
  Future<void> logout() async {
    try {
      await localDataSource.clearSession();
    } on CacheException catch (e) {
      throw CacheFailure(message: e.message);
    } catch (e) {
      throw UnknownFailure(message: e.toString());
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    return localDataSource.isLoggedIn();
  }

  @override
  Future<String?> getSavedMobile() async {
    return localDataSource.getSavedMobile();
  }
}
