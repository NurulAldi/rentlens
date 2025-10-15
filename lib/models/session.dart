import 'user.dart';

enum UserRole { peminjam, pemilik }

class Session {
  static UserRole? currentRole;
  static User? currentUser;

  static void login(UserRole role, {User? user}) {
    currentRole = role;
    currentUser = user;
  }

  static void logout() {
    currentRole = null;
    currentUser = null;
  }

  static bool get isPemilik => currentRole == UserRole.pemilik;
  static bool get isPeminjam => currentRole == UserRole.peminjam;
  static bool get isLoggedIn => currentRole != null;

  static String get username => currentUser?.username ?? 'User';
  static String get email => currentUser?.email ?? '';
}
