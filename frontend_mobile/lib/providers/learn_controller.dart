import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/mock/mock_data.dart';
import '../data/models/learning_material.dart';

class LearnState {
  const LearnState({
    this.materials = MockData.learningMaterials,
    this.query = '',
    this.category,
    this.completedIds = const {},
  });

  final List<LearningMaterial> materials;
  final String query;
  final String? category;
  final Set<String> completedIds;

  List<String> get categories {
    final values = materials.map((item) => item.category).toSet().toList();
    values.sort();
    return values;
  }

  List<LearningMaterial> get filtered {
    final normalized = query.trim().toLowerCase();
    return materials.where((item) {
      final matchesCategory = category == null || item.category == category;
      final matchesQuery = normalized.isEmpty ||
          item.title.toLowerCase().contains(normalized) ||
          item.summary.toLowerCase().contains(normalized) ||
          item.category.toLowerCase().contains(normalized);
      return matchesCategory && matchesQuery;
    }).toList();
  }

  bool isCompleted(String id) => completedIds.contains(id);

  LearnState copyWith({
    String? query,
    String? category,
    bool clearCategory = false,
    Set<String>? completedIds,
  }) {
    return LearnState(
      materials: materials,
      query: query ?? this.query,
      category: clearCategory ? null : (category ?? this.category),
      completedIds: completedIds ?? this.completedIds,
    );
  }
}

final learnProvider = NotifierProvider<LearnController, LearnState>(
  LearnController.new,
);

class LearnController extends Notifier<LearnState> {
  @override
  LearnState build() => const LearnState();

  void setQuery(String value) {
    state = state.copyWith(query: value);
  }

  void setCategory(String? value) {
    state = value == null
        ? state.copyWith(clearCategory: true)
        : state.copyWith(category: value);
  }

  void toggleCompleted(String id) {
    final next = Set<String>.from(state.completedIds);
    if (!next.add(id)) next.remove(id);
    state = state.copyWith(completedIds: next);
  }

  void reset() {
    state = const LearnState();
  }
}

