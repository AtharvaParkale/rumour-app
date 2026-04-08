import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'features/room/data/datasources/room_remote_datasource.dart';
import 'features/room/data/repositories/room_repository_impl.dart';
import 'features/room/domain/repositories/room_repository.dart';
import 'features/room/domain/usecases/create_or_join_room.dart';
import 'features/room/domain/usecases/get_rooms.dart';
import 'features/room/presentation/bloc/room_bloc.dart';

import 'features/identity/data/datasources/identity_remote_datasource.dart';
import 'features/identity/data/datasources/identity_local_datasource.dart';
import 'features/identity/data/repositories/identity_repository_impl.dart';
import 'features/identity/domain/repositories/identity_repository.dart';
import 'features/identity/domain/usecases/get_local_identity.dart';
import 'features/identity/domain/usecases/fetch_random_user.dart';
import 'features/identity/domain/usecases/save_identity.dart';
import 'features/identity/presentation/bloc/identity_bloc.dart';

import 'features/chat/data/datasources/chat_remote_datasource.dart';
import 'features/chat/data/repositories/chat_repository_impl.dart';
import 'features/chat/domain/repositories/chat_repository.dart';
import 'features/chat/domain/usecases/get_messages.dart';
import 'features/chat/domain/usecases/send_message.dart';
import 'features/chat/presentation/bloc/chat_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => FirebaseFirestore.instance);

  sl.registerLazySingleton<RoomRemoteDataSource>(
    () => RoomRemoteDataSourceImpl(firestore: sl()),
  );

  sl.registerLazySingleton<RoomRepository>(
    () => RoomRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton(() => CreateOrJoinRoom(sl()));
  sl.registerLazySingleton(() => GetRooms(sl()));

  sl.registerFactory(() => RoomBloc(createOrJoinRoom: sl(), getRooms: sl()));

  sl.registerLazySingleton<IdentityRemoteDataSource>(
    () => IdentityRemoteDataSourceImpl(client: sl()),
  );
  sl.registerLazySingleton<IdentityLocalDataSource>(
    () => IdentityLocalDataSourceImpl(sharedPreferences: sl()),
  );

  sl.registerLazySingleton<IdentityRepository>(
    () => IdentityRepositoryImpl(localDataSource: sl(), remoteDataSource: sl()),
  );

  sl.registerLazySingleton(() => GetLocalIdentity(sl()));
  sl.registerLazySingleton(() => FetchRandomUser(sl()));
  sl.registerLazySingleton(() => SaveIdentity(sl()));

  sl.registerFactory(
    () => IdentityBloc(
      getLocalIdentity: sl(),
      fetchRandomUser: sl(),
      saveIdentity: sl(),
    ),
  );

  sl.registerLazySingleton<ChatRemoteDataSource>(
    () => ChatRemoteDataSourceImpl(firestore: sl()),
  );

  sl.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton(() => GetMessages(sl()));
  sl.registerLazySingleton(() => SendMessage(sl()));

  sl.registerFactory(() => ChatBloc(getMessages: sl(), sendMessage: sl()));
}
