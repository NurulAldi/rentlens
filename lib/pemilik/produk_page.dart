import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../widgets/app_drawer.dart';
import '../widgets/product_image_widget.dart';
import '../providers/product_provider.dart';
import '../utils/drawer_navigator.dart';
import 'product_form_page.dart';

class PemilikProdukPage extends StatefulWidget {
  const PemilikProdukPage({super.key});

  @override
  State<PemilikProdukPage> createState() => _PemilikProdukPageState();
}

class _PemilikProdukPageState extends State<PemilikProdukPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  DrawerMenu _activeMenu = DrawerMenu.produk;

  String _kategori = 'Semua';
  bool _pilihSemua = false;
  final Map<String, bool> _checked = {};

  void _togglePilihSemua(bool value) {
    final provider = Provider.of<ProductProvider>(context, listen: false);
    setState(() {
      _pilihSemua = value;
      for (final p in [
        ...provider.availableProducts,
        ...provider.bookedProducts,
      ]) {
        _checked[p.id] = value;
      }
    });
  }

  void _onHapusProduk(Product p) async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x1A000000),
                    blurRadius: 18,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 8),
                  const Text(
                    'Apakah Anda Yakin ?',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Pastikan anda sudah Yakin untuk menghapus produk!',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF5C62F6),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Tidak'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF5C62F6),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Konfirmasi'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    if (confirmed == true) {
      final provider = Provider.of<ProductProvider>(context, listen: false);
      provider.deleteProduct(p.id);
      setState(() {
        _checked.remove(p.id);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {
        // Apply category filter
        List<Product> tersedia;
        List<Product> dibooking;

        if (_kategori == 'Semua') {
          tersedia = productProvider.availableProducts;
          dibooking = productProvider.bookedProducts;
        } else {
          tersedia = productProvider.availableProducts
              .where(
                (p) => p.category?.toLowerCase() == _kategori.toLowerCase(),
              )
              .toList();
          dibooking = productProvider.bookedProducts
              .where(
                (p) => p.category?.toLowerCase() == _kategori.toLowerCase(),
              )
              .toList();
        }

        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.grey[100],
          drawer: AppDrawer(
            activeMenu: _activeMenu,
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
                _ActionBar(
                  kategori: _kategori,
                  onTambah: () async {
                    // Navigate to Add mode
                    final result = await Navigator.push<Product>(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ProductFormPage(),
                      ),
                    );
                    if (result != null) {
                      productProvider.addProduct(result);
                    }
                  },
                  onKategoriChanged: (val) => setState(() => _kategori = val),
                  onPilihSemua: () => _togglePilihSemua(!_pilihSemua),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Produk Tersedia',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                ),
                const SizedBox(height: 8),
                _ProdukList(
                  items: tersedia,
                  checked: _checked,
                  disabled: false,
                  onChecked: (id, val) => setState(() => _checked[id] = val),
                  onHapus: _onHapusProduk,
                  onEdit: (p) async {
                    final edited = await Navigator.push<Product>(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProductFormPage(initialProduct: p),
                      ),
                    );
                    if (edited != null) {
                      productProvider.updateProduct(edited);
                    }
                  },
                ),
                const SizedBox(height: 20),
                const Text(
                  'Produk Dibooking',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                ),
                const SizedBox(height: 8),
                _ProdukList(
                  items: dibooking,
                  checked: _checked,
                  disabled: true,
                  onChecked: (id, val) => setState(() => _checked[id] = val),
                  onHapus: _onHapusProduk,
                  onEdit: (_) {},
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ActionBar extends StatelessWidget {
  final String kategori;
  final VoidCallback onTambah;
  final ValueChanged<String> onKategoriChanged;
  final VoidCallback onPilihSemua;
  const _ActionBar({
    required this.kategori,
    required this.onTambah,
    required this.onKategoriChanged,
    required this.onPilihSemua,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 40,
          child: ElevatedButton.icon(
            onPressed: onTambah,
            icon: SvgPicture.asset(
              'assets/images/Add-produk.svg',
              width: 18,
              height: 18,
            ),
            label: const Text('Tambah Produk'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF5C62F6),
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              textStyle: const TextStyle(fontSize: 14),
              minimumSize: const Size(0, 40),
              maximumSize: const Size(double.infinity, 40),
            ),
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          height: 40,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: const Color(0xFF5C62F6),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: kategori,
                  icon: SvgPicture.asset(
                    'assets/images/dropdown-down.svg',
                    width: 8,
                    height: 8,
                  ),
                  dropdownColor: Colors.white,
                  style: const TextStyle(color: Colors.black, fontSize: 14),
                  isDense: true,
                  alignment: Alignment.centerLeft,
                  borderRadius: BorderRadius.circular(8),
                  underline: const SizedBox(),
                  items: const [
                    DropdownMenuItem(value: 'Semua', child: Text('Semua')),
                    DropdownMenuItem(value: 'Kamera', child: Text('Kamera')),
                    DropdownMenuItem(value: 'Lensa', child: Text('Lensa')),
                    DropdownMenuItem(value: 'Tripod', child: Text('Tripod')),
                    DropdownMenuItem(
                      value: 'Lighting',
                      child: Text('Lighting'),
                    ),
                  ],
                  onChanged: (v) {
                    if (v != null) onKategoriChanged(v);
                  },
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          height: 40,
          child: ElevatedButton(
            onPressed: onPilihSemua,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF5C62F6),
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              textStyle: const TextStyle(fontSize: 14),
              minimumSize: const Size(0, 40),
              maximumSize: const Size(double.infinity, 40),
            ),
            child: const Text('Pilih Semua'),
          ),
        ),
      ],
    );
  }
}

class _ProdukList extends StatelessWidget {
  final List<Product> items;
  final Map<String, bool> checked;
  final bool disabled;
  final void Function(String, bool) onChecked;
  final void Function(Product) onHapus;
  final void Function(Product) onEdit;
  const _ProdukList({
    required this.items,
    required this.checked,
    required this.disabled,
    required this.onChecked,
    required this.onHapus,
    required this.onEdit,
  });

  String _formatRupiah(int value) {
    final s = value.toString();
    final chars = s.split('').reversed.toList();
    final buf = StringBuffer();
    for (int i = 0; i < chars.length; i++) {
      if (i != 0 && i % 3 == 0) buf.write('.');
      buf.write(chars[i]);
    }
    return buf.toString().split('').reversed.join();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: items.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final p = items[index];
        final isChecked = checked[p.id] ?? false;
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Checkbox(
                  value: isChecked,
                  onChanged: (v) => onChecked(p.id, v ?? false),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Opacity(
                    opacity: disabled ? 0.4 : 1,
                    child: ProductImageWidget(
                      imagePath: p.imageAsset,
                      width: 64,
                      height: 40,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        p.name,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Rp ${_formatRupiah(p.pricePerDay.toInt())}/hari',
                        style: const TextStyle(color: Color(0xFFEA7A00)),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: disabled ? null : () => onEdit(p),
                  icon: SvgPicture.asset(
                    'assets/images/edit.svg',
                    width: 20,
                    height: 20,
                    colorFilter: ColorFilter.mode(
                      disabled ? Colors.black26 : Colors.black,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                IconButton(
                  onPressed: () => onHapus(p),
                  icon: SvgPicture.asset(
                    'assets/images/delete.svg',
                    width: 20,
                    height: 20,
                    colorFilter: const ColorFilter.mode(
                      Colors.red,
                      BlendMode.srcIn,
                    ),
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
