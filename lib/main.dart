import 'package:agrigo_v3/presentation/pages/chatbot_page/chatbot_bloc.dart';
import 'package:agrigo_v3/presentation/pages/chatbot_page/chatbot_screen.dart';
import 'package:agrigo_v3/presentation/pages/home_page/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'presentation/pages/register_page/register_screen.dart';
import 'presentation/pages/register_page/register_bloc.dart';
import 'presentation/pages/login_page/login_screen.dart';
import 'presentation/pages/login_page/login_bloc.dart';
import 'presentation/pages/landing_page.dart';
import '/core/constants/app_colors.dart';
import 'package:hive_flutter/hive_flutter.dart';



void main() async{
  final dio = Dio();
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => RegisterBloc(dio: dio),
        ),
        BlocProvider(
          create: (context) => LoginBloc(dio: dio),
        ),
        BlocProvider(
          create: (_) => ChatBotBloc(),
        ),
      ],
      child: const AgriGoApp(),
    ),
  );
}

class AgriGoApp extends StatelessWidget {
  const AgriGoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AgriGo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
        ),
        useMaterial3: true,
      ),
      
      initialRoute: '/',
      routes: {
        '/signup': (context) => const RegisterScreen(),
        '/': (context) => const LandingPage(),
        '/login': (context) => BlocProvider.value(
              value: BlocProvider.of<LoginBloc>(context),
              child: const LoginScreen(),
            ),
        '/home': (context) => const HomeScreen(),
        '/chatbot': (context) => const ChatBotScreen(),
      },
    );
  }
}