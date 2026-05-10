part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

class LoginMobileChanged extends LoginEvent {
  final String mobile;

  const LoginMobileChanged(this.mobile);

  @override
  List<Object?> get props => [mobile];
}

class LoginSubmitted extends LoginEvent {
  final String mobile;

  const LoginSubmitted(this.mobile);

  @override
  List<Object?> get props => [mobile];
}

class LoginReset extends LoginEvent {
  const LoginReset();
}
