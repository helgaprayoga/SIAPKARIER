<?php

namespace Database\Seeders;

use App\Models\LearningMaterial;
use Illuminate\Database\Seeder;

class LearningMaterialSeeder extends Seeder
{
    public function run(): void
    {
        $materials = [
            ['ringkasan-profil', 'cv', 'CV dan Lamaran', 'Menulis Ringkasan Profil yang Kuat', 7, 'article'],
            ['cv-pertama', 'cv', 'CV dan Lamaran', 'Membuat CV Pertama dari Tugas Kuliah', 10, 'guide'],
            ['studi-kasus', 'portfolio', 'Portofolio', 'Mengubah Tugas Kuliah Menjadi Studi Kasus', 10, 'guide'],
            ['email-profesional', 'communication', 'Komunikasi Profesional', 'Email Profesional untuk Mahasiswa', 6, 'article'],
            ['star', 'interview', 'Wawancara', 'Menjelaskan Pengalaman dengan Metode STAR', 9, 'guide'],
            ['cek-lowongan', 'safety', 'Keamanan Digital', 'Memeriksa Lowongan Sebelum Melamar', 5, 'checklist'],
            ['alat-digital', 'digital', 'Keterampilan Digital', 'Mengenali Alat Digital Sesuai Bidang', 8, 'article'],
            ['magang', 'internship', 'Persiapan Magang dan Kerja', 'Memahami Deskripsi Posisi Magang', 7, 'guide'],
        ];

        foreach ($materials as $index => [$slug, $categoryId, $categoryLabel, $title, $duration, $contentType]) {
            LearningMaterial::updateOrCreate(
                ['slug' => $slug],
                [
                    'category_id' => $categoryId,
                    'category_label' => $categoryLabel,
                    'title' => $title,
                    'summary' => 'Materi praktis untuk membantu persiapan karier secara bertahap.',
                    'content' => "Tujuan materi\n\nPelajari langkah praktis yang dapat langsung dicoba.\n\nLangkah berikutnya\n\nCatat satu tindakan kecil setelah selesai membaca materi ini.",
                    'duration_minutes' => $duration,
                    'content_type' => $contentType,
                    'source_type' => 'internal',
                    'is_published' => true,
                    'sort_order' => $index + 1,
                ],
            );
        }
    }
}
