import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/utils/title_case.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_empty_state.dart';
import '../../core/widgets/app_page_header.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../core/widgets/app_tag.dart';
import '../../core/widgets/sticky_action_bar.dart';
import '../../data/models/portfolio_project.dart';
import '../../providers/portfolio_controller.dart';

class PortfolioPreviewPage extends ConsumerWidget {
  const PortfolioPreviewPage({super.key, required this.projectId});

  final String projectId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(portfolioProvider);
    final project = state.projects
        .where((item) => item.id == projectId)
        .firstOrNull;

    if (project == null) {
      return AppScaffold(
        children: [
          AppPageHeader(
            title: 'Portofolio',
            onBack: () => context.pop(),
          ),
          AppEmptyState(
            icon: LucideIcons.folderOpen,
            title: 'Proyek tidak tersedia',
            message: 'Proyek mungkin sudah dihapus dari perangkat ini.',
            actionLabel: 'Kembali',
            onAction: () => context.pop(),
          ),
        ],
      );
    }

    return AppScaffold(
      bottomNavigationBar: StickyActionBar(
        primaryLabel: 'Edit proyek',
        primaryIcon: LucideIcons.pencil,
        onPrimary: () {
          ref.read(portfolioProvider.notifier).edit(project);
          context.push('/portfolio/form');
        },
        secondaryLabel: 'Hapus',
        secondaryIcon: LucideIcons.trash2,
        onSecondary: () => _confirmDelete(context, ref, project),
        primaryVariant: AppButtonVariant.primary,
      ),
      children: [
        AppPageHeader(
          title: 'Studi Kasus',
          onBack: () => context.pop(),
        ),
        Text(
          toTitleCase(project.title),
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontSize: 24,
                height: 1.2,
              ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: 5,
          runSpacing: 5,
          children: [
            AppTag(label: project.role, tone: AppTagTone.teal),
            ...project.skills.map(
              (skill) => AppTag(label: skill, tone: AppTagTone.neutral),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),
        _DetailSection(
          icon: LucideIcons.target,
          title: 'Masalah',
          content: project.problem,
          fallback: 'Belum diisi. Tambahkan konteks masalah proyek.',
        ),
        _DetailSection(
          icon: LucideIcons.gitBranch,
          title: 'Proses',
          content: project.process,
          fallback: 'Belum diisi. Ceritakan pendekatan yang kamu gunakan.',
        ),
        _DetailSection(
          icon: LucideIcons.trendingUp,
          title: 'Hasil',
          content: project.result,
          fallback: 'Belum diisi. Tuliskan hasil atau pelajaran yang didapat.',
        ),
        _DetailSection(
          icon: LucideIcons.lightbulb,
          title: 'Refleksi',
          content: project.reflection,
          fallback: 'Belum diisi. Apa yang akan kamu lakukan berbeda?',
        ),
        if (project.tools.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.md),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      LucideIcons.wrench,
                      size: 18,
                      color: AppColors.teal,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Alat yang digunakan',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 9),
                Wrap(
                  spacing: 5,
                  runSpacing: 5,
                  children: project.tools
                      .map(
                        (tool) => AppTag(
                          label: tool,
                          tone: AppTagTone.gold,
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
        ],
        if (project.link != null) ...[
          const SizedBox(height: 10),
          AppCard(
            child: Row(
              children: [
                const Icon(
                  LucideIcons.link,
                  size: 18,
                  color: AppColors.teal,
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Text(
                    project.link!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    PortfolioProject project,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus proyek?'),
        content: Text(
          'Proyek "${project.title}" akan dihapus dari perangkat ini.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      ref.read(portfolioProvider.notifier).delete(project.id);
      if (context.mounted) context.pop();
    }
  }
}

class _DetailSection extends StatelessWidget {
  const _DetailSection({
    required this.icon,
    required this.title,
    required this.content,
    required this.fallback,
  });

  final IconData icon;
  final String title;
  final String content;
  final String fallback;

  @override
  Widget build(BuildContext context) {
    final isEmpty = content.trim().isEmpty;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 18, color: AppColors.teal),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              isEmpty ? fallback : content,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isEmpty ? AppColors.muted : AppColors.ink,
                    fontStyle: isEmpty ? FontStyle.italic : FontStyle.normal,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

