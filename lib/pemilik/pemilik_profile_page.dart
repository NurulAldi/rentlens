import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../widgets/app_drawer.dart';
import '../utils/drawer_navigator.dart';
import '../widgets/product_image_widget.dart';
import '../pages/product_detail_page.dart';
import '../providers/product_provider.dart';
import '../models/session.dart';
import '../providers/profile_provider.dart';
import 'pemilik_edit_profile_page.dart';
import 'dart:io';

class PemilikProfilePage extends StatefulWidget {
  const PemilikProfilePage({super.key});

  @override
  State<PemilikProfilePage> createState() => _PemilikProfilePageState();
}

class _PemilikProfilePageState extends State<PemilikProfilePage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late TabController _tabController;
  DrawerMenu activeMenu = DrawerMenu.profil;

  final List<String> _categories = const [
    'Semua',
    'Kamera',
    'Lensa',
    'Tripod',
    'Lighting',
  ];
  int _selectedCategory = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    final months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, profileProvider, child) {
        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.grey[100],
          drawerScrimColor: Colors.black.withOpacity(0.4),
          drawer: AppDrawer(
            activeMenu: activeMenu,
            role: 'pemilik',
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
              PopupMenuButton<String>(
                icon: SvgPicture.asset(
                  'assets/images/setting.svg',
                  width: 24,
                  height: 24,
                ),
                offset: const Offset(0, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit, size: 20),
                        SizedBox(width: 12),
                        Text('Edit Profil'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'logout',
                    child: Row(
                      children: [
                        Icon(Icons.logout, size: 20, color: Colors.red),
                        SizedBox(width: 12),
                        Text('Logout', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
                onSelected: (value) {
                  if (value == 'edit') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const PemilikEditProfilePage(),
                      ),
                    );
                  } else if (value == 'logout') {
                    Session.logout();
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/login',
                      (_) => false,
                    );
                  }
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.grey.shade300,
                      backgroundImage: profileProvider.imagePath != null
                          ? FileImage(File(profileProvider.imagePath!))
                          : profileProvider.imageAsset != null
                          ? AssetImage(profileProvider.imageAsset!)
                                as ImageProvider
                          : null,
                      child:
                          profileProvider.imagePath == null &&
                              profileProvider.imageAsset == null
                          ? const Icon(
                              Icons.person,
                              size: 24,
                              color: Colors.grey,
                            )
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          profileProvider.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          profileProvider.joinDate != null
                              ? 'Tanggal Bergabung: ${_formatDate(profileProvider.joinDate!)}'
                              : 'Tanggal Bergabung: -',
                          style: const TextStyle(color: Colors.black54),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Biodata Pemilik
                _SectionCard(
                  title: 'Biodata Pemilik',
                  trailing: const SizedBox.shrink(),
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
                      _infoRow(
                        'Bio',
                        Text(
                          profileProvider.bio.isEmpty
                              ? '-'
                              : profileProvider.bio,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: profileProvider.bio.isEmpty
                                ? Colors.grey
                                : Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Stats Card
                _StatsCard(),

                const SizedBox(height: 12),

                // Tabs
                Container(
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
                  child: Column(
                    children: [
                      TabBar(
                        controller: _tabController,
                        indicatorColor: const Color(0xFF5C62F6),
                        labelColor: Colors.black,
                        tabs: [
                          Tab(
                            icon: SvgPicture.asset(
                              'assets/images/store.svg',
                              width: 22,
                              height: 22,
                            ),
                          ),
                          Tab(
                            icon: SvgPicture.asset(
                              'assets/images/star.svg',
                              width: 22,
                              height: 22,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 600,
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            // Toko Tab
                            _StoreTab(
                              categories: _categories,
                              selectedIndex: _selectedCategory,
                              onSelect: (i) {
                                setState(() => _selectedCategory = i);
                              },
                            ),
                            // Ulasan Tab
                            const _ReviewsTab(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child, this.trailing});
  final String title;
  final Widget child;
  final Widget? trailing;
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

class _StatsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Cek apakah ini akun testing (pemilik1) atau akun baru
    final currentUser = Session.currentUser;
    final isTestAccount = currentUser?.username.toLowerCase() == 'pemilik1';

    Widget cell(String big, String small) {
      return Expanded(
        child: Column(
          children: [
            Text(
              big,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 20,
                color: isTestAccount ? Colors.black : Colors.grey,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              small,
              style: const TextStyle(color: Colors.black54, fontSize: 12),
            ),
          ],
        ),
      );
    }

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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          cell(isTestAccount ? '99%' : '-', 'Review Positif'),
          cell(isTestAccount ? '30rb x' : '-', 'Produk Dipinjam'),
          cell(isTestAccount ? '1rb +' : '-', 'Total Ulasan'),
        ],
      ),
    );
  }
}

class _StoreTab extends StatelessWidget {
  const _StoreTab({
    required this.categories,
    required this.selectedIndex,
    required this.onSelect,
  });
  final List<String> categories;
  final int selectedIndex;
  final void Function(int) onSelect;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          const Text(
            'Kategori',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 38,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, i) {
                final active = i == selectedIndex;
                return GestureDetector(
                  onTap: () => onSelect(i),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: active ? Colors.black : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Text(
                      categories[i],
                      style: TextStyle(
                        color: active ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (_, __) => const SizedBox(width: 10),
            ),
          ),
          const SizedBox(height: 12),
          // Grid 2 kolom
          Expanded(
            child: Consumer<ProductProvider>(
              builder: (context, productProvider, child) {
                // Filter produk berdasarkan kategori dan owner
                final ownerProducts = productProvider.getProductsByOwner(
                  Session.username,
                );
                final filteredProducts = selectedIndex == 0
                    ? ownerProducts
                    : ownerProducts
                          .where(
                            (p) =>
                                p.category?.toLowerCase() ==
                                categories[selectedIndex].toLowerCase(),
                          )
                          .toList();

                if (filteredProducts.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inventory_2_outlined,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Belum ada produk',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tambahkan produk pertama Anda',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return GridView.builder(
                  itemCount: filteredProducts.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.78,
                  ),
                  itemBuilder: (context, index) {
                    final product = filteredProducts[index];

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProductDetailPage(product: product),
                          ),
                        );
                      },
                      child: Container(
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                              ),
                              child: AspectRatio(
                                aspectRatio: 16 / 9,
                                child: ProductImageWidget(
                                  imagePath: product.imageAsset,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              child: Text(
                                product.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              child: Text(
                                'Rp ${product.pricePerDay.toStringAsFixed(0)}/hari',
                                style: const TextStyle(
                                  color: Color(0xFFEA7A00),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: Color(0xFFFFC107),
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    product.rating.toString(),
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewsTab extends StatelessWidget {
  const _ReviewsTab();
  @override
  Widget build(BuildContext context) {
    // Cek apakah ini akun testing (pemilik1) atau akun baru
    final currentUser = Session.currentUser;
    final isTestAccount = currentUser?.username.toLowerCase() == 'pemilik1';

    if (!isTestAccount) {
      // Tampilkan placeholder untuk akun baru
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.rate_review_outlined,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'Belum ada ulasan',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Ulasan akan muncul setelah produk disewa',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
            ),
          ],
        ),
      );
    }

    // Tampilkan data dummy untuk akun testing
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: 6,
      itemBuilder: (context, i) {
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
            children: const [
              Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundImage: AssetImage(
                      'assets/images/profile_image2.jpeg',
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Mas Amba',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Spacer(),
                  Row(
                    children: [
                      Icon(Icons.star, color: Color(0xFFFFC107), size: 16),
                      Icon(Icons.star, color: Color(0xFFFFC107), size: 16),
                      Icon(Icons.star, color: Color(0xFFFFC107), size: 16),
                      Icon(Icons.star, color: Color(0xFFFFC107), size: 16),
                      Icon(
                        Icons.star_border,
                        color: Color(0xFFFFC107),
                        size: 16,
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                'Barang mulus, sesuai deskripsi. Respon cepat, recommended!',
              ),
            ],
          ),
        );
      },
      separatorBuilder: (_, __) => const SizedBox(height: 12),
    );
  }
}
