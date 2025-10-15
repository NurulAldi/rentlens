// Pindahan dari lib/notification_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/app_drawer.dart';
import '../utils/drawer_navigator.dart';
import '../models/session.dart';

// ...existing code from original notification_page.dart...
class NotificationItem {
  final String title;
  final String time;
  final String message;
  const NotificationItem({
    required this.title,
    required this.time,
    required this.message,
  });
}

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key, this.items});
  final List<NotificationItem>? items; // if null we will use demo data

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  DrawerMenu activeDrawerMenu = DrawerMenu.notifikasi;

  // Check if current user is test account (pemilik1 or peminjam1)
  bool get _isTestAccount =>
      Session.username == 'pemilik1' || Session.username == 'peminjam1';

  List<NotificationItem> get _items {
    // If widget has custom items, use them
    if (widget.items != null) return widget.items!;

    // Show demo data only for test accounts
    if (_isTestAccount) return _demoItems;

    // For new users, return empty list
    return [];
  }

  // Demo data to show non-empty state
  static const _demoItems = <NotificationItem>[
    NotificationItem(
      title: 'Notifikasi Sistem',
      time: '9 Oktober 2025 19:20',
      message:
          'Anda telah melakukan booking produk Nikon Z6 III Milik Mas Amba dengan masa rental 4 hari, mohon konfirmasi.',
    ),
    NotificationItem(
      title: 'Notifikasi Sistem',
      time: '9 Oktober 2025 19:20',
      message:
          'Pesanan Anda telah diterima oleh pemilik. Silakan selesaikan pembayaran.',
    ),
    NotificationItem(
      title: 'Notifikasi Sistem',
      time: '9 Oktober 2025 19:20',
      message: 'Pengingat: Masa rental berakhir 2 hari lagi.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[100],
      drawerScrimColor: Colors.black.withOpacity(0.4),
      drawer: AppDrawer(
        activeMenu: activeDrawerMenu,
        role: Session.isPemilik ? 'pemilik' : 'peminjam',
        onMenuTap: (m) => DrawerNavigator.go(context, m),
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          icon: SvgPicture.asset(
            'assets/images/sidebar_ham.svg',
            width: 24,
            height: 24,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: SvgPicture.asset(
              'assets/images/searchbar.svg',
              width: 24,
              height: 24,
            ),
          ),
        ],
      ),
      body: _items.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/no_notif.png',
                      width: 150,
                      height: 150,
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Belum ada notifikasi',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Notifikasi akan muncul di sini',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              itemBuilder: (context, index) {
                if (index == _items.length) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Center(
                      child: Text(
                        'Semua notifikasi telah ditampilkan!',
                        style: TextStyle(color: Colors.black54),
                      ),
                    ),
                  );
                }
                final n = _items[index];
                return _NotifCard(item: n);
              },
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemCount: _items.length + 1, // +1 for footer text
            ),
    );
  }
}

class _NotifCard extends StatelessWidget {
  const _NotifCard({required this.item});
  final NotificationItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            'assets/images/notif_sistem.svg',
            width: 28,
            height: 28,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  item.time,
                  style: const TextStyle(color: Colors.black54, fontSize: 12),
                ),
                const SizedBox(height: 8),
                Text(
                  item.message,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert, size: 18, color: Colors.black54),
            splashRadius: 18,
          ),
        ],
      ),
    );
  }
}
