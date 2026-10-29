import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/utils/title_case.dart';
import '../../core/widgets/app_bottom_nav.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_empty_state.dart';
import '../../core/widgets/app_filter_chip.dart';
import '../../core/widgets/app_page_header.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../core/widgets/app_tag.dart';
import '../../data/models/learning_material.dart';
import '../../providers/learn_controller.dart';

class LearnPage extends ConsumerWidget {
  const LearnPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(learnProvider);
    final controller = ref.read(learnProvider.notifier);

    return AppScaffold(
      bottomNavigationBar: const AppBottomNav(currentIndex: 3),
      children: [
        const AppPageHeader(
          title: 'Learning Corner',
        ),
        TextField(
          onChanged: controller.setQuery,
          decoration: const InputDecoration(
            hintText: 'Cari materi, keterampilan, atau topik...',
            prefixIcon: Icon(
              LucideIcons.search,
              size: 19,
              color: AppColors.muted,
            ),
          ),
        ),
        const SizedBox(height: 14),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              AppFilterChip(
                label: 'Semua',
                selected: state.category == null,
                onTap: () => controller.setCategory(null),
              ),
              const SizedBox(width: 7),
              ...state.categories.map(
                (category) => Padding(
                  padding: const EdgeInsets.only(right: 7),
                  child: AppFilterChip(
                    label: category,
                    selected: state.category == category,
                    onTap: () => controller.setCategory(category),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        if (state.filtered.isEmpty)
          const AppEmptyState(
            icon: LucideIcons.search,
            title: 'Materi Tidak Ditemukan',
            message: 'Coba kata kunci lain atau pilih kategori yang berbeda.',
          )
        else ...[
          _FeaturedMaterial(
            material: state.filtered.first,
            completed: state.isCompleted(state.filtered.first.id),
            onTap: () => context.push('/learn/${state.filtered.first.slug}'),
          ),
          const SizedBox(height: AppSpacing.xl),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Semua materi',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Text(
                '${state.filtered.length} materi',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          const SizedBox(height: 11),
          ...state.filtered.skip(1).map(
                (material) => Padding(
                  padding: const EdgeInsets.only(bottom: 9),
                  child: _MaterialCard(
                    material: material,
                    completed: state.isCompleted(material.id),
                    onTap: () => context.push('/learn/${material.slug}'),
                  ),
                ),
              ),
        ],
        const SizedBox(height: AppSpacing.md),
        Text(
          'Materi disusun untuk membantu mahasiswa memulai, bukan menggantikan '
          'pendampingan karier profesional.',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _FeaturedMaterial extends StatelessWidget {
  const _FeaturedMaterial({
    required this.material,
    required this.completed,
    required this.onTap,
  });

  final LearningMaterial material;
  final bool completed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      padding: EdgeInsets.zero,
      semanticLabel: 'Buka materi ${material.title}',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.teal, AppColors.tealDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(AppSpacing.radiusMd),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    AppTag(
                      label: material.category,
                      tone: AppTagTone.gold,
                    ),
                    const Spacer(),
                    if (completed)
                      const Icon(
                        LucideIcons.checkCircle2,
                        color: Colors.white,
                        size: 20,
                      ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  toTitleCase(material.title),
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontSize: 21,
                      ),
                ),
                const SizedBox(height: 7),
                Text(
                  material.summary,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'DM Sans',
                    fontSize: 11,
                    height: 1.5,
                    color: Colors.white.withValues(alpha: 0.78),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
            child: Row(
              children: [
                const Icon(
                  LucideIcons.clock,
                  size: 15,
                  color: AppColors.muted,
                ),
                const SizedBox(width: 5),
                Text(
                  '${material.durationMinutes} menit',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(width: 12),
                Text(
                  material.contentType.label,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const Spacer(),
                const Text(
                  'Mulai',
                  style: TextStyle(
                    fontFamily: 'DM Sans',
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: AppColors.teal,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  LucideIcons.arrowRight,
                  size: 15,
                  color: AppColors.teal,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MaterialCard extends StatelessWidget {
  const _MaterialCard({
    required this.material,
    required this.completed,
    required this.onTap,
  });

  final LearningMaterial material;
  final bool completed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(14),
      semanticLabel: 'Buka materi ${material.title}',
      child: Row(
        children: [
          Container(
            width: 43,
            height: 43,
            decoration: BoxDecoration(
              color: completed ? AppColors.tealSoft : AppColors.background,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              completed ? LucideIcons.checkCircle2 : LucideIcons.bookOpen,
              size: 20,
              color: completed ? AppColors.teal : AppColors.muted,
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  material.category,
                  style: const TextStyle(
                    fontFamily: 'DM Sans',
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.7,
                    color: AppColors.teal,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  material.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 13,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${material.durationMinutes} menit | ${material.contentType.label}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const Icon(
            LucideIcons.chevronRight,
            size: 17,
            color: AppColors.muted,
          ),
        ],
      ),
    );
  }
}

