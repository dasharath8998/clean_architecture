part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  final String mobile;
  final bool isValid;

  const LoginState({this.mobile = '', this.isValid = false});

  @override
  List<Object?> get props => [mobile, isValid];
}

class LoginInitial extends LoginState {
  const LoginInitial() : super(mobile: '', isValid: false);
}

class LoginLoading extends LoginState {
  const LoginLoading({required super.mobile, required super.isValid});
}

class LoginSuccess extends LoginState {
  final String sentToMobile;

  const LoginSuccess({
    required super.mobile,
    required super.isValid,
    required this.sentToMobile,
  });

  @override
  List<Object?> get props => [mobile, isValid, sentToMobile];
}

class LoginFailure extends LoginState {
  final String errorMessage;

  const LoginFailure({
    required super.mobile,
    required super.isValid,
    required this.errorMessage,
  });

  @override
  List<Object?> get props => [mobile, isValid, errorMessage];
}

class LoginInputChanged extends LoginState {
  const LoginInputChanged({required super.mobile, required super.isValid});
}
