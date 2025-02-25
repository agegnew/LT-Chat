import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'injection_container.dart' as di;
import 'features/chat/presentation/pages/chat_page.dart';
import 'features/chat/presentation/bloc/chat_bloc.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/views/phone_input_screen.dart';
import 'features/auth/presentation/views/waiting_approval_screen.dart';
import 'features/auth/presentation/views/profile_setup_screen.dart';
import 'features/auth/presentation/views/otp_verification_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:io';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final file = File('.env');
  print('Current directory: ${Directory.current.path}');
  print('.env exists? ${file.existsSync()}');
  print('>> DEBUG: Starting main()');

  try {
    await dotenv.load(fileName: ".env");
    print('>> DEBUG: dotenv.load() success');
  } catch (e) {
    print('>> ERROR loading dotenv: $e');
  }

  print('>> DEBUG: Now calling di.init()');
  try {
    await di.init();
    print('>> DEBUG: di.init() success');
  } catch (e) {
    print('>> ERROR in di.init(): $e');
  }

  print('>> DEBUG: Checking user authentication status...');
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? userToken = prefs.getString('user_token');
  final bool isApproved = prefs.getBool('is_approved') ?? false;

  Widget initialScreen;
  if (userToken == null) {
    initialScreen = PhoneInputScreen(); // User needs to log in
  } else if (!isApproved) {
    initialScreen = WaitingApprovalScreen(); // User logged in but not approved
  } else {
    initialScreen = ChatPage(); // User is authenticated and approved
  }

  print('>> DEBUG: About to runApp()');
  runApp(MyApp(initialScreen: initialScreen));
  print('>> DEBUG: runApp() called');
}

class MyApp extends StatelessWidget {
  final Widget initialScreen;
  const MyApp({super.key, required this.initialScreen});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ChatBloc>(
          create: (_) => di.sl<ChatBloc>(),
        ),
        BlocProvider<AuthBloc>(
          create: (_) => di.sl<AuthBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'Chat App',
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: '/',
        routes: {
          '/': (context) => initialScreen,
          '/chat': (context) => ChatPage(),
          '/set-profile': (context) {
            final String phone = ModalRoute.of(context)!.settings.arguments as String;
            return ProfileSetupScreen(phone: phone);
          },
          '/waiting-approval': (context) => WaitingApprovalScreen(),
        },
      ),
    );
  }
}
