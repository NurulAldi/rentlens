import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class ImageStorageHelper {
  /// Menyimpan gambar ke direktori aplikasi permanen
  /// Returns: path gambar yang disimpan
  static Future<String> saveImage(File imageFile) async {
    try {
      // Dapatkan direktori aplikasi
      final appDir = await getApplicationDocumentsDirectory();

      // Buat folder untuk menyimpan gambar produk
      final productImagesDir = Directory('${appDir.path}/product_images');
      if (!await productImagesDir.exists()) {
        await productImagesDir.create(recursive: true);
      }

      // Generate nama file unik menggunakan timestamp
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final extension = path.extension(imageFile.path);
      final fileName = 'product_$timestamp$extension';

      // Path lengkap untuk file baru
      final savedImagePath = '${productImagesDir.path}/$fileName';

      // Copy file ke lokasi baru
      final savedImage = await imageFile.copy(savedImagePath);

      return savedImage.path;
    } catch (e) {
      print('Error saving image: $e');
      rethrow;
    }
  }

  /// Menghapus gambar dari storage
  static Future<void> deleteImage(String imagePath) async {
    try {
      // Jangan hapus jika itu asset
      if (imagePath.startsWith('assets/')) {
        return;
      }

      final file = File(imagePath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      print('Error deleting image: $e');
    }
  }

  /// Check apakah path adalah asset atau file lokal
  static bool isAssetImage(String imagePath) {
    return imagePath.startsWith('assets/');
  }

  /// Check apakah file ada
  static Future<bool> imageExists(String imagePath) async {
    if (isAssetImage(imagePath)) {
      return true; // Assume assets exist
    }

    try {
      final file = File(imagePath);
      return await file.exists();
    } catch (e) {
      return false;
    }
  }
}
