import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Room Layer Dependencies
import 'features/room/data/datasources/room_remote_datasource.dart';
import 'features/room/data/repositories/room_repository_impl.dart';
import 'features/room/domain/usecases/create_or_join_room.dart';
import 'features/room/domain/usecases/get_rooms.dart';
import 'features/room/presentation/bloc/room_bloc.dart';
import 'features/room/presentation/pages/room_page.dart';

// Identity Layer Dependencies
import 'features/identity/data/datasources/identity_remote_datasource.dart';
import 'features/identity/data/datasources/identity_local_datasource.dart';
import 'features/identity/data/repositories/identity_repository_impl.dart';
import 'features/identity/domain/usecases/get_local_identity.dart';
import 'features/identity/domain/usecases/fetch_random_user.dart';
import 'features/identity/domain/usecases/save_identity.dart';
import 'features/identity/presentation/bloc/identity_bloc.dart';

// Chat Layer Dependencies
import 'features/chat/data/datasources/chat_remote_datasource.dart';
import 'features/chat/data/repositories/chat_repository_impl.dart';
import 'features/chat/domain/usecases/get_messages.dart';
import 'features/chat/domain/usecases/send_message.dart';
import 'features/chat/presentation/bloc/chat_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initializes Firebase mappings assuming google-services.json / GoogleService-Info.plist are linked natively
  await Firebase.initializeApp();
  
  // Async framework payloads hooked up safely 
  final sharedPrefs = await SharedPreferences.getInstance();
  final httpClient = http.Client();
  final firestore = FirebaseFirestore.instance;

  // Forge explicit Data Dependencies explicitly shielding Clean Architecture structures
  final roomRemoteDataSource = RoomRemoteDataSourceImpl(firestore: firestore);
  final roomRepository = RoomRepositoryImpl(remoteDataSource: roomRemoteDataSource);
  
  final identityRemoteDataSource = IdentityRemoteDataSourceImpl(client: httpClient);
  final identityLocalDataSource = IdentityLocalDataSourceImpl(sharedPreferences: sharedPrefs);
  final identityRepository = IdentityRepositoryImpl(
    localDataSource: identityLocalDataSource,
    remoteDataSource: identityRemoteDataSource,
  );

  final chatRemoteDataSource = ChatRemoteDataSourceImpl(firestore: firestore);
  final chatRepository = ChatRepositoryImpl(remoteDataSource: chatRemoteDataSource);

  runApp(RumourApp(
    roomRepository: roomRepository,
    identityRepository: identityRepository,
    chatRepository: chatRepository,
  ));
}

class RumourApp extends StatelessWidget {
  final RoomRepositoryImpl roomRepository;
  final IdentityRepositoryImpl identityRepository;
  final ChatRepositoryImpl chatRepository;

  const RumourApp({
    super.key,
    required this.roomRepository,
    required this.identityRepository,
    required this.chatRepository,
  });

  @override
  Widget build(BuildContext context) {
    // Utilize MultiBlocProvider bridging logic cleanly outwards ensuring single instance allocations mapping global flows
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => RoomBloc(
            createOrJoinRoom: CreateOrJoinRoom(roomRepository),
            getRooms: GetRooms(roomRepository),
          ),
        ),
        BlocProvider(
          create: (_) => IdentityBloc(
            getLocalIdentity: GetLocalIdentity(identityRepository),
            fetchRandomUser: FetchRandomUser(identityRepository),
            saveIdentity: SaveIdentity(identityRepository),
          ),
        ),
        BlocProvider(
          create: (_) => ChatBloc(
            getMessages: GetMessages(chatRepository),
            sendMessage: SendMessage(chatRepository),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Rumour',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: Colors.black,
          primaryColor: const Color(0xFFC1FF72), // Vibrant Neon Green
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFFC1FF72),
            secondary: Color(0xFFC1FF72),
            surface: Color(0xFF161616),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.black,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.white),
          ),
        ),
        home: const RoomPage(),
      ),
    );
  }
}
