import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/app_bottom_nav.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_page_header.dart';
import '../../core/widgets/app_progress.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../core/widgets/app_tag.dart';
import '../../data/mock/mock_data.dart';
import '../../data/models/readiness.dart';
import '../../providers/readiness_controller.dart';

class ReadinessIntroPage extends ConsumerWidget {
  const ReadinessIntroPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(readinessProvider);
    final result = state.result;
    final answered = state.answeredCount;

    return AppScaffold(
      bottomNavigationBar: const AppBottomNav(currentIndex: 1),
      children: [
        const AppPageHeader(
          title: 'Career Readiness',
        ),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.teal, AppColors.tealDark],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppTag(
                label: '16 pertanyaan',
                tone: AppTagTone.gold,
              ),
              const SizedBox(height: 13),
              Text(
                'Pahami kekuatan dan\narea yang perlu ditumbuhkan.',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontSize: 22,
                    ),
              ),
              const SizedBox(height: 10),
              Text(
                'Jawab dengan jujur. Tidak ada jawaban benar atau salah, '
                'hanya potret kesiapanmu saat ini.',
                style: TextStyle(
                  fontFamily: 'DM Sans',
                  fontSize: 12,
                  height: 1.5,
                  color: Colors.white.withValues(alpha: 0.82),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        if (result != null) ...[
          AppCard(
            onTap: () => context.push('/readiness/result'),
            semanticLabel: 'Lihat hasil readiness terakhir',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Hasil terakhirmu',
                        style: TextStyle(
                          fontFamily: 'DM Sans',
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.navy,
                        ),
                      ),
                    ),
                    AppTag(
                      label: result.status.label,
                      tone: result.status == ReadinessStatus.sudahMulai
                          ? AppTagTone.teal
                          : AppTagTone.gold,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text(
                      '${result.percentage.round()}%',
                      style: const TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        color: AppColors.navyDeep,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AppProgress(
                        value: result.percentage,
                        semanticLabel: 'Skor readiness terakhir',
                      ),
                    ),
                    const SizedBox(width: 8),
                    const AppChevron(),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
        const AppCard(
          child: Column(
            children: [
              _InfoRow(
                icon: LucideIcons.clock,
                title: '5-7 Menit',
                subtitle: 'Waktu pengerjaan',
              ),
              Divider(height: 22, color: AppColors.line),
              _InfoRow(
                icon: LucideIcons.layers,
                title: '4 Kategori',
                subtitle: 'Dokumen, digital, melamar, keamanan',
              ),
              Divider(height: 22, color: AppColors.line),
              _InfoRow(
                icon: LucideIcons.lock,
                title: 'Jawabanmu Privat',
                subtitle: 'Disimpan di perangkatmu',
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        AppButton(
          label: result == null ? 'Mulai readiness check' : 'Ulangi readiness check',
          icon: LucideIcons.arrowRight,
          onPressed: () {
            ref.read(readinessProvider.notifier).reset();
            context.push('/readiness/quiz');
          },
        ),
        if (answered > 0 && result == null) ...[
          const SizedBox(height: 10),
          Text(
            'Kamu sudah menjawab $answered dari ${MockData.readinessQuestions.length} pertanyaan.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.tealSoft,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.teal, size: 19),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ],
    );
  }
}

