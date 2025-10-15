import 'package:flutter/foundation.dart';
import '../models/session.dart';

class PeminjamProfileProvider extends ChangeNotifier {
  String _name = '';
  String _bio = '';
  String? _imageAsset;
  String? _imagePath;
  DateTime? _joinDate;
  bool _isVerified = true;

  PeminjamProfileProvider() {
    _loadFromSession();
  }

  // Getters
  String get name => _name;
  String get bio => _bio;
  String? get imageAsset => _imageAsset;
  String? get imagePath => _imagePath;
  DateTime? get joinDate => _joinDate;
  bool get isVerified => _isVerified;

  // Load data dari Session
  void _loadFromSession() {
    final user = Session.currentUser;
    if (user == null) return;

    // Untuk akun peminjam1, gunakan nama "Mas Rusdi" (data hardcode)
    if (user.username.toLowerCase() == 'peminjam1') {
      _name = 'Mas Rusdi';
    } else {
      // Untuk akun baru, gunakan username sebagai nama
      _name = user.username;
    }

    _bio = user.bio ?? '';
    _imageAsset = user.profileImage;
    _joinDate = user.joinDate;
    _isVerified = user.isVerified;
    notifyListeners();
  }

  // Reload data dari session (dipanggil setelah login)
  void reloadFromSession() {
    _loadFromSession();
  }

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

  // Reset to session data
  void reset() {
    _loadFromSession();
  }
}
