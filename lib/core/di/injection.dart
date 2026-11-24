import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/data/data_sources/auth_remote_data_source.dart';
import '../../features/auth/data/data_sources/mock_auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/presentation/cubit/forgot_password_cubit.dart';
import '../../features/auth/presentation/cubit/login_cubit.dart';
import '../../features/auth/presentation/cubit/register_cubit.dart';
import '../../features/home/presentation/cubit/home_cubit.dart';
import '../../features/memories/data/data_sources/memories_remote_data_source.dart';
import '../../features/memories/data/data_sources/mock_memories_remote_data_source.dart';
import '../../features/memories/data/repositories/memories_repository_impl.dart';
import '../../features/memories/domain/repositories/memories_repository.dart';
import '../../features/settings/presentation/cubit/settings_cubit.dart';
import '../../features/splash/presentation/cubit/splash_cubit.dart';
import '../constants/env.dart';
import '../networking/dio_factory.dart';
import '../routing/app_router.dart';
import '../session/session_manager.dart';
import '../storage/token_storage.dart';

/// The composition root: the only place that wires features together.
final GetIt getIt = GetIt.instance;

Future<void> configureDependencies() async {
  final prefs = await SharedPreferences.getInstance();

  getIt
    ..registerSingleton<SharedPreferences>(prefs)
    ..registerSingleton<TokenStorage>(TokenStorage(const FlutterSecureStorage()))
    ..registerSingleton<SessionManager>(SessionManager(prefs))
    ..registerSingleton<Dio>(
      createDio(tokenStorage: getIt<TokenStorage>(), session: getIt<SessionManager>()),
    );

  _registerAuth();
  _registerMemories();
  _registerScreens();

  getIt.registerSingleton<AppRouter>(AppRouter(getIt<SessionManager>()));
}

void _registerAuth() {
  getIt
    ..registerLazySingleton<AuthRemoteDataSource>(
      () => Env.useMock ? MockAuthRemoteDataSource() : AuthRemoteDataSourceImpl(getIt<Dio>()),
    )
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(
        remote: getIt<AuthRemoteDataSource>(),
        tokenStorage: getIt<TokenStorage>(),
        session: getIt<SessionManager>(),
      ),
    )
    ..registerFactory<LoginCubit>(() => LoginCubit(getIt<AuthRepository>()))
    ..registerFactory<RegisterCubit>(() => RegisterCubit(getIt<AuthRepository>()))
    ..registerFactory<ForgotPasswordCubit>(() => ForgotPasswordCubit(getIt<AuthRepository>()));
}

void _registerMemories() {
  getIt
    ..registerLazySingleton<MemoriesRemoteDataSource>(
      () => Env.useMock
          ? MockMemoriesRemoteDataSource()
          : MemoriesRemoteDataSourceImpl(getIt<Dio>()),
    )
    ..registerLazySingleton<MemoriesRepository>(
      () => MemoriesRepositoryImpl(getIt<MemoriesRemoteDataSource>()),
    );
}

void _registerScreens() {
  getIt
    ..registerFactory<SplashCubit>(() => SplashCubit(getIt<AuthRepository>()))
    ..registerFactory<HomeCubit>(() => HomeCubit(getIt<MemoriesRepository>()))
    ..registerFactory<SettingsCubit>(() => SettingsCubit(getIt<AuthRepository>()));
}
