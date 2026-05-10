class ApiConstants {
  ApiConstants._();

  // Base URL (replace with real URL when integrating actual API)
  static const String baseUrl = 'https://api.example.com/v1';

  // Timeouts
  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;

  // Endpoints
  static const String login = '/auth/login';
  static const String verifyOtp = '/auth/verify-otp';
  static const String profile = '/user/profile';
  static const String logout = '/auth/logout';

  // Mock Delays
  static const Duration mockDelay = Duration(seconds: 2);

  // Mock static OTP
  static const String validOtp = '123456';

  // Headers
  static const String contentTypeJson = 'application/json';
  static const String authorizationHeader = 'Authorization';
  static const String bearerPrefix = 'Bearer ';
}
