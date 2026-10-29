# 00 — Shared Foundation

## Metadata

| Field | Nilai |
|-------|-------|
| ID | SF-00 |
| Rujukan PRD | §8, §10, §11, §12, §13 |
| Prioritas | Must Have (§14.1) |
| Platform | Flutter (`frontend_mobile/`), referensi visual React/Figma |
| Status | Rencana |
| Bergantung pada | — |
| Diperlukan oleh | 01–07 |

## 1. Ringkasan dan Tujuan

Fondasi bersama mencakup design token, komponen UI dasar, navigasi, kontrak data, pola state, dan kebijakan label data. Tujuannya agar tujuh fitur memiliki tampilan, perilaku, dan struktur data yang konsisten serta tidak menduplikasi keputusan.

## 2. Ruang Lingkup

### Termasuk

- Design token warna, tipografi, spacing, radius, dan shadow.
- Komponen reusable: tombol, kartu, tag, progress, header, field, bottom nav, sticky action.
- Struktur navigasi lima tab dan route detail.
- Kontrak model data lintas fitur.
- Pola state Riverpod dan repository.
- Kebijakan label data contoh, simulasi, dan data nyata.
- Baseline accessibility dan pengujian.

### Tidak Termasuk

- Logika bisnis spesifik per fitur (dibahas di dokumen 01–07).
- Konten materi pembelajaran dan keamanan (dibahas di 05 dan 06).
- Implementasi backend rinci (dibahas sebagai konvensi di §12).

## 3. Design Token

Sumber: `SiapKarier Career Prep App/src/index.css`.

### Warna

| Token | Nilai | Penggunaan |
|-------|-------|------------|
| navy | `#183B56` | Teks heading, kartu gelap, avatar |
| navyDeep | `#102E45` | Heading utama |
| teal | `#327D76` | Aksi utama, ikon aktif, progress |
| tealDark | `#286962` | Hover/tekanan tombol |
| tealSoft | `#E7F3F0` | Latar tag, ikon, state terpilih |
| gold | `#D8A33D` | Progress, aksen, badge |
| goldSoft | `#FFF3D8` | Latar peringatan ringan |
| ink | `#21323F` | Teks body |
| muted | `#71808A` | Teks sekunder |
| line | `#E4E9E8` | Border dan pemisah |
| surface | `#FFFFFF` | Latar kartu |
| background | `#F3F6F5` | Latar halaman |
| danger | `#B85F51` | Peringatan keamanan |

Aturan: jangan menambah warna baru tanpa memperbarui dokumen ini. Warna tidak boleh menjadi satu-satunya pembeda status; selalu sertakan teks atau ikon.

### Tipografi

| Peran | Font | Ukuran acuan |
|-------|------|--------------|
| Heading 1 | Manrope 800 | 27–29 |
| Heading 2 | Manrope 700 | 21–25 |
| Heading 3 | Manrope 700 | 16 |
| Body | DM Sans 400 | 13–16 |
| Label/tag | DM Sans 800 | 10 |
| Caption | DM Sans 400 | 9–11 |

Font dibundel di `assets/fonts/` agar tidak bergantung koneksi. Jika memakai `google_fonts`, sediakan fallback dan uji mode offline.

### Spacing, Radius, Shadow

- Spacing dasar: 4, 8, 12, 16, 20, 22, 24, 28, 30.
- Padding halaman: 22 horizontal; 30 atas; 116 bawah bila ada bottom nav.
- Radius: `sm` 12, `md` 18, `lg` 26.
- Shadow: `sm` `0 6 20 rgba(24,59,86,0.07)`; `lg` `0 28 70 rgba(24,59,86,0.14)`.

## 4. Komponen Wajib

| Komponen | Perilaku |
|----------|----------|
| `AppButton` | Varian primary, secondary, ghost; min height 51; state disabled; ikon opsional |
| `AppCard` | Border, radius, shadow; dapat menjadi tombol dengan Semantics |
| `AppTag` | Varian teal, gold, neutral, navy; teks pendek |
| `AppProgress` | Nilai 0–100; label aksesibel; warna gold |
| `AppPageHeader` | Eyebrow, judul, tombol kembali, aksi kanan |
| `AppTextField` | Label, hint, error, multiline, counter; validasi |
| `StickyActionBar` | Satu atau dua tombol; safe area; tidak menutupi konten |
| `AppBottomNav` | 5 tab; indikator aktif; label teks |
| `AppIcon` | Ikon stroke konsisten (Lucide) |
| `EmptyState` | Ikon, judul, deskripsi, aksi |
| `SectionTitle` | Eyebrow + heading + aksi opsional |

## 5. Navigasi

Lima tab utama sesuai PRD §8:

1. Home
2. Readiness
3. CV
4. Learn
5. Profile

Portfolio dan Safe Job diakses dari Home atau Learn, bukan tab tersendiri.

### Peta Route Flutter

```text
/login
/register
/home
/readiness
/readiness/quiz
/readiness/result
/cv
/cv/template
/cv/preview
/portfolio
/portfolio/form
/portfolio/preview
/learn
/learn/:materialId
/safe
/safe/checklist
/profile
/profile/edit
/profile/privacy
```

Bottom nav hanya tampil pada route tab. Route detail menggunakan root navigator agar nav tersembunyi, sesuai perilaku prototipe.

## 6. Kontrak Data Bersama

Model minimal yang dipakai lintas fitur:

```text
UserProfile
  id, fullName, studyProgram?, semester?, careerInterest?, avatarInitials

ReadinessAssessment
  id, userId?, answers[], score, percentage, categories[], createdAt

CvData
  fullName, email, phone?, links[], summary,
  education[], experiences[], organizations[], projects[],
  skills[], certificates[], languages[], template

PortfolioProject
  id, userId?, title, role, problem, process, result,
  tools[], skills[], imageUrl?, createdAt, updatedAt

LearningMaterial
  id, slug, category, title, summary, content,
  durationMinutes, sourceType, externalUrl?, sourceCheckedAt?

LearningProgress
  userId, materialId, completedAt

SafeChecklistProgress
  userId?, checklistVersion, checkedItems[], updatedAt

ActivitySummary
  readinessPercentage?, completedMaterials, savedCvs,
  portfolioProjects, lastUpdatedAt
```

Aturan:

- Field opsional harus benar-benar opsional di UI dan penyimpanan.
- Data contoh tidak boleh mengisi field pengguna secara otomatis.
- Tanggal disimpan ISO-8601; tampilan memakai `intl`.
- ID entri baru dibuat di repository, bukan di widget.

## 7. State dan Repository

Gunakan Riverpod tanpa code generation.

```text
AuthController          -> session, user, status
ReadinessController     -> answers, currentIndex, result
CvController            -> draft, validation, selectedTemplate
PortfolioController     -> projects, draft, validation
LearnController         -> filter, query, materials, progress
SafeController          -> checkedItems, progress
ProfileController       -> profile, activity summary
```

Setiap fitur memiliki repository interface dengan dua implementasi:

- `MockXRepository` untuk pengembangan UI dan pengujian.
- `SupabaseXRepository` untuk integrasi nyata.

Widget tidak boleh memanggil Supabase langsung.

## 8. Kebijakan Label Data

Tiga jenis data harus dibedakan secara visual dan tekstual:

| Jenis | Label | Contoh |
|-------|-------|--------|
| Data pengguna | Tidak berlabel khusus | CV yang diisi pengguna |
| Data contoh | `CONTOH — BUKAN KARYAMU` atau `Data contoh` | Proyek referensi |
| Hasil simulasi | `Simulasi prototipe` | Tombol unduh yang belum menghasilkan PDF |

Aturan:

- Jangan menampilkan nama, kampus, atau pengalaman fiktif sebagai data pengguna.
- Jika suatu fitur belum nyata, tombol harus menjelaskan batasannya.
- Jangan mengklaim akun terhubung ke backend bila autentikasi belum aktif.

## 9. Pola UX Bersama

Setiap layar wajib memiliki:

- **Loading**: skeleton atau indikator, bukan layar kosong.
- **Empty**: penjelasan + aksi memulai.
- **Error**: pesan masalah + cara memperbaiki + tombol coba lagi.
- **Success**: konfirmasi singkat, tidak menutupi konten.
- **Disabled**: alasan jelas, bukan sekadar tombol mati.

Formulir panjang dibagi per bagian. Pesan kesalahan memakai bahasa sederhana dan menyebut field yang bermasalah.

## 10. Accessibility Baseline

Target WCAG 2.2 AA:

- Kontras teks minimal 4.5:1 untuk body dan 3:1 untuk teks besar.
- Touch target minimal 48×48 dp.
- Setiap ikon tombol memiliki `Semantics` label.
- Urutan fokus logis; form memiliki label yang terhubung.
- Status tidak hanya dibedakan warna.
- Mendukung text scaling hingga 200% tanpa clipping kritis.
- Tidak ada informasi penting yang hanya ada di gambar.

## 11. Backend Shared Convention

Target: Supabase.

- Auth: email/password; sesi disimpan aman.
- Tabel: `profiles`, `readiness_assessments`, `cvs`, `portfolio_projects`, `learning_materials`, `learning_progress`, `safe_checklist_progress`.
- RLS: pengguna hanya mengakses baris miliknya; materi publik hanya baca.
- Storage: bucket privat per pengguna untuk gambar portofolio dan PDF.
- Kunci yang dipakai di aplikasi hanya anon key; service role tidak boleh ada di mobile.
- Konfigurasi lewat `--dart-define`, bukan hardcode.

## 12. Langkah Implementasi

1. Buat struktur folder `core/`, `data/`, `features/`, `providers/`.
2. Definisikan token dan tema.
3. Bundel font dan ikon.
4. Buat komponen dasar beserta widget test.
5. Buat router dan shell lima tab.
6. Definisikan model dan repository mock.
7. Terapkan pola loading/empty/error.
8. Audit accessibility baseline.
9. Siapkan adapter Supabase setelah UI stabil.

## 13. Kriteria Penerimaan

- [ ] Token warna dan tipografi terpusat, tidak ada hardcode berulang.
- [ ] Lima tab berfungsi dan route detail menyembunyikan bottom nav.
- [ ] Komponen dasar dipakai ulang oleh minimal dua fitur.
- [ ] Model data bersama tersedia dan tervalidasi.
- [ ] Label data contoh/simulasi diterapkan.
- [ ] Tidak ada data fiktif yang mengisi field pengguna.
- [ ] Baseline accessibility lulus pemeriksaan manual.
- [ ] `flutter analyze` bersih.

## 14. Risiko dan Open Questions

### Risiko

- **HIGH**: perbedaan perilaku CSS web dan Flutter (blur, fixed bar, conic gradient).
- **MEDIUM**: godaan menyalin data contoh dari prototipe React.
- **MEDIUM**: duplikasi token di banyak file jika tidak disiplin.

### Open Questions

- Apakah nama paket diubah menjadi `siapkarier` dan applicationId `com.siapkarier.app`?
- Apakah font dibundel atau memakai `google_fonts`?
- Apakah login wajib sebelum memakai fitur, atau opsional sampai pengguna menyimpan data?
