import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Feature: Room
import 'features/room/data/datasources/room_remote_datasource.dart';
import 'features/room/data/repositories/room_repository_impl.dart';
import 'features/room/domain/repositories/room_repository.dart';
import 'features/room/domain/usecases/create_or_join_room.dart';
import 'features/room/domain/usecases/get_rooms.dart';
import 'features/room/presentation/bloc/room_bloc.dart';

// Feature: Identity
import 'features/identity/data/datasources/identity_remote_datasource.dart';
import 'features/identity/data/datasources/identity_local_datasource.dart';
import 'features/identity/data/repositories/identity_repository_impl.dart';
import 'features/identity/domain/repositories/identity_repository.dart';
import 'features/identity/domain/usecases/get_local_identity.dart';
import 'features/identity/domain/usecases/fetch_random_user.dart';
import 'features/identity/domain/usecases/save_identity.dart';
import 'features/identity/presentation/bloc/identity_bloc.dart';

// Feature: Chat
import 'features/chat/data/datasources/chat_remote_datasource.dart';
import 'features/chat/data/repositories/chat_repository_impl.dart';
import 'features/chat/domain/repositories/chat_repository.dart';
import 'features/chat/domain/usecases/get_messages.dart';
import 'features/chat/domain/usecases/send_message.dart';
import 'features/chat/presentation/bloc/chat_bloc.dart';

// Global Dependency Container
final sl = GetIt.instance;

Future<void> init() async {
  // --------- External / Core Hooks ---------
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => FirebaseFirestore.instance);

  // --------- Room Feature Map ---------
  // Data sources
  sl.registerLazySingleton<RoomRemoteDataSource>(
    () => RoomRemoteDataSourceImpl(firestore: sl()),
  );
  // Repository
  sl.registerLazySingleton<RoomRepository>(
    () => RoomRepositoryImpl(remoteDataSource: sl()),
  );
  // UseCases
  sl.registerLazySingleton(() => CreateOrJoinRoom(sl()));
  sl.registerLazySingleton(() => GetRooms(sl()));
  // Bloc
  sl.registerFactory(() => RoomBloc(
    createOrJoinRoom: sl(),
    getRooms: sl(),
  ));

  // --------- Identity Feature Map ---------
  // Data sources
  sl.registerLazySingleton<IdentityRemoteDataSource>(
    () => IdentityRemoteDataSourceImpl(client: sl()),
  );
  sl.registerLazySingleton<IdentityLocalDataSource>(
    () => IdentityLocalDataSourceImpl(sharedPreferences: sl()),
  );
  // Repository
  sl.registerLazySingleton<IdentityRepository>(
    () => IdentityRepositoryImpl(
      localDataSource: sl(),
      remoteDataSource: sl(),
    ),
  );
  // UseCases
  sl.registerLazySingleton(() => GetLocalIdentity(sl()));
  sl.registerLazySingleton(() => FetchRandomUser(sl()));
  sl.registerLazySingleton(() => SaveIdentity(sl()));
  // Bloc
  sl.registerFactory(() => IdentityBloc(
    getLocalIdentity: sl(),
    fetchRandomUser: sl(),
    saveIdentity: sl(),
  ));

  // --------- Chat Feature Map ---------
  // Data sources
  sl.registerLazySingleton<ChatRemoteDataSource>(
    () => ChatRemoteDataSourceImpl(firestore: sl()),
  );
  // Repository
  sl.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(remoteDataSource: sl()),
  );
  // UseCases
  sl.registerLazySingleton(() => GetMessages(sl()));
  sl.registerLazySingleton(() => SendMessage(sl()));
  // Bloc
  sl.registerFactory(() => ChatBloc(
    getMessages: sl(),
    sendMessage: sl(),
  ));
}
