part of 'otp_bloc.dart';

abstract class OtpEvent extends Equatable {
  const OtpEvent();

  @override
  List<Object?> get props => [];
}

class OtpChanged extends OtpEvent {
  final String otp;

  const OtpChanged(this.otp);

  @override
  List<Object?> get props => [otp];
}

class OtpSubmitted extends OtpEvent {
  final String mobile;
  final String otp;

  const OtpSubmitted({required this.mobile, required this.otp});

  @override
  List<Object?> get props => [mobile, otp];
}

class OtpReset extends OtpEvent {
  const OtpReset();
}
