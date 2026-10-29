class ActivitySummary {
  const ActivitySummary({
    this.readinessPercentage,
    this.completedMaterials = 0,
    this.savedCvs = 0,
    this.portfolioProjects = 0,
    this.lastUpdatedAt,
  });

  final double? readinessPercentage;
  final int completedMaterials;
  final int savedCvs;
  final int portfolioProjects;
  final DateTime? lastUpdatedAt;

  double get overallProgress {
    final readiness = readinessPercentage ?? 0;
    final materialScore = (completedMaterials.clamp(0, 4) / 4) * 100;
    final cvScore = (savedCvs.clamp(0, 1)) * 100;
    final portfolioScore = (portfolioProjects.clamp(0, 1)) * 100;
    return ((readiness * 0.4) +
            (materialScore * 0.2) +
            (cvScore * 0.2) +
            (portfolioScore * 0.2))
        .clamp(0, 100);
  }
}
