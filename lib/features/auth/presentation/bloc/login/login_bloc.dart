import 'package:clean_architecture/core/error/failures.dart';
import 'package:clean_architecture/core/utils/validators.dart';
import 'package:clean_architecture/features/auth/domain/usecases/login_use_case.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUseCase loginUseCase;

  LoginBloc({required this.loginUseCase}) : super(const LoginInitial()) {
    on<LoginMobileChanged>(_onMobileChanged);
    on<LoginSubmitted>(_onLoginSubmitted);
    on<LoginReset>(_onReset);
  }

  void _onMobileChanged(LoginMobileChanged event, Emitter<LoginState> emit) {
    final isValid = Validators.isMobileValid(event.mobile);
    emit(LoginInputChanged(mobile: event.mobile, isValid: isValid));
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    if (!Validators.isMobileValid(event.mobile)) return;

    emit(LoginLoading(mobile: event.mobile, isValid: true));

    try {
      await loginUseCase(LoginParams(mobile: event.mobile));
      emit(
        LoginSuccess(
          mobile: event.mobile,
          isValid: true,
          sentToMobile: event.mobile,
        ),
      );
    } on Failure catch (e) {
      emit(
        LoginFailure(
          mobile: event.mobile,
          isValid: true,
          errorMessage: e.message,
        ),
      );
    } catch (e) {
      emit(
        LoginFailure(
          mobile: event.mobile,
          isValid: true,
          errorMessage: 'Something went wrong. Please try again.',
        ),
      );
    }
  }

  void _onReset(LoginReset event, Emitter<LoginState> emit) {
    emit(const LoginInitial());
  }
}
