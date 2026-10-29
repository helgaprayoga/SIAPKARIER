import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/utils/title_case.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_empty_state.dart';
import '../../core/widgets/app_page_header.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../core/widgets/app_tag.dart';
import '../../core/widgets/sticky_action_bar.dart';
import '../../data/models/learning_material.dart';
import '../../providers/learn_controller.dart';

class LearnDetailPage extends ConsumerWidget {
  const LearnDetailPage({super.key, required this.slug});

  final String slug;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(learnProvider);
    final material = state.materials
        .where((item) => item.slug == slug)
        .firstOrNull;

    if (material == null) {
      return AppScaffold(
        children: [
          AppPageHeader(
            title: 'Learning Corner',
            onBack: () => context.pop(),
          ),
          AppEmptyState(
            icon: LucideIcons.bookOpen,
            title: 'Materi Tidak Tersedia',
            message: 'Materi mungkin sudah dipindahkan atau dihapus.',
            actionLabel: 'Kembali',
            onAction: () => context.pop(),
          ),
        ],
      );
    }

    final completed = state.isCompleted(material.id);

    return AppScaffold(
      bottomNavigationBar: StickyActionBar(
        primaryLabel: completed ? 'Tandai belum selesai' : 'Tandai selesai',
        primaryIcon: completed ? LucideIcons.rotateCcw : LucideIcons.check,
        onPrimary: () {
          ref.read(learnProvider.notifier).toggleCompleted(material.id);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                completed
                    ? 'Materi ditandai belum selesai.'
                    : 'Materi selesai. Progres belajarmu bertambah.',
              ),
            ),
          );
        },
        note: 'Progres belajar disimpan di perangkatmu.',
      ),
      children: [
        AppPageHeader(
          title: material.category,
          onBack: () => context.pop(),
        ),
        Text(
          toTitleCase(material.title),
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontSize: 24,
                height: 1.2,
              ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            AppTag(label: material.contentType.label),
            AppTag(
              label: '${material.durationMinutes} menit',
              tone: AppTagTone.neutral,
            ),
            if (completed)
              const AppTag(label: 'Selesai', tone: AppTagTone.gold),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),
        Text(
          material.summary,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: AppSpacing.lg),
        ...material.content.split('\n').where((line) => line.trim().isNotEmpty).map(
              (paragraph) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  paragraph.trim(),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        height: 1.65,
                      ),
                ),
              ),
            ),
        if (material.takeaways.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.sm),
          AppCard(
            color: AppColors.tealSoft,
            borderColor: AppColors.tealSoft,
            showShadow: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      LucideIcons.listChecks,
                      size: 19,
                      color: AppColors.tealDark,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Yang bisa kamu coba',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppColors.tealDark,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ...material.takeaways.map(
                  (takeaway) => Padding(
                    padding: const EdgeInsets.only(bottom: 7),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 3),
                          child: Icon(
                            LucideIcons.check,
                            size: 13,
                            color: AppColors.teal,
                          ),
                        ),
                        const SizedBox(width: 7),
                        Expanded(
                          child: Text(
                            takeaway,
                            style: const TextStyle(
                              fontFamily: 'DM Sans',
                              fontSize: 11,
                              height: 1.5,
                              color: AppColors.tealDark,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        if (material.sourceType == LearningSourceType.external) ...[
          const SizedBox(height: 12),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sumber eksternal',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 5),
                Text(
                  [
                    if (material.sourceName != null) material.sourceName!,
                    if (material.sourceCheckedAt != null)
                      'Diperiksa ${_date(material.sourceCheckedAt!)}',
                  ].join(' | '),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                if (material.externalUrl != null) ...[
                  const SizedBox(height: 10),
                  TextButton.icon(
                    onPressed: () => launchUrl(
                      Uri.parse(material.externalUrl!),
                      mode: LaunchMode.externalApplication,
                    ),
                    icon: const Icon(LucideIcons.externalLink, size: 16),
                    label: const Text('Buka sumber'),
                  ),
                ],
              ],
            ),
          ),
        ],
        const SizedBox(height: AppSpacing.md),
        Text(
          'Materi ini bersifat edukatif. Sesuaikan dengan kondisi dan kebutuhanmu.',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  String _date(DateTime value) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    return '${value.day} ${months[value.month - 1]} ${value.year}';
  }
}

