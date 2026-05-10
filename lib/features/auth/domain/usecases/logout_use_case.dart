import 'package:clean_architecture/core/utils/use_case.dart';
import 'package:clean_architecture/features/auth/domain/repositories/auth_repository.dart';

class LogoutUseCase implements UseCase<void, NoParams> {
  final AuthRepository repository;

  const LogoutUseCase(this.repository);

  @override
  Future<void> call(NoParams params) async {
    return repository.logout();
  }
}

class IsLoggedInUseCase implements UseCase<bool, NoParams> {
  final AuthRepository repository;

  const IsLoggedInUseCase(this.repository);

  @override
  Future<bool> call(NoParams params) async {
    return repository.isLoggedIn();
  }
}
