import 'package:flutter/foundation.dart';

class ProfileProvider extends ChangeNotifier {
  String _name = 'Mas Amba';
  String _bio = 'Maniak pengoleksi kamera yang sudah ditandatangani bahill';
  String? _imageAsset = 'assets/images/profile_image2.jpeg';
  String? _imagePath;

  // Getters
  String get name => _name;
  String get bio => _bio;
  String? get imageAsset => _imageAsset;
  String? get imagePath => _imagePath;

  // Update profile
  void updateProfile({
    required String name,
    required String bio,
    String? imagePath,
    String? imageAsset,
  }) {
    _name = name;
    _bio = bio;

    if (imagePath != null) {
      _imagePath = imagePath;
      _imageAsset = null;
    } else if (imageAsset != null) {
      _imageAsset = imageAsset;
      _imagePath = null;
    }

    notifyListeners();
  }

  // Reset to default
  void reset() {
    _name = 'Mas Amba';
    _bio = 'Maniak pengoleksi kamera yang sudah ditandatangani bahill';
    _imageAsset = 'assets/images/profile_image2.jpeg';
    _imagePath = null;
    notifyListeners();
  }
}
