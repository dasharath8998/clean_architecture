import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String name;
  final String mobile;
  final String? email;
  final String? token;

  const UserEntity({
    required this.name,
    required this.mobile,
    this.email,
    this.token,
  });

  @override
  List<Object?> get props => [name, mobile, email, token];
}
