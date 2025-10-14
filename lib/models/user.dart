class User {
  final String username;
  final String email;
  final String password;
  final String role; // 'Peminjam' atau 'Pemilik'

  const User({
    required this.username,
    required this.email,
    required this.password,
    required this.role,
  });
}
