# 01 — Home Dashboard

## Metadata

| Field | Nilai |
|-------|-------|
| ID | FT-01 |
| Rujukan PRD | §9.1, §11.3 butir 1, §15 |
| Prioritas | Must Have (§14.1) |
| Platform | Flutter (`frontend_mobile/`) |
| Status | Rencana |
| Bergantung pada | 00 Shared Foundation |
| Diperlukan oleh | 02, 03, 04, 05, 06, 07 |

## 1. Ringkasan dan Tujuan

Home Dashboard adalah layar pertama setelah aplikasi dibuka. Layar ini merangkum progres persiapan karier, memberi akses cepat ke fitur utama, dan mendorong pengguna mengambil langkah berikutnya.

Tujuan:

- Memberi gambaran singkat progres.
- Memudahkan akses ke CV, Portfolio, Readiness, Learning, dan Safe Job.
- Menampilkan rekomendasi aktivitas.
- Tetap informatif saat belum ada data.

## 2. Ruang Lingkup

### Termasuk

- Header sapaan dan avatar/inisial.
- Kartu ringkasan Career Readiness.
- Indikator progres persiapan karier.
- Akses cepat CV dan Portfolio.
- Rekomendasi materi Learning Corner.
- Banner Safe Job Search.
- Bottom navigation.
- Empty state untuk pengguna baru.

### Tidak Termasuk

- Perhitungan detail skor readiness (dibahas di 02).
- Form CV dan Portfolio (03, 04).
- Katalog materi lengkap (05).
- Notifikasi push.

## 3. Matriks Traceability

| FR | Kebutuhan | Aturan bisnis | Kriteria penerimaan | Tes |
|----|-----------|---------------|---------------------|-----|
| FR-HOME-01 | Tampilkan Home setelah aplikasi dibuka | Home adalah route awal setelah auth | Home tampil tanpa error | Widget test route awal |
| FR-HOME-02 | Tampilkan ringkasan progres dari aktivitas selesai | Progres hanya dari aktivitas tercatat | Angka sesuai data, bukan hardcode | Unit test `ActivitySummary` |
| FR-HOME-03 | Buka Readiness dari dashboard | Kartu readiness dapat ditekan | Navigasi ke intro/quiz | Widget test tap |
| FR-HOME-04 | Buka CV Generator | Kartu CV dapat ditekan | Navigasi ke `/cv` | Widget test tap |
| FR-HOME-05 | Buka Portfolio Starter Kit | Kartu Portfolio dapat ditekan | Navigasi ke `/portfolio` | Widget test tap |
| FR-HOME-06 | Buka Learning Corner | Kartu materi dan "Lihat semua" | Navigasi ke `/learn` | Widget test tap |
| FR-HOME-07 | Buka Safe Job Search | Banner safe job | Navigasi ke `/safe` | Widget test tap |
| FR-HOME-08 | Empty state informatif | Jika data kosong, tampilkan ajakan memulai | Tidak ada progres palsu | Widget test empty |

## 4. Alur Pengguna dan Layar

```text
Login/Home
  ├── Kartu Readiness → Readiness intro → quiz → result
  ├── Kartu CV → CV form → template → preview
  ├── Kartu Portfolio → Portfolio → form → preview
  ├── Materi → Lesson
  ├── Lihat semua → Learn
  ├── Banner Safe Job → Safe Job → checklist
  └── Avatar → Profile
```

Layar: **Home Dashboard** (§11.3 butir 1).

## 5. Model Data

`HomeSummary`:

```text
greetingName?        // dari profil, fallback "Mahasiswa"
readinessPercentage? // null jika belum pernah evaluasi
readinessLabel?      // "Langkah Awal" | "Perlu Dikembangkan" | "Sudah Mulai"
readinessCompletedSteps? // 0–5 kategori
readinessTotalSteps      // 5
lastUpdatedAt?       // null jika belum ada
recommendedMaterial? // materi pertama yang relevan
safeChecklistProgress? // 0–7
```

Sumber:

- Profil: `ProfileRepository`.
- Readiness: `ReadinessRepository.latest()`.
- Materi: `LearningRepository.recommended()`.
- Progres aktivitas: `ActivityRepository.summary()`.

## 6. Komposisi UI

Urutan dari atas ke bawah:

1. **Header**: teks "Persiapan karier mahasiswa", judul "SIAPKARIER", avatar inisial.
2. **Kartu Readiness**: tag "Langkah berikutnya", persentase, judul, deskripsi, progress bar, caption "x dari 5 langkah", tombol "Lanjutkan evaluasi".
3. **Peralatan kariermu**: grid dua kartu (Buat CV, Portofolio).
4. **Belajar dalam 10 menit**: judul bagian, "Lihat semua", kartu materi unggulan.
5. **Banner Safe Job**: ikon shield, judul, subjudul, panah.
6. **Bottom navigation**: 5 tab.

Gunakan komponen dari 00. Jangan membuat token baru.

## 7. State

```text
homeSummaryProvider = FutureProvider<HomeSummary>
```

Aturan:

- Loading: skeleton kartu, bukan spinner penuh layar.
- Error: kartu ringkasan menampilkan pesan dan tombol "Coba lagi"; akses cepat tetap tampil.
- Empty: kartu readiness menampilkan "Belum ada evaluasi" + tombol "Mulai evaluasi"; progress tidak ditampilkan sebagai 0% palsu kecuali dijelaskan.
- Refresh: tarik untuk menyegarkan atau refresh saat kembali dari fitur.

## 8. Aturan Bisnis dan Pagar Klaim

- Progres hanya dihitung dari aktivitas yang benar-benar tercatat (FR-HOME-02, §9.1.5).
- Jangan menampilkan persentase karangan saat data kosong.
- Rekomendasi materi pada prototipe harus berlabel contoh bila memakai data simulasi.
- Sapaan memakai nama pengguna hanya jika tersedia; jangan mengarang nama.
- Kartu readiness tidak boleh menyiratkan sertifikasi kompetensi.
- Jika pengguna baru, tampilkan ajakan memulai, bukan dashboard kosong.

## 9. Langkah Implementasi

### Fase A — UI dan mock

1. Buat `HomePage` dan `HomeSummary` mock.
2. Implementasikan header, kartu readiness, grid tool, kartu materi, banner safe.
3. Hubungkan navigasi ke route 02–07.
4. Tambahkan state loading, empty, error.
5. Tambahkan widget test untuk lima navigasi utama.

### Fase B — Integrasi

1. Hubungkan `HomeSummary` ke repository Supabase.
2. Hitung progres dari tabel aktivitas.
3. Tambahkan refresh saat kembali dari fitur.
4. Uji dengan akun baru dan akun berisi data.

## 10. Edge Case dan Pesan

| Kondisi | Perilaku |
|---------|----------|
| Belum login | Arahkan ke `/login` |
| Profil tanpa nama | Sapaan "Halo, Mahasiswa" |
| Belum ada readiness | Kartu empty + CTA mulai |
| Gagal memuat | "Ringkasan belum bisa dimuat." + Coba lagi |
| Materi rekomendasi kosong | Sembunyikan bagian, tampilkan CTA Learn |
| Data readiness lama | Tampilkan tanggal "Terakhir diperbarui ..." |

## 11. Accessibility dan Usability

- Avatar memiliki label "Buka profil".
- Kartu yang dapat ditekan memakai `Semantics(button: true)`.
- Progress memiliki label "Progres kesiapan karier, x persen".
- Jangan hanya mengandalkan warna gold untuk status.
- Pastikan teks "Lanjutkan evaluasi" tetap terbaca pada text scale 200%.

## 12. Rencana Pengujian

- Widget: render empty, loading, error, dan data lengkap.
- Widget: tap setiap kartu menuju route yang benar.
- Unit: `HomeSummary` menghitung langkah dari data.
- Manual: bandingkan dengan prototipe pada lebar 390 dan 430.
- Usability: pengguna baru dapat menemukan Readiness dan CV dalam <10 detik.

## 13. Kriteria Penerimaan

- [ ] Home tampil sebagai layar awal setelah login.
- [ ] Ringkasan progres sesuai data nyata.
- [ ] Semua tombol utama bernavigasi benar.
- [ ] Empty state informatif untuk pengguna baru.
- [ ] Tidak ada progres atau nama fiktif.
- [ ] Bottom nav menandai tab aktif.
- [ ] Layout aman pada layar kecil dan text scale besar.

## 14. Risiko, Dependensi, Open Questions

### Risiko

- **MEDIUM**: progres dari beberapa sumber dapat tidak sinkron.
- **MEDIUM**: kartu readiness terlalu padat di layar kecil.
- **LOW**: rekomendasi materi terlihat seperti data nyata padahal contoh.

### Dependensi

- 00 Shared Foundation.
- Repository profil, readiness, learning, activity.

### Open Questions

- Apakah Home menampilkan persentase atau hanya label kategori?
- Apakah "2 dari 5 langkah" dihitung per kategori atau per pertanyaan?
- Apakah banner Safe Job tetap tampil setelah checklist selesai?
