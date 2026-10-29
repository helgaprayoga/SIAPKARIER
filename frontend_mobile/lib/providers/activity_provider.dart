import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/activity_summary.dart';
import 'cv_controller.dart';
import 'learn_controller.dart';
import 'portfolio_controller.dart';
import 'readiness_controller.dart';

final activitySummaryProvider = Provider<ActivitySummary>((ref) {
  final readiness = ref.watch(readinessProvider).result;
  final cv = ref.watch(cvProvider);
  final portfolio = ref.watch(portfolioProvider);
  final learn = ref.watch(learnProvider);

  return ActivitySummary(
    readinessPercentage: readiness?.percentage,
    completedMaterials: learn.completedIds.length,
    savedCvs: cv.cvs.length,
    portfolioProjects: portfolio.projects.length,
    lastUpdatedAt: DateTime.now(),
  );
});
