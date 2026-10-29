import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/mock/mock_data.dart';
import '../data/models/safe_checklist.dart';

class SafeState {
  const SafeState({
    this.items = MockData.safeChecklist,
    this.checkedIds = const {},
  });

  final List<SafeChecklistItem> items;
  final Set<String> checkedIds;

  int get checkedCount => checkedIds.length;

  double get progress =>
      items.isEmpty ? 0 : checkedCount / items.length;

  bool get isComplete => checkedCount == items.length;

  SafeState copyWith({Set<String>? checkedIds}) {
    return SafeState(
      items: items,
      checkedIds: checkedIds ?? this.checkedIds,
    );
  }
}

final safeProvider = NotifierProvider<SafeController, SafeState>(
  SafeController.new,
);

class SafeController extends Notifier<SafeState> {
  @override
  SafeState build() => const SafeState();

  void toggle(String id) {
    final next = Set<String>.from(state.checkedIds);
    if (!next.add(id)) next.remove(id);
    state = state.copyWith(checkedIds: next);
  }

  void reset() {
    state = const SafeState();
  }
}
