import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '/presentation/pages/profile_page/profile_screen.dart';
// App Colors
import 'package:agrigo_v3/core/constants/app_colors.dart';

// Models
import 'package:agrigo_v3/models/plant_model.dart';
import 'core/models/bookmarked_plant.dart';

// Pages
import 'package:agrigo_v3/presentation/pages/landing_page.dart';
import 'package:agrigo_v3/presentation/pages/login_page/login_screen.dart';
import 'package:agrigo_v3/presentation/pages/register_page/register_screen.dart';
import 'package:agrigo_v3/presentation/pages/home_page/home_screen.dart';
import 'package:agrigo_v3/presentation/pages/chatbot_page/chatbot_screen.dart';
import 'package:agrigo_v3/presentation/pages/PlanetDetail/PlantDetailScreen.dart'
    as plantDetail;

// BLoCs
import 'package:agrigo_v3/presentation/pages/login_page/login_bloc.dart';
import 'package:agrigo_v3/presentation/pages/register_page/register_bloc.dart';
import 'package:agrigo_v3/presentation/pages/chatbot_page/chatbot_bloc.dart';

void main() async {
  // Initialize Flutter binding
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Dio for HTTP requests
  final dio = Dio();

  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(PlantModelAdapter());
  Hive.registerAdapter(BookmarkedPlantAdapter());
  await Hive.openBox<PlantModel>('plants_box');
  await Hive.openBox<BookmarkedPlant>('bookmarks');

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => RegisterBloc(dio: dio)),
        BlocProvider(create: (context) => LoginBloc(dio: dio)),
        BlocProvider(create: (_) => ChatBotBloc()),
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
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 2,
          centerTitle: true,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LandingPage(),
        '/login': (context) => BlocProvider.value(
              value: BlocProvider.of<LoginBloc>(context),
              child: const LoginScreen(),
            ),
        '/signup': (context) => BlocProvider.value(
              value: BlocProvider.of<RegisterBloc>(context),
              child: const RegisterScreen(),
            ),
        '/home': (context) => const HomeScreen(),
        '/chatbot': (context) => BlocProvider.value(
              value: BlocProvider.of<ChatBotBloc>(context),
              child: const ChatBotScreen(),
            ),
        '/plant-details': (context) {
          final args = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;
          return plantDetail.PlantDetailsScreen(
            name: args['name'],
            family: args['family'],
            image: args['image'],
          );
        },
        '/profile': (context) => const ProfilePage(),
      },
      onGenerateRoute: (settings) {
        // Handle 404 - Page Not Found
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(title: const Text('Page Not Found')),
            body: Center(
              child: Text('Route ${settings.name} not found'),
            ),
          ),
        );
      },
    );
  }
}
