import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_empty_state.dart';
import '../../core/widgets/app_page_header.dart';
import '../../core/widgets/app_progress.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../core/widgets/app_tag.dart';
import '../../core/widgets/sticky_action_bar.dart';
import '../../data/models/readiness.dart';
import '../../providers/readiness_controller.dart';

class ReadinessResultPage extends ConsumerWidget {
  const ReadinessResultPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final result = ref.watch(readinessProvider).result;

    if (result == null) {
      return AppScaffold(
        children: [
          AppPageHeader(
            eyebrow: 'Hasil readiness',
            title: 'Belum Ada Hasil',
            eyebrowAboveTitle: true,
            onBack: () => context.pop(),
          ),
          AppEmptyState(
            icon: LucideIcons.sparkles,
            title: 'Mulai Readiness Check Dulu',
            message:
                'Jawab 16 pertanyaan singkat untuk melihat kesiapan kariermu.',
            actionLabel: 'Mulai sekarang',
            onAction: () => context.go('/readiness'),
          ),
        ],
      );
    }

    final status = result.status;
    final recommendations = _recommendations(result);

    return AppScaffold(
      bottomNavigationBar: StickyActionBar(
        primaryLabel: 'Ulangi penilaian',
        primaryIcon: LucideIcons.refreshCw,
        onPrimary: () {
          ref.read(readinessProvider.notifier).reset();
          context.pushReplacement('/readiness/quiz');
        },
        secondaryLabel: 'Ke Home',
        secondaryIcon: LucideIcons.home,
        onSecondary: () => context.go('/home'),
      ),
      children: [
        AppPageHeader(
          eyebrow: 'Hasil readiness',
          title: 'Potret Kesiapanmu',
          eyebrowAboveTitle: true,
          onBack: () => context.pop(),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            border: Border.all(color: AppColors.line),
            boxShadow: AppSpacing.shadowSm,
          ),
          child: Column(
            children: [
              _ScoreCircle(percentage: result.percentage),
              const SizedBox(height: 16),
              AppTag(
                label: status.label,
                tone: status == ReadinessStatus.sudahMulai
                    ? AppTagTone.teal
                    : AppTagTone.gold,
              ),
              const SizedBox(height: 10),
              Text(
                status.description,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 6),
              Text(
                '${result.totalPoints} dari ${result.maxPoints} poin',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        Text(
          'Rincian per kategori',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 11),
        ...result.categories.map(
          (category) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: AppCard(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          category.category,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      Text(
                        '${category.percentage.round()}%',
                        style: const TextStyle(
                          fontFamily: 'DM Sans',
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: AppColors.teal,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 9),
                  AppProgress(
                    value: category.percentage,
                    color: category.percentage >= 67
                        ? AppColors.teal
                        : AppColors.gold,
                    semanticLabel: 'Skor ${category.category}',
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${category.points} dari ${category.maxPoints} poin',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          'Langkah yang bisa kamu coba',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 11),
        ...recommendations.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 9),
            child: AppCard(
              padding: const EdgeInsets.all(14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: AppColors.tealSoft,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      item.icon,
                      color: AppColors.teal,
                      size: 17,
                    ),
                  ),
                  const SizedBox(width: 11),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item.description,
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
        const SizedBox(height: AppSpacing.md),
        Text(
          'Hasil ini disimpan di perangkatmu. Kamu bisa mengulang kapan saja '
          'untuk melihat perkembangan.',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  List<_Recommendation> _recommendations(ReadinessResult result) {
    final sorted = List<ReadinessCategoryResult>.from(result.categories)
      ..sort((a, b) => a.percentage.compareTo(b.percentage));

    return sorted.take(3).map((category) {
      return switch (category.category) {
        'Dokumen Karier' => const _Recommendation(
            icon: LucideIcons.fileText,
            title: 'Mulai CV dan Portofolio',
            description:
                'Susun CV pertama dan ubah satu tugas kuliah menjadi studi kasus.',
          ),
        'Keterampilan Digital' => const _Recommendation(
            icon: LucideIcons.monitor,
            title: 'Kenali Alat Digital Bidangmu',
            description:
                'Baca materi alat digital, lalu pilih satu alat untuk dilatih.',
          ),
        'Persiapan Melamar' => const _Recommendation(
            icon: LucideIcons.send,
            title: 'Pelajari Proses Melamar',
            description:
                'Pahami deskripsi posisi dan persiapan dasar sebelum melamar.',
          ),
        'Profesionalisme dan Komunikasi' => const _Recommendation(
            icon: LucideIcons.messageCircle,
            title: 'Latih Komunikasi Profesional',
            description:
                'Mulai dari email profesional dan cerita pengalaman dengan STAR.',
          ),
        'Keamanan Pencarian Kerja' => const _Recommendation(
            icon: LucideIcons.shieldCheck,
            title: 'Periksa Lowongan dengan Aman',
            description:
                'Gunakan checklist lowongan sebelum membagikan data pribadi.',
          ),
        _ => const _Recommendation(
            icon: LucideIcons.bookOpen,
            title: 'Lanjutkan Belajar',
            description: 'Pilih materi yang paling relevan dengan minatmu.',
          ),
      };
    }).toList();
  }
}

class _ScoreCircle extends StatelessWidget {
  const _ScoreCircle({required this.percentage});

  final double percentage;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 132,
      height: 132,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CircularProgressIndicator(
            value: percentage / 100,
            strokeWidth: 9,
            backgroundColor: AppColors.line,
            valueColor: const AlwaysStoppedAnimation(AppColors.gold),
            strokeCap: StrokeCap.round,
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${percentage.round()}%',
                  style: const TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 31,
                    fontWeight: FontWeight.w800,
                    color: AppColors.navyDeep,
                  ),
                ),
                const Text(
                  'skor',
                  style: TextStyle(
                    fontFamily: 'DM Sans',
                    fontSize: 10,
                    color: AppColors.muted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Recommendation {
  const _Recommendation({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;
}

