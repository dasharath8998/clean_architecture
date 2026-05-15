import 'package:clean_architecture/core/constants/api_constants.dart';
import 'package:clean_architecture/core/error/exceptions.dart';

abstract class ApiClient {
  Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  });

  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, String>? queryParams,
    Map<String, String>? headers,
  });
}

class MockApiClient implements ApiClient {
  @override
  Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    // Simulate network latency
    await Future.delayed(ApiConstants.mockDelay);

    switch (endpoint) {
      case ApiConstants.login:
        return _handleLogin(body);
      case ApiConstants.verifyOtp:
        return _handleVerifyOtp(body);
      case ApiConstants.logout:
        return _handleLogout();
      default:
        throw ServerException(
          message: 'Endpoint not found: $endpoint',
          statusCode: 404,
        );
    }
  }

  @override
  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, String>? queryParams,
    Map<String, String>? headers,
  }) async {
    await Future.delayed(ApiConstants.mockDelay);

    switch (endpoint) {
      case ApiConstants.profile:
        return _handleProfile();
      default:
        throw ServerException(
          message: 'Endpoint not found: $endpoint',
          statusCode: 404,
        );
    }
  }

  // ─── Mock Handlers ───────────────────────────────────────────────────────────

  Map<String, dynamic> _handleLogin(Map<String, dynamic>? body) {
    final mobile = body?['mobile'] as String?;
    if (mobile == null || mobile.length != 10) {
      throw const ServerException(
        message: 'Invalid mobile number.',
        statusCode: 400,
      );
    }
    return {
      'success': true,
      'message': 'OTP sent successfully.',
      'data': {'mobile': mobile},
    };
  }

  Map<String, dynamic> _handleVerifyOtp(Map<String, dynamic>? body) {
    final otp = body?['otp'] as String?;
    if (otp != ApiConstants.validOtp) {
      throw const ServerException(
        message: 'Invalid OTP. Please try again.',
        statusCode: 401,
      );
    }
    return {
      'success': true,
      'message': 'OTP verified successfully.',
      'data': {
        'token': 'mock_auth_token_xyz_123',
        'user': {'name': 'John Doe', 'mobile': body?['mobile'] ?? ''},
      },
    };
  }

  Map<String, dynamic> _handleProfile() {
    return {
      'success': true,
      'data': {
        'name': 'John Doe',
        'mobile': '9876543210',
        'email': 'john.doe@example.com',
      },
    };
  }

  Map<String, dynamic> _handleLogout() {
    return {'success': true, 'message': 'Logged out successfully.'};
  }
}
