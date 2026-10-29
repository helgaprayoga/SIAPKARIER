# Backend Implementation Plan — Safe Job Search

## Metadata

| Field | Value |
|---|---|
| Feature ID | FT-06 |
| Backend Scope | Safety topics, checklist, progress |
| PRD Reference | §9.6, §12.1 |
| Priority | Must Have |
| Platform | Laravel backend + Supabase database + Flutter mobile |
| Status | Plan |
| Depends On | 00 Shared Foundation, 02 Readiness |

## 1. Ringkasan Backend

Backend Laravel menyediakan data edukasi keamanan kerja dan progres checklist. Fitur tidak boleh mengklaim verifikasi otomatis perusahaan atau jaminan keamanan lowongan.

## 2. Endpoint API

| Method | Endpoint | Deskripsi | Auth |
|---|---|---|---|
| GET | `/api/v1/safe/topics` | Daftar topik keamanan | Public |
| GET | `/api/v1/safe/checklist` | Detail checklist | Public |
| POST | `/api/v1/safe/checklist/progress` | Tandai item diperiksa | User |
| PUT | `/api/v1/safe/checklist/progress` | Update progress | User |

## 3. Skema Data

- `safe_topics`
- `safe_checklist_items`
- `safe_checklist_progress`

## 4. Logika Bisnis

1. Checklist memakai versi.
2. User menandai item yang diperiksa.
3. Completion box jika semua item tercapai.
4. Reminder verifikasi silang melalui sumber resmi.

## 5. Auth dan Keamanan

- Topik/checklist bisa public melalui backend Laravel.
- Progress user-scoped melalui auth Laravel/Supabase.
- Tidak meminta data sensitif.
- Jangan klaim verifikasi otomatis.

## 6. Implementasi Backend

1. Definisikan tabel topik, checklist, dan progress di Supabase PostgreSQL.
2. Definisikan model Eloquent di Laravel.
3. Buat route dan controller di Laravel.
4. Terapkan versi checklist.
5. Sediakan langkah tindak lanjut.

## 7. Testing Backend

- Unit test completion.
- Integration test progress.
- Content test sumber resmi.

## 8. Acceptance Criteria

- [ ] Checklist tidak dianggap jaminan.
- [ ] Progress user-scoped.
- [ ] Tautan resmi terverifikasi.
- [ ] Tidak ada permintaan data sensitif.

## 9. Risks dan Open Questions

- Kanal resmi yang direkomendasikan.
- Frekuensi verifikasi konten.
- Apakah progress per user.
