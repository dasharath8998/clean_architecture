import 'package:clean_architecture/core/utils/use_case.dart';
import 'package:clean_architecture/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase implements UseCase<void, LoginParams> {
  const LoginUseCase(this.repository);

  final AuthRepository repository;

  @override
  Future<void> call(LoginParams params) async {
    return repository.login(params.mobile);
  }
}

class LoginParams {
  const LoginParams({required this.mobile});

  final String mobile;
}
