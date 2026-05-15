import 'package:clean_architecture/core/network/api_client.dart';
import 'package:clean_architecture/core/storage/local_storage.dart';
import 'package:clean_architecture/core/storage/shared_preferences_storage.dart';
import 'package:clean_architecture/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:clean_architecture/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:clean_architecture/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:clean_architecture/features/auth/domain/repositories/auth_repository.dart';
import 'package:clean_architecture/features/auth/domain/usecases/login_use_case.dart';
import 'package:clean_architecture/features/auth/domain/usecases/logout_use_case.dart';
import 'package:clean_architecture/features/auth/domain/usecases/verify_otp_use_case.dart';
import 'package:clean_architecture/features/auth/presentation/bloc/login/login_bloc.dart';
import 'package:clean_architecture/features/auth/presentation/bloc/otp/otp_bloc.dart';
import 'package:clean_architecture/features/home/presentation/bloc/home_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ─── External Dependencies ────────────────────────────────────────────────

  // SharedPreferences (async, registered as singleton)
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  // ─── Core ─────────────────────────────────────────────────────────────────

  // Local Storage abstraction
  sl.registerLazySingleton<LocalStorage>(() => SharedPreferencesStorage(sl()));

  // API Client (mock implementation; swap with DioApiClient for production)
  sl.registerLazySingleton<ApiClient>(() => MockApiClient());

  // ─── Features: Auth ───────────────────────────────────────────────────────

  // Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(apiClient: sl()),
  );

  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(storage: sl()),
  );

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
  );

  // Use Cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => VerifyOtpUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => IsLoggedInUseCase(sl()));

  // BLoCs (registered as factory so each screen gets a fresh instance)
  sl.registerFactory(() => LoginBloc(loginUseCase: sl()));
  sl.registerFactory(() => OtpBloc(verifyOtpUseCase: sl()));
  sl.registerFactory(() => HomeBloc());
}
