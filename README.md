# Aplikasi Manajemen Tugas - Tugas 3

## Tentang Proyek
Repositori ini adalah hasil pengerjaan **Tugas 3 - Pemrograman Perangkat Bergerak (Section 4: Form & CRUD)**. Projek ini berfokus pada penerapan CRUD sederhana menggunakan database lokal dengan pola arsitektur **MVC (Model-View-Controller)**.

Tujuan utama saya di sini adalah mencoba memahami bagaimana data bisa tetap tersimpan (persistent) dengan stabil, baik saat dijalankan di perangkat mobile maupun lewat browser.

## Pendekatan Database
Dalam pengerjaannya, saya mencoba menggabungkan dua solusi untuk menangani perbedaan platform:
1.  **Isar Database**: Digunakan untuk lingkungan Mobile (Android/iOS) karena performanya yang responsif.
2.  **Hive CE**: Digunakan saat dijalankan di Chrome (Web). Saya memilih Hive untuk versi Web karena lebih stabil dalam hal sinkronisasi data di browser tanpa kendala teknis yang rumit.

Pemisahan logika database ini saya letakkan di layer *Service* agar bagian UI dan Controller tetap rapi dan tidak bingung saat harus berpindah platform.

## Fitur
*   Operasi CRUD dasar: Tambah tugas, edit, hapus, dan tandai selesai.
*   Update antar muka (UI) secara reaktif saat data berubah.
*   Tampilan Material 3 yang simpel dan fungsional.

## Struktur Folder
*   `lib/models/`: Definisi data dan konversi Map untuk kebutuhan database.
*   `lib/controllers/`: Penghubung logika antara UI dan database.
*   `lib/services/`: Inisialisasi Isar dan Hive.
*   `lib/views/` & `lib/widgets/`: Komponen tampilan aplikasi.

## Cara Menjalankan
1.  Jalankan `fvm flutter pub get` untuk mengambil package yang diperlukan.
2.  Untuk demo di Chrome, jalankan dengan `fvm flutter run -d chrome`.
3.  (Opsional) Jika ingin mencoba di Mobile, pastikan file pendukung di-generate dulu lewat perintah: `fvm dart run build_runner build`.

---
**re1c**  
*Pemrograman Perangkat Bergerak (E)*  
*Institut Teknologi Sepuluh Nopember (ITS)*
