import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../models/product.dart';
import 'pemilik_drawer.dart';
import 'product_form_page.dart';

class PemilikProdukPage extends StatefulWidget {
  const PemilikProdukPage({super.key});

  @override
  State<PemilikProdukPage> createState() => _PemilikProdukPageState();
}

class _PemilikProdukPageState extends State<PemilikProdukPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  PemilikDrawerMenu _activeMenu = PemilikDrawerMenu.produk;

  final List<Product> _tersedia = List.generate(
    4,
    (i) => Product(
      id: 't$i',
      name: 'Nikon Z6 III',
      imageAsset: 'assets/images/gambar_produk.png',
      pricePerDay: 199000,
      rating: 4.0,
      owner: 'Anda',
    ),
  );
  final List<Product> _dibooking = List.generate(
    1,
    (i) => Product(
      id: 'b$i',
      name: 'Nikon Z6 III',
      imageAsset: 'assets/images/gambar_produk.png',
      pricePerDay: 199000,
      rating: 4.0,
      owner: 'Anda',
    ),
  );

  String _kategori = 'Semua';
  bool _pilihSemua = false;
  final Map<String, bool> _checked = {};

  void _togglePilihSemua(bool value) {
    setState(() {
      _pilihSemua = value;
      for (final p in [..._tersedia, ..._dibooking]) {
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
      setState(() {
        _tersedia.removeWhere((e) => e.id == p.id);
        _dibooking.removeWhere((e) => e.id == p.id);
        _checked.remove(p.id);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[100],
      drawer: PemilikDrawer(
        activeMenu: _activeMenu,
        onMenuTap: (m) {
          setState(() => _activeMenu = m);
          switch (m) {
            case PemilikDrawerMenu.dashboard:
              // TODO: navigate to dashboard when implemented
              break;
            case PemilikDrawerMenu.produk:
              // already here
              break;
            case PemilikDrawerMenu.notifikasi:
              Navigator.pushReplacementNamed(context, '/notifications');
              break;
            case PemilikDrawerMenu.profil:
              Navigator.pushReplacementNamed(context, '/profile');
              break;
            case PemilikDrawerMenu.logout:
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
                  MaterialPageRoute(builder: (_) => const ProductFormPage()),
                );
                if (result != null) {
                  setState(() {
                    _tersedia.add(result);
                  });
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
              items: _tersedia,
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
                  setState(() {
                    final idx = _tersedia.indexWhere((e) => e.id == edited.id);
                    if (idx != -1) _tersedia[idx] = edited;
                  });
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
              items: _dibooking,
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
      children: [
        ElevatedButton.icon(
          onPressed: onTambah,
          icon: SvgPicture.asset(
            'assets/images/Add-produk.svg',
            width: 18,
            height: 18,
          ),
          label: const Text('Tambah Produk'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF5C62F6),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: const Color(0xFF5C62F6),
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1A000000),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: kategori,
              icon: SvgPicture.asset(
                'assets/images/dropdown.svg',
                width: 14,
                height: 14,
                color: Colors.white,
              ),
              dropdownColor: Colors.white,
              style: const TextStyle(color: Colors.white),
              items: const [
                DropdownMenuItem(value: 'Semua', child: Text('Kategori')),
                DropdownMenuItem(value: 'Kamera', child: Text('Kamera')),
                DropdownMenuItem(value: 'Lensa', child: Text('Lensa')),
                DropdownMenuItem(value: 'Tripod', child: Text('Tripod')),
              ],
              onChanged: (v) {
                if (v != null) onKategoriChanged(v);
              },
            ),
          ),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: onPilihSemua,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF5C62F6),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text('Pilih Semua'),
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
                    child: Image.asset(
                      p.imageAsset,
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
                    children: const [
                      Text(
                        'Nikon Z6 III',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Rp 199.000/hari',
                        style: TextStyle(color: Color(0xFFEA7A00)),
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
