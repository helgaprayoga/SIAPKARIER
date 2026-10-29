# 06 — Safe Job Search

## Metadata

| Field | Nilai |
|-------|-------|
| ID | FT-06 |
| Rujukan PRD | §9.6, §11.3 butir 15–16, §15.5 |
| Prioritas | Must Have (§14.1) |
| Platform | Flutter (`frontend_mobile/`) |
| Status | Rencana |
| Bergantung pada | 00 Shared Foundation, 02 (rekomendasi) |
| Diperlukan oleh | 01 (banner), 07 (statistik) |

## 1. Ringkasan dan Tujuan

Safe Job Search adalah fitur edukasi untuk membantu mahasiswa mencari peluang kerja atau magang secara lebih aman, mengenali tanda lowongan mencurigakan, dan menjaga data pribadi.

Tujuan:

- Meningkatkan kesadaran risiko penipuan rekrutmen.
- Membantu memeriksa informasi dasar lowongan.
- Mendorong kebiasaan menjaga data pribadi.
- Memberi panduan tindakan saat menemukan indikasi penipuan.

Fitur ini bukan layanan verifikasi perusahaan otomatis.

## 2. Ruang Lingkup

### Termasuk

- Daftar panduan keamanan.
- Checklist pemeriksaan lowongan.
- Tanda-tanda lowongan mencurigakan.
- Panduan perlindungan data pribadi.
- Langkah umum saat menemukan indikasi penipuan.
- Pengingat verifikasi melalui sumber resmi.
- Progres checklist.

### Tidak Termasuk

- Verifikasi otomatis perusahaan atau lowongan.
- Jaminan bahwa lowongan yang lolos checklist pasti aman.
- Pelaporan otomatis ke pihak berwenang.
- Pencarian lowongan kerja.
- Permintaan password, OTP, atau data sensitif.

## 3. Matriks Traceability

| FR | Kebutuhan | Aturan bisnis | Kriteria penerimaan | Tes |
|----|-----------|---------------|---------------------|-----|
| FR-SAFE-01 | Materi keamanan | Bahasa jelas, tidak panik | Materi tampil | Review konten |
| FR-SAFE-02 | Checklist lowongan | Alat bantu, bukan jaminan | Checklist dapat digunakan | Widget test |
| FR-SAFE-03 | Tanda mencurigakan | Contoh konkret | Daftar tanda tampil | Review konten |
| FR-SAFE-04 | Perlindungan data | Tidak meminta data sensitif | Panduan tampil | Review konten |
| FR-SAFE-05 | Langkah tindakan | Langkah umum dan jelas | Panduan tampil | Review konten |
| FR-SAFE-06 | Pengingat verifikasi | Sumber resmi | Pengingat tampil | Widget test |
| FR-SAFE-07 | Tidak klaim verifikasi | Disclaimer | Tidak ada klaim otomatis | Review konten |
| FR-SAFE-08 | Tidak jaminan aman | Disclaimer checklist | Teks jaminan tidak ada | Review konten |
| FR-SAFE-09 | Tautan sumber resmi | Hanya tautan terverifikasi | Tautan berlabel | Review konten |

## 4. Materi Utama

Sepuluh topik PRD §9.6.3:

1. Memeriksa identitas perusahaan dan kanal resminya.
2. Memeriksa konsistensi informasi lowongan.
3. Mengenali permintaan pembayaran yang mencurigakan.
4. Berhati-hati terhadap permintaan data sensitif.
5. Memeriksa alamat email dan identitas perekrut.
6. Mengenali tekanan untuk segera mengambil keputusan.
7. Memeriksa kejelasan tugas, lokasi, durasi, dan persyaratan.
8. Menghindari tautan dan berkas mencurigakan.
9. Menjaga keamanan akun dan dokumen pribadi.
10. Menyimpan bukti dan melaporkan dugaan penipuan melalui kanal yang sesuai.

## 5. Checklist Lowongan

Tujuh poin yang dapat dicentang:

1. Identitas dan situs resmi perusahaan dapat ditemukan.
2. Deskripsi peran, lokasi, dan durasi cukup jelas.
3. Alamat email perekrut sesuai kanal resmi.
4. Tidak ada permintaan pembayaran apa pun.
5. Tidak diminta kata sandi, OTP, atau data perbankan.
6. Tautan dan berkas berasal dari sumber yang dikenal.
7. Ada waktu yang wajar untuk mempertimbangkan.

Setiap poin harus disertai penjelasan singkat "cara memeriksa", bukan hanya label.

## 6. Tanda yang Perlu Diperiksa

| Tanda | Penjelasan |
|-------|------------|
| Diminta membayar di awal | Perusahaan kredibel tidak meminta biaya rekrutmen |
| Email tidak terlihat resmi | Periksa domain dan kanal resmi perusahaan |
| Ditekan untuk segera setuju | Waspadai desakan tanpa waktu memeriksa |
| Diminta data terlalu sensitif | Jangan bagikan OTP, kata sandi, atau data perbankan |
| Tautan/berkas mencurigakan | Jangan membuka lampiran dari sumber tidak dikenal |
| Informasi posisi tidak jelas | Tugas, lokasi, durasi, dan syarat harus masuk akal |

## 7. Alur Pengguna

1. Pengguna membuka Safe Job Search.
2. Sistem menampilkan daftar panduan.
3. Pengguna memilih topik atau checklist.
4. Sistem menampilkan penjelasan dan checklist.
5. Pengguna membaca setiap poin.
6. Pengguna menandai poin yang sudah diperiksa.
7. Sistem menampilkan langkah tindak lanjut.
8. Pengguna diingatkan memverifikasi melalui sumber resmi.

Layar: Safe Job Search, Safe Checklist (§11.3 butir 15–16).

## 8. Model Data

```text
SafeTopic
  id, title, summary, content, order, sourceCheckedAt?

SafeChecklistItem
  id, text, helpText, order, version

SafeChecklistProgress
  userId?
  checklistVersion
  checkedItemIds[]
  updatedAt

SafetyReportGuidance
  steps[], officialChannels[], lastReviewedAt
```

## 9. Komponen UI

### Safe Job

- Header dengan tombol kembali.
- Hero shield, tag "Panduan keamanan", judul, deskripsi.
- Kartu checklist: jumlah poin, CTA.
- Daftar tanda peringatan dengan ikon dan penjelasan.
- Disclaimer: checklist bukan jaminan keamanan.
- Tautan sumber resmi bila tersedia.

### Safe Checklist

- Progress "Sudah diperiksa x/7".
- Daftar item yang dapat dicentang.
- Completion box saat semua dicentang.
- Tombol "Selesai memeriksa".
- Pengingat pemeriksaan silang.

## 10. Aturan Bisnis dan Pagar Klaim

- Informasi disampaikan jelas dan tidak menimbulkan kepanikan.
- Checklist adalah alat bantu, bukan jaminan.
- Pengguna didorong memeriksa silang melalui sumber resmi.
- Materi harus diperiksa ulang karena prosedur dan kanal dapat berubah.
- Aplikasi tidak meminta kata sandi, OTP, atau data sensitif.
- Jangan mengklaim telah memverifikasi perusahaan/lowongan.
- Tautan resmi harus memiliki tanggal pemeriksaan.
- Jangan menampilkan nomor telepon atau alamat yang tidak terverifikasi.

## 11. State

```text
safeControllerProvider
  state: SafeState {
    topics, checklistItems, checkedItemIds,
    checklistVersion, status: idle|loading|error
  }
```

Aksi: `toggleItem`, `resetChecklist`, `openTopic`, `refresh`.

## 12. Langkah Implementasi

### Fase A — UI dan mock

1. Buat model topik dan checklist.
2. Implementasikan halaman utama dan checklist.
3. Implementasikan progress dan completion box.
4. Tambahkan disclaimer dan pengingat verifikasi.
5. Simpan progres di memori.

### Fase B — Integrasi dan konten

1. Simpan progres checklist ke Supabase.
2. Verifikasi setiap tautan dan kanal resmi.
3. Tambahkan tanggal pemeriksaan dan status konten.
4. Tambahkan panduan pelaporan yang dapat diperbarui tanpa rilis aplikasi.
5. Hubungkan rekomendasi readiness ke Safe Job.

## 13. Edge Case dan Pesan

| Kondisi | Perilaku |
|---------|----------|
| Checklist belum lengkap | Tombol selesai tetap bisa, progress ditampilkan |
| Semua dicentang | Completion box + pengingat verifikasi |
| Tautan resmi tidak tersedia | Tampilkan panduan tanpa tautan |
| Gagal menyimpan progres | Tetap centang di sesi, beri tahu belum tersinkron |
| Materi kedaluwarsa | Tampilkan "Perlu verifikasi ulang" |
| Pengguna menemukan penipuan | Tampilkan langkah simpan bukti dan lapor |

## 14. Accessibility dan Usability

- Checkbox memiliki label dan state yang terbaca.
- Ikon peringatan disertai teks.
- Jangan memakai warna merah saja untuk risiko.
- Progress memiliki label "x dari 7 poin diperiksa".
- Teks panduan mudah dipindai dengan heading dan daftar.

## 15. Rencana Pengujian

- Widget: checklist toggle dan progress.
- Widget: completion box muncul saat semua dicentang.
- Widget: disclaimer tampil.
- Konten: 10 topik tercakup.
- Konten: tidak ada klaim verifikasi otomatis.
- Manual: tautan resmi dapat dibuka dan sumber jelas.
- Usability: pengguna dapat menyelesaikan checklist tanpa bantuan.

## 16. Kriteria Penerimaan

- [ ] Pengguna dapat menemukan panduan keamanan.
- [ ] Checklist mudah dipahami dan digunakan.
- [ ] Sistem membedakan edukasi dari verifikasi otomatis.
- [ ] Pengguna memperoleh langkah tindak lanjut.
- [ ] Progres checklist tersimpan atau dijelaskan batasannya.
- [ ] Tidak ada permintaan data sensitif.
- [ ] Disclaimer jaminan keamanan tampil.
- [ ] Tautan resmi terverifikasi dan bertanggal.

## 17. Risiko, Dependensi, Open Questions

### Risiko

- **HIGH**: informasi keamanan yang salah dapat membahayakan pengguna.
- **HIGH**: kanal pelaporan dan prosedur dapat berubah.
- **MEDIUM**: checklist dapat disalahartikan sebagai jaminan.
- **MEDIUM**: konten menakut-nakuti pengguna.

### Dependensi

- 00 Shared Foundation.
- 02 untuk rekomendasi.
- Repository safe checklist.

### Open Questions

- Kanal resmi mana yang akan direkomendasikan dan siapa yang memverifikasi?
- Apakah progres checklist disimpan per pengguna atau per sesi?
- Apakah perlu tautan ke sumber eksternal pada versi pertama?
- Seberapa sering konten keamanan ditinjau ulang?
