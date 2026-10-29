import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_page_header.dart';
import '../../core/widgets/app_progress.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../core/widgets/app_tag.dart';
import '../../core/widgets/sticky_action_bar.dart';
import '../../providers/safe_controller.dart';

class SafeChecklistPage extends ConsumerWidget {
  const SafeChecklistPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(safeProvider);
    final controller = ref.read(safeProvider.notifier);

    return AppScaffold(
      bottomNavigationBar: StickyActionBar(
        primaryLabel: 'Selesai memeriksa',
        primaryIcon: LucideIcons.check,
        primaryEnabled: state.isComplete,
        onPrimary: () => context.pop(),
        secondaryLabel: 'Reset',
        secondaryIcon: LucideIcons.rotateCcw,
        onSecondary: controller.reset,
        note: state.isComplete
            ? 'Checklist lengkap. Kamu bisa melanjutkan dengan lebih tenang.'
            : 'Centang poin yang sudah kamu periksa.',
      ),
      children: [
        AppPageHeader(
          title: 'Safe Job Search',
          onBack: () => context.pop(),
          action: AppTag(
            label: '${state.checkedCount}/${state.items.length}',
            tone: state.isComplete ? AppTagTone.teal : AppTagTone.neutral,
          ),
        ),
        AppProgress(
          value: state.progress * 100,
          color: AppColors.teal,
          semanticLabel: 'Progres checklist lowongan',
        ),
        const SizedBox(height: 8),
        Text(
          'Periksa poin berikut sebelum membagikan data atau melanjutkan proses.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: AppSpacing.xl),
        ...state.items.map(
          (item) {
            final checked = state.checkedIds.contains(item.id);
            return Padding(
              padding: const EdgeInsets.only(bottom: 9),
              child: AppCard(
                onTap: () => controller.toggle(item.id),
                padding: const EdgeInsets.all(14),
                borderColor: checked ? AppColors.teal : AppColors.line,
                semanticLabel: item.text,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: checked ? AppColors.teal : Colors.transparent,
                        borderRadius: BorderRadius.circular(7),
                        border: Border.all(
                          color: checked ? AppColors.teal : AppColors.line,
                          width: 1.5,
                        ),
                      ),
                      child: checked
                          ? const Icon(
                              LucideIcons.check,
                              size: 15,
                              color: Colors.white,
                            )
                          : null,
                    ),
                    const SizedBox(width: 11),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.text,
                            style: TextStyle(
                              fontFamily: 'DM Sans',
                              fontSize: 12,
                              height: 1.45,
                              fontWeight: FontWeight.w700,
                              color: checked
                                  ? AppColors.tealDark
                                  : AppColors.ink,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            item.helpText,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(height: AppSpacing.md),
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
                size: 18,
                color: Color(0xFF916C22),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  'Checklist ini membantu, tetapi tidak menjamin lowongan '
                  'sepenuhnya aman. Percayai instingmu.',
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

