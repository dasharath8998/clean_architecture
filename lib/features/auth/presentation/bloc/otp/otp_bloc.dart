import 'package:clean_architecture/core/error/failures.dart';
import 'package:clean_architecture/features/auth/domain/usecases/verify_otp_use_case.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'otp_event.dart';

part 'otp_state.dart';

class OtpBloc extends Bloc<OtpEvent, OtpState> {
  final VerifyOtpUseCase verifyOtpUseCase;

  OtpBloc({required this.verifyOtpUseCase}) : super(const OtpInitial()) {
    on<OtpChanged>(_onOtpChanged);
    on<OtpSubmitted>(_onOtpSubmitted);
    on<OtpReset>(_onReset);
  }

  void _onOtpChanged(OtpChanged event, Emitter<OtpState> emit) {
    emit(OtpInputChanged(otp: event.otp));
  }

  Future<void> _onOtpSubmitted(
    OtpSubmitted event,
    Emitter<OtpState> emit,
  ) async {
    if (event.otp.length != 6) return;

    emit(OtpLoading(otp: event.otp));

    try {
      final user = await verifyOtpUseCase(
        VerifyOtpParams(mobile: event.mobile, otp: event.otp),
      );
      emit(OtpSuccess(otp: event.otp, userName: user.name));
    } on Failure catch (e) {
      emit(OtpFailure(otp: event.otp, errorMessage: e.message));
    } catch (e) {
      emit(
        OtpFailure(
          otp: event.otp,
          errorMessage: 'Something went wrong. Please try again.',
        ),
      );
    }
  }

  void _onReset(OtpReset event, Emitter<OtpState> emit) {
    emit(const OtpInitial());
  }
}
