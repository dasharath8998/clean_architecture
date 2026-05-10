import 'package:clean_architecture/core/utils/use_case.dart';
import 'package:clean_architecture/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase implements UseCase<void, LoginParams> {
  final AuthRepository repository;

  const LoginUseCase(this.repository);

  @override
  Future<void> call(LoginParams params) async {
    return repository.login(params.mobile);
  }
}

class LoginParams {
  final String mobile;

  const LoginParams({required this.mobile});
}
