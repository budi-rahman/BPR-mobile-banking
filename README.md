# BPR-mobile-banking

Mockup frontend Flutter untuk aplikasi Mobile Banking BPR Varia, dibuat dari file Figma
(`sl2KFp5bNdtoWSy54F7Am8`). Semua data dummy dan hanya tersimpan di memori
([lib/data/dummy_data.dart](lib/data/dummy_data.dart)).

## Alur demo

- **Login**: User ID dan Password apa pun diterima.
- **Buka Rekening**: isi Nama, Tanggal Lahir, No telp.
  - No telp `081234567890` → "KTP sudah terdaftar" → e-KYC.
  - No telp lain → form 3 langkah (1/3, 2/3, 3/3) → e-KYC.
- **Beranda**: tombol mata menampilkan saldo, menu Pengiriman Uang, promo bisa digeser & dibuka.
- **Pengiriman Uang**: Antar Rekening / Antar Bank (BI FAST, Online, SKN, RTGS) → konfirmasi (SETUJU) → SUKSES.
  Saldo terpotong dan tercatat di mutasi tab Rekening Saya.

## Perintah

```
flutter build apk --release                         # APK di build/app/outputs/flutter-apk/
flutter test test/screenshot_test.dart --update-goldens   # render semua layar ke test/screenshots/
flutter test test/generate_icon_test.dart           # buat ulang PNG logo dari assets/launcher/logo_source.png
dart run flutter_launcher_icons                     # generate ulang ikon Android
```
