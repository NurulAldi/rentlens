import 'package:flutter/foundation.dart';
import '../models/product.dart';

class ProductProvider extends ChangeNotifier {
  final List<Product> _products = [];

  // Getter untuk mendapatkan semua produk
  List<Product> get products => List.unmodifiable(_products);

  // Getter untuk produk tersedia (tidak dibooking)
  List<Product> get availableProducts =>
      _products.where((p) => !p.isBooked).toList();

  // Getter untuk produk yang dibooking
  List<Product> get bookedProducts =>
      _products.where((p) => p.isBooked).toList();

  // Filter produk berdasarkan kategori
  List<Product> getProductsByCategory(String category) {
    if (category == 'Semua') {
      return availableProducts;
    }
    return availableProducts
        .where((p) => p.category?.toLowerCase() == category.toLowerCase())
        .toList();
  }

  // Filter produk berdasarkan owner (untuk halaman profil pemilik)
  List<Product> getProductsByOwner(String owner) {
    return _products.where((p) => p.owner == owner).toList();
  }

  // Inisialisasi dengan data dummy
  void initializeDummyData() {
    if (_products.isEmpty) {
      _products.addAll([
        Product(
          id: 't1',
          name: 'Nikon Z6 III',
          imageAsset: 'assets/images/gambar_produk.png',
          pricePerDay: 199000,
          rating: 4.0,
          owner: 'Mas Amba',
          description:
              'Kamera profesional dengan sensor full-frame 24MP, ideal untuk fotografi dan videografi.',
          category: 'Kamera',
          isBooked: false,
        ),
        Product(
          id: 't2',
          name: 'Canon EOS R6',
          imageAsset: 'assets/images/gambar_produk.png',
          pricePerDay: 250000,
          rating: 4.5,
          owner: 'Mas Amba',
          description:
              'Kamera mirrorless full-frame dengan autofocus canggih dan stabilisasi gambar.',
          category: 'Kamera',
          isBooked: false,
        ),
        Product(
          id: 't3',
          name: 'Sony A7 IV',
          imageAsset: 'assets/images/gambar_produk.png',
          pricePerDay: 280000,
          rating: 4.8,
          owner: 'Mas Amba',
          description:
              'Kamera hybrid untuk foto dan video dengan resolusi tinggi.',
          category: 'Kamera',
          isBooked: false,
        ),
        Product(
          id: 't4',
          name: 'Nikon D5600',
          imageAsset: 'assets/images/gambar_produk.png',
          pricePerDay: 150000,
          rating: 4.2,
          owner: 'Mas Amba',
          description: 'DSLR entry-level dengan kualitas gambar excellent.',
          category: 'Kamera',
          isBooked: false,
        ),
        Product(
          id: 'b1',
          name: 'Canon EF 50mm f/1.8',
          imageAsset: 'assets/images/gambar_produk.png',
          pricePerDay: 75000,
          rating: 4.6,
          owner: 'Mas Amba',
          description: 'Lensa prime terbaik untuk portrait photography.',
          category: 'Lensa',
          isBooked: true,
        ),
      ]);
    }
  }

  // CREATE - Tambah produk baru
  void addProduct(Product product) {
    _products.add(product);
    notifyListeners();
  }

  // UPDATE - Edit produk
  void updateProduct(Product updatedProduct) {
    final index = _products.indexWhere((p) => p.id == updatedProduct.id);
    if (index != -1) {
      _products[index] = updatedProduct;
      notifyListeners();
    }
  }

  // DELETE - Hapus produk
  void deleteProduct(String productId) {
    _products.removeWhere((p) => p.id == productId);
    notifyListeners();
  }

  // DELETE - Hapus multiple produk
  void deleteProducts(List<String> productIds) {
    _products.removeWhere((p) => productIds.contains(p.id));
    notifyListeners();
  }

  // Toggle booking status
  void toggleBookingStatus(String productId) {
    final index = _products.indexWhere((p) => p.id == productId);
    if (index != -1) {
      final product = _products[index];
      _products[index] = Product(
        id: product.id,
        name: product.name,
        imageAsset: product.imageAsset,
        pricePerDay: product.pricePerDay,
        rating: product.rating,
        owner: product.owner,
        description: product.description,
        category: product.category,
        isBooked: !product.isBooked,
      );
      notifyListeners();
    }
  }

  // Get single product by ID
  Product? getProductById(String id) {
    try {
      return _products.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }
}
