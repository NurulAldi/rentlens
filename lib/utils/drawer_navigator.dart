import 'package:flutter/material.dart';
import '../models/session.dart';
import '../widgets/app_drawer.dart';

/// Helper untuk navigasi drawer yang role-aware
/// Memastikan navigasi selalu konsisten berdasarkan role user
class DrawerNavigator {
  /// Navigasi ke halaman yang sesuai berdasarkan menu dan role user
  static void go(BuildContext context, DrawerMenu menu) {
    final bool isPeminjam = Session.isPeminjam;

    switch (menu) {
      case DrawerMenu.home:
        if (isPeminjam) {
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          Navigator.pushReplacementNamed(context, '/pemilik/dashboard');
        }
        break;

      case DrawerMenu.dashboard:
        Navigator.pushReplacementNamed(context, '/pemilik/dashboard');
        break;

      case DrawerMenu.produk:
        Navigator.pushReplacementNamed(context, '/pemilik/produk');
        break;

      case DrawerMenu.notifikasi:
        Navigator.pushReplacementNamed(context, '/notifications');
        break;

      case DrawerMenu.profil:
        if (isPeminjam) {
          Navigator.pushReplacementNamed(context, '/profile');
        } else {
          Navigator.pushReplacementNamed(context, '/pemilik/profile');
        }
        break;
    }
  }
}
