<?php

namespace Database\Seeders;

use App\Models\SafeChecklistItem;
use App\Models\SafeTopic;
use Illuminate\Database\Seeder;

class SafeContentSeeder extends Seeder
{
    public function run(): void
    {
        $topics = [
            ['Memeriksa Identitas Perusahaan', 'Cari kanal resmi dan informasi perusahaan.', 'Periksa situs resmi, alamat email, dan konsistensi informasi sebelum merespons lowongan.'],
            ['Menghindari Permintaan Pembayaran', 'Waspadai biaya rekrutmen di awal.', 'Perusahaan kredibel tidak meminta biaya untuk proses rekrutmen.'],
            ['Menjaga Data Pribadi', 'Jangan membagikan data sensitif.', 'Jangan mengirim password, OTP, PIN, atau data perbankan dalam proses rekrutmen.'],
            ['Memeriksa Tautan dan Berkas', 'Pastikan sumber tautan dapat dipercaya.', 'Hindari membuka lampiran atau tautan dari sumber yang tidak dikenal.'],
        ];

        foreach ($topics as $index => [$title, $summary, $content]) {
            SafeTopic::updateOrCreate(
                ['title' => $title],
                [
                    'summary' => $summary,
                    'content' => $content,
                    'sort_order' => $index + 1,
                    'source_checked_at' => now(),
                ],
            );
        }

        $items = [
            ['Identitas dan situs resmi perusahaan dapat ditemukan.', 'Cari situs dan kanal resmi perusahaan.'],
            ['Deskripsi peran, lokasi, dan durasi cukup jelas.', 'Pastikan informasi posisi tidak samar.'],
            ['Alamat email perekrut sesuai kanal resmi.', 'Periksa domain email perekrut.'],
            ['Tidak ada permintaan pembayaran apa pun.', 'Jangan membayar biaya rekrutmen.'],
            ['Tidak diminta kata sandi, OTP, atau data perbankan.', 'Lindungi data autentikasi dan finansial.'],
            ['Tautan dan berkas berasal dari sumber yang dikenal.', 'Jangan membuka sumber yang mencurigakan.'],
            ['Ada waktu yang wajar untuk mempertimbangkan.', 'Waspadai tekanan untuk segera setuju.'],
        ];

        foreach ($items as $index => [$text, $helpText]) {
            SafeChecklistItem::updateOrCreate(
                ['version' => 1, 'sort_order' => $index + 1],
                ['text' => $text, 'help_text' => $helpText],
            );
        }
    }
}
