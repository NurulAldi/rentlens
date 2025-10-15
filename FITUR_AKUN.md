# Fitur Pendaftaran dan Login

## 📋 Ringkasan Fitur

Aplikasi RentLens sekarang memiliki sistem pendaftaran dan login yang lengkap dengan validasi dan manajemen session.

## ✨ Fitur yang Ditambahkan

### 1. **Service Layer - UserService** (`lib/services/user_service.dart`)
- Singleton pattern untuk manajemen user global
- Database dummy dengan 2 user default:
  - **Peminjam**: `peminjam1@email.com` / `password123`
  - **Pemilik**: `pemilik1@email.com` / `password123`

#### Validasi Registrasi:
- ✅ Username minimal 3 karakter
- ✅ Email format valid (regex validation)
- ✅ Password minimal 6 karakter
- ✅ Cek duplikasi username
- ✅ Cek duplikasi email

#### Validasi Login:
- ✅ Email dan password tidak boleh kosong
- ✅ Validasi kombinasi email, password, dan role
- ✅ Pesan error yang informatif

### 2. **Session Management** (`lib/models/session.dart`)
Menyimpan informasi user yang sedang login:
- `currentRole`: Role user (Peminjam/Pemilik)
- `currentUser`: Data user lengkap (username, email, dll)
- Helper getters:
  - `Session.username`: Mendapat username
  - `Session.email`: Mendapat email
  - `Session.isPemilik`: Cek apakah pemilik
  - `Session.isPeminjam`: Cek apakah peminjam
  - `Session.isLoggedIn`: Cek status login

### 3. **Register Page** (`lib/register_page.dart`)
- Form registrasi dengan 3 field: Username, Email, Password
- Toggle role: Peminjam / Pemilik
- Validasi real-time dengan feedback jelas
- Snackbar berwarna (hijau = sukses, merah = error)
- Auto-clear form setelah registrasi berhasil

### 4. **Login Page** (`lib/login_page.dart`)
- Form login dengan 2 field: Email, Password
- Toggle role: Peminjam / Pemilik
- Validasi credentials
- Redirect otomatis:
  - Pemilik → Dashboard Pemilik (`/pemilik/dashboard`)
  - Peminjam → Home (`/home`)
- Simpan data user ke Session

### 5. **Dashboard Personalisasi** (`lib/pemilik/dashboard_page.dart`)
- Sapaan personal: "Selamat Datang, [Username]!"
- Menggunakan `Session.username` untuk menampilkan nama user yang login

## 🎯 Cara Menggunakan

### Registrasi Akun Baru:
1. Buka aplikasi → Halaman Login
2. Klik "Daftar" di bawah
3. Isi Username, Email, Password
4. Pilih role: Peminjam atau Pemilik
5. Klik tombol "Daftar"
6. Jika berhasil, kembali ke halaman login

### Login:
1. Masukkan Email dan Password
2. Pilih role yang sesuai
3. Klik tombol "Login"
4. Akan diarahkan ke halaman sesuai role

### Testing dengan Akun Default:

**Akun Peminjam:**
- Email: `peminjam1@email.com`
- Password: `password123`
- Role: Peminjam

**Akun Pemilik:**
- Email: `pemilik1@email.com`
- Password: `password123`
- Role: Pemilik

## 🔒 Validasi yang Diterapkan

### Registrasi:
- Username: min 3 karakter, unik
- Email: format valid, unik
- Password: min 6 karakter
- Semua field wajib diisi

### Login:
- Email dan password wajib diisi
- Kombinasi email, password, dan role harus cocok
- Case-insensitive untuk email

## 📦 File yang Diubah/Ditambahkan

### Baru:
- `lib/services/user_service.dart` - Service layer untuk user management

### Dimodifikasi:
- `lib/models/session.dart` - Ditambah penyimpanan user lengkap
- `lib/register_page.dart` - Menggunakan UserService + validasi lengkap
- `lib/login_page.dart` - Menggunakan UserService + simpan ke Session
- `lib/pemilik/dashboard_page.dart` - Sapaan personal dari Session

## 🚀 Pengembangan Selanjutnya

Fitur yang bisa ditambahkan:
- [ ] Enkripsi password (bcrypt/hash)
- [ ] Persistent storage (SharedPreferences/SQLite)
- [ ] Forgot password
- [ ] Email verification
- [ ] Profile editing
- [ ] Logout dari semua halaman
- [ ] Remember me checkbox
- [ ] Session timeout
- [ ] Backend integration (Firebase/REST API)

## 💡 Catatan Penting

- Data user saat ini disimpan di memory (hilang saat restart app)
- Password disimpan plain text (untuk development only)
- Dalam production, gunakan:
  - Database lokal (Hive/SQLite) atau
  - Backend server dengan authentication API
  - Password hashing/encryption
