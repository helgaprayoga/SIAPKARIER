enum ReadinessStatus { langkahAwal, perluDikembangkan, sudahMulai }

extension ReadinessStatusX on ReadinessStatus {
  String get label => switch (this) {
        ReadinessStatus.langkahAwal => 'Langkah Awal',
        ReadinessStatus.perluDikembangkan => 'Perlu Dikembangkan',
        ReadinessStatus.sudahMulai => 'Sudah Mulai',
      };

  String get description => switch (this) {
        ReadinessStatus.langkahAwal =>
          'Kamu bisa memulai dari aktivitas dasar yang direkomendasikan.',
        ReadinessStatus.perluDikembangkan =>
          'Masih ada aspek yang perlu dipersiapkan sedikit demi sedikit.',
        ReadinessStatus.sudahMulai =>
          'Beberapa langkah persiapan sudah kamu mulai.',
      };

  static ReadinessStatus fromPercentage(double percentage) {
    if (percentage >= 67) return ReadinessStatus.sudahMulai;
    if (percentage >= 34) return ReadinessStatus.perluDikembangkan;
    return ReadinessStatus.langkahAwal;
  }
}

class ReadinessQuestion {
  const ReadinessQuestion({
    required this.id,
    required this.category,
    required this.text,
  });

  final String id;
  final String category;
  final String text;
}

class ReadinessCategoryResult {
  const ReadinessCategoryResult({
    required this.category,
    required this.points,
    required this.maxPoints,
  });

  final String category;
  final int points;
  final int maxPoints;

  double get percentage =>
      maxPoints == 0 ? 0 : (points / maxPoints) * 100;

  ReadinessStatus get status =>
      ReadinessStatusX.fromPercentage(percentage);
}

class ReadinessResult {
  const ReadinessResult({
    required this.answers,
    required this.totalPoints,
    required this.maxPoints,
    required this.categories,
    required this.createdAt,
  });

  final Map<String, int> answers;
  final int totalPoints;
  final int maxPoints;
  final List<ReadinessCategoryResult> categories;
  final DateTime createdAt;

  double get percentage => maxPoints == 0 ? 0 : (totalPoints / maxPoints) * 100;

  ReadinessStatus get status => ReadinessStatusX.fromPercentage(percentage);
}
