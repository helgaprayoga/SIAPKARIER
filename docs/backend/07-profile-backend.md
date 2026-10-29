# Backend Implementation Plan — Profile

## Metadata

| Field | Value |
|---|---|
| Feature ID | FT-07 |
| Backend Scope | Profile, activity summary, auth, privacy, account deletion |
| PRD Reference | §9.7, §12.1 |
| Priority | Must Have |
| Platform | Laravel backend + Supabase Auth + Supabase database + Supabase Storage + Flutter mobile |
| Status | Plan |
| Depends On | 00 Shared Foundation, 01–06 |

## 1. Ringkasan Backend

Backend Laravel menyediakan profil user, ringkasan aktivitas, autentikasi, dan privasi data. Fitur harus jelas batas antara data nyata user dan data contoh/simulasi.

## 2. Endpoint API

| Method | Endpoint | Deskripsi | Auth |
|---|---|---|---|
| GET | `/api/v1/profile` | Mendapatkan profil | User |
| PUT | `/api/v1/profile` | Memperbarui profil | User |
| GET | `/api/v1/profile/activity` | Ringkasan aktivitas | User |
| DELETE | `/api/v1/profile/data` | Menghapus data user | User |
| POST | `/api/v1/auth/logout` | Logout | User |
| POST | `/api/v1/auth/delete-account` | Hapus akun | User |

## 3. Skema Data

- `profiles`
- `auth.users`
- storage bucket privat

## 4. Logika Bisnis

1. Update field profil yang diizinkan.
2. Hitung activity summary.
3. Simpan lokasi penyimpanan data.
4. Jangan tampilkan data sensitif tanpa kebutuhan.
5. Logout dan penghapusan data wajib konfirmasi.

## 5. Auth dan Keamanan

- Backend Laravel terintegrasi dengan Supabase Auth untuk autentikasi email/password.
- Backend Laravel menggunakan Sanctum/API token; sesi disimpan aman.
- RLS pada profil di Supabase.
- Bucket privat Laravel/S3-compatible untuk dokumen dan gambar.

## 6. Implementasi Backend

1. Buat tabel `profiles` di Supabase PostgreSQL.
2. Hubungkan Laravel dengan Supabase Auth.
3. Buat route/controller profile di Laravel.
4. Buat route/controller activity di Laravel.
5. Buat route/controller delete data di Laravel.
6. Atur kebijakan privasi.

## 7. Testing Backend

- Unit test validasi profil.
- Unit test activity summary.
- Integration test update profile.
- Security test RLS.

## 8. Acceptance Criteria

- [ ] User hanya mengakses profil sendiri.
- [ ] Privacy page menjelaskan penyimpanan nyata.
- [ ] Logout hanya aktif bila auth nyata.
- [ ] Data sensitif tidak dikumpul berlebih.

## 9. Risks dan Open Questions

- Apakah penghapusan akun tersedia pada versi pertama?
- Apakah email ditampilkan di profil?
- Apakah mode gelap termasuk ruang lingkup backend.
