import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_page_header.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../providers/cv_controller.dart';
import '../../providers/learn_controller.dart';
import '../../providers/portfolio_controller.dart';
import '../../providers/readiness_controller.dart';
import '../../providers/safe_controller.dart';

class PrivacyPage extends ConsumerWidget {
  const PrivacyPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppScaffold(
      children: [
        AppPageHeader(
          title: 'Privasi dan Data',
          onBack: () => context.pop(),
        ),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.tealSoft,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      LucideIcons.hardDrive,
                      size: 19,
                      color: AppColors.teal,
                    ),
                  ),
                  const SizedBox(width: 11),
                  Expanded(
                    child: Text(
                      'Data sesi',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 11),
              Text(
                'Saat ini data profil, hasil readiness, CV, portofolio, dan '
                'progres belajar tersedia selama sesi aplikasi. Belum ada '
                'data yang dikirim ke server atau disimpan permanen.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        const _InfoRow(
          icon: LucideIcons.lock,
           title: 'Kamu yang Memegang Kendali',
           description:
               'Kamu bisa menghapus data sesi kapan saja melalui tombol di bawah.',
        ),
        const _InfoRow(
          icon: LucideIcons.eyeOff,
           title: 'Tidak untuk Data Sensitif',
          description:
              'Jangan menyimpan nomor identitas, data perbankan, atau dokumen '
              'rahasia di aplikasi ini.',
        ),
        const _InfoRow(
          icon: LucideIcons.shieldCheck,
           title: 'Hati-Hati saat Membagikan',
          description:
              'CV dan portofolio yang kamu bagikan berisi data pribadi. '
              'Periksa tujuan sebelum mengirim.',
        ),
        const SizedBox(height: AppSpacing.xl),
        AppButton(
           label: 'Hapus semua data sesi',
          icon: LucideIcons.trash2,
          variant: AppButtonVariant.secondary,
          onPressed: () => _confirmClear(context, ref),
        ),
        const SizedBox(height: 10),
        Text(
         'Fitur ini akan menghapus progres dan isian pada sesi ini. '
          'Tindakan tidak dapat dibatalkan.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Future<void> _confirmClear(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
           title: const Text('Hapus semua data sesi?'),
        content: const Text(
          'Progres readiness, draf CV, portofolio, dan materi yang selesai '
           'akan dihapus dari sesi aplikasi ini.',
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

    if (confirmed != true) return;

    ref.read(readinessProvider.notifier).reset();
    ref.read(cvProvider.notifier).reset();
    ref.read(portfolioProvider.notifier).clear();
    ref.read(learnProvider.notifier).reset();
    ref.read(safeProvider.notifier).reset();

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
         const SnackBar(content: Text('Data sesi sudah dihapus.')),
      );
    }
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: AppCard(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 18, color: AppColors.teal),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

