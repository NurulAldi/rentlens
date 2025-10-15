import 'package:flutter/foundation.dart';

class PeminjamProfileProvider extends ChangeNotifier {
  String _name = 'Mas Rusdi';
  String _bio = 'Fotografer freelance di padang suka outdoor photo shoot';
  String? _imageAsset = 'assets/images/profile_image.png';
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
    _name = 'Mas Rusdi';
    _bio = 'Fotografer freelance di padang suka outdoor photo shoot';
    _imageAsset = 'assets/images/profile_image.png';
    _imagePath = null;
    notifyListeners();
  }
}
