import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../widgets/app_drawer.dart';
import '../pages/product_detail_page.dart';
import '../providers/product_provider.dart';

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
    'Aksesoris',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[100],
      drawerScrimColor: Colors.black.withOpacity(0.4),
      drawer: AppDrawer(
        activeMenu: activeMenu,
        role: 'pemilik',
        onMenuTap: (menu) {
          setState(() => activeMenu = menu);
          switch (menu) {
            case DrawerMenu.dashboard:
              Navigator.pushReplacementNamed(context, '/home');
              break;
            case DrawerMenu.produk:
              // navigate to produk page if exists
              break;
            case DrawerMenu.notifikasi:
              Navigator.pushReplacementNamed(context, '/notifications');
              break;
            case DrawerMenu.profil:
              // already here
              break;
            case DrawerMenu.logout:
            case DrawerMenu.home:
              // handled in drawer
              break;
          }
        },
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
            // Header
            Row(
              children: const [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: AssetImage(
                    'assets/images/profile_image2.jpeg',
                  ),
                ),
                SizedBox(width: 12),
                Text(
                  'Mas Amba',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
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
                  _infoRow('Badge', const Text('Pemilik Aktif')),
                  const SizedBox(height: 12),
                  _infoRow(
                    'Bio',
                    const Text(
                      'Maniak pengoleksi kamera yang sudah ditandatangani bahill',
                      textAlign: TextAlign.right,
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
                    height: 600, // fixed viewport height for demo scrollables
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
    Widget cell(String big, String small) {
      return Expanded(
        child: Column(
          children: [
            Text(
              big,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
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
          cell('99%', 'Review Positif'),
          cell('30rb x', 'Produk Dipinjam'),
          cell('1rb +', 'Total Ulasan'),
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
                  'Mas Amba',
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
                  return const Center(child: Text('Tidak ada produk'));
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
                                child: Image.asset(
                                  product.imageAsset,
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
