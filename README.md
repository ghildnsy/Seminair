# 📝 Seminair - Web Pendaftaran Seminar

Aplikasi ini digunakan untuk pengelolaan dan pendaftaran peserta seminar secara online. Dibangun berbasis web menggunakan PHP native

## ✨ Fitur Utama
- SignIn/SignUp
- Pendaftaran peserta seminar.
- Menyimpan data event dan peserta ke database.
- Panel admin untuk melihat & mengelola data pendaftar.

---

## Setup Lokal (PHP Native)

### Prasyarat
- PHP 8+
- MySQL / MariaDB (Laragon, XAMPP, atau setara)
- Node.js + npm

### 1) Install dependency frontend
```bash
npm install
```

### 2) Konfigurasi database
Edit `config.php` dan sesuaikan host/user/password/database dengan MySQL lokal.

Contoh untuk Laragon default (password kosong):
```php
$server = "localhost";
$user = "root";
$password = "";
$database_name = "seminair";
```

### 3) Migrasi tabel
Import file SQL berikut ke phpMyAdmin:

`database/seminair_migration.sql`

File tersebut akan:
- membuat database `seminair`
- membuat tabel `admin`, `pengguna`, `kategori`, `event`, `daftar_peserta`
- menambahkan seed kategori
- menambahkan akun admin default

Admin default:
- username: `admin`
- password: `admin123`

### 4) Jalankan aplikasi
Jalankan server PHP dari root project:
```bash
php -S localhost:8000
```

Lalu buka:
- Frontend: `http://localhost:8000`
- Admin: `http://localhost:8000/admin/Routes/admin_login.php`

Catatan:
- Project ini bukan Laravel, jadi tidak menggunakan `php artisan`.
