import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/chat/data/sources/chat_remote_data_source.dart';
import 'features/chat/data/repositories/chat_repository_impl.dart';
import 'features/chat/domain/repositories/chat_repository.dart';
import 'features/chat/presentation/bloc/chat_bloc.dart';
import 'features/chat/data/sources/chat_socket_data_source.dart';


final sl = GetIt.instance; // 'sl' = Service Locator

Future<void> init() async {
  // 1. EXTERNAL
  sl.registerLazySingleton<Dio>(() => Dio());

  final sharedPrefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPrefs);

  // 2. DATA SOURCES
  sl.registerLazySingleton<ChatRemoteDataSource>(
        () => ChatRemoteDataSourceImpl(dio: sl<Dio>()),
  );

  sl.registerLazySingleton<ChatSocketDataSource>(
          () => ChatSocketDataSource());

  // 3. REPOSITORIES
  sl.registerLazySingleton<ChatRepository>(
        () => ChatRepositoryImpl(remoteDataSource: sl<ChatRemoteDataSource>()),
  );

  // 4. BLOCS
  sl.registerFactory<ChatBloc>(
        () => ChatBloc(chatRepository: sl<ChatRepository>()),
  );
}
