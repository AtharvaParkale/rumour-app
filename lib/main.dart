import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'injection_container.dart' as di;

import 'features/room/presentation/bloc/room_bloc.dart';
import 'features/room/presentation/pages/room_page.dart';
import 'features/identity/presentation/bloc/identity_bloc.dart';
import 'features/chat/presentation/bloc/chat_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initializes Firebase mappings assuming google-services.json / GoogleService-Info.plist are linked natively
  await Firebase.initializeApp();
  
  // Await Dependency Container bootstrapping mapping 
  await di.init();

  runApp(const RumourApp());
}

class RumourApp extends StatelessWidget {
  const RumourApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Top routing safely pulls completely from injection abstraction map
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<RoomBloc>()),
        BlocProvider(create: (_) => di.sl<IdentityBloc>()),
        BlocProvider(create: (_) => di.sl<ChatBloc>()),
      ],
      child: MaterialApp(
        title: 'Rumour',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xFF0A0A0A),
          primaryColor: const Color(0xFFC1FF72), // Vibrant Neon Green
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFFC1FF72),
            secondary: Color(0xFFC1FF72),
            surface: Color(0xFF161616),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF0A0A0A),
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.white),
          ),
        ),
        home: const RoomPage(),
      ),
    );
  }
}
