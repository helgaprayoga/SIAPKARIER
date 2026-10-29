enum LearningContentType { article, checklist, guide, video, reflection, sample, link }

extension LearningContentTypeX on LearningContentType {
  String get label => switch (this) {
        LearningContentType.article => 'Artikel',
        LearningContentType.checklist => 'Checklist',
        LearningContentType.guide => 'Panduan',
        LearningContentType.video => 'Video',
        LearningContentType.reflection => 'Refleksi',
        LearningContentType.sample => 'Contoh',
        LearningContentType.link => 'Tautan',
      };
}

enum LearningSourceType { internal, external }

extension LearningSourceTypeX on LearningSourceType {
  String get label => switch (this) {
        LearningSourceType.internal => 'Materi internal',
        LearningSourceType.external => 'Tautan eksternal',
      };
}

class LearningMaterial {
  const LearningMaterial({
    required this.id,
    required this.slug,
    required this.category,
    required this.title,
    required this.summary,
    required this.content,
    required this.durationMinutes,
    required this.contentType,
    this.sourceType = LearningSourceType.internal,
    this.sourceName,
    this.externalUrl,
    this.sourceCheckedAt,
    this.takeaways = const [],
  });

  final String id;
  final String slug;
  final String category;
  final String title;
  final String summary;
  final String content;
  final int durationMinutes;
  final LearningContentType contentType;
  final LearningSourceType sourceType;
  final String? sourceName;
  final String? externalUrl;
  final DateTime? sourceCheckedAt;
  final List<String> takeaways;
}
