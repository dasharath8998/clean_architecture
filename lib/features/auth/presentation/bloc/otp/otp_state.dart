part of 'otp_bloc.dart';

abstract class OtpState extends Equatable {
  final String otp;

  const OtpState({this.otp = ''});

  @override
  List<Object?> get props => [otp];
}

class OtpInitial extends OtpState {
  const OtpInitial() : super(otp: '');
}

class OtpInputChanged extends OtpState {
  const OtpInputChanged({required super.otp});
}

class OtpLoading extends OtpState {
  const OtpLoading({required super.otp});
}

class OtpSuccess extends OtpState {
  final String userName;

  const OtpSuccess({required super.otp, required this.userName});

  @override
  List<Object?> get props => [otp, userName];
}

class OtpFailure extends OtpState {
  final String errorMessage;

  const OtpFailure({required super.otp, required this.errorMessage});

  @override
  List<Object?> get props => [otp, errorMessage];
}
