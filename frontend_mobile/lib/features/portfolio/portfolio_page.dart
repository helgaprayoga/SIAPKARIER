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
import '../../core/widgets/section_title.dart';
import '../../data/models/portfolio_project.dart';
import '../../providers/portfolio_controller.dart';

class PortfolioPage extends ConsumerWidget {
  const PortfolioPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(portfolioProvider);

    return AppScaffold(
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 10, 22, 14),
          child: AppButton(
            label: 'Tambah proyek',
            icon: LucideIcons.plus,
            onPressed: () {
              ref.read(portfolioProvider.notifier).startNew();
              context.push('/portfolio/form');
            },
          ),
        ),
      ),
      children: [
        AppPageHeader(
          title: 'Portfolio Starter Kit',
          onBack: () => context.pop(),
          action: AppTag(
            label: '${state.projects.length} proyek',
            tone: AppTagTone.neutral,
          ),
        ),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.navy,
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppTag(
                label: 'Mulai dari yang ada',
                tone: AppTagTone.gold,
              ),
              const SizedBox(height: 12),
              Text(
                'Tugas kuliah bisa menjadi\nbukti kemampuanmu.',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontSize: 21,
                    ),
              ),
              const SizedBox(height: 7),
              Text(
                'Tulis masalah, peran, proses, dan hasil. Tidak perlu sempurna '
                'untuk mulai.',
                style: TextStyle(
                  fontFamily: 'DM Sans',
                  fontSize: 11,
                  height: 1.5,
                  color: Colors.white.withValues(alpha: 0.72),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        SectionTitle(
          title: 'Proyekmu',
          trailing: state.projects.isEmpty
              ? null
              : Text(
                  'Ketuk untuk melihat',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
        ),
        if (state.projects.isEmpty)
          AppEmptyState(
            icon: LucideIcons.folderOpen,
            title: 'Belum Ada Proyek',
            message:
                'Mulai dari satu tugas kuliah atau proyek pribadi yang paling '
                'kamu banggakan.',
            actionLabel: 'Buat proyek pertama',
            onAction: () {
              ref.read(portfolioProvider.notifier).startNew();
              context.push('/portfolio/form');
            },
          )
        else
          ...state.projects.map(
            (project) => Padding(
              padding: const EdgeInsets.only(bottom: 11),
              child: _ProjectCard(
                project: project,
                onTap: () => context.push('/portfolio/preview/${project.id}'),
              ),
            ),
          ),
        const SizedBox(height: AppSpacing.md),
        Text(
          'Portofolio yang baik menunjukkan cara kamu berpikir, bukan hanya '
          'hasil akhirnya.',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _ProjectCard extends StatelessWidget {
  const _ProjectCard({required this.project, required this.onTap});

  final PortfolioProject project;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(15),
      semanticLabel: 'Lihat proyek ${project.title}',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.tealSoft,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  LucideIcons.folderKanban,
                  size: 20,
                  color: AppColors.teal,
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      toTitleCase(project.title),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      project.role,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const AppChevron(),
            ],
          ),
          if (project.skills.isNotEmpty) ...[
            const SizedBox(height: 11),
            Wrap(
              spacing: 5,
              runSpacing: 5,
              children: project.skills
                  .take(4)
                  .map(
                    (skill) => AppTag(
                      label: skill,
                      tone: AppTagTone.neutral,
                    ),
                  )
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }
}

