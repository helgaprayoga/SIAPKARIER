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
import '../../data/mock/mock_data.dart';
import '../../data/models/safe_checklist.dart';
import '../../providers/safe_controller.dart';

class SafeJobPage extends ConsumerWidget {
  const SafeJobPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(safeProvider);

    return AppScaffold(
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 10, 22, 14),
          child: AppButton(
            label: 'Buka checklist lowongan',
            icon: LucideIcons.clipboardCheck,
            onPressed: () => context.push('/safe/checklist'),
          ),
        ),
      ),
      children: [
        AppPageHeader(
          title: 'Safe Job Search',
          onBack: () => context.pop(),
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
                label: 'Kenali tandanya',
                tone: AppTagTone.gold,
              ),
              const SizedBox(height: 12),
              Text(
                'Peluang yang baik tidak\nmeminta data rahasiamu.',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontSize: 21,
                    ),
              ),
              const SizedBox(height: 7),
              Text(
                'Luangkan waktu untuk memeriksa sebelum membagikan data '
                'pribadi atau mengambil keputusan.',
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
        AppCard(
          onTap: () => context.push('/safe/checklist'),
          semanticLabel: 'Buka checklist keamanan lowongan',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Checklist sebelum melamar',
                      style: TextStyle(
                        fontFamily: 'DM Sans',
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: AppColors.navy,
                      ),
                    ),
                  ),
                  AppTag(
                    label: '${state.checkedCount}/${state.items.length}',
                    tone: state.isComplete
                        ? AppTagTone.teal
                        : AppTagTone.neutral,
                  ),
                ],
              ),
              const SizedBox(height: 11),
              AppProgress(
                value: state.progress * 100,
                color: AppColors.teal,
                semanticLabel: 'Progres checklist keamanan',
              ),
              const SizedBox(height: 8),
              Text(
                state.isComplete
                    ? 'Semua poin sudah kamu periksa.'
                    : 'Periksa poin-poin penting sebelum mengirim lamaran.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 11),
              Row(
                children: [
                  const Text(
                    'Mulai checklist',
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
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        Text(
          'Tanda yang perlu diwaspadai',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 11),
        ...MockData.safeWarnings.map(
          (warning) => Padding(
            padding: const EdgeInsets.only(bottom: 9),
            child: _WarningCard(warning: warning),
          ),
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
                LucideIcons.shieldAlert,
                size: 18,
                color: Color(0xFF916C22),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  'Jika kamu merasa tidak aman, berhenti berkomunikasi dan '
                  'cari bantuan dari orang yang kamu percaya.',
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

class _WarningCard extends StatelessWidget {
  const _WarningCard({required this.warning});

  final SafeWarning warning;

  @override
  Widget build(BuildContext context) {
    final icon = switch (warning.iconKey) {
      'alert' => LucideIcons.alertTriangle,
      'mail' => LucideIcons.mailWarning,
      'clock' => LucideIcons.clock,
      'lock' => LucideIcons.lock,
      _ => LucideIcons.shieldAlert,
    };

    return AppCard(
      padding: const EdgeInsets.all(13),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              color: const Color(0xFFFBEDEA),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 17, color: AppColors.danger),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  warning.title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 2),
                Text(
                  warning.description,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

