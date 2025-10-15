// Pindahan dari lib/profile_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/app_drawer.dart';
import '../utils/drawer_navigator.dart';

// ...existing code from original profile_page.dart...

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  DrawerMenu activeDrawerMenu = DrawerMenu.profil;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[100],
      drawerScrimColor: Colors.black.withOpacity(0.4),
      drawer: AppDrawer(
        activeMenu: activeDrawerMenu,
        role: 'peminjam',
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
              'assets/images/setting.svg',
              width: 24,
              height: 24,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header profile
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 28,
                  backgroundImage: AssetImage(
                    'assets/images/profile_image.png',
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Mas Rusdi',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Tanggal Bergabung: 9 September 2025',
                      style: TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Biodata Peminjam Card
            _SectionCard(
              title: 'Biodata Peminjam',
              child: Column(
                children: [
                  _infoRow(
                    'Terverifikasi',

                    Image.asset(
                      'assets/images/verified.png',
                      width: 18,
                      height: 18,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _infoRow('Badge', const Text('Penyewa Aktif')),
                  const SizedBox(height: 12),
                  _infoRow(
                    'Bio',
                    const Expanded(
                      child: Text(
                        'Fotografer freelance di padang suka outdoor photo shoot',
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // History Peminjaman Card
            _SectionCard(
              title: 'History Peminjaman',
              trailing: const Text(
                'More >',
                style: TextStyle(color: Colors.black54),
              ),
              child: Column(
                children: const [
                  _HistoryItem(
                    image: 'assets/images/gambar_produk.png',
                    name: 'Nikon Z6 III',
                    price: 'Rp 199.000/hari',
                    date: 'Tanggal: 09/10/2025 - 13/10/2025',
                  ),
                  SizedBox(height: 12),
                  _HistoryItem(
                    image: 'assets/images/gambar_produk.png',
                    name: 'Nikon Z6 III',
                    price: 'Rp 199.000/hari',
                    date: 'Tanggal: 08/10/2025 - 12/10/2025',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Rating dan Ulasan
            const Text(
              'Rating dan Ulasan',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Row(
              children: const [
                Icon(Icons.star, color: Color(0xFFFFC107), size: 32),
                SizedBox(width: 8),
                Text(
                  '4,0',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
                ),
              ],
            ),
            const SizedBox(height: 4),
            const Text('123.456', style: TextStyle(color: Colors.black54)),
            const SizedBox(height: 12),

            const _ReviewCard(),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, this.trailing, required this.child});
  final String title;
  final Widget? trailing;
  final Widget child;

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              if (trailing != null) trailing!,
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

Widget _infoRow(String label, Widget value) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(width: 120, child: Text(label)),
      const SizedBox(width: 8),
      Expanded(
        child: Align(alignment: Alignment.centerRight, child: value),
      ),
    ],
  );
}

class _HistoryItem extends StatelessWidget {
  const _HistoryItem({
    required this.image,
    required this.name,
    required this.price,
    required this.date,
  });
  final String image;
  final String name;
  final String price;
  final String date;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(image, width: 52, height: 52, fit: BoxFit.cover),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              Text(
                price,
                style: const TextStyle(
                  color: Color(0xFFEA7A00),
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                date,
                style: const TextStyle(color: Colors.black54, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ReviewCard extends StatelessWidget {
  const _ReviewCard();

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 16,
                backgroundImage: AssetImage(
                  'assets/images/profile_image2.jpeg',
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Mas Amba',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 2),
                  Text(
                    '09/10/2025',
                    style: TextStyle(color: Colors.black54, fontSize: 12),
                  ),
                ],
              ),
              const Spacer(),
              Row(
                children: const [
                  Icon(Icons.star, color: Color(0xFFFFC107), size: 16),
                  Icon(Icons.star, color: Color(0xFFFFC107), size: 16),
                  Icon(Icons.star, color: Color(0xFFFFC107), size: 16),
                  Icon(Icons.star, color: Color(0xFFFFC107), size: 16),
                  Icon(Icons.star_border, color: Color(0xFFFFC107), size: 16),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Mas Rusdi loh rek, jujur banget kalau soal minjam barang, dibilang sama sistem durasi pinjamannya 7 hari eh baru juga sehari udah dikembalikan, baik banget loh ya',
          ),
        ],
      ),
    );
  }
}
