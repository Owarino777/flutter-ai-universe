import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/universe.dart';

import 'screens/character_list_screen.dart';
import 'screens/create_character_screen.dart';
import 'screens/create_universe_screen.dart';
import 'screens/rules_screen.dart';
import 'screens/universe_list_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/chat_screen.dart';

import 'providers/auth_provider.dart';
import 'providers/universe_provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UniverseProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Yod.AI - Aventure',
      theme: ThemeData(
        primaryColor: const Color(0xFF6D4C41), // Bois foncé
        scaffoldBackgroundColor: const Color(0xFFF5E1C0), // Fond parchemin
        fontFamily: 'MedievalSharp', // Police médiévale immersive
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF8D6E63), // Marron clair
          titleTextStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF3E2723)),
          bodyMedium: TextStyle(fontSize: 18, color: Colors.black87),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF8D6E63), width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF4E342E), width: 2.5),
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/rules': (context) => const RulesScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/create_universe': (context) => const CreateUniverseScreen(),
        '/universe_list': (context) => const UniverseListScreen(), // ⚠️ Manquant
        '/chat': (context) => const ChatScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/create_character') {
          final universe = settings.arguments as Universe;
          return MaterialPageRoute(builder: (context) => CreateCharacterScreen(universe: universe));
        }
        if (settings.name == '/character_list') {
          final universe = settings.arguments as Universe;
          return MaterialPageRoute(builder: (context) => CharacterListScreen(universe: universe));
        }
        if (settings.name == '/character_list') {
          final universe = settings.arguments as Universe;
          return MaterialPageRoute(
            builder: (_) => CharacterListScreen(universe: universe),
          );
        }
        return null;
      },

    );
  }
}