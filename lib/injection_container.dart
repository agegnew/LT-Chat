import 'package:chat_frontend_clean_arch/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:chat_frontend_clean_arch/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/auth/data/sources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/chat/presentation/bloc/chat_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // 1. EXTERNAL
  sl.registerLazySingleton<Dio>(() => Dio());
  final sharedPrefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPrefs);

  // 2. DATA SOURCES
  sl.registerLazySingleton<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(dio: sl<Dio>()),
  );

  // 3. REPOSITORIES
  sl.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(remoteDataSource: sl<AuthRemoteDataSource>()),
  );

  // 4. BLOCS
  sl.registerFactory<AuthBloc>(
        () => AuthBloc(authRepository: sl<AuthRepository>()),
  );
  sl.registerFactory<ChatBloc>(
        () => ChatBloc(chatRepository: sl<ChatRepositoryImpl>()),
  );
}
