import 'package:flutter/material.dart';
import 'login_page.dart';
import 'register_page.dart';
import 'splash_page.dart';
import 'home_page.dart';
import 'notification_page.dart';
import 'profile_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rent Lens',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF5C62F6)),
        useMaterial3: true,
      ),
      home: const SplashPage(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => const HomePage(),
        '/notifications': (context) => const NotificationPage(),
        '/profile': (context) => const ProfilePage(),
      },
    );
  }
}
