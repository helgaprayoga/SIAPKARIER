# Backend Implementation Plan — CV Generator

## Metadata

| Field | Value |
|---|---|
| Feature ID | FT-03 |
| Backend Scope | CV CRUD, validation, PDF storage |
| PRD Reference | §9.3, §12.1 |
| Priority | Must Have |
| Platform | Laravel backend + Supabase database + Supabase Storage + Flutter mobile |
| Status | Plan |
| Depends On | 00 Shared Foundation, 07 Profile |

## 1. Ringkasan Backend

Backend Laravel menyediakan penyimpanan CV user dan penyimpanan file PDF hasil generate. Mobile tetap menjadi pembuat PDF, tetapi backend Laravel menyediakan kontrak penyimpanan dan metadata CV.

## 2. Endpoint API

| Method | Endpoint | Deskripsi | Auth |
|---|---|---|---|
| GET | `/api/v1/cvs` | Daftar CV user | User |
| POST | `/api/v1/cvs` | Buat CV | User |
| GET | `/api/v1/cvs/{id}` | Detail CV | Owner |
| PUT | `/api/v1/cvs/{id}` | Perbarui CV | Owner |
| DELETE | `/api/v1/cvs/{id}` | Hapus CV | Owner |
| POST | `/api/v1/cvs/{id}/pdf` | Simpan PDF hasil generate | Owner |

## 3. Skema Data

- `cvs`
  - `id`
  - `user_id`
  - `data`
  - `template`
  - `created_at`
  - `updated_at`

## 4. Storage

- Bucket privat untuk PDF CV.
- File path menyimpan user-scoped object.
- Mobile hanya mengirim PDF ke backend Laravel atau memakai share; backend Laravel menyediakan penyimpanan jika diaktifkan.

## 5. Logika Bisnis

1. Buat CV kosong.
2. Update CV.
3. Hapus CV.
4. Simpan PDF.
5. Pastikan data fiktif tidak pernah dibuat.

## 6. Auth dan Keamanan

- Laravel menggunakan Sanctum/API token untuk validasi user, dengan RLS pada tabel `cvs` di Supabase.
- Storage bucket privat Laravel/S3-compatible untuk PDF CV.
- User hanya mengakses CV sendiri.

## 7. Implementasi Backend

1. Definisikan tabel `cvs` di Supabase PostgreSQL.
2. Buat route dan controller CRUD di Laravel.
3. Hubungkan Laravel Storage/S3-compatible ke Supabase Storage.
4. Terapkan validasi minimal di Laravel.
5. Uji akses owner.

## 8. Testing Backend

- Unit test validasi CV.
- Integration test CRUD CV.
- Storage test upload/download PDF.

## 9. Acceptance Criteria

- [ ] User dapat membuat daftar CV.
- [ ] User dapat mengedit dan menghapus CV.
- [ ] PDF disimpan privat.
- [ ] Data fiktif tidak dihasilkan.

## 10. Risks dan Open Questions

- Apakah PDF perlu disimpan backend atau hanya lokal?
- Apakah template diubah menjadi field string?
