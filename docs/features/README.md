# Rencana Implementasi Fitur SIAPKARIER

Folder ini berisi rencana implementasi per fitur yang diturunkan dari [`../PRD.md`](../PRD.md). Dokumen di sini adalah **rencana**, bukan kode aplikasi. Perubahan kode tetap dilakukan di `frontend_mobile/`.

## Tujuan

- Memecah PRD menjadi dokumen kerja per fitur yang dapat dieksekusi dan diuji.
- Menjaga traceability antara kebutuhan fungsional (FR), aturan bisnis, kriteria penerimaan, dan pengujian.
- Menjadi acuan bersama antara desain, Flutter, dan backend.

## Indeks Dokumen

| No | Dokumen | Fitur | PRD | Prioritas | Layar utama |
|----|---------|-------|-----|-----------|-------------|
| 00 | [00-shared-foundation.md](00-shared-foundation.md) | Fondasi bersama | §8, §10, §11, §12 | Must | Semua |
| 01 | [01-home-dashboard.md](01-home-dashboard.md) | Home Dashboard | §9.1 | Must | Home |
| 02 | [02-career-readiness-check.md](02-career-readiness-check.md) | Career Readiness Check | §9.2 | Must | Readiness intro, quiz, result |
| 03 | [03-cv-generator.md](03-cv-generator.md) | CV Generator | §9.3 | Must | CV form, template, preview |
| 04 | [04-portfolio-starter-kit.md](04-portfolio-starter-kit.md) | Portfolio Starter Kit | §9.4 | Must | Portfolio, form, preview |
| 05 | [05-learning-corner.md](05-learning-corner.md) | Learning Corner | §9.5 | Must | Learn, lesson |
| 06 | [06-safe-job-search.md](06-safe-job-search.md) | Safe Job Search | §9.6 | Must | Safe job, checklist |
| 07 | [07-profile.md](07-profile.md) | Profile | §9.7 | Must | Profile, privacy |

## Peta Ketergantungan

```text
00-shared-foundation
   ├── 01-home-dashboard
   ├── 02-career-readiness-check
   │      └── 01 (ringkasan progres)
   ├── 03-cv-generator
   │      └── 01 (akses cepat)
   ├── 04-portfolio-starter-kit
   │      └── 01 (akses cepat)
   ├── 05-learning-corner
   │      └── 02 (rekomendasi hasil evaluasi)
   ├── 06-safe-job-search
   │      └── 02 (rekomendasi hasil evaluasi)
   └── 07-profile
          └── 01, 02, 03, 04, 05 (ringkasan aktivitas)
```

## Konvensi Dokumen

Setiap dokumen fitur memakai struktur berikut:

1. Metadata dan status
2. Ringkasan dan tujuan
3. Ruang lingkup
4. Matriks traceability FR
5. Alur pengguna dan layar
6. Model data dan validasi
7. Komponen UI dan state
8. Aturan bisnis dan pagar klaim
9. Langkah implementasi
10. Edge case dan pesan kesalahan
11. Accessibility dan usability
12. Rencana pengujian
13. Kriteria penerimaan
14. Risiko, dependensi, dan open questions

## Dua Jalur Implementasi

Setiap fitur memiliki dua status yang harus dibedakan:

- **Prototipe Figma/React** — referensi visual dan interaksi yang sudah ada di `SiapKarier Career Prep App/`.
- **Implementasi Flutter** — target sebenarnya di `frontend_mobile/`.

Dokumen fitur menjelaskan keduanya secara terpisah bila perilakunya berbeda. Jangan menganggap perilaku prototipe otomatis menjadi spesifikasi final.

## Cakupan FR

Total kebutuhan fungsional yang dilacak:

| Fitur | Jumlah FR |
|-------|-----------|
| Home | 8 |
| Readiness | 8 |
| CV | 12 |
| Portfolio | 10 |
| Learning | 9 |
| Safe Job | 9 |
| Profile | 8 |
| **Total** | **64** |

## Status

| Item | Status | Catatan |
|------|--------|---------|
| Dokumen 00–07 | Selesai | Rencana per fitur sudah ditulis |
| Implementasi Flutter | Belum dimulai | `frontend_mobile/lib/main.dart` masih scaffold |
| Integrasi Supabase | Belum dimulai | Menunggu UI dan repository mock stabil |

## Catatan Penting

- `SiapKarier Career Prep App/` adalah ekspor Figma Make berbasis React, bukan file desain `.fig`. Yang diambil adalah token visual, komposisi, dan alur.
- Prototipe React memakai data contoh pada beberapa pratinjau (misalnya nama dan kampus fiktif). Implementasi Flutter **tidak boleh** menyalin perilaku itu karena melanggar FR-CV-10 dan aturan label data contoh.
- Prototipe React memakai `Math.max(20, ...)` pada skor readiness. Implementasi Flutter harus memakai rumus yang transparan dan tidak menaikkan skor secara artifisial.
- Rencana backend mengacu pada Supabase (PostgreSQL + Auth + Storage), tetapi UI harus tetap dapat berjalan dengan repository mock sampai integrasi siap.
- Semua materi keamanan dan tautan eksternal wajib memiliki tanggal pemeriksaan dan status verifikasi.

## Cara Menggunakan

1. Baca `00-shared-foundation.md` sebelum mengerjakan fitur apa pun.
2. Implementasikan fitur sesuai urutan dependensi.
3. Gunakan matriks traceability untuk memastikan tidak ada FR yang terlewat.
4. Perbarui status dokumen setelah implementasi dan pengujian.
5. Catat penyimpangan dari PRD di bagian open questions, bukan diam-diam di kode.
