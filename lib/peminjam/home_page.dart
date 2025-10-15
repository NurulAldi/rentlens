import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../pages/product_detail_page.dart';
import '../widgets/app_drawer.dart';
import '../utils/drawer_navigator.dart';
import '../widgets/product_image_widget.dart';
import '../models/session.dart';
import '../providers/product_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final List<String> categories = const [
    'Semua',
    'Kamera',
    'Lensa',
    'Tripod',
    'Lighting',
  ];
  int selectedIndex = 0;
  DrawerMenu activeDrawerMenu = DrawerMenu.home;

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {
        // Get products based on selected category
        final products = selectedIndex == 0
            ? productProvider.availableProducts
            : productProvider.getProductsByCategory(categories[selectedIndex]);

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
          body: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      const Text(
                        'Kategori',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 40,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            final active = index == selectedIndex;
                            return GestureDetector(
                              onTap: () =>
                                  setState(() => selectedIndex = index),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: active
                                      ? Colors.black
                                      : Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: Text(
                                  categories[index],
                                  style: TextStyle(
                                    color: active ? Colors.white : Colors.black,
                                  ),
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 12),
                          itemCount: categories.length,
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
              if (products.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: _EmptyProducts(),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.78,
                        ),
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final p = products[index];
                      return _ProductCard(
                        product: p,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProductDetailPage(product: p),
                          ),
                        ),
                      );
                    }, childCount: products.length),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.product, required this.onTap});
  final Product product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
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
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Rp ${product.pricePerDay.toStringAsFixed(0)}/hari',
                    style: const TextStyle(
                      color: Color(0xFFEA7A00),
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: const [
                      Icon(Icons.star, color: Color(0xFFFFC107), size: 16),
                      SizedBox(width: 4),
                      Text('4.0', style: TextStyle(fontSize: 12)),
                    ],
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

class _EmptyProducts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/no_produk.png', width: 220),
            const SizedBox(height: 20),
            const Text(
              'Produk Tidak Ditemukan!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            const Text(
              'Produk belum tersedia di lokasi anda, coba ubah filter atau cek kategori lain!',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
