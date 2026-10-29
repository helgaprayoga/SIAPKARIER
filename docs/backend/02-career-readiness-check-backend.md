# Backend Implementation Plan — Career Readiness Check

## Metadata

| Field | Value |
|---|---|
| Feature ID | FT-02 |
| Backend Scope | Question bank, assessment, answer storage, result calculation |
| PRD Reference | §9.2, §12.1 |
| Priority | Must Have |
| Platform | Laravel backend + Supabase database + Flutter mobile |
| Status | Plan |
| Depends On | 00 Shared Foundation, 07 Profile |

## 1. Ringkasan Backend

Backend Laravel menyediakan penyimpanan assessment readiness dan perhitungan hasil. Fitur ini tidak boleh mengklaim assessment sebagai sertifikasi atau pengukuran kompetensi objektif.

## 2. Endpoint API

| Method | Endpoint | Deskripsi | Auth |
|---|---|---|---|
| GET | `/api/v1/readiness/questions` | Mendapatkan bank pertanyaan | Public |
| POST | `/api/v1/readiness/assessments` | Menyimpan hasil assessment | Optional |
| GET | `/api/v1/readiness/assessments/{id}` | Mendapatkan detail assessment | Owner |
| GET | `/api/v1/readiness/assessments/latest` | Mendapatkan hasil terbaru | Owner |

## 3. Skema Data

- `readiness_questions`
- `readiness_assessments`
- `readiness_answers`

## 4. Logika Bisnis

1. Validasi semua pertanyaan wajib dijawab.
2. Hitung poin per kategori.
3. Hitung persentase keseluruhan.
4. Simpan assessment dan jawaban.
5. Generate rekomendasi berdasarkan kategori rendah.
6. Kembalikan disclaimer bahwa hasil bukan sertifikasi.

## 5. Auth dan Keamanan

- Pertanyaan bisa public.
- Assessment user-scoped.
- Laravel menggunakan Sanctum/API token untuk validasi user, dengan RLS aktif di Supabase.
- Tidak menyimpan data sensitif yang tidak perlu.

## 6. Implementasi Backend

1. Buat seed bank pertanyaan melalui Laravel/Eloquent.
2. Buat route dan controller create/get di Laravel.
3. Terapkan validasi jawaban di Laravel.
4. Terapkan rumus skor transparan.
5. Sediakan rekomendasi awal.

## 7. Testing Backend

- Unit test validasi jawaban.
- Unit test perhitungan skor.
- Unit test mapping rekomendasi.
- Integration test create assessment.

## 8. Acceptance Criteria

- [ ] Assessment wajib memiliki semua jawaban.
- [ ] Skor dihitung sesuai rumus.
- [ ] Hasil tidak diklaim sebagai sertifikasi.
- [ ] User hanya mengakses assessment sendiri.

## 9. Risks dan Open Questions

- Apakah pertanyaan awal harus 5 atau 16?
- Apakah assessment disimpan sebagai riwayat atau hasil terbaru?
