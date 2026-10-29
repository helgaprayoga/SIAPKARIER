import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/mock/mock_data.dart';
import '../data/models/readiness.dart';

class ReadinessState {
  const ReadinessState({
    required this.questions,
    this.answers = const {},
    this.currentIndex = 0,
    this.isReviewing = false,
    this.result,
  });

  final List<ReadinessQuestion> questions;
  final Map<String, int> answers;
  final int currentIndex;
  final bool isReviewing;
  final ReadinessResult? result;

  ReadinessQuestion get currentQuestion => questions[currentIndex];

  int get answeredCount => answers.length;

  bool get isComplete => answers.length == questions.length;

  ReadinessState copyWith({
    List<ReadinessQuestion>? questions,
    Map<String, int>? answers,
    int? currentIndex,
    bool? isReviewing,
    ReadinessResult? result,
    bool clearResult = false,
  }) {
    return ReadinessState(
      questions: questions ?? this.questions,
      answers: answers ?? this.answers,
      currentIndex: currentIndex ?? this.currentIndex,
      isReviewing: isReviewing ?? this.isReviewing,
      result: clearResult ? null : (result ?? this.result),
    );
  }
}

final readinessProvider =
    NotifierProvider<ReadinessController, ReadinessState>(
  ReadinessController.new,
);

class ReadinessController extends Notifier<ReadinessState> {
  @override
  ReadinessState build() {
    return const ReadinessState(questions: MockData.readinessQuestions);
  }

  void answer(String questionId, int value) {
    final next = Map<String, int>.from(state.answers)..[questionId] = value;
    state = state.copyWith(answers: next);
  }

  void next() {
    if (!state.answers.containsKey(state.currentQuestion.id)) return;
    if (state.currentIndex < state.questions.length - 1) {
      state = state.copyWith(currentIndex: state.currentIndex + 1);
    } else {
      state = state.copyWith(isReviewing: true);
    }
  }

  void previous() {
    if (state.isReviewing) {
      state = state.copyWith(isReviewing: false);
      return;
    }
    if (state.currentIndex > 0) {
      state = state.copyWith(currentIndex: state.currentIndex - 1);
    }
  }

  void goTo(int index) {
    if (index < 0 || index >= state.questions.length) return;
    state = state.copyWith(currentIndex: index, isReviewing: false);
  }

  void submit() {
    if (!state.isComplete) return;
    final result = _calculateResult();
    state = state.copyWith(result: result, isReviewing: false);
  }

  void reset() {
    state = ReadinessState(questions: state.questions);
  }

  ReadinessResult _calculateResult() {
    final categories = <String, List<ReadinessQuestion>>{};
    for (final question in state.questions) {
      categories.putIfAbsent(question.category, () => []).add(question);
    }

    final categoryResults = <ReadinessCategoryResult>[];
    var totalPoints = 0;
    var maxPoints = 0;

    for (final entry in categories.entries) {
      var points = 0;
      for (final question in entry.value) {
        final answer = state.answers[question.id] ?? 2;
        points += 2 - answer;
      }
      final categoryMax = entry.value.length * 2;
      totalPoints += points;
      maxPoints += categoryMax;
      categoryResults.add(
        ReadinessCategoryResult(
          category: entry.key,
          points: points,
          maxPoints: categoryMax,
        ),
      );
    }

    return ReadinessResult(
      answers: Map<String, int>.from(state.answers),
      totalPoints: totalPoints,
      maxPoints: maxPoints,
      categories: categoryResults,
      createdAt: DateTime.now(),
    );
  }
}
