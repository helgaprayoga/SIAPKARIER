# 02 — Career Readiness Check

## Metadata

| Field | Nilai |
|-------|-------|
| ID | FT-02 |
| Rujukan PRD | §9.2, §11.3 butir 2–4, §15.1 |
| Prioritas | Must Have (§14.1) |
| Platform | Flutter (`frontend_mobile/`) |
| Status | Rencana |
| Bergantung pada | 00 Shared Foundation |
| Diperlukan oleh | 01 (ringkasan), 05 dan 06 (rekomendasi) |

## 1. Ringkasan dan Tujuan

Career Readiness Check adalah evaluasi diri untuk membantu mahasiswa mengenali aspek persiapan karier yang sudah dimulai dan yang masih perlu dikembangkan. Fitur ini bukan tes kompetensi dan bukan sertifikasi.

Tujuan:

- Mendorong refleksi diri.
- Mengidentifikasi kebutuhan pengembangan.
- Memberi arahan tindakan berikutnya.
- Menjadi dasar rekomendasi aktivitas.

## 2. Ruang Lingkup

### Termasuk

- Halaman pengantar dengan penjelasan tujuan.
- Bank pertanyaan untuk lima kategori.
- Pilihan jawaban yang tidak memaksa pengguna mengaku sudah mencoba.
- Validasi jawaban wajib.
- Tinjauan jawaban sebelum dikirim.
- Hasil per kategori dan keseluruhan.
- Saran tindakan dan tautan ke fitur relevan.
- Ulangi evaluasi.

### Tidak Termasuk

- Penilaian kompetensi profesional.
- Sertifikasi.
- Perbandingan dengan pengguna lain.
- Rekomendasi berbasis machine learning.

## 3. Matriks Traceability

| FR | Kebutuhan | Aturan bisnis | Kriteria penerimaan | Tes |
|----|-----------|---------------|---------------------|-----|
| FR-READY-01 | Tampilkan pertanyaan evaluasi | Pertanyaan dikelompokkan per kategori | Semua pertanyaan tampil | Widget test |
| FR-READY-02 | Pilih jawaban sesuai kondisi | Tiga pilihan netral | Pilihan tersimpan | Widget test |
| FR-READY-03 | Tidak memaksa mengaku | Ada "Belum pernah mencoba" | Tidak ada jawaban terpilih otomatis | Widget test |
| FR-READY-04 | Validasi pertanyaan wajib | Tidak bisa lanjut tanpa jawaban | Tombol disabled/validasi | Widget test |
| FR-READY-05 | Tampilkan ringkasan jawaban | Tinjau sebelum submit | Ringkasan sesuai jawaban | Widget test |
| FR-READY-06 | Saran tindakan per kategori | Saran relevan dan dapat ditindaklanjuti | Setiap kategori punya saran | Unit test mapping |
| FR-READY-07 | Dapat mengulang evaluasi | Reset jawaban dengan konfirmasi | Hasil baru menggantikan | Widget test |
| FR-READY-08 | Bukan sertifikasi | Disclaimer tampil di hasil | Teks disclaimer ada | Widget test |

## 4. Cakupan Evaluasi dan Bank Pertanyaan

### A. Dokumen Karier (4)

1. Saya sudah memiliki CV yang memuat pendidikan, proyek, atau pengalaman.
2. Saya memahami struktur CV yang baik.
3. Saya memiliki portofolio atau contoh proyek yang dapat ditunjukkan.
4. Saya memahami cara menampilkan pengalaman dan keterampilan di CV atau portofolio.

### B. Keterampilan Digital (3)

5. Saya mengenali perangkat atau aplikasi digital yang relevan dengan bidang minat saya.
6. Saya pernah mengerjakan proyek menggunakan perangkat digital.
7. Saya memahami pentingnya keterampilan digital untuk bidang yang saya minati.

### C. Persiapan Melamar (3)

8. Saya memahami proses melamar magang atau pekerjaan.
9. Saya mengetahui cara mencari peluang kerja.
10. Saya memahami persiapan dasar wawancara.

### D. Profesionalisme dan Komunikasi (3)

11. Saya mampu menjelaskan kemampuan dan pengalaman saya.
12. Saya memahami komunikasi profesional melalui email atau platform digital.
13. Saya mengetahui cara menampilkan identitas profesional secara wajar.

### E. Keamanan Pencarian Kerja (3)

14. Saya mengetahui tanda-tanda lowongan yang mencurigakan.
15. Saya memahami pentingnya menjaga data pribadi.
16. Saya mengetahui cara memeriksa kredibilitas perusahaan atau perekrut.

**Total: 16 pertanyaan.**

Prototipe Figma memakai subset 5 pertanyaan: A1, B5, C8, D11, E14. Implementasi Flutter dapat memulai dengan subset ini untuk paritas visual, lalu memperluas ke 16 pertanyaan pada fase berikutnya.

## 5. Pilihan Jawaban

| Nilai | Label | Poin |
|-------|-------|------|
| 0 | Sudah saya lakukan | 2 |
| 1 | Sedang saya pelajari | 1 |
| 2 | Belum pernah mencoba | 0 |

Aturan: "Belum pernah mencoba" berarti belum ada bukti aktivitas, bukan berarti tidak mampu. Teks bantuan harus menjelaskan hal ini.

## 6. Alur Pengguna

1. Pengguna membuka Readiness.
2. Sistem menampilkan pengantar dan tujuan.
3. Pengguna mulai evaluasi.
4. Sistem menampilkan pertanyaan satu per satu dengan progress.
5. Pengguna memilih jawaban.
6. Setelah pertanyaan terakhir, pengguna meninjau jawaban.
7. Pengguna mengirim jawaban.
8. Sistem menampilkan ringkasan dan hasil.
9. Pengguna membuka rekomendasi fitur.
10. Pengguna dapat mengulang evaluasi.

Layar: Readiness intro, Readiness quiz, Readiness result (§11.3 butir 2–4). Tinjauan jawaban dapat berupa bottom sheet, bukan route baru.

## 7. Model Data dan Validasi

```text
ReadinessQuestion
  id, categoryId, categoryLabel, text, order

ReadinessAnswer
  questionId, value // 0 | 1 | 2

ReadinessCategoryResult
  categoryId, label, points, maxPoints, percentage, status

ReadinessAssessment
  id?, userId?, answers[], totalPoints, maxPoints,
  percentage, overallStatus, categoryResults[], createdAt
```

Validasi:

- Semua pertanyaan wajib dijawab sebelum submit.
- Nilai harus 0, 1, atau 2.
- Tidak ada jawaban default.
- Jika pengguna menekan kembali, jawaban sebelumnya dipertahankan selama sesi.

## 8. Rumus Skor Transparan

PRD mengizinkan skor asalkan metode dan batas kategori dijelaskan.

```text
poin pertanyaan = 2 (sudah), 1 (sedang), 0 (belum)
poin kategori   = jumlah poin pertanyaan kategori
maks kategori   = 2 × jumlah pertanyaan kategori
persentase      = round(poin / maks × 100)
```

Batas label deskriptif:

| Rentang | Label | Makna |
|---------|-------|-------|
| 67–100 | Sudah Mulai | Beberapa langkah sudah dilakukan |
| 34–66 | Perlu Dikembangkan | Masih ada aspek yang perlu disiapkan |
| 0–33 | Langkah Awal | Disarankan memulai dari aktivitas dasar |

Aturan:

- Jangan memakai `Math.max(20, ...)` atau menaikkan skor agar terlihat lebih baik.
- Jika semua jawaban "Belum pernah mencoba", hasil 0% dengan label "Langkah Awal", bukan dianggap tidak mampu.
- Tampilkan penjelasan singkat cara skor dihitung pada halaman hasil.
- Label bersifat deskriptif, bukan penilaian mutlak.

## 9. Hasil dan Rekomendasi

Halaman hasil memuat:

- Persentase keseluruhan dan label.
- Ringkasan per kategori dengan status.
- Dua sampai tiga saran utama.
- Tautan ke CV, Portfolio, Learn, atau Safe Job sesuai kategori terendah.
- Disclaimer: "Hasil ini adalah refleksi diri, bukan sertifikasi atau pengukuran kompetensi profesional."
- Tombol "Ulangi evaluasi".

Mapping saran:

| Kategori rendah | Saran |
|-----------------|-------|
| Dokumen Karier | Buat CV / Portfolio |
| Keterampilan Digital | Materi keterampilan digital |
| Persiapan Melamar | Materi persiapan magang dan wawancara |
| Profesionalisme | Materi komunikasi profesional |
| Keamanan | Safe Job Search |

## 10. State

```text
readinessControllerProvider
  state: ReadinessState {
    questions, answers, currentIndex, isReviewing,
    result?, status: idle|loading|error
  }
```

Aksi: `answer(questionId, value)`, `next()`, `previous()`, `review()`, `submit()`, `reset()`.

## 11. Langkah Implementasi

### Fase A — Paritas prototipe

1. Buat model pertanyaan dan subset 5 pertanyaan.
2. Implementasikan intro, quiz, result.
3. Implementasikan progress dan validasi.
4. Implementasikan ringkasan kategori dinamis.
5. Tambahkan disclaimer.

### Fase B — Cakupan PRD penuh

1. Perluas bank menjadi 16 pertanyaan.
2. Tambahkan layar/bottom sheet tinjau jawaban.
3. Simpan hasil ke repository (mock, lalu Supabase).
4. Hubungkan rekomendasi ke fitur 03–06.
5. Tambahkan riwayat evaluasi bila waktu memungkinkan.

## 12. Edge Case dan Pesan

| Kondisi | Perilaku |
|---------|----------|
| Belum menjawab | Tombol "Berikutnya" disabled + teks bantuan |
| Kembali di pertanyaan pertama | Kembali ke intro dengan konfirmasi bila ada jawaban |
| Semua jawaban "belum" | 0%, label "Langkah Awal", nada tidak menghakimi |
| Gagal menyimpan | "Hasil belum tersimpan." + coba lagi |
| Pengguna menutup aplikasi | Jawaban sesi hilang kecuali disimpan draf |
| Mengulang evaluasi | Konfirmasi sebelum reset |

## 13. Accessibility dan Usability

- Setiap pertanyaan dibacakan sebagai heading.
- Pilihan jawaban memakai radio group dengan label.
- Progress memiliki label "Pertanyaan x dari y".
- Tombol kembali memiliki label "Kembali".
- Jangan memakai warna saja untuk status kategori; sertakan teks.
- Teks hasil tidak menghakimi dan tidak memakai istilah teknis tanpa penjelasan.

## 14. Rencana Pengujian

- Unit: perhitungan poin, persentase, dan label untuk semua kombinasi batas.
- Unit: mapping rekomendasi per kategori.
- Widget: validasi wajib, navigasi maju/mundur, reset.
- Widget: hasil menampilkan kategori dan disclaimer.
- Manual: pengguna dapat menyelesaikan evaluasi tanpa bantuan.
- Konten: bahasa tidak menghakimi dan tidak mengklaim sertifikasi.

## 15. Kriteria Penerimaan

- [ ] Pengguna dapat menyelesaikan evaluasi.
- [ ] Jawaban dapat ditinjau sebelum hasil.
- [ ] Semua pertanyaan wajib tervalidasi.
- [ ] Hasil per kategori dan keseluruhan mudah dipahami.
- [ ] Setiap saran mengarah ke tindakan relevan.
- [ ] Tidak ada klaim sertifikasi atau kompetensi objektif.
- [ ] Skor dihitung transparan dan tidak dimanipulasi.
- [ ] Pengguna dapat mengulang evaluasi.

## 16. Risiko, Dependensi, Open Questions

### Risiko

- **HIGH**: 16 pertanyaan dapat terasa panjang; perlu progress dan pengelompokan yang jelas.
- **MEDIUM**: label hasil dapat disalahartikan sebagai penilaian kemampuan.
- **MEDIUM**: rekomendasi harus benar-benar terhubung ke fitur, bukan tautan mati.

### Dependensi

- 00 Shared Foundation.
- Repository readiness.
- Fitur 03–06 untuk tautan rekomendasi.

### Open Questions

- Apakah versi pertama memakai 5 atau 16 pertanyaan?
- Apakah hasil disimpan sebagai riwayat atau hanya hasil terbaru?
- Apakah pengguna boleh melompat antar kategori?
