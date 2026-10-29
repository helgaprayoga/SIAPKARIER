import '../models/learning_material.dart';
import '../models/readiness.dart';
import '../models/safe_checklist.dart';
import '../models/user_profile.dart';

class MockData {
  MockData._();

  static const user = UserProfile(
    id: 'demo-user',
    fullName: 'Raka Aditya',
    studyProgram: 'Sistem Informasi',
    semester: 5,
    careerInterest: 'Produk Digital',
    email: 'raka.aditya@email.com',
  );

  static const readinessQuestions = <ReadinessQuestion>[
    ReadinessQuestion(
      id: 'q1',
      category: 'Dokumen Karier',
      text:
          'Saya sudah memiliki CV yang memuat pendidikan, proyek, atau pengalaman.',
    ),
    ReadinessQuestion(
      id: 'q2',
      category: 'Dokumen Karier',
      text: 'Saya memahami struktur CV yang baik.',
    ),
    ReadinessQuestion(
      id: 'q3',
      category: 'Dokumen Karier',
      text: 'Saya memiliki portofolio atau contoh proyek yang dapat ditunjukkan.',
    ),
    ReadinessQuestion(
      id: 'q4',
      category: 'Dokumen Karier',
      text:
          'Saya memahami cara menampilkan pengalaman dan keterampilan di CV atau portofolio.',
    ),
    ReadinessQuestion(
      id: 'q5',
      category: 'Keterampilan Digital',
      text:
          'Saya mengenali perangkat atau aplikasi digital yang relevan dengan bidang minat saya.',
    ),
    ReadinessQuestion(
      id: 'q6',
      category: 'Keterampilan Digital',
      text: 'Saya pernah mengerjakan proyek menggunakan perangkat digital.',
    ),
    ReadinessQuestion(
      id: 'q7',
      category: 'Keterampilan Digital',
      text:
          'Saya memahami pentingnya keterampilan digital untuk bidang yang saya minati.',
    ),
    ReadinessQuestion(
      id: 'q8',
      category: 'Persiapan Melamar',
      text: 'Saya memahami proses melamar magang atau pekerjaan.',
    ),
    ReadinessQuestion(
      id: 'q9',
      category: 'Persiapan Melamar',
      text: 'Saya mengetahui cara mencari peluang kerja.',
    ),
    ReadinessQuestion(
      id: 'q10',
      category: 'Persiapan Melamar',
      text: 'Saya memahami persiapan dasar wawancara.',
    ),
    ReadinessQuestion(
      id: 'q11',
      category: 'Profesionalisme dan Komunikasi',
      text: 'Saya mampu menjelaskan kemampuan dan pengalaman saya.',
    ),
    ReadinessQuestion(
      id: 'q12',
      category: 'Profesionalisme dan Komunikasi',
      text:
          'Saya memahami komunikasi profesional melalui email atau platform digital.',
    ),
    ReadinessQuestion(
      id: 'q13',
      category: 'Profesionalisme dan Komunikasi',
      text:
          'Saya mengetahui cara menampilkan identitas profesional secara wajar.',
    ),
    ReadinessQuestion(
      id: 'q14',
      category: 'Keamanan Pencarian Kerja',
      text: 'Saya mengetahui tanda-tanda lowongan yang mencurigakan.',
    ),
    ReadinessQuestion(
      id: 'q15',
      category: 'Keamanan Pencarian Kerja',
      text: 'Saya memahami pentingnya menjaga data pribadi.',
    ),
    ReadinessQuestion(
      id: 'q16',
      category: 'Keamanan Pencarian Kerja',
      text: 'Saya mengetahui cara memeriksa kredibilitas perusahaan atau perekrut.',
    ),
  ];

  static const answerLabels = <String>[
    'Sudah saya lakukan',
    'Sedang saya pelajari',
    'Belum pernah mencoba',
  ];

  static const learningMaterials = <LearningMaterial>[
    LearningMaterial(
      id: 'm1',
      slug: 'ringkasan-profil',
      category: 'CV dan Lamaran',
      title: 'Menulis ringkasan profil yang kuat',
      summary:
          'Ringkasan profil adalah 2-3 kalimat di bagian atas CV yang membantu perekrut memahami fokus dan nilai yang kamu tawarkan.',
      content:
          'Mulai dengan tiga elemen: siapa kamu saat ini, fokus dan kekuatanmu, serta arah yang kamu cari. Gunakan informasi yang benar dan hindari menambahkan keterampilan yang belum kamu miliki.',
      durationMinutes: 7,
      contentType: LearningContentType.article,
      takeaways: [
        'Sebutkan status studi atau bidang yang sedang ditekuni.',
        'Pilih kemampuan yang relevan dan bisa didukung dengan bukti.',
        'Jelaskan tipe kesempatan atau bidang yang ingin dipelajari.',
      ],
    ),
    LearningMaterial(
      id: 'm2',
      slug: 'cv-pertama',
      category: 'CV dan Lamaran',
      title: 'Membuat CV pertama dari tugas kuliah',
      summary:
          'Tugas kuliah, organisasi, dan proyek pribadi dapat menjadi bukti kemampuan saat belum ada pengalaman kerja.',
      content:
          'Pilih tugas yang paling relevan dengan bidang yang diminati. Jelaskan konteks, peranmu, proses, dan hasil yang kamu capai.',
      durationMinutes: 10,
      contentType: LearningContentType.guide,
      takeaways: [
        'Pilih proyek yang relevan dengan posisi yang dituju.',
        'Tuliskan kontribusi spesifik, bukan hanya nama proyek.',
        'Sertakan hasil atau pelajaran yang didapat.',
      ],
    ),
    LearningMaterial(
      id: 'm3',
      slug: 'studi-kasus',
      category: 'Portofolio',
      title: 'Ubah tugas kuliah menjadi studi kasus',
      summary:
          'Dokumentasikan masalah, peran, proses, dan hasil proyek agar pembaca memahami cara kamu berpikir.',
      content:
          'Gunakan struktur empat bagian: masalah yang diselesaikan, peranmu, proses pengerjaan, dan hasil atau pelajaran.',
      durationMinutes: 10,
      contentType: LearningContentType.guide,
      takeaways: [
        'Mulai dari masalah yang jelas.',
        'Tunjukkan kontribusi individual pada proyek kelompok.',
        'Akhiri dengan hasil dan refleksi.',
      ],
    ),
    LearningMaterial(
      id: 'm4',
      slug: 'email-profesional',
      category: 'Komunikasi Profesional',
      title: 'Email profesional untuk mahasiswa',
      summary:
          'Email yang jelas dan sopan membantu memperkenalkan diri dan menyampaikan kebutuhan dengan tepat.',
      content:
          'Gunakan subjek yang spesifik, sapaan yang sopan, isi yang ringkas, dan penutup yang jelas. Periksa ejaan sebelum mengirim.',
      durationMinutes: 6,
      contentType: LearningContentType.article,
      takeaways: [
        'Tulis subjek yang menjelaskan tujuan email.',
        'Sampaikan konteks dan permintaan secara ringkas.',
        'Akhiri dengan nama lengkap dan kontak yang jelas.',
      ],
    ),
    LearningMaterial(
      id: 'm5',
      slug: 'star',
      category: 'Wawancara',
      title: 'Ceritakan pengalaman dengan metode STAR',
      summary:
          'Metode STAR membantu menjawab pertanyaan wawancara dengan cerita yang terstruktur.',
      content:
          'STAR berarti Situation, Task, Action, dan Result. Jelaskan konteks, tanggung jawab, tindakan yang kamu lakukan, dan hasilnya.',
      durationMinutes: 9,
      contentType: LearningContentType.guide,
      takeaways: [
        'Pilih contoh pengalaman yang relevan.',
        'Fokus pada tindakan yang benar-benar kamu lakukan.',
        'Tutup dengan hasil yang terukur bila memungkinkan.',
      ],
    ),
    LearningMaterial(
      id: 'm6',
      slug: 'cek-lowongan',
      category: 'Keamanan Digital',
      title: 'Memeriksa lowongan sebelum melamar',
      summary:
          'Gunakan checklist sederhana untuk memeriksa kredibilitas lowongan sebelum mengirim data.',
      content:
          'Periksa identitas perusahaan, kanal resmi, konsistensi informasi, dan permintaan data. Jangan pernah membagikan OTP, kata sandi, atau data perbankan.',
      durationMinutes: 5,
      contentType: LearningContentType.checklist,
      takeaways: [
        'Cari situs resmi dan kanal komunikasi perusahaan.',
        'Waspadai permintaan pembayaran di awal.',
        'Minta waktu untuk memeriksa sebelum mengambil keputusan.',
      ],
    ),
    LearningMaterial(
      id: 'm7',
      slug: 'alat-digital',
      category: 'Keterampilan Digital',
      title: 'Mengenali alat digital sesuai bidang',
      summary:
          'Setiap bidang memiliki alat dan keterampilan digital yang berbeda. Mulailah dari yang paling relevan.',
      content:
          'Telusuri deskripsi posisi yang diminati, catat alat yang sering muncul, lalu pilih satu atau dua alat untuk dipelajari lebih dalam.',
      durationMinutes: 8,
      contentType: LearningContentType.article,
      takeaways: [
        'Baca beberapa deskripsi posisi yang serupa.',
        'Pilih alat yang paling sering diminta.',
        'Latih alat tersebut melalui proyek kecil.',
      ],
    ),
    LearningMaterial(
      id: 'm8',
      slug: 'magang',
      category: 'Persiapan Magang dan Kerja',
      title: 'Memahami deskripsi posisi magang',
      summary:
          'Deskripsi posisi membantu memahami tugas, persyaratan, dan hal yang perlu disiapkan.',
      content:
          'Bedakan antara persyaratan wajib dan nilai tambah. Catat tugas utama dan keterampilan yang perlu ditunjukkan dalam CV.',
      durationMinutes: 7,
      contentType: LearningContentType.guide,
      takeaways: [
        'Tandai persyaratan wajib.',
        'Cocokkan pengalaman dengan tugas utama.',
        'Siapkan bukti untuk keterampilan yang disebutkan.',
      ],
    ),
  ];

  static const safeChecklist = <SafeChecklistItem>[
    SafeChecklistItem(
      id: 's1',
      text: 'Identitas dan situs resmi perusahaan dapat ditemukan',
      helpText: 'Cari nama perusahaan di situs resmi dan kanal komunikasi resminya.',
    ),
    SafeChecklistItem(
      id: 's2',
      text: 'Deskripsi peran, lokasi, dan durasi cukup jelas',
      helpText: 'Lowongan yang kredibel biasanya menjelaskan tugas dan durasi.',
    ),
    SafeChecklistItem(
      id: 's3',
      text: 'Alamat email perekrut sesuai kanal resmi',
      helpText: 'Periksa domain email, bukan hanya nama pengirim.',
    ),
    SafeChecklistItem(
      id: 's4',
      text: 'Tidak ada permintaan pembayaran apa pun',
      helpText: 'Perusahaan kredibel tidak meminta biaya rekrutmen.',
    ),
    SafeChecklistItem(
      id: 's5',
      text: 'Tidak diminta kata sandi, OTP, atau data perbankan',
      helpText: 'Jangan pernah membagikan kode rahasia atau data keuangan.',
    ),
    SafeChecklistItem(
      id: 's6',
      text: 'Tautan dan berkas berasal dari sumber yang dikenal',
      helpText: 'Hindari membuka lampiran dari pengirim yang tidak dikenal.',
    ),
    SafeChecklistItem(
      id: 's7',
      text: 'Ada waktu yang wajar untuk mempertimbangkan',
      helpText: 'Tekanan untuk segera setuju adalah tanda yang perlu diwaspadai.',
    ),
  ];

  static const safeWarnings = <SafeWarning>[
    SafeWarning(
      title: 'Diminta membayar di awal',
      description: 'Perusahaan kredibel tidak meminta biaya rekrutmen.',
      iconKey: 'alert',
    ),
    SafeWarning(
      title: 'Email tidak terlihat resmi',
      description: 'Periksa domain dan kanal resmi perusahaan.',
      iconKey: 'mail',
    ),
    SafeWarning(
      title: 'Ditekan untuk segera setuju',
      description: 'Waspadai desakan tanpa waktu untuk memeriksa.',
      iconKey: 'clock',
    ),
    SafeWarning(
      title: 'Diminta data yang terlalu sensitif',
      description: 'Jangan bagikan OTP, kata sandi, atau data perbankan.',
      iconKey: 'lock',
    ),
  ];
}
