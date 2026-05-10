import 'package:clean_architecture/core/utils/use_case.dart';
import 'package:clean_architecture/features/auth/domain/entities/user_entity.dart';
import 'package:clean_architecture/features/auth/domain/repositories/auth_repository.dart';

class VerifyOtpUseCase implements UseCase<UserEntity, VerifyOtpParams> {
  final AuthRepository repository;

  const VerifyOtpUseCase(this.repository);

  @override
  Future<UserEntity> call(VerifyOtpParams params) async {
    return repository.verifyOtp(params.mobile, params.otp);
  }
}

class VerifyOtpParams {
  final String mobile;
  final String otp;

  const VerifyOtpParams({required this.mobile, required this.otp});
}
