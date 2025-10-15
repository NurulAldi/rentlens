class User {
  final String username;
  final String email;
  final String password;
  final String role; // 'Peminjam' atau 'Pemilik'
  final String? profileImage; // Path ke image asset atau file
  final String? bio;
  final DateTime joinDate;
  final bool isVerified; // Semua akun otomatis verified

  User({
    required this.username,
    required this.email,
    required this.password,
    required this.role,
    this.profileImage,
    this.bio,
    DateTime? joinDate,
    this.isVerified = true, // Default true untuk semua akun
  }) : joinDate = joinDate ?? DateTime.now();

  User copyWith({
    String? username,
    String? email,
    String? password,
    String? role,
    String? profileImage,
    String? bio,
    DateTime? joinDate,
    bool? isVerified,
  }) {
    return User(
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      role: role ?? this.role,
      profileImage: profileImage ?? this.profileImage,
      bio: bio ?? this.bio,
      joinDate: joinDate ?? this.joinDate,
      isVerified: isVerified ?? this.isVerified,
    );
  }
}
