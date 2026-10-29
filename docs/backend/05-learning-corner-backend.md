# Backend Implementation Plan — Learning Corner

## Metadata

| Field | Value |
|---|---|
| Feature ID | FT-05 |
| Backend Scope | Learning content and progress |
| PRD Reference | §9.5, §12.1 |
| Priority | Must Have |
| Platform | Laravel backend + Supabase database + Flutter mobile |
| Status | Plan |
| Depends On | 00 Shared Foundation, 02 Readiness |

## 1. Ringkasan Backend

Backend Laravel menyediakan katalog materi pembelajaran dan status selesai yang ditandai user. Materi internal dan eksternal harus dipisah, dan tautan eksternal harus terverifikasi.

## 2. Endpoint API

| Method | Endpoint | Deskripsi | Auth |
|---|---|---|---|
| GET | `/api/v1/learning/materials` | Daftar materi publik | Public |
| GET | `/api/v1/learning/materials/{slug}` | Detail materi | Public |
| POST | `/api/v1/learning/progress` | Tandai selesai | User |
| PUT | `/api/v1/learning/progress` | Update progress | User |

## 3. Skema Data

- `learning_materials`
  - `id`
  - `slug`
  - `category_id`
  - `category_label`
  - `title`
  - `summary`
  - `content`
  - `duration_minutes`
  - `content_type`
  - `source_type`
  - `source_name`
  - `external_url`
  - `source_checked_at`
  - `is_published`
  - `order`

- `learning_progress`
  - `user_id`
  - `material_id`
  - `completed_at`

## 4. Logika Bisnis

1. Hanya materi `is_published` yang dikembalikan.
2. Materi eksternal wajib memiliki URL dan tanggal pemeriksaan.
3. Progress user-scoped.
4. Status selesai bukan bukti kompetensi.

## 5. Auth dan Keamanan

- Materi publik bisa dibaca melalui backend Laravel.
- Progress user-specific melalui auth Laravel/Supabase.
- Tidak ada penempatan atau penyimpanan data pribadi.

## 6. Implementasi Backend

1. Definisikan tabel materi dan progress di Supabase PostgreSQL.
2. Definisikan model Eloquent di Laravel.
3. Buat route dan controller list/detail di Laravel.
4. Buat route dan controller progress di Laravel.
5. Sediakan rekomendasi berbasis readiness.

## 7. Testing Backend

- Unit test daftar materi publik.
- Unit test detail slug.
- Integration test progress.
- Content test verifikasi tautan.

## 8. Acceptance Criteria

- [ ] Materi tidak terbit tidak tampil.
- [ ] Tautan eksternal terverifikasi.
- [ ] Progress user-scoped.
- [ ] Status bukan sertifikasi.

## 9. Risks dan Open Questions

- Format konten Markdown/HTML/rich text.
- Frekuensi verifikasi konten.
- Apakah progress perlu per user.
