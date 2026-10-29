# Backend Implementation Plan — Portfolio Starter Kit

## Metadata

| Field | Value |
|---|---|
| Feature ID | FT-04 |
| Backend Scope | Project CRUD, image upload, public project listing |
| PRD Reference | §9.4, §12.1 |
| Priority | Must Have |
| Platform | Laravel backend + Supabase database + Supabase Storage + Flutter mobile |
| Status | Plan |
| Depends On | 00 Shared Foundation, 07 Profile |

## 1. Ringkasan Backend

Backend Laravel menyediakan penyimpanan proyek portofolio user dan file gambar pendukung. Proyek disusun dengan struktur masalah, peran, proses, hasil, alat, keterampilan, dan refleksi.

## 2. Endpoint API

| Method | Endpoint | Deskripsi | Auth |
|---|---|---|---|
| GET | `/api/v1/portfolio/projects` | Daftar proyek user | User |
| POST | `/api/v1/portfolio/projects` | Buat proyek | User |
| GET | `/api/v1/portfolio/projects/{id}` | Detail proyek | Owner |
| PUT | `/api/v1/portfolio/projects/{id}` | Perbarui proyek | Owner |
| DELETE | `/api/v1/portfolio/projects/{id}` | Hapus proyek | Owner |
| POST | `/api/v1/portfolio/projects/{id}/image` | Upload gambar | Owner |

## 3. Skema Data

- `portfolio_projects`
  - `id`
  - `user_id`
  - `title`
  - `problem`
  - `role`
  - `process`
  - `result`
  - `tools`
  - `skills`
  - `image_url`
  - `link`
  - `reflection`
  - `created_at`
  - `updated_at`

## 4. Logika Bisnis

1. Validasi judul dan peran wajib.
2. Simpan struktur proyek.
3. Upload gambar ke bucket privat.
4. Generate URL akses aman.
5. Pastikan contoh proyek tidak masuk sebagai data user.

## 5. Auth dan Keamanan

- Laravel menggunakan Sanctum/API token untuk validasi user, dengan RLS pada tabel proyek di Supabase.
- Laravel Storage/S3-compatible untuk gambar.
- Signed URL Laravel untuk akses yang aman.

## 6. Implementasi Backend

1. Definisikan tabel `portfolio_projects` di Supabase PostgreSQL.
2. Buat route dan controller CRUD di Laravel.
3. Hubungkan Laravel Storage/S3-compatible ke Supabase Storage gambar.
4. Terapkan validasi.
5. Uji akses owner.

## 7. Testing Backend

- Unit test validasi proyek.
- Integration test CRUD.
- Storage test upload gambar.

## 8. Acceptance Criteria

- [ ] User dapat membuat proyek.
- [ ] User dapat mengedit dan menghapus.
- [ ] Gambar disimpan privat.
- [ ] Contoh tidak masuk daftar user.

## 9. Risks dan Open Questions

- Apakah gambar wajib pada versi pertama?
- Apakah perlu ekspor portofolio ke PDF?
