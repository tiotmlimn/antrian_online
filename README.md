# Antrian Online - UNPAM Health Care

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)

**"Antre Tanpa Ribet, Sehat Tanpa Menunggu"**

Sistem manajemen antrean kesehatan digital untuk klinik **Universitas Pamulang (UNPAM)**. Aplikasi mobile ini menghubungkan mahasiswa, staf, dan admin klinik dalam satu ekosistem antrean daring yang efisien.

---

## Fitur Utama

### Multi-Role System

Aplikasi ini memiliki 3 role pengguna dengan akses berbeda:

| Role | Akses |
|------|-------|
| **User** | Ambil antrean, lihat status, download tiket PDF, riwayat antrean |
| **Staff** | Panggil antrean berikutnya, tandai selesai, kelola daftar antrean |
| **Admin** | Kelola user, kelola poliklinik, lihat statistik harian |

### Autentikasi

- Login/Register dengan email dan password
- Google Sign-In
- Reset password via email
- Seed user default saat pertama kali dijalankan

### Fitur Per Role

#### User (Mahasiswa/Staf)
- **Beranda**: Tampilan tiket antrean aktif dengan desain custom, tips antrean, statistik cepat, daftar poliklinik aktif
- **Layanan**: Daftar poliklinik (Poli) dengan status buka/tutup
- **Riwayat**: Daftar antrean lama dengan badge status, bisa hapus riwayat
- **Profil**: Lihat/edit foto profil, lihat foto KTM, upload foto KTM & profil untuk verifikasi admin
- Download tiket antrean sebagai PDF

#### Staff
- Dashboard dengan ringkasan statistik hari ini (total, selesai, menunggu)
- Tampilan "Sedang Memanggil" dengan aksi "Selesai"
- Kelola antrean per poliklinik: panggil berikutnya, tandai selesai
- Lihat semua antrean dikelompokkan per poli

#### Admin
- Dashboard dengan kartu kampus, statistik grid, aksi cepat, ringkasan per poli
- **Kelola User**: Tambah/edit/hapus user, cari, approve foto profil & KTM
- **Kelola Poli**: Tambah/hapus poliklinik, toggle aktif/nonaktif

---

## Tech Stack

| Tech | Deskripsi |
|------|-----------|
| **Flutter** | Framework UI (Material 3) |
| **Dart SDK** | ^3.12.2 |
| **Provider** | State management |
| **Firebase Auth** | Autentikasi pengguna |
| **Firebase Realtime Database** | Backend database untuk users, queues, polis |
| **PDF + Printing** | Generate dan cetak tiket antrean |
| **Google Sign-In** | Login dengan akun Google |
| **Cached Network Image** | Cache gambar profil |

---

## Struktur Project

```
lib/
├── main.dart                          # Entry point app
├── firebase_options.dart              # Konfigurasi Firebase per platform
├── models/
│   ├── queue_model.dart               # Model data antrean
│   ├── user_model.dart                # Model data pengguna
│   ├── poly_model.dart                # Model data poliklinik
│   └── nav_item_model.dart            # Model item navigasi
├── providers/
│   ├── auth_provider.dart             # State management autentikasi & user
│   └── queue_provider.dart            # State management antrean & poli
├── services/
│   └── firebase_service.dart          # Firebase singleton & references
├── screens/
│   ├── splash_screen.dart             # Splash screen saat startup
│   ├── auth_gate.dart                 # Routing berbasis role
│   ├── login_screen.dart              # Login & register
│   ├── user/                          # Screen user
│   │   ├── user_dashboard.dart        # Dashboard dengan bottom nav
│   │   ├── user_beranda_tab.dart      # Tab beranda
│   │   ├── user_layanan_tab.dart      # Tab layanan/poli
│   │   ├── user_riwayat_tab.dart      # Tab riwayat
│   │   └── user_profil_tab.dart       # Tab profil
│   ├── staff/                         # Screen staff
│   │   ├── staff_dashboard.dart       # Dashboard staff
│   │   └── staff_manage.dart          # Kelola antrean
│   └── admin/                         # Screen admin
│       ├── admin_dashboard.dart       # Dashboard admin
│       ├── admin_manage_users.dart    # Kelola user
│       └── admin_manage_poly.dart     # Kelola poliklinik
├── widgets/
│   ├── glass_card.dart                # Komponen kartu glassmorphism
│   ├── glass_button.dart              # Komponen tombol glassmorphism
│   ├── custom_bottom_nav.dart         # Bottom navigation bar
│   ├── floating_app_bar.dart          # App bar floating
│   └── app_drawer.dart                # Drawer navigasi staff/admin
└── theme/
    └── app_theme.dart                 # Tema warna, gradient, glass effects

android/
└── app/
    ├── google-services.json           # Konfigurasi Firebase Android
    └── src/main/AndroidManifest.xml   # Manifest aplikasi

assets/
├── unpam.png                          # Logo UNPAM
├── google.png                         # Logo Google Sign-In
└── logosi.jpeg                        # Logo aplikasi
```

---

## Data Models

### UserModel
| Field | Tipe | Keterangan |
|-------|------|-----------|
| id | String | ID unik pengguna |
| name | String | Nama lengkap |
| email | String | Email login |
| password | String | Password (disimpan di Firebase Auth) |
| role | String | `user`, `staff`, atau `admin` |
| nim | String | NIM mahasiswa (opsional) |
| profilePhoto | String | URL foto profil |
| ktmUrl | String | URL foto KTM |
| profilePhotoApproved | bool | Status verifikasi foto profil |
| ktmApproved | bool | Status verifikasi KTM |
| createdAt | String | Tanggal registrasi |

### QueueModel
| Field | Tipe | Keterangan |
|-------|------|-----------|
| id | String | ID unik antrean |
| ticketNumber | String | Nomor antrean (format: POLI-XXX) |
| userId | String | ID pengguna pengambil antrean |
| userName | String | Nama pengguna |
| polyId | String | ID poliklinik |
| polyName | String | Nama poliklinik |
| status | String | `waiting`, `called`, `completed`, `cancelled` |
| createdAt | String | Tanggal & waktu pengambilan antrean |
| estimatedTime | String | Estimasi waktu tunggu |

### PolyModel
| Field | Tipe | Keterangan |
|-------|------|-----------|
| id | String | ID unik poliklinik |
| name | String | Nama poliklinik |
| description | String | Deskripsi layanan |
| isActive | bool | Status buka/tutup |

---

## Konfigurasi Firebase

Firebase telah dikonfigurasi dengan project **`antrian-online-138aa`**:

- **Project ID**: `antrian-online-138aa`
- **Realtime Database URL**: `https://antrian-online-138aa-default-rtdb.asia-southeast1.firebasedatabase.app`
- **Platforms**: Android, iOS, Web, macOS, Windows

### Firebase Console Setup

Pastikan layanan berikut diaktifkan di [Firebase Console](https://console.firebase.google.com):

1. **Authentication**: Email/Password + Google provider
2. **Realtime Database**: 
   - Rules untuk development:
     ```
     {
       "rules": {
         ".read": true,
         ".write": true
       }
     }
     ```
3. **Storage** (jika ingin upload foto profil/KTM - saat ini menggunakan URL)

---

## User Default

Saat pertama kali dijalankan, aplikasi otomatis menambahkan 3 user default:

| Role | Email | Password |
|------|-------|----------|
| Admin | admin@kampus.ac.id | admin123 |
| Staff | staff@kampus.ac.id | staff123 |
| User | user@kampus.ac.id | user123 |

---

## Cara Menjalankan

### Prerequisites

- Flutter SDK ^3.12.x
- Dart SDK ^3.12.x
- Android Studio / VS Code
- Firebase project yang sudah dikonfigurasi

### Langkah-langkah

```bash
# 1. Clone repository
git clone <repo-url>
cd antrian_online

# 2. Install dependencies
flutter pub get

# 3. Pastikan google-services.json sudah ada di android/app/
# File ini sudah disertakan dalam repository

# 4. Jalankan aplikasi
flutter run
```

### Build APK (Android)

```bash
flutter build apk --release
```

---

## Tampilan UI

Aplikasi menggunakan desain **Glassmorphism** dengan:

- **Warna utama**: Biru (`#2563EB`, `#4F46E5`) dan Ungu (`#7C3AED`)
- **Mode**: Dark theme
- **Effects**: Backdrop blur, transparan semi, border putih
- **Komponen khusus**: `GlassCard`, `GlassButton`, `FloatingAppBar`

---

## Catatan Pengembangan

- Belum ada Cloud Messaging (FCM) untuk notifikasi push
- Upload foto profil/KTM menggunakan URL string (bisa diganti dengan Firebase Storage)
- Realtime Database digunakan untuk sinkronisasi data real-time
- Nomor antrean digenerate otomatis per poliklinik per hari

---

## Kontribusi

Project ini dikembangkan untuk memenuhi kebutuhan sistem antrean kesehatan di UNPAM. Untuk pertanyaan atau kontribusi, silakan hubungi tim pengembang.

---

## License

Proprietary - UNPAM Health Care
