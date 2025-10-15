import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../widgets/app_drawer.dart';
import '../utils/drawer_navigator.dart';
import '../models/product.dart';
import '../models/session.dart';
import 'product_form_page.dart';

class PemilikDashboardPage extends StatefulWidget {
  const PemilikDashboardPage({super.key});

  @override
  State<PemilikDashboardPage> createState() => _PemilikDashboardPageState();
}

class _PemilikDashboardPageState extends State<PemilikDashboardPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  DrawerMenu _activeMenu = DrawerMenu.dashboard;

  // Dummy data for statistics
  int pendapatanBulanIni = 3250000; // rupiah
  int produkDisewa = 5;
  int produkTersedia = 12;

  // Dummy recent activities
  final List<_AktivitasItem> _aktivitas = [
    _AktivitasItem(
      icon: 'assets/images/notif_sistem.svg',
      description: 'Produk Nikon Z6 III baru saja dibooking',
    ),
    _AktivitasItem(
      icon: 'assets/images/notif_sistem.svg',
      description: 'Anda menerima ulasan baru pada Canon EOS R5',
    ),
    _AktivitasItem(
      icon: 'assets/images/notif_sistem.svg',
      description: 'Pembayaran untuk Sony A7 IV telah dikonfirmasi',
    ),
    _AktivitasItem(
      icon: 'assets/images/notif_sistem.svg',
      description: 'Sewa lensa 24-70mm selesai hari ini',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[100],
      drawer: AppDrawer(
        role: 'pemilik',
        activeMenu: _activeMenu,
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selamat Datang, ${Session.username}!',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 20),
            _StatRow(
              pendapatan: pendapatanBulanIni,
              disewa: produkDisewa,
              tersedia: produkTersedia,
            ),
            const SizedBox(height: 24),
            const Text(
              'Aksi Cepat',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5C62F6),
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () async {
                        final product = await Navigator.push<Product>(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ProductFormPage(),
                          ),
                        );
                        if (!mounted) return;
                        if (product != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Produk berhasil ditambahkan'),
                            ),
                          );
                        }
                      },
                      child: const Text('Tambah Produk'),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5C62F6),
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                          context,
                          '/pemilik/produk',
                        );
                      },
                      child: const Text('Lihat Semua Produk'),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            _AktivitasCard(items: _aktivitas),
          ],
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final int pendapatan;
  final int disewa;
  final int tersedia;
  const _StatRow({
    required this.pendapatan,
    required this.disewa,
    required this.tersedia,
  });

  String _formatRupiah(int value) {
    final s = value.toString();
    final chars = s.split('').reversed.toList();
    final buf = StringBuffer();
    for (int i = 0; i < chars.length; i++) {
      if (i != 0 && i % 3 == 0) buf.write('.');
      buf.write(chars[i]);
    }
    return 'Rp ${buf.toString().split('').reversed.join()}';
  }

  @override
  Widget build(BuildContext context) {
    Widget card({required String label, required Widget value}) {
      return Expanded(
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                value,
                const SizedBox(height: 6),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Row(
      children: [
        card(
          label: 'Pendapatan Bulan Ini',
          value: Text(
            _formatRupiah(pendapatan),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(width: 12),
        card(
          label: 'Produk Disewa',
          value: Text(
            disewa.toString(),
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
          ),
        ),
        const SizedBox(width: 12),
        card(
          label: 'Produk Tersedia',
          value: Text(
            tersedia.toString(),
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
          ),
        ),
      ],
    );
  }
}

class _AktivitasItem {
  final String icon;
  final String description;
  _AktivitasItem({required this.icon, required this.description});
}

class _AktivitasCard extends StatelessWidget {
  final List<_AktivitasItem> items;
  const _AktivitasCard({required this.items});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Aktivitas Terbaru',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            ListView.separated(
              itemCount: items.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (_, __) => const Divider(height: 20),
              itemBuilder: (context, index) {
                final a = items[index];
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SvgPicture.asset(a.icon, width: 28, height: 28),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        a.description,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
