# 03 — CV Generator

## Metadata

| Field | Nilai |
|-------|-------|
| ID | FT-03 |
| Rujukan PRD | §9.3, §11.3 butir 5–9, §15.2 |
| Prioritas | Must Have (§14.1), Should Have untuk multi-template (§14.2) |
| Platform | Flutter (`frontend_mobile/`) |
| Status | Rencana |
| Bergantung pada | 00 Shared Foundation |
| Diperlukan oleh | 01 (akses cepat), 07 (statistik) |

## 1. Ringkasan dan Tujuan

CV Generator membantu pengguna menyusun CV melalui formulir terstruktur, memilih template, melihat pratinjau, dan menghasilkan PDF yang dapat diperiksa sebelum digunakan.

Tujuan:

- Memudahkan mahasiswa memulai CV.
- Memberi struktur informasi yang konsisten.
- Membantu pengguna tanpa pengalaman kerja tetap menampilkan proyek dan keterampilan.
- Mengurangi hambatan teknis dalam menyiapkan dokumen lamaran.

## 2. Ruang Lingkup

### Termasuk

- Formulir data pribadi, pendidikan, pengalaman, organisasi, proyek, keterampilan, sertifikat, dan bahasa.
- Entri multi-item (tambah, edit, hapus).
- Tiga template: Fokus, Klasik, Modern.
- Pratinjau CV sesuai data.
- Validasi field wajib.
- Simpan draf.
- Generate PDF nyata dan bagikan/unduh.
- Peringatan untuk memeriksa ulang sebelum melamar.

### Tidak Termasuk

- Membuat pengalaman, keterampilan, atau sertifikat fiktif.
- Klaim bahwa CV dijamin diterima perusahaan.
- Sinkronisasi lintas perangkat di luar Supabase.
- Penilaian kualitas CV secara otomatis.

## 3. Matriks Traceability

| FR | Kebutuhan | Aturan bisnis | Kriteria penerimaan | Tes |
|----|-----------|---------------|---------------------|-----|
| FR-CV-01 | Formulir terstruktur | Bagian jelas dan berurutan | Semua bagian tampil | Widget test |
| FR-CV-02 | Isi dan edit data | Perubahan tersimpan di draf | Data bertahan saat navigasi | Widget test |
| FR-CV-03 | Tambah beberapa entri | Pendidikan/proyek/pengalaman/sertifikat | Entri bertambah | Widget test |
| FR-CV-04 | Hapus entri | Konfirmasi hapus | Entri hilang dari pratinjau | Widget test |
| FR-CV-05 | Pilihan template | Minimal 3 template | Template dapat dipilih | Widget test |
| FR-CV-06 | Pratinjau dari data | Hanya data pengguna | Pratinjau sesuai input | Widget test |
| FR-CV-07 | Kembali edit | Dari pratinjau ke form | Data tidak hilang | Widget test |
| FR-CV-08 | Simpan/unduh | PDF nyata dan dapat dibuka | File terbentuk | Integration test |
| FR-CV-09 | Validasi | Nama, email, minimal satu konten | Error jelas | Unit/widget test |
| FR-CV-10 | Tidak ada data fiktif | Field kosong disembunyikan | Tidak muncul nama/kampus contoh | Widget test |
| FR-CV-11 | Info tanpa pengalaman kerja | Tip dan alternatif proyek | Tip tampil | Widget test |
| FR-CV-12 | Peringatan periksa ulang | Sebelum simpan/unduh | Dialog/teks peringatan | Widget test |

## 4. Alur Pengguna

1. Pengguna membuka CV Generator.
2. Sistem menampilkan penjelasan singkat.
3. Pengguna mengisi profil dan pendidikan.
4. Pengguna menambahkan pengalaman, organisasi, proyek, keterampilan, sertifikat, dan bahasa.
5. Pengguna memilih template.
6. Sistem menampilkan pratinjau.
7. Pengguna meninjau dan kembali mengedit bila perlu.
8. Pengguna menyimpan draf atau mengunduh PDF.
9. Sistem memberi peringatan untuk memeriksa kembali.

Layar: CV form, CV template, CV preview (§11.3 butir 5–9).

## 5. Model Data

```text
CvData
  fullName: String
  email: String
  phone: String?
  links: List<CvLink>          // label, url
  summary: String
  education: List<Education>
  experiences: List<Experience>
  organizations: List<Experience>
  projects: List<Project>
  skills: List<String>
  certificates: List<Certificate>
  languages: List<Language>
  template: CvTemplate        // focus | classic | modern

Education
  institution, degree, major, startYear, endYear?, gpa?, description?

Experience
  title, organization, startDate, endDate?, description, achievements[]

Project
  name, role, description, tools[], result, link?

Certificate
  name, issuer, year?, credentialUrl?

Language
  name, proficiency
```

Field PRD §9.3.3 yang harus tersedia: nama, email, telepon opsional, tautan portofolio/profil, ringkasan, pendidikan, pengalaman kerja/magang, organisasi/kepanitiaan, proyek, keterampilan, sertifikat/pelatihan, bahasa.

## 6. Validasi

| Field | Aturan | Pesan |
|-------|--------|-------|
| Nama lengkap | Wajib, 2–80 karakter | "Nama lengkap perlu diisi." |
| Email | Wajib, format email | "Masukkan email yang valid." |
| Telepon | Opsional, digit/+/spasi | "Nomor telepon tidak valid." |
| Tautan | Opsional, URL valid | "Tautan perlu diawali http:// atau https://." |
| Ringkasan | Opsional, maks 240 karakter | "Ringkasan maksimal 240 karakter." |
| Pendidikan | Minimal satu entri disarankan | "Tambahkan pendidikan agar CV lebih lengkap." |
| Konten | Minimal satu dari pendidikan/proyek/pengalaman | "Isi minimal satu bagian pengalaman atau proyek." |
| Tahun | Angka 4 digit, akhir ≥ awal | "Tahun akhir tidak boleh lebih awal." |

Validasi keras: nama dan email. Validasi konten: minimal satu bagian agar CV tidak kosong, tetapi pengguna tetap bisa melihat pratinjau dengan empty state yang jelas.

## 7. Komponen UI

### CV Form

- Header "Buat CV", eyebrow "LANGKAH 1 DARI 3".
- Stepper 1–2–3.
- Bagian Profil: nama, email, telepon, tautan, ringkasan.
- Bagian Pendidikan: daftar entri + tombol "Tambah pendidikan".
- Bagian Pengalaman: kerja/magang + organisasi + tombol tambah.
- Bagian Proyek: nama, peran, deskripsi, alat, hasil, tautan.
- Bagian Keterampilan: input tag/comma-separated.
- Bagian Sertifikat dan Bahasa.
- Tip "Belum punya pengalaman kerja?".
- Sticky action "Pilih template".

### CV Template

- Tiga kartu preview mini: Fokus (direkomendasikan), Klasik (rapi/formal), Modern (segar/ringkas).
- State terpilih jelas dengan border dan radio.
- Tombol kembali dan "Lihat pratinjau".

### CV Preview

- Lembar A4 dengan header, profil, pendidikan, pengalaman, proyek, keterampilan.
- Tombol edit.
- Peringatan "Periksa kembali semua informasi sebelum melamar."
- Tombol "Unduh PDF" dan "Simpan".

## 8. Aturan Bisnis dan Pagar Klaim

- Pengguna bertanggung jawab atas kebenaran data.
- Sistem hanya menyusun dan memformat data yang diberikan.
- Bagian kosong disembunyikan; jangan mengisi dengan data contoh.
- Jangan meminta data sensitif tanpa alasan (NIK, rekening, password).
- PDF harus dapat dibuka dan diperiksa pengguna sebelum dikirim.
- Jangan mengklaim CV dijamin diterima.
- Jika pengguna belum punya pengalaman kerja, tampilkan alternatif proyek/organisasi.
- Data draf disimpan hanya jika pengguna memilih simpan; jelaskan lokasinya.

## 9. PDF

Gunakan package `pdf` untuk membuat dokumen A4 dan `printing` untuk pratinjau/bagikan.

- Tiga template mengikuti gaya Figma: Fokus, Klasik, Modern.
- Nama file: `CV_<Nama>_<YYYYMMDD>.pdf`.
- Simpan ke direktori dokumen aplikasi; bagikan lewat share sheet.
- Jika disimpan ke Supabase Storage, gunakan bucket privat dan signed URL.
- Uji PDF di Android: buka, scroll, dan pastikan teks tidak terpotong.
- Jangan sertakan metadata sensitif yang tidak perlu.

## 10. State

```text
cvControllerProvider
  state: CvState {
    draft: CvData,
    errors: Map<String,String>,
    selectedTemplate: CvTemplate,
    isSaving, isGenerating,
    savedCvId?
  }
```

Aksi: `updateField`, `addEducation`, `removeEducation`, `addExperience`, `removeExperience`, `addProject`, `removeProject`, `selectTemplate`, `validate`, `saveDraft`, `generatePdf`, `reset`.

## 11. Langkah Implementasi

### Fase A — UI dan mock

1. Buat model `CvData` dan entri.
2. Implementasikan form dengan bagian dan entri dinamis.
3. Implementasikan validasi.
4. Implementasikan pemilihan template.
5. Implementasikan pratinjau tanpa data fiktif.
6. Tambahkan tip dan peringatan.

### Fase B — PDF dan penyimpanan

1. Implementasikan `CvPdfService` untuk tiga template.
2. Tambahkan preview/share PDF.
3. Simpan draf ke repository mock.
4. Integrasikan Supabase untuk simpan/unduh.
5. Tambahkan daftar CV tersimpan di Profile/Home bila diperlukan.

## 12. Edge Case dan Pesan

| Kondisi | Perilaku |
|---------|----------|
| Nama/email kosong | Tombol lanjut disabled + error |
| Tidak ada pengalaman | Tetap bisa lanjut; tip alternatif tampil |
| Entri kosong | Tidak dirender di pratinjau |
| URL tidak valid | Error pada field |
| PDF gagal dibuat | "PDF belum bisa dibuat. Coba lagi." |
| Penyimpanan gagal | "Draf belum tersimpan." + coba lagi |
| Pengguna keluar saat mengisi | Konfirmasi simpan/buang draf |
| Teks sangat panjang | Pratinjau memotong dengan elipsis, PDF membungkus teks |

## 13. Accessibility dan Usability

- Setiap field memiliki label yang terhubung.
- Error diumumkan dengan `Semantics` dan teks.
- Tombol tambah/hapus memiliki label jelas.
- Form dapat diselesaikan dengan keyboard dan screen reader.
- Jangan memakai placeholder sebagai satu-satunya label.
- Pastikan urutan fokus sesuai urutan visual.

## 14. Rencana Pengujian

- Unit: validasi email, tahun, URL, dan field wajib.
- Unit: serialisasi/deserialisasi `CvData`.
- Widget: tambah/hapus entri.
- Widget: pratinjau tidak menampilkan data fiktif.
- Integration: generate PDF dan buka file.
- Manual: bandingkan tiga template dengan desain.
- Konten: peringatan periksa ulang tampil.

## 15. Kriteria Penerimaan

- [ ] Pengguna dapat mengisi dan mengedit CV.
- [ ] Pengguna dapat menambah dan menghapus entri.
- [ ] Tiga template dapat dipilih dan dipratinjau.
- [ ] Pratinjau hanya menampilkan data pengguna.
- [ ] Field kosong tidak diisi data fiktif.
- [ ] Validasi jelas dan tidak memblokir tanpa alasan.
- [ ] PDF dapat dihasilkan, dibuka, dan dibagikan.
- [ ] Pengguna dapat kembali mengedit tanpa kehilangan data.
- [ ] Peringatan pemeriksaan akhir tampil.

## 16. Risiko, Dependensi, Open Questions

### Risiko

- **HIGH**: PDF multi-template memakan waktu dan rawan layout rusak.
- **HIGH**: data pribadi di CV harus dilindungi.
- **MEDIUM**: form panjang dapat membingungkan; perlu pembagian bagian.
- **MEDIUM**: pengguna mungkin mengira CV dijamin lolos seleksi.

### Dependensi

- 00 Shared Foundation.
- `pdf`, `printing`, `path_provider`, `share_plus`.
- Supabase Storage bila menyimpan PDF di cloud.

### Open Questions

- Apakah draf disimpan otomatis atau manual?
- Apakah PDF disimpan ke cloud atau hanya perangkat?
- Apakah template dapat ditambah setelah versi pertama?
- Apakah perlu fitur impor data dari profil?
