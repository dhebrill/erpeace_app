# ERPeace

Aplikasi mobile ERP untuk UMKM Indonesia: kelola inventori, pembelian, penjualan,
dan pantau performa bisnis dalam satu aplikasi Flutter dengan backend Supabase.

Seluruh antarmuka menggunakan Bahasa Indonesia, mata uang Rupiah, dan alur kerja
yang disederhanakan untuk pemilik usaha kecil dan menengah.

---

## Fitur

### Beranda (Dashboard)
- KPI bulan berjalan: total penjualan, total pembelian, estimasi laba, dan nilai stok.
- Grafik batang penjualan 7 hari terakhir.
- Ringkasan status pesanan penjualan dan pembelian yang masih berjalan.
- Daftar pesanan terbaru serta produk dengan stok menipis.
- Konten menyesuaikan peran pengguna (mis. tim gudang tidak melihat penjualan).

### Inventori
- CRUD produk dan kategori, termasuk SKU, satuan, harga beli, harga jual, dan stok minimum.
- Penyesuaian stok masuk/keluar beserta riwayat pergerakan stok.
- Opname stok: hitung fisik, tinjau selisih, lalu finalisasi untuk menyesuaikan stok.
- Penanda otomatis stok menipis dan stok habis.
- Pencarian, filter, dan paginasi (infinite scroll).

### Pembelian
- Master supplier.
- Pesanan pembelian (PO) dengan alur `draf → disetujui → diterima` atau `dibatalkan`.
- Penerimaan barang menambah stok produk secara otomatis.
- Detail PO berisi item, jumlah, harga, dan total.

### Penjualan
- Master pelanggan.
- Pesanan penjualan (SO) dengan alur `draf → disetujui → selesai` atau `dibatalkan`.
- Validasi ketersediaan stok saat membuat pesanan.
- Penyelesaian pesanan mengurangi stok secara otomatis.
- Detail SO berisi item, jumlah, harga, dan total.

### Panel Admin (khusus admin)
- Daftar pengguna dengan pencarian nama/email dan filter peran.
- Ubah peran pengguna (admin, manajer, gudang, penjualan, pembelian).
- Aktifkan/nonaktifkan akun. Akun nonaktif langsung kehilangan akses data.
- Pengguna tidak dapat mengubah peran atau status aktifnya sendiri.

### Pengaturan
- Ubah nama tampilan dan kata sandi.
- Pilih tema terang/gelap/sistem (tersimpan di perangkat).
- Informasi aplikasi dan tombol keluar.

---

## Peran dan Hak Akses

| Peran | Kode | Inventori | Pembelian | Penjualan | Panel Admin |
| --- | --- | --- | --- | --- | --- |
| Admin | `admin` | Penuh | Penuh | Penuh | Ya |
| Manajer | `manager` | Penuh | Penuh (setujui/terima) | Penuh (setujui/selesaikan) | Tidak |
| Gudang | `warehouse` | Penuh | Lihat + terima barang | Tidak | Tidak |
| Penjualan | `sales` | Lihat | Tidak | Penuh | Tidak |
| Pembelian | `purchasing` | Lihat | Penuh | Tidak | Tidak |

Aturan di atas ditegakkan di dua lapis: navigasi aplikasi (Flutter) dan
Row Level Security (RLS) di PostgreSQL, sehingga tetap aman walaupun API
dipanggil langsung.

---

## Tumpukan Teknologi

| Lapisan | Teknologi |
| --- | --- |
| Aplikasi | Flutter 3.41+, Dart 3.11+ |
| State management | Riverpod 3 (`Notifier`, `AsyncNotifier`, `FutureProvider`) |
| Navigasi | go_router 17 (auth + role guard) |
| Backend | Supabase (PostgreSQL, Auth, RLS, RPC) |
| Model | freezed + json_serializable (`build_runner`) |
| UI | Material 3, google_fonts, shimmer, fl_chart |
| Format | intl (`id_ID`), shared_preferences, flutter_dotenv |

---

## Struktur Proyek

```
lib/
  core/                     # fondasi lintas fitur
    config/                 # AppConfig (.env / --dart-define)
    constants/              # rute, modul, nama tabel
    error/                  # Failure + ErrorHandler
    router/                 # go_router + shell navigasi
    supabase/               # provider klien Supabase
    theme/                  # AppTheme, spacing
    utils/                  # format Rupiah/tanggal, validator
    widgets/                # komponen bersama (kartu, shimmer, dll.)
  features/
    auth/                   # login, registrasi, status persetujuan, model peran
    dashboard/              # KPI, grafik, ringkasan
    inventory/              # produk, kategori, pergerakan stok, opname
    purchasing/             # supplier, pesanan pembelian
    sales/                  # pelanggan, pesanan penjualan
    admin/                  # manajemen pengguna dan peran
    settings/               # profil, kata sandi, tema
supabase/
  migrations/               # 001_schema, 002_functions, 003_triggers, 004_rls
  seed.sql                  # data demo (idempoten)
test/                       # unit + widget test
```

Setiap fitur mengikuti pola `data/` (repository Supabase) → `domain/` (model) →
`presentation/` (provider, widget, layar). Semua akses backend melewati
repository, tidak ada panggilan Supabase langsung dari widget.

---

## Memulai

### Prasyarat
- Flutter SDK 3.41 atau lebih baru (`flutter doctor`).
- Proyek Supabase (gratis) dengan akses SQL Editor.
- Android Studio / Xcode untuk menjalankan di emulator atau perangkat.

### 1. Dependensi
```bash
flutter pub get
```
File `.env` sudah disertakan sebagai templat kosong agar proyek langsung bisa
di-build. Lihat langkah 3 untuk mengisi kredensial.

### 2. Siapkan database Supabase
Buka **Supabase Dashboard → SQL Editor**, lalu jalankan file berikut **sesuai urutan**:

1. `supabase/migrations/001_schema.sql` — tabel, enum, kolom terhitung, indeks.
2. `supabase/migrations/002_functions.sql` — RPC bisnis (buat pesanan, setujui,
   terima barang, selesaikan penjualan, opname stok) dan helper RLS.
3. `supabase/migrations/003_triggers.sql` — `updated_at`, pembuatan profil saat
   pengguna mendaftar, proteksi perubahan peran sendiri.
4. `supabase/migrations/004_rls.sql` — kebijakan RLS per peran + hak akses tabel.
5. `supabase/seed.sql` — data demo (opsional, aman dijalankan berulang).

Semua file bersifat idempoten; menjalankannya ulang tidak menggandakan data.

### 3. Konfigurasi koneksi
Aplikasi membaca dua variabel: `SUPABASE_URL` dan `SUPABASE_ANON_KEY`
(Project Settings → API).

Opsi A — file `.env` (paling cepat):
```
SUPABASE_URL=https://<project-ref>.supabase.co
SUPABASE_ANON_KEY=<anon/publishable key>
```
> `.env` di repositori ini hanya templat kosong. Jangan meng-commit kredensial
> asli; gunakan opsi B untuk build rilis.

Opsi B — `--dart-define` (disarankan, kredensial tidak masuk repo):
```bash
flutter run \
  --dart-define=SUPABASE_URL=https://<project-ref>.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=<anon/publishable key>
```

Nilai `--dart-define` diprioritaskan di atas isi `.env`. Jika konfigurasi kosong,
aplikasi menampilkan layar bantuan, bukan crash.

### 4. Jalankan
```bash
flutter run
```

### 5. Promosikan admin pertama
Registrasi dari aplikasi membuat akun dengan peran `sales` yang **menunggu
aktivasi**. Karena panel admin hanya bisa dibuka oleh admin, promosikan akun
pertama lewat SQL Editor:

```sql
update public.profiles
set role = 'admin', is_active = true
where email = 'admin@perusahaan.id';
```

Setelah itu login ulang; menu **Panel Admin** muncul otomatis.

Pengguna berikutnya dapat didaftarkan lewat aplikasi lalu disetujui
(diubah perannya dan diaktifkan) dari Panel Admin.

---

## Data Demo

`supabase/seed.sql` mengisi 5 kategori, 5 supplier, 5 pelanggan, belasan produk
lintas kategori, serta beberapa pesanan pembelian/penjualan dengan status
berbeda. Data ini membuat dashboard, grafik, dan daftar pesanan langsung terisi.

Seed tidak membuat akun auth, sehingga tabel `profiles` tetap kosong sampai
ada pengguna yang mendaftar.

---

## Skrip Pengembangan

| Perintah | Fungsi |
| --- | --- |
| `flutter analyze` | Analisis statis (target: `No issues found!`) |
| `flutter test` | Unit + widget test |
| `dart format lib test` | Format kode |
| `dart run build_runner build` | Regenerasi kode freezed/json_serializable |
| `flutter build bundle` | Verifikasi kompilasi tanpa perangkat |
| `flutter build apk --release --dart-define=...` | Build APK rilis |

---

## Catatan Arsitektur

- **Peran**: `UserRole` menyimpan aturan `canAccess(AppModule)` dan izin
  (`canApproveOrders`, `canManagePurchasing`, dll). Router menolak rute yang
  tidak sesuai peran; RLS menjadi lapisan pertahanan kedua.
- **Penomoran dokumen**: RPC `next_document_number` menghasilkan nomor
  berurutan per prefix dan periode (mis. `SO-202610-0001`).
- **Stok**: perubahan stok selalu lewat RPC/`stock_movements` agar riwayat dan
  saldo konsisten. Penerimaan pembelian menambah stok, penyelesaian penjualan
  mengurangi stok, opname menetapkan selisih.
- **Paginasi**: `PaginatedNotifier` + `PaginatedState` dipakai semua daftar
  (produk, supplier, pelanggan, pesanan) dengan pencarian dan filter.
- **Angka**: kolom `numeric` Supabase bisa tiba sebagai `int` atau `double`,
  sehingga semua model memakai konverter `jsonToDouble`.
- **Status pesanan** diselesaikan lewat RPC `SECURITY DEFINER`, sehingga
  validasi transisi status dan stok terjadi atomik di database.

---

## Batasan yang Diketahui

- **Perubahan peran** baru berlaku untuk pengguna terkait pada login/start
  berikutnya (aplikasi tidak memantau perubahan peran secara real time).
  Sebaliknya, **penonaktifan akun berlaku seketika** karena RLS memeriksa
  `current_user_is_active()` pada setiap baris.
- **Tidak ada penghapusan akun** dari dalam aplikasi; gunakan Supabase Dashboard
  (Auth → Users) bila diperlukan.
- **Belum ada reset kata sandi via email**; kata sandi hanya bisa diubah setelah
  login melalui menu Pengaturan.
- **`profiles.email`** diisi oleh trigger saat pendaftaran, bukan oleh input
  pengguna, sehingga selalu sinkron dengan data Auth.
- **Registrasi mandiri** tidak langsung memberi akses data: akun harus
  diaktifkan admin terlebih dahulu.
- **Laporan/ekspor** (PDF/Excel) dan notifikasi push belum termasuk cakupan versi
  ini.

---

## Lisensi

Proyek internal ERPeace. Hubungi pemilik repositori untuk izin penggunaan.
