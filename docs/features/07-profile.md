# 07 — Profile

## Metadata

| Field | Nilai |
|-------|-------|
| ID | FT-07 |
| Rujukan PRD | §9.7, §11.3 butir 17–18 |
| Prioritas | Must Have (§14.1) |
| Platform | Flutter (`frontend_mobile/`) |
| Status | Rencana |
| Bergantung pada | 00 Shared Foundation, 01–06 (ringkasan aktivitas) |
| Diperlukan oleh | — |

## 1. Ringkasan dan Tujuan

Profile adalah halaman untuk melihat dan mengelola informasi dasar pengguna, preferensi aplikasi, ringkasan aktivitas, dan informasi privasi.

Tujuan:

- Menampilkan informasi dasar pengguna.
- Memberi akses ke pengaturan.
- Menampilkan aktivitas dan progres persiapan karier.
- Menyediakan kontrol atas data yang disimpan.

## 2. Ruang Lingkup

### Termasuk

- Profil: nama, program studi, semester/tahun, minat karier.
- Edit profil.
- Ringkasan aktivitas: materi selesai, CV tersimpan, proyek dibuat, progres readiness.
- Pengaturan aplikasi.
- Halaman privasi dan penggunaan data.
- Logout.
- Informasi versi aplikasi.

### Tidak Termasuk

- Menampilkan data pribadi yang tidak relevan.
- Klaim akun terhubung ke backend bila autentikasi belum aktif.
- Penghapusan akun otomatis tanpa konfirmasi.
- Pengaturan pembayaran atau langganan.

## 3. Matriks Traceability

| FR | Kebutuhan | Aturan bisnis | Kriteria penerimaan | Tes |
|----|-----------|---------------|---------------------|-----|
| FR-PROFILE-01 | Tampilkan profil | Data relevan saja | Profil tampil | Widget test |
| FR-PROFILE-02 | Edit informasi dasar | Field opsional jelas | Perubahan tersimpan | Widget test |
| FR-PROFILE-03 | Tampilkan minat karier | Hanya jika diisi | Tidak ada data fiktif | Widget test |
| FR-PROFILE-04 | Ringkasan aktivitas | Dari data nyata | Angka sesuai sumber | Unit test |
| FR-PROFILE-05 | Akses privasi | Halaman tersedia | Navigasi berfungsi | Widget test |
| FR-PROFILE-06 | Tidak minta data tidak relevan | Minimalkan data | Form hanya field perlu | Review |
| FR-PROFILE-07 | Penjelasan data tersimpan | Jika ada penyimpanan | Penjelasan tampil | Review konten |
| FR-PROFILE-08 | Fitur akun hanya jika didukung | Jangan klaim palsu | Logout hanya jika auth aktif | Widget test |

## 4. Alur Pengguna

1. Pengguna membuka Profile dari bottom nav atau avatar.
2. Sistem menampilkan profil dan ringkasan aktivitas.
3. Pengguna membuka edit profil.
4. Pengguna mengubah field yang diizinkan.
5. Pengguna menyimpan perubahan.
6. Pengguna membuka privasi dan data.
7. Pengguna dapat logout bila autentikasi aktif.

Layar: Profile, Privacy, Edit Profile (§11.3 butir 17–18).

## 5. Model Data

```text
UserProfile
  id
  fullName
  studyProgram?
  semester?
  careerInterest?
  avatarInitials
  createdAt
  updatedAt

ActivitySummary
  readinessPercentage?
  completedMaterials
  savedCvs
  portfolioProjects
  lastUpdatedAt

PrivacyInfo
  dataCollected[]
  purpose
  storageLocation
  retention
  deletionMethod?
```

Field PRD §9.7.3:

- Nama pengguna.
- Bidang studi/program studi (opsional).
- Tahun/semester (opsional).
- Bidang karier diminati (opsional).
- Ringkasan aktivitas.
- Pengaturan aplikasi.
- Informasi privasi dan penggunaan data.

## 6. Validasi

| Field | Aturan | Pesan |
|-------|--------|-------|
| Nama | Wajib, 2–80 karakter | "Nama perlu diisi." |
| Program studi | Opsional, maks 80 karakter | "Nama program studi terlalu panjang." |
| Semester | Opsional, 1–14 | "Semester tidak valid." |
| Minat karier | Opsional, maks 80 karakter | "Minat karier terlalu panjang." |

Field opsional harus ditandai "Opsional" dan tidak boleh memblokir penyimpanan.

## 7. Komponen UI

### Profile

- Header "Profil".
- Avatar inisial, nama, program studi, tag minat karier.
- Tombol edit.
- Kartu aktivitas: persentase, progress, tiga statistik (materi selesai, CV tersimpan, proyek dibuat).
- Catatan "Data contoh" bila data simulasi.
- Daftar pengaturan: minat karier, privasi & data, tentang aplikasi.
- Tombol logout bila auth aktif.
- Versi aplikasi.

### Edit Profile

- Nama, program studi, semester, minat karier.
- Tombol simpan.
- Validasi dan state loading.

### Privacy

- Penjelasan data yang dikumpulkan.
- Tujuan penggunaan.
- Lokasi penyimpanan.
- Cara menghapus data.
- Danger box: jangan bagikan password/OTP/PIN/data perbankan.
- Tanggal pembaruan kebijakan.

## 8. Aturan Bisnis dan Pagar Klaim

- Data profil hanya digunakan untuk fungsi yang dijelaskan.
- Informasi yang tidak diperlukan tidak dikumpulkan.
- Data contoh tidak boleh dianggap data pengguna sebenarnya.
- Jika autentikasi belum tersedia, jangan menampilkan klaim akun terhubung.
- Logout hanya tampil jika sesi autentikasi nyata.
- Penghapusan data harus memiliki konfirmasi dan penjelasan konsekuensi.
- Jangan menampilkan email lengkap di layar publik tanpa kebutuhan.

## 9. State

```text
profileControllerProvider
  state: ProfileState {
    profile: UserProfile?,
    activity: ActivitySummary?,
    isEditing, isSaving,
    status: idle|loading|error
  }

authControllerProvider
  state: AuthState {
    session?, user?, status: unknown|authenticated|unauthenticated
  }
```

Aksi: `load`, `updateProfile`, `logout`, `deleteAccount` (bila didukung).

## 10. Langkah Implementasi

### Fase A — UI dan mock

1. Buat model profil dan activity summary.
2. Implementasikan halaman profil dan kartu aktivitas.
3. Implementasikan edit profil.
4. Implementasikan halaman privasi.
5. Tambahkan state kosong, loading, error.
6. Tampilkan data contoh dengan label jelas.

### Fase B — Integrasi

1. Hubungkan profil ke Supabase `profiles`.
2. Hitung activity summary dari tabel terkait.
3. Implementasikan logout dan sesi.
4. Implementasikan penghapusan data bila didukung.
5. Perbarui kebijakan privasi sesuai implementasi nyata.

## 11. Edge Case dan Pesan

| Kondisi | Perilaku |
|---------|----------|
| Belum login | Tampilkan ajakan login, bukan profil fiktif |
| Profil kosong | Placeholder "Lengkapi profil" |
| Gagal memuat | "Profil belum bisa dimuat." + coba lagi |
| Gagal menyimpan | "Perubahan belum tersimpan." |
| Logout | Konfirmasi sebelum keluar |
| Hapus data | Konfirmasi + penjelasan konsekuensi |
| Data aktivitas kosong | Tampilkan 0 dengan penjelasan, bukan data contoh |

## 12. Accessibility dan Usability

- Avatar memiliki label "Foto profil <nama>" atau "Inisial <nama>".
- Statistik memiliki label yang jelas, bukan hanya angka.
- Tombol edit dan logout memiliki label.
- Field opsional ditandai secara tekstual.
- Halaman privasi mudah dipindai dengan heading.

## 13. Rencana Pengujian

- Unit: validasi profil.
- Unit: perhitungan activity summary.
- Widget: edit dan simpan profil.
- Widget: state kosong, loading, error.
- Widget: navigasi ke privasi.
- Integration: logout dan sesi.
- Konten: privasi menjelaskan data yang benar-benar disimpan.

## 14. Kriteria Penerimaan

- [ ] Pengguna dapat melihat profil.
- [ ] Pengguna dapat mengedit informasi dasar.
- [ ] Field opsional ditandai jelas.
- [ ] Ringkasan aktivitas sesuai data nyata.
- [ ] Halaman privasi dapat diakses.
- [ ] Tidak ada data pribadi yang tidak relevan.
- [ ] Tidak ada klaim backend jika auth belum aktif.
- [ ] Logout berfungsi bila auth tersedia.

## 15. Risiko, Dependensi, Open Questions

### Risiko

- **HIGH**: data pribadi dan privasi harus ditangani hati-hati.
- **MEDIUM**: activity summary dapat tidak sinkron dengan fitur lain.
- **MEDIUM**: pengguna mungkin mengira data contoh adalah data mereka.
- **LOW**: field opsional dapat membingungkan bila tidak ditandai.

### Dependensi

- 00 Shared Foundation.
- 01–06 untuk data aktivitas.
- Supabase Auth dan tabel `profiles`.

### Open Questions

- Apakah pengguna wajib login sebelum menyimpan data?
- Apakah penghapusan akun tersedia pada versi pertama?
- Apakah email ditampilkan di profil?
- Apakah preferensi mode gelap termasuk ruang lingkup?
