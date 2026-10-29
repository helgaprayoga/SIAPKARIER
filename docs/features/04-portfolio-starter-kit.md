# 04 — Portfolio Starter Kit

## Metadata

| Field | Nilai |
|-------|-------|
| ID | FT-04 |
| Rujukan PRD | §9.4, §11.3 butir 10–12, §15.3 |
| Prioritas | Must Have (§14.1) |
| Platform | Flutter (`frontend_mobile/`) |
| Status | Rencana |
| Bergantung pada | 00 Shared Foundation |
| Diperlukan oleh | 01 (akses cepat), 07 (statistik) |

## 1. Ringkasan dan Tujuan

Portfolio Starter Kit membantu mahasiswa memulai portofolio dengan mengorganisasi proyek, menjelaskan kontribusi, dan menyajikan hasil secara terstruktur. Fitur ini terutama ditujukan bagi mahasiswa yang belum punya portofolio.

Tujuan:

- Menjelaskan struktur portofolio.
- Mendorong dokumentasi proyek akademik dan pribadi.
- Membantu menjelaskan peran, proses, dan hasil.
- Mendukung identitas profesional.

## 2. Ruang Lingkup

### Termasuk

- Halaman pengantar dan panduan memulai.
- Struktur proyek empat bagian: masalah, peran, proses, hasil.
- Formulir proyek.
- Pratinjau studi kasus.
- Daftar proyek pengguna.
- Edit dan hapus proyek.
- Contoh proyek berlabel jelas.
- Pengingat kerahasiaan.
- Unggah gambar opsional.

### Tidak Termasuk

- Publikasi otomatis ke platform eksternal.
- Klaim bahwa contoh adalah karya pengguna.
- Penyimpanan gambar tanpa izin.
- Penilaian kualitas portofolio.

## 3. Matriks Traceability

| FR | Kebutuhan | Aturan bisnis | Kriteria penerimaan | Tes |
|----|-----------|---------------|---------------------|-----|
| FR-PORT-01 | Panduan memulai | Struktur jelas | Panduan tampil | Widget test |
| FR-PORT-02 | Template dokumentasi | Empat bagian utama | Form mengikuti struktur | Widget test |
| FR-PORT-03 | Buat entri baru | Judul dan peran wajib | Entri tersimpan | Widget test |
| FR-PORT-04 | Edit dan hapus | Konfirmasi hapus | Perubahan tercermin | Widget test |
| FR-PORT-05 | Kolom peran, proses, alat, hasil | Semua tersedia | Field tampil | Widget test |
| FR-PORT-06 | Pratinjau | Hanya data pengguna | Pratinjau sesuai input | Widget test |
| FR-PORT-07 | Daftar proyek | Tampil jika ada data | Daftar/empty state | Widget test |
| FR-PORT-08 | Contoh proyek berlabel | Label "contoh" jelas | Label terlihat | Widget test |
| FR-PORT-09 | Tidak klaim contoh sebagai karya | Contoh terpisah dari daftar pengguna | Tidak tercampur | Widget test |
| FR-PORT-10 | Panduan publikasi eksternal | Tanpa wajib data pribadi | Panduan tersedia | Review konten |

## 4. Alur Pengguna

1. Pengguna membuka Portfolio.
2. Sistem menampilkan penjelasan fungsi portofolio.
3. Pengguna melihat struktur empat bagian.
4. Pengguna memilih "Buat proyek".
5. Pengguna mengisi informasi proyek.
6. Pengguna melihat pratinjau.
7. Pengguna menyimpan atau mengedit.
8. Pengguna melihat daftar proyek yang dibuat.
9. Pengguna dapat mengedit atau menghapus proyek.

Layar: Portfolio, Portfolio form, Portfolio preview (§11.3 butir 10–12).

## 5. Model Data

```text
PortfolioProject
  id
  userId?
  title
  shortDescription?
  problem
  role
  process
  result
  tools[]          // alat/teknologi
  skills[]         // keterampilan
  imageUrl?        // opsional
  link?            // tautan pendukung
  reflection?      // pelajaran
  createdAt
  updatedAt
```

Sepuluh komponen PRD §9.4.3:

1. Nama proyek.
2. Deskripsi singkat.
3. Tujuan/masalah.
4. Peran pengguna.
5. Teknologi/alat.
6. Proses pengerjaan.
7. Hasil/keluaran.
8. Gambar/tautan pendukung.
9. Keterampilan.
10. Refleksi/pelajaran.

## 6. Validasi

| Field | Aturan | Pesan |
|-------|--------|-------|
| Judul | Wajib, 3–100 karakter | "Nama proyek perlu diisi." |
| Peran | Wajib, 2–80 karakter | "Jelaskan peranmu di proyek ini." |
| Masalah | Opsional, maks 600 karakter | "Masalah terlalu panjang." |
| Proses | Opsional, maks 1000 karakter | "Proses terlalu panjang." |
| Hasil | Opsional, maks 600 karakter | "Hasil terlalu panjang." |
| Alat | Opsional, daftar dipisah koma | — |
| Tautan | Opsional, URL valid | "Tautan tidak valid." |
| Gambar | Opsional, maks 5 MB, jpg/png | "Ukuran gambar maksimal 5 MB." |

Minimal: judul dan peran. Field lain boleh kosong dan disembunyikan di pratinjau.

## 7. Komponen UI

### Portfolio Main

- Header "Portfolio Starter" dengan tombol kembali.
- Hero: tag "Mulai dari yang kamu punya", judul, deskripsi, tombol "Buat proyek", ilustrasi tumpukan kartu.
- Struktur empat bagian: 01 Masalah, 02 Peranmu, 03 Proses, 04 Hasil.
- Contoh proyek dengan label `CONTOH — BUKAN KARYAMU`.
- Daftar "Proyek saya" jika ada; empty state jika kosong.

### Portfolio Form

- Judul, peran, masalah, proses, hasil, alat, keterampilan, tautan, gambar.
- Tip keamanan: jangan unggah data rahasia kampus/organisasi/klien.
- Sticky action "Lihat pratinjau".

### Portfolio Preview

- Cover dengan judul dan peran.
- Empat bagian studi kasus.
- Daftar alat/keterampilan.
- Tombol edit dan simpan.
- Label jika data masih draf.

## 8. Aturan Bisnis dan Pagar Klaim

- Pengguna harus jujur tentang peran dan kontribusi.
- Proyek kelompok harus menjelaskan kontribusi individual.
- Contoh proyek tidak boleh otomatis masuk ke daftar pengguna.
- Jika unggah gambar belum tersedia, jangan mengklaim gambar tersimpan.
- Ingatkan agar tidak mengunggah informasi rahasia.
- Jangan mengklaim portofolio dijamin menarik perekrut.
- Panduan publikasi eksternal tidak boleh mewajibkan data pribadi.

## 9. State

```text
portfolioControllerProvider
  state: PortfolioState {
    projects: List<PortfolioProject>,
    draft: PortfolioProject?,
    errors: Map<String,String>,
    status: idle|loading|saving|error
  }
```

Aksi: `createDraft`, `updateField`, `addTool`, `removeTool`, `save`, `delete`, `edit`, `clearDraft`.

## 10. Langkah Implementasi

### Fase A — UI dan mock

1. Buat model dan repository mock.
2. Implementasikan halaman utama, struktur, dan contoh berlabel.
3. Implementasikan form dan validasi.
4. Implementasikan pratinjau.
5. Implementasikan daftar proyek dan empty state.
6. Implementasikan edit/hapus dengan konfirmasi.

### Fase B — Integrasi

1. Simpan proyek ke Supabase.
2. Tambahkan unggah gambar ke Storage.
3. Tambahkan signed URL untuk gambar privat.
4. Sinkronkan statistik proyek ke Home/Profile.
5. Tambahkan panduan publikasi eksternal.

## 11. Edge Case dan Pesan

| Kondisi | Perilaku |
|---------|----------|
| Belum ada proyek | Empty state + CTA buat proyek |
| Judul/peran kosong | Tombol lanjut disabled |
| Proyek kelompok | Tip kontribusi individual |
| Gambar terlalu besar | Error ukuran file |
| Gagal unggah | "Gambar belum bisa diunggah." + coba lagi |
| Hapus proyek | Konfirmasi, lalu hapus dari daftar |
| Data rahasia | Peringatan sebelum simpan |
| Pratinjau tanpa data | Placeholder netral, bukan contoh fiktif |

## 12. Accessibility dan Usability

- Kartu proyek dapat dibaca screen reader dengan ringkasan.
- Tombol hapus memiliki label "Hapus proyek <judul>".
- Label contoh tidak hanya warna; gunakan teks.
- Form mendukung text scale dan keyboard.
- Gambar memiliki deskripsi alternatif bila diunggah.

## 13. Rencana Pengujian

- Unit: validasi dan serialisasi proyek.
- Widget: buat, edit, hapus proyek.
- Widget: contoh tidak muncul di daftar pengguna.
- Widget: empty state.
- Integration: unggah gambar dan tampilkan.
- Manual: pratinjau sesuai input.
- Konten: peringatan kerahasiaan jelas.

## 14. Kriteria Penerimaan

- [ ] Pengguna memahami struktur portofolio.
- [ ] Pengguna dapat membuat dokumentasi proyek.
- [ ] Pratinjau menampilkan data yang diisi.
- [ ] Contoh dan data pengguna dibedakan jelas.
- [ ] Pengguna dapat mengedit dan menghapus proyek.
- [ ] Daftar proyek tampil atau empty state informatif.
- [ ] Peringatan kerahasiaan tampil.
- [ ] Tidak ada klaim contoh sebagai karya pengguna.

## 15. Risiko, Dependensi, Open Questions

### Risiko

- **MEDIUM**: unggah gambar menambah kompleksitas storage dan izin.
- **MEDIUM**: pengguna dapat membagikan data rahasia tanpa sadar.
- **MEDIUM**: contoh proyek dapat disalahartikan sebagai karya pengguna.
- **LOW**: form panjang di layar kecil.

### Dependensi

- 00 Shared Foundation.
- `image_picker` bila unggah gambar.
- Supabase Storage bila menyimpan gambar.

### Open Questions

- Apakah gambar diwajibkan atau opsional pada versi pertama?
- Apakah proyek dapat diurutkan atau difilter?
- Apakah perlu ekspor portofolio ke PDF?
- Apakah panduan publikasi menautkan platform eksternal tertentu?
