enum UserRole { peminjam, pemilik }

class Session {
  static UserRole? currentRole;

  static void login(UserRole role) {
    currentRole = role;
  }

  static void logout() {
    currentRole = null;
  }

  static bool get isPemilik => currentRole == UserRole.pemilik;
  static bool get isPeminjam => currentRole == UserRole.peminjam;
}
