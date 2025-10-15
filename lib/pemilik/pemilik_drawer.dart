import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum PemilikDrawerMenu { dashboard, produk, notifikasi, profil, logout }

class PemilikDrawer extends StatelessWidget {
  final PemilikDrawerMenu activeMenu;
  final void Function(PemilikDrawerMenu) onMenuTap;
  const PemilikDrawer({
    super.key,
    required this.activeMenu,
    required this.onMenuTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget item({
      required PemilikDrawerMenu menu,
      required String label,
      required String iconAsset,
      bool isLogout = false,
    }) {
      final active = menu == activeMenu;
      return InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          Navigator.pop(context);
          if (isLogout) {
            Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
          } else {
            onMenuTap(menu);
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: active && !isLogout
                ? Colors.grey.shade200
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              SvgPicture.asset(iconAsset, width: 20, height: 20),
              const SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: isLogout ? Colors.red : null,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Drawer(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: SvgPicture.asset(
                  'assets/images/back_button.svg',
                  width: 24,
                  height: 24,
                ),
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(height: 8),
              item(
                menu: PemilikDrawerMenu.dashboard,
                label: 'Dashboard',
                iconAsset: 'assets/images/dashboard.svg',
              ),
              const SizedBox(height: 8),
              item(
                menu: PemilikDrawerMenu.produk,
                label: 'Produk',
                iconAsset: 'assets/images/produk.svg',
              ),
              const SizedBox(height: 8),
              item(
                menu: PemilikDrawerMenu.notifikasi,
                label: 'Notifikasi',
                iconAsset: 'assets/images/notif.svg',
              ),
              const SizedBox(height: 8),
              item(
                menu: PemilikDrawerMenu.profil,
                label: 'Profil',
                iconAsset: 'assets/images/profile.svg',
              ),
              const SizedBox(height: 8),
              item(
                menu: PemilikDrawerMenu.logout,
                label: 'Logout',
                iconAsset: 'assets/images/logout.svg',
                isLogout: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
