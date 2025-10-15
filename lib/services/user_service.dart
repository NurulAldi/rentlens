import '../models/user.dart';

class UserService {
  // Singleton pattern
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;
  UserService._internal();

  // Simulasi database user (dalam aplikasi nyata, gunakan database lokal atau backend)
  final List<User> _users = [
    // Akun testing dengan data hardcode
    User(
      username: 'peminjam1',
      email: 'peminjam1@email.com',
      password: 'password123',
      role: 'Peminjam',
      profileImage: 'assets/images/profile_image.png',
      bio: 'Fotografer freelance di padang suka outdoor photo shoot',
      joinDate: DateTime(2024, 1, 15), // Data tetap untuk testing
      isVerified: true,
    ),
    User(
      username: 'pemilik1',
      email: 'pemilik1@email.com',
      password: 'password123',
      role: 'Pemilik',
      profileImage: 'assets/images/profile_image2.jpeg',
      bio: 'Maniak pengoleksi kamera yang sudah ditandatangani bahill',
      joinDate: DateTime(2023, 6, 20), // Data tetap untuk testing
      isVerified: true,
    ),
  ];

  /// Mendapatkan semua user (untuk debugging)
  List<User> get allUsers => List.unmodifiable(_users);

  /// Validasi format email
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  /// Cek apakah username sudah terdaftar
  bool isUsernameExists(String username) {
    return _users.any(
      (user) => user.username.toLowerCase() == username.toLowerCase(),
    );
  }

  /// Cek apakah email sudah terdaftar
  bool isEmailExists(String email) {
    return _users.any(
      (user) => user.email.toLowerCase() == email.toLowerCase(),
    );
  }

  /// Register user baru
  /// Returns: (success, message)
  (bool, String) register({
    required String username,
    required String email,
    required String password,
    required String role,
  }) {
    // Validasi input kosong
    if (username.trim().isEmpty) {
      return (false, 'Username tidak boleh kosong');
    }
    if (email.trim().isEmpty) {
      return (false, 'Email tidak boleh kosong');
    }
    if (password.isEmpty) {
      return (false, 'Password tidak boleh kosong');
    }

    // Validasi panjang username
    if (username.trim().length < 3) {
      return (false, 'Username minimal 3 karakter');
    }

    // Validasi format email
    if (!_isValidEmail(email.trim())) {
      return (false, 'Format email tidak valid');
    }

    // Validasi panjang password
    if (password.length < 6) {
      return (false, 'Password minimal 6 karakter');
    }

    // Cek duplikasi username
    if (isUsernameExists(username.trim())) {
      return (false, 'Username sudah terdaftar');
    }

    // Cek duplikasi email
    if (isEmailExists(email.trim())) {
      return (false, 'Email sudah terdaftar');
    }

    // Tambahkan user baru
    _users.add(
      User(
        username: username.trim(),
        email: email.trim().toLowerCase(),
        password: password,
        role: role,
      ),
    );

    return (true, 'Akun $role berhasil dibuat!');
  }

  /// Login user
  /// Returns: (success, message, user)
  (bool, String, User?) login({
    required String email,
    required String password,
    required String role,
  }) {
    // Validasi input kosong
    if (email.trim().isEmpty) {
      return (false, 'Email tidak boleh kosong', null);
    }
    if (password.isEmpty) {
      return (false, 'Password tidak boleh kosong', null);
    }

    try {
      // Cari user yang cocok
      final user = _users.firstWhere(
        (u) =>
            u.email.toLowerCase() == email.trim().toLowerCase() &&
            u.password == password &&
            u.role == role,
      );

      return (true, 'Login berhasil!', user);
    } catch (e) {
      return (false, 'Email, password, atau role salah!', null);
    }
  }

  /// Mendapatkan user berdasarkan email
  User? getUserByEmail(String email) {
    try {
      return _users.firstWhere(
        (u) => u.email.toLowerCase() == email.trim().toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }
}
