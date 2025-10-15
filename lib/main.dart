import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'login_page.dart';
import 'register_page.dart';
import 'splash_page.dart';
import 'peminjam/home_page.dart';
import 'peminjam/notification_page.dart';
import 'peminjam/profile_page.dart';
import 'pemilik/produk_page.dart';
import 'pemilik/dashboard_page.dart';
import 'pemilik/pemilik_profile_page.dart';
import 'providers/product_provider.dart';
import 'providers/profile_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ProductProvider()..initializeDummyData(),
        ),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
      ],
      child: MaterialApp(
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
          '/pemilik/profile': (context) => const PemilikProfilePage(),
          '/pemilik/produk': (context) => const PemilikProdukPage(),
          '/pemilik/dashboard': (context) => const PemilikDashboardPage(),
        },
      ),
    );
  }
}
