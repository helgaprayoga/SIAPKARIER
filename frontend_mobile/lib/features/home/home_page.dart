import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/app_avatar.dart';
import '../../core/widgets/app_bottom_nav.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_brand.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_progress.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../core/widgets/app_tag.dart';
import '../../core/widgets/section_title.dart';
import '../../data/models/learning_material.dart';
import '../../providers/activity_provider.dart';
import '../../providers/auth_controller.dart';
import '../../providers/learn_controller.dart';
import '../../providers/readiness_controller.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider);
    final readiness = ref.watch(readinessProvider);
    final learn = ref.watch(learnProvider);
    final summary = ref.watch(activitySummaryProvider);

    return AppScaffold(
      bottomNavigationBar: const AppBottomNav(currentIndex: 0),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const AppBrand(),
            AppAvatar(initials: user?.initials ?? 'SK'),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),
        _HeroCard(
          progress: summary.overallProgress,
          onTap: () => context.go('/readiness'),
        ),
        const SizedBox(height: AppSpacing.xl),
        AppCard(
          color: AppColors.surface,
          onTap: () => context.go('/readiness'),
          semanticLabel: 'Buka Career Readiness Check',
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.tealSoft,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(
                  LucideIcons.sparkles,
                  color: AppColors.teal,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AppTag(label: 'Mulai dari sini'),
                    const SizedBox(height: 7),
                    Text(
                      'Career Readiness Check',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      readiness.result == null
                          ? 'Kenali kesiapan kariermu lewat 16 pertanyaan singkat.'
                          : 'Skor terakhirmu ${readiness.result!.percentage.round()}%. Lihat hasilnya.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const AppChevron(),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        const SectionTitle(title: 'Langkah Berikutnya'),
        Row(
          children: [
            Expanded(
              child: _QuickAction(
                icon: LucideIcons.fileText,
                label: 'Buat CV',
                color: AppColors.teal,
                onTap: () => context.go('/cv'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _QuickAction(
                icon: LucideIcons.layoutGrid,
                label: 'Portofolio',
                color: AppColors.gold,
                onTap: () => context.push('/portfolio'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _QuickAction(
                icon: LucideIcons.shieldCheck,
                label: 'Cek Aman',
                color: const Color(0xFF6A7FB5),
                onTap: () => context.push('/safe'),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xxl),
        SectionTitle(
          title: 'Lanjutkan Belajar',
          trailing: TextButton(
            onPressed: () => context.go('/learn'),
            child: const Text('Lihat semua'),
          ),
        ),
        ...learn.materials.take(2).map(
              (material) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _LearningCard(
                  material: material,
                  onTap: () => context.push('/learn/${material.slug}'),
                ),
              ),
            ),
      ],
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.progress, required this.onTap});

  final double progress;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.navy, AppColors.navyDeep],
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        boxShadow: AppSpacing.shadowLg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const AppTag(
                label: 'Progres persiapan',
                tone: AppTagTone.gold,
              ),
              const Spacer(),
              Icon(
                LucideIcons.arrowUpRight,
                color: Colors.white.withValues(alpha: 0.65),
                size: 18,
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            'Siapkan langkah kecil\nuntuk karier besarmu.',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: Colors.white,
                  fontSize: 25,
                ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Text(
                '${progress.round()}%',
                style: const TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: AppProgress(
                  value: progress,
                  color: AppColors.gold,
                  background: Colors.white.withValues(alpha: 0.18),
                  semanticLabel: 'Progres persiapan karier',
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Terus tumbuh, satu langkah setiap hari.',
            style: TextStyle(
              fontFamily: 'DM Sans',
              fontSize: 11,
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 16),
          AppButton(
            label: 'Lanjutkan perjalanan',
            onPressed: onTap,
            variant: AppButtonVariant.secondary,
            icon: LucideIcons.arrowRight,
          ),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
      semanticLabel: label,
      child: Column(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 9),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'DM Sans',
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.navy,
            ),
          ),
        ],
      ),
    );
  }
}

class _LearningCard extends StatelessWidget {
  const _LearningCard({required this.material, required this.onTap});

  final LearningMaterial material;
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
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.goldSoft,
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Icon(
              LucideIcons.bookOpen,
              color: AppColors.gold,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
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
                  '${material.durationMinutes} menit',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const AppChevron(),
        ],
      ),
    );
  }
}

