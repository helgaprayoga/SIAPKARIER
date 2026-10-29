# 05 — Learning Corner

## Metadata

| Field | Nilai |
|-------|-------|
| ID | FT-05 |
| Rujukan PRD | §9.5, §11.3 butir 13–14, §15.4 |
| Prioritas | Must Have (§14.1), Should Have untuk status selesai (§14.2) |
| Platform | Flutter (`frontend_mobile/`) |
| Status | Rencana |
| Bergantung pada | 00 Shared Foundation, 02 (rekomendasi) |
| Diperlukan oleh | 01 (rekomendasi materi), 07 (statistik) |

## 1. Ringkasan dan Tujuan

Learning Corner menyediakan materi, referensi, dan aktivitas belajar untuk mendukung kesiapan karier. Materi mencakup CV, portofolio, keterampilan digital, komunikasi, wawancara, persiapan magang, dan keamanan digital.

Tujuan:

- Memudahkan pengguna menemukan materi relevan.
- Membantu menentukan langkah pengembangan diri.
- Menghubungkan hasil readiness dengan rekomendasi.
- Mendorong pembelajaran mandiri bertahap.

## 2. Ruang Lingkup

### Termasuk

- Kategori materi.
- Pencarian dan filter.
- Daftar materi dan detail materi.
- Tujuan, ringkasan, dan langkah praktis.
- Tautan eksternal berlabel.
- Status selesai yang ditandai pengguna.
- Rekomendasi materi.
- Informasi sumber dan tanggal pemeriksaan.

### Tidak Termasuk

- Sertifikasi profesional.
- Klaim penguasaan kompetensi.
- Video player internal pada versi pertama.
- Forum diskusi.
- Pembayaran atau langganan.

## 3. Matriks Traceability

| FR | Kebutuhan | Aturan bisnis | Kriteria penerimaan | Tes |
|----|-----------|---------------|---------------------|-----|
| FR-LEARN-01 | Kategori materi | Tujuh kategori | Kategori tampil | Widget test |
| FR-LEARN-02 | Detail materi | Konten dapat dibuka | Detail tampil | Widget test |
| FR-LEARN-03 | Tujuan dan ringkasan | Ada di setiap materi | Terlihat di detail | Review konten |
| FR-LEARN-04 | Tautan eksternal | Ditandai jelas | Label eksternal tampil | Widget test |
| FR-LEARN-05 | Tandai selesai | Hanya jika progres tersedia | Status berubah | Widget test |
| FR-LEARN-06 | Rekomendasi | Berdasarkan readiness | Materi relevan | Unit test mapping |
| FR-LEARN-07 | Bedakan internal/eksternal | Label sumber | Tidak tercampur | Widget test |
| FR-LEARN-08 | Informasi sumber | Pembuat/sumber tampil | Metadata terlihat | Widget test |
| FR-LEARN-09 | Bukan sertifikasi | Disclaimer | Tidak ada klaim sertifikasi | Review konten |

## 4. Kategori Materi

1. **CV dan Lamaran** — struktur CV, ringkasan profil, penyesuaian CV.
2. **Portofolio** — dokumentasi proyek, kontribusi, penyajian hasil.
3. **Keterampilan Digital** — alat dan keterampilan sesuai bidang.
4. **Komunikasi Profesional** — email, komunikasi tim, presentasi diri.
5. **Wawancara** — pertanyaan umum, menjelaskan pengalaman.
6. **Persiapan Magang dan Kerja** — proses melamar, deskripsi posisi, dokumen.
7. **Keamanan Digital** — data pribadi, indikasi penipuan lowongan.

## 5. Jenis Konten

- Artikel singkat.
- Checklist praktis.
- Panduan langkah demi langkah.
- Video atau materi eksternal.
- Latihan refleksi.
- Contoh dokumen.
- Tautan sumber belajar.

## 6. Inventaris Materi Awal

Materi berikut adalah usulan seed. Status konten: **perlu ditulis/diverifikasi** sebelum dipublikasikan.

| Slug | Kategori | Judul | Jenis | Durasi | Sumber |
|------|----------|-------|-------|--------|--------|
| ringkasan-profil | CV dan Lamaran | Menulis ringkasan profil yang kuat | Artikel | 7 menit | Internal |
| cv-pertama | CV dan Lamaran | Membuat CV pertama dari tugas kuliah | Panduan | 10 menit | Internal |
| studi-kasus | Portofolio | Mengubah tugas kuliah menjadi studi kasus | Panduan | 10 menit | Internal |
| email-profesional | Komunikasi | Email profesional untuk mahasiswa | Artikel | 6 menit | Internal |
| star | Wawancara | Menjelaskan pengalaman dengan metode STAR | Panduan | 9 menit | Internal |
| cek-lowongan | Keamanan Digital | Memeriksa lowongan sebelum melamar | Checklist | 5 menit | Internal |
| alat-digital | Keterampilan Digital | Mengenali alat digital sesuai bidang | Artikel | 8 menit | Internal |
| magang | Persiapan Magang | Memahami deskripsi posisi magang | Panduan | 7 menit | Internal |

Materi eksternal harus memiliki `externalUrl`, `sourceName`, dan `sourceCheckedAt`. Jangan menambahkan tautan yang belum diperiksa.

## 7. Model Data

```text
LearningMaterial
  id
  slug
  categoryId
  categoryLabel
  title
  summary
  content        // markdown/rich text terstruktur
  durationMinutes
  contentType    // article|checklist|guide|video|reflection|sample|link
  sourceType     // internal|external
  sourceName?
  externalUrl?
  sourceCheckedAt?
  isPublished
  order

LearningProgress
  userId
  materialId
  completedAt
```

## 8. Alur Pengguna

1. Pengguna membuka Learning Corner.
2. Sistem menampilkan kategori dan materi.
3. Pengguna mencari atau memfilter kategori.
4. Pengguna membuka detail materi.
5. Pengguna membaca tujuan, ringkasan, dan langkah.
6. Pengguna membuka tautan eksternal bila ada.
7. Pengguna menandai selesai.
8. Sistem menyarankan materi berikutnya.

Layar: Learning Corner, Lesson detail (§11.3 butir 13–14).

## 9. Komponen UI

### Learn

- Header "Learning Corner".
- Search box fungsional.
- Chip kategori horizontal: Semua, CV, Portofolio, Wawancara, Digital.
- Kartu rekomendasi utama.
- Daftar materi dengan ikon kategori, judul, durasi, status selesai.
- Empty state bila filter tidak menemukan hasil.

### Lesson

- Header dengan tombol kembali.
- Tag kategori, judul, durasi, jenis sumber.
- Artikel dengan heading, paragraf, daftar, blockquote, callout.
- Label "Materi internal" atau "Tautan eksternal".
- Tombol "Tandai sebagai selesai" / "Ditandai selesai".
- Disclaimer: status selesai bukan bukti kompetensi.

## 10. Aturan Bisnis dan Pagar Klaim

- Materi harus relevan dengan persiapan karier mahasiswa.
- Tautan eksternal harus diperiksa sebelum dimasukkan.
- Bahasa harus jelas dan tidak menyesatkan.
- Status selesai adalah aktivitas belajar yang ditandai pengguna, bukan bukti penguasaan.
- Materi bukan sertifikasi kecuali memang program sertifikasi resmi.
- Jangan menampilkan tautan mati atau tidak terverifikasi.
- Sertakan tanggal pemeriksaan untuk konten keamanan dan tautan eksternal.

## 11. State

```text
learnControllerProvider
  state: LearnState {
    query, selectedCategory, materials,
    progress: Set<materialId>,
    recommendedMaterial?,
    status: idle|loading|error
  }
```

Aksi: `setQuery`, `setCategory`, `openMaterial`, `toggleCompleted`, `refresh`.

## 12. Langkah Implementasi

### Fase A — UI dan mock

1. Buat model dan seed materi.
2. Implementasikan daftar, chip kategori, dan pencarian.
3. Implementasikan detail materi.
4. Implementasikan status selesai di memori.
5. Tambahkan label sumber dan disclaimer.

### Fase B — Integrasi

1. Simpan progres ke Supabase.
2. Hubungkan rekomendasi readiness ke materi.
3. Tambahkan pengelolaan konten dari database.
4. Tambahkan validasi tautan eksternal dan tanggal pemeriksaan.
5. Tambahkan analitik sederhana bila diperlukan.

## 13. Edge Case dan Pesan

| Kondisi | Perilaku |
|---------|----------|
| Pencarian kosong | Tampilkan semua materi |
| Tidak ada hasil | "Belum ada materi yang cocok." + reset filter |
| Materi tidak ditemukan | "Materi tidak tersedia." + kembali |
| Gagal memuat progres | Tetap baca materi, status selesai ditandai belum tersinkron |
| Tautan eksternal gagal | Tampilkan pesan dan sumber alternatif |
| Materi belum terbit | Jangan tampilkan ke pengguna |
| Offline | Tampilkan materi yang tersimpan lokal bila ada |

## 14. Accessibility dan Usability

- Chip kategori memiliki label dan state terpilih.
- Search memiliki label dan hint yang jelas.
- Artikel memakai heading hierarkis.
- Tautan eksternal diberi label "membuka di luar aplikasi".
- Durasi dibacakan sebagai teks, bukan hanya ikon.
- Kontras teks artikel memenuhi AA.

## 15. Rencana Pengujian

- Unit: filter kategori dan pencarian.
- Widget: daftar, detail, status selesai.
- Widget: empty state dan label eksternal.
- Konten: setiap materi punya tujuan, ringkasan, dan langkah.
- Konten: tidak ada klaim sertifikasi.
- Manual: tautan eksternal dapat dibuka dan sumber jelas.

## 16. Kriteria Penerimaan

- [ ] Pengguna dapat menemukan kategori materi.
- [ ] Detail materi dapat dibuka dan dibaca.
- [ ] Tautan eksternal ditampilkan jelas.
- [ ] Materi internal dan eksternal dibedakan.
- [ ] Pengguna dapat menandai selesai.
- [ ] Status selesai tidak diklaim sebagai kompetensi.
- [ ] Rekomendasi materi relevan dengan hasil readiness.
- [ ] Tidak ada tautan yang belum diverifikasi.

## 17. Risiko, Dependensi, Open Questions

### Risiko

- **MEDIUM**: konten harus ditulis dan diverifikasi; bukan hanya UI.
- **MEDIUM**: tautan eksternal dapat berubah atau mati.
- **MEDIUM**: status selesai dapat disalahartikan sebagai sertifikasi.
- **LOW**: pencarian sederhana mungkin tidak cukup untuk katalog besar.

### Dependensi

- 00 Shared Foundation.
- 02 untuk rekomendasi.
- Repository learning dan progres.

### Open Questions

- Apakah materi disimpan sebagai Markdown, HTML, atau rich text?
- Apakah video eksternal perlu embed atau cukup tautan?
- Apakah pengguna dapat menandai selesai tanpa login?
- Siapa yang bertanggung jawab memverifikasi konten dan seberapa sering?
