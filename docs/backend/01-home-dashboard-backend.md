# Backend Implementation Plan — Home Dashboard

## Metadata

| Field | Value |
|---|---|
| Feature ID | FT-01 |
| Backend Scope | Activity summary aggregation for Home Dashboard |
| PRD Reference | §9.1, §12.1 |
| Priority | Must Have |
| Platform | Laravel backend + Supabase database + Flutter mobile |
| Status | Plan |
| Depends On | 00 Shared Foundation, 02 Readiness, 05 Learning, 06 Safe, 03 CV, 04 Portfolio |

## 1. Ringkasan Backend

Backend Laravel bertugas menyediakan satu kontrak agregasi aktivitas yang dapat dibaca oleh Home Dashboard. Home tidak boleh menyimpan state hasil evaluasi secara lokal sebagai sumber kebenaran bila integrasi backend sudah tersedia.

Backend harus menggabungkan data readiness, pembelajaran, CV, portofolio, dan safe checklist untuk menghasilkan `HomeSummary`.

## 2. Endpoint API

| Method | Endpoint | Deskripsi | Auth |
|---|---|---|---|
| GET | `/api/v1/home/summary` | Mengambil ringkasan aktivitas pengguna | Optional |

Respons:

```json
{
  "readinessPercentage": 34,
  "readinessLabel": "Perlu Dikembangkan",
  "completedMaterials": 2,
  "savedCvs": 1,
  "portfolioProjects": 3,
  "lastUpdatedAt": "2026-10-29T12:00:00Z"
}
```

## 3. Skema / Sumber Data

Gunakan tabel yang sudah direncanakan:

- `profiles`
- `readiness_assessments`
- `learning_progress`
- `cvs`
- `portfolio_projects`
- `safe_checklist_progress`

Backend dapat menggunakan SQL view atau query gabungan untuk menghitung summary.

## 4. Logika Bisnis

1. Ambil profil user.
2. Ambil hasil readiness terbaru.
3. Hitung jumlah materi yang ditandai selesai.
4. Hitung jumlah CV tersimpan.
5. Hitung jumlah portofolio.
6. Ambil timestamp terakhir aktivitas.
7. Mapping label readiness.

## 5. Auth dan Keamanan

- Gunakan RLS pada tabel user-specific di Supabase PostgreSQL.
- Backend Laravel hanya mengembalikan baris milik user yang divalidasi.
- Data anonim boleh menggunakan sesi anonim bila fitur tetap dapat diakses tanpa login.

## 6. Implementasi Backend

1. Definisikan response schema `HomeSummary`.
2. Buat controller dan route di Laravel.
3. Gunakan Eloquent/PostgreSQL client untuk query agregasi.
4. Sediakan fallback empty state bila data belum ada.
5. Uji agregasi lintas fitur.

## 7. Testing Backend

- Unit test perhitungan readiness percentage.
- Unit test jumlah materi selesai.
- Integration test endpoint summary.
- Widget test tetap memakai mock.

## 8. Acceptance Criteria

- [ ] Home summary hanya dari data backend.
- [ ] Belum ada data menampilkan empty state.
- [ ] Progres tidak hardcode.
- [ ] Auth user-scoped.

## 9. Risks dan Open Questions

- Apakah Home memakai satu tabel activity atau banyak tabel?
- Apakah readiness disimpan per user atau global?
