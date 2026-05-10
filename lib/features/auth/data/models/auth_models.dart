import 'package:clean_architecture/features/auth/domain/entities/user_entity.dart';

class LoginRequestModel {
  final String mobile;

  const LoginRequestModel({required this.mobile});

  Map<String, dynamic> toJson() => {'mobile': mobile};
}

class VerifyOtpRequestModel {
  final String mobile;
  final String otp;

  const VerifyOtpRequestModel({required this.mobile, required this.otp});

  Map<String, dynamic> toJson() => {'mobile': mobile, 'otp': otp};
}

class UserModel {
  final String name;
  final String mobile;
  final String? email;
  final String? token;

  const UserModel({
    required this.name,
    required this.mobile,
    this.email,
    this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'] as String? ?? '',
      mobile: json['mobile'] as String? ?? '',
      email: json['email'] as String?,
      token: json['token'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'mobile': mobile,
    if (email != null) 'email': email,
    if (token != null) 'token': token,
  };

  UserEntity toEntity() =>
      UserEntity(name: name, mobile: mobile, email: email, token: token);
}
