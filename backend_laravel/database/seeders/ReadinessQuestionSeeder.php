<?php

namespace Database\Seeders;

use App\Models\ReadinessQuestion;
use Illuminate\Database\Seeder;

class ReadinessQuestionSeeder extends Seeder
{
    public function run(): void
    {
        $questions = [
            ['documents', 'Dokumen Karier', 'Saya sudah memiliki CV yang memuat pendidikan, proyek, atau pengalaman.'],
            ['documents', 'Dokumen Karier', 'Saya memahami struktur CV yang baik.'],
            ['documents', 'Dokumen Karier', 'Saya memiliki portofolio atau contoh proyek yang dapat ditunjukkan.'],
            ['documents', 'Dokumen Karier', 'Saya memahami cara menampilkan pengalaman dan keterampilan di CV atau portofolio.'],
            ['digital', 'Keterampilan Digital', 'Saya mengenali perangkat atau aplikasi digital yang relevan dengan bidang minat saya.'],
            ['digital', 'Keterampilan Digital', 'Saya pernah mengerjakan proyek menggunakan perangkat digital.'],
            ['digital', 'Keterampilan Digital', 'Saya memahami pentingnya keterampilan digital untuk bidang yang saya minati.'],
            ['application', 'Persiapan Melamar', 'Saya memahami proses melamar magang atau pekerjaan.'],
            ['application', 'Persiapan Melamar', 'Saya mengetahui cara mencari peluang kerja.'],
            ['application', 'Persiapan Melamar', 'Saya memahami persiapan dasar wawancara.'],
            ['communication', 'Profesionalisme dan Komunikasi', 'Saya mampu menjelaskan kemampuan dan pengalaman saya.'],
            ['communication', 'Profesionalisme dan Komunikasi', 'Saya memahami komunikasi profesional melalui email atau platform digital.'],
            ['communication', 'Profesionalisme dan Komunikasi', 'Saya mengetahui cara menampilkan identitas profesional secara wajar.'],
            ['safety', 'Keamanan Pencarian Kerja', 'Saya mengetahui tanda-tanda lowongan yang mencurigakan.'],
            ['safety', 'Keamanan Pencarian Kerja', 'Saya memahami pentingnya menjaga data pribadi.'],
            ['safety', 'Keamanan Pencarian Kerja', 'Saya mengetahui cara memeriksa kredibilitas perusahaan atau perekrut.'],
        ];

        foreach ($questions as $index => [$categoryId, $categoryLabel, $text]) {
            ReadinessQuestion::updateOrCreate(
                ['sort_order' => $index + 1],
                [
                    'category_id' => $categoryId,
                    'category_label' => $categoryLabel,
                    'text' => $text,
                    'is_active' => true,
                ],
            );
        }
    }
}
