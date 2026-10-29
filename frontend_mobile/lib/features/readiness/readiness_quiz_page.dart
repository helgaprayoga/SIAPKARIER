import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_page_header.dart';
import '../../core/widgets/app_progress.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../core/widgets/app_tag.dart';
import '../../core/widgets/sticky_action_bar.dart';
import '../../data/mock/mock_data.dart';
import '../../providers/readiness_controller.dart';

class ReadinessQuizPage extends ConsumerWidget {
  const ReadinessQuizPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(readinessProvider);
    final controller = ref.read(readinessProvider.notifier);

    if (state.isReviewing) {
      return _ReviewView(
        state: state,
        onBack: () => controller.previous(),
        onEdit: controller.goTo,
        onSubmit: () {
          controller.submit();
          context.pushReplacement('/readiness/result');
        },
      );
    }

    final question = state.currentQuestion;
    final selected = state.answers[question.id];
    final isLast = state.currentIndex == state.questions.length - 1;

    return AppScaffold(
      bottomNavigationBar: StickyActionBar(
        primaryLabel: isLast ? 'Periksa jawaban' : 'Lanjut',
        primaryIcon: isLast ? LucideIcons.check : LucideIcons.arrowRight,
        primaryEnabled: selected != null,
        onPrimary: controller.next,
        note: selected == null
            ? 'Pilih satu jawaban untuk melanjutkan.'
            : null,
      ),
      children: [
        AppPageHeader(
          eyebrow: 'Pertanyaan ${state.currentIndex + 1} dari ${state.questions.length}',
          title: 'Readiness Check',
          eyebrowAboveTitle: true,
          onBack: () {
            if (state.currentIndex == 0) {
              context.pop();
            } else {
              controller.previous();
            }
          },
          action: AppTag(
            label: '${((state.currentIndex + 1) / state.questions.length * 100).round()}%',
            tone: AppTagTone.neutral,
          ),
        ),
        AppProgress(
          value: (state.currentIndex + 1) / state.questions.length * 100,
          color: AppColors.teal,
          semanticLabel: 'Progres pertanyaan',
        ),
        const SizedBox(height: AppSpacing.xxl),
        AppTag(label: question.category, tone: AppTagTone.teal),
        const SizedBox(height: 14),
        Text(
          question.text,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontSize: 24,
                height: 1.35,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          'Pilih jawaban yang paling menggambarkan kondisimu saat ini.',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: AppSpacing.xl),
        ...List.generate(MockData.answerLabels.length, (index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _AnswerOption(
              label: MockData.answerLabels[index],
              description: switch (index) {
                0 => 'Aku sudah melakukannya dengan cukup percaya diri.',
                1 => 'Aku sedang mempelajari atau mulai mencobanya.',
                _ => 'Aku belum pernah mencoba atau belum tahu caranya.',
              },
              selected: selected == index,
              onTap: () => controller.answer(question.id, index),
            ),
          );
        }),
        const SizedBox(height: AppSpacing.sm),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.goldSoft,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                LucideIcons.info,
                size: 17,
                color: Color(0xFF916C22),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  'Jawaban ini bukan penilaian akhir. Gunakan hasilnya untuk '
                  'menentukan langkah belajar berikutnya.',
                  style: TextStyle(
                    fontFamily: 'DM Sans',
                    fontSize: 11,
                    height: 1.5,
                    color: const Color(0xFF916C22),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AnswerOption extends StatelessWidget {
  const _AnswerOption({
    required this.label,
    required this.description,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String description;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: Material(
        color: selected ? AppColors.tealSoft : AppColors.surface,
        borderRadius: BorderRadius.circular(15),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(15),
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: selected ? AppColors.teal : AppColors.line,
                width: selected ? 1.6 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 23,
                  height: 23,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: selected ? AppColors.teal : Colors.transparent,
                    border: Border.all(
                      color: selected ? AppColors.teal : AppColors.line,
                      width: 1.5,
                    ),
                  ),
                  child: selected
                      ? const Icon(
                          LucideIcons.check,
                          color: Colors.white,
                          size: 14,
                        )
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: TextStyle(
                          fontFamily: 'DM Sans',
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: selected ? AppColors.tealDark : AppColors.ink,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        description,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ReviewView extends StatelessWidget {
  const _ReviewView({
    required this.state,
    required this.onBack,
    required this.onEdit,
    required this.onSubmit,
  });

  final ReadinessState state;
  final VoidCallback onBack;
  final ValueChanged<int> onEdit;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      bottomNavigationBar: StickyActionBar(
        primaryLabel: 'Lihat hasil',
        primaryIcon: LucideIcons.sparkles,
        primaryEnabled: state.isComplete,
        onPrimary: onSubmit,
        note: state.isComplete
            ? 'Semua pertanyaan sudah dijawab.'
            : 'Masih ada pertanyaan yang belum dijawab.',
      ),
      children: [
        AppPageHeader(
          eyebrow: 'Periksa jawaban',
          title: 'Satu Langkah Lagi',
          eyebrowAboveTitle: true,
          onBack: onBack,
        ),
        Text(
          'Kamu bisa mengubah jawaban sebelum melihat hasil. '
          'Tekan pertanyaan untuk mengeditnya.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: AppSpacing.xl),
        ...List.generate(state.questions.length, (index) {
          final question = state.questions[index];
          final answer = state.answers[question.id];
          return Padding(
            padding: const EdgeInsets.only(bottom: 9),
            child: AppCard(
              onTap: () => onEdit(index),
              padding: const EdgeInsets.all(13),
              semanticLabel: 'Edit jawaban ${index + 1}',
              child: Row(
                children: [
                  Container(
                    width: 26,
                    height: 26,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: answer == null
                          ? AppColors.background
                          : AppColors.tealSoft,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        fontFamily: 'DM Sans',
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: answer == null
                            ? AppColors.muted
                            : AppColors.tealDark,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          question.text,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: 'DM Sans',
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.ink,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          answer == null
                              ? 'Belum dijawab'
                              : MockData.answerLabels[answer],
                          style: TextStyle(
                            fontFamily: 'DM Sans',
                            fontSize: 10,
                            color: answer == null
                                ? AppColors.danger
                                : AppColors.teal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const AppChevron(),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}

