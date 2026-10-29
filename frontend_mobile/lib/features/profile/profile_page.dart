import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/app_avatar.dart';
import '../../core/widgets/app_bottom_nav.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_empty_state.dart';
import '../../core/widgets/app_page_header.dart';
import '../../core/widgets/app_progress.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../core/widgets/app_tag.dart';
import '../../providers/activity_provider.dart';
import '../../providers/auth_controller.dart';
import '../../providers/learn_controller.dart';
import '../../providers/portfolio_controller.dart';
import '../../providers/readiness_controller.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider);
    final readiness = ref.watch(readinessProvider);
    final learn = ref.watch(learnProvider);
    final portfolio = ref.watch(portfolioProvider);
    final summary = ref.watch(activitySummaryProvider);

    if (user == null) {
      return AppScaffold(
        bottomNavigationBar: const AppBottomNav(currentIndex: 4),
        children: [
          const AppPageHeader(
            title: 'Profil',
          ),
          AppEmptyState(
            icon: LucideIcons.user,
            title: 'Kamu Belum Masuk',
            message:
                'Masuk untuk menyimpan progres dan melanjutkan persiapan karier.',
            actionLabel: 'Masuk',
            onAction: () => context.push('/login'),
          ),
          const SizedBox(height: 12),
          AppButton(
            label: 'Buat akun',
            variant: AppButtonVariant.secondary,
            onPressed: () => context.push('/register'),
          ),
        ],
      );
    }

    return AppScaffold(
      bottomNavigationBar: const AppBottomNav(currentIndex: 4),
      children: [
        AppPageHeader(
          title: 'Profil',
          action: AppIconButton(
            icon: LucideIcons.settings,
            label: 'Edit profil',
            onPressed: () => context.push('/profile/edit'),
          ),
        ),
        AppCard(
          child: Row(
            children: [
              AppAvatar(initials: user.initials, size: 56),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.fullName,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      [
                        if (user.studyProgram != null) user.studyProgram!,
                        if (user.semester != null) 'Semester ${user.semester}',
                      ].join(' | '),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    if (user.careerInterest != null) ...[
                      const SizedBox(height: 6),
                      AppTag(label: user.careerInterest!),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        AppCard(
          color: AppColors.navy,
          borderColor: AppColors.navy,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const AppTag(
                    label: 'Progres keseluruhan',
                    tone: AppTagTone.gold,
                  ),
                  const Spacer(),
                  Text(
                    '${summary.overallProgress.round()}%',
                    style: const TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 11),
              AppProgress(
                value: summary.overallProgress,
                color: AppColors.gold,
                background: Colors.white.withValues(alpha: 0.18),
                semanticLabel: 'Progres keseluruhan',
              ),
              const SizedBox(height: 8),
              Text(
                'Teruskan langkah kecilmu. Progres dihitung dari readiness, '
                'CV, portofolio, dan materi yang selesai.',
                style: TextStyle(
                  fontFamily: 'DM Sans',
                  fontSize: 10,
                  height: 1.5,
                  color: Colors.white.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                value: readiness.result == null
                    ? '-'
                    : '${readiness.result!.percentage.round()}%',
                label: 'Readiness',
              ),
            ),
            const SizedBox(width: 9),
            Expanded(
              child: _StatCard(
                value: '${learn.completedIds.length}',
                label: 'Materi selesai',
              ),
            ),
            const SizedBox(width: 9),
            Expanded(
              child: _StatCard(
                value: '${portfolio.projects.length}',
                label: 'Proyek',
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),
        Text(
          'Kelola ruangmu',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 11),
        _MenuTile(
          icon: LucideIcons.pencil,
                    title: 'Edit Profil',
          subtitle: 'Perbarui data studi dan minat karier.',
          onTap: () => context.push('/profile/edit'),
        ),
        _MenuTile(
          icon: LucideIcons.shieldCheck,
          title: 'Privasi dan Data',
          subtitle: 'Pelajari cara data kamu disimpan.',
          onTap: () => context.push('/profile/privacy'),
        ),
        _MenuTile(
          icon: LucideIcons.shieldAlert,
                    title: 'Safe Job Search',
          subtitle: 'Periksa lowongan sebelum melamar.',
          onTap: () => context.push('/safe'),
        ),
        _MenuTile(
          icon: LucideIcons.bookOpen,
                    title: 'Learning Corner',
          subtitle: 'Kembali ke materi belajar.',
          onTap: () => context.go('/learn'),
        ),
        const SizedBox(height: AppSpacing.md),
        AppButton(
          label: 'Keluar',
          icon: LucideIcons.logOut,
          variant: AppButtonVariant.secondary,
          onPressed: () {
            ref.read(authProvider.notifier).logout();
            context.go('/login');
          },
        ),
        const SizedBox(height: 10),
        Text(
          'SIAPKARIER membantu persiapan karier mahasiswa. Bukan layanan '
          'rekrutmen atau penempatan kerja.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 13),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Manrope',
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.navyDeep,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 9,
                ),
          ),
        ],
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: AppCard(
        onTap: onTap,
        padding: const EdgeInsets.all(13),
        semanticLabel: title,
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.tealSoft,
                borderRadius: BorderRadius.circular(11),
              ),
              child: Icon(icon, size: 18, color: AppColors.teal),
            ),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const AppChevron(),
          ],
        ),
      ),
    );
  }
}

