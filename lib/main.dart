// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'injection_container.dart' as di;
import 'features/chat/presentation/pages/chat_page.dart';
import 'features/chat/presentation/bloc/chat_bloc.dart';
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

  print('>> DEBUG: About to runApp()');
  runApp(const MyApp());
  print('>> DEBUG: runApp() called');
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ChatBloc>(
          create: (_) => di.sl<ChatBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'Chat App',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const ChatPage(), // No more "chats: []"
      ),
    );
  }
}
