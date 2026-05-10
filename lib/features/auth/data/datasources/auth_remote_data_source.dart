import 'package:clean_architecture/core/constants/api_constants.dart';
import 'package:clean_architecture/core/error/exceptions.dart';
import 'package:clean_architecture/core/network/api_client.dart';
import 'package:clean_architecture/features/auth/data/models/auth_models.dart';

abstract class AuthRemoteDataSource {
  Future<void> login(String mobile);

  Future<UserModel> verifyOtp(String mobile, String otp);

  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;

  const AuthRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<void> login(String mobile) async {
    final request = LoginRequestModel(mobile: mobile);
    final response = await apiClient.post(
      ApiConstants.login,
      body: request.toJson(),
    );

    if (response['success'] != true) {
      throw ServerException(
        message: response['message'] as String? ?? 'Login failed.',
      );
    }
  }

  @override
  Future<UserModel> verifyOtp(String mobile, String otp) async {
    final request = VerifyOtpRequestModel(mobile: mobile, otp: otp);
    final response = await apiClient.post(
      ApiConstants.verifyOtp,
      body: request.toJson(),
    );

    if (response['success'] != true) {
      throw ServerException(
        message: response['message'] as String? ?? 'OTP verification failed.',
      );
    }

    final data = response['data'] as Map<String, dynamic>;
    final user = data['user'] as Map<String, dynamic>;
    final token = data['token'] as String?;

    return UserModel.fromJson({...user, 'token': token});
  }

  @override
  Future<void> logout() async {
    await apiClient.post(ApiConstants.logout);
  }
}
