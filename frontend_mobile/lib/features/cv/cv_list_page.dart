import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/app_bottom_nav.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_empty_state.dart';
import '../../core/widgets/app_page_header.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../core/widgets/app_tag.dart';
import '../../data/models/cv_data.dart';
import '../../providers/cv_controller.dart';

class CvListPage extends ConsumerWidget {
  const CvListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(cvProvider);
    final controller = ref.read(cvProvider.notifier);

    void createCv() {
      controller.startNew();
      context.push('/cv/editor');
    }

    return AppScaffold(
      bottomNavigationBar: const AppBottomNav(currentIndex: 2),
      children: [
        const AppPageHeader(
          title: 'CV dan Lamaran',
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
                label: 'Banyak versi, satu profil',
                tone: AppTagTone.gold,
              ),
              const SizedBox(height: 12),
              Text(
                'Buat CV yang berbeda\nuntuk setiap peluang.',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontSize: 21,
                    ),
              ),
              const SizedBox(height: 7),
              Text(
                'Simpan beberapa versi CV, lalu pilih yang paling relevan '
                'saat melamar.',
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
        Row(
          children: [
            Expanded(
              child: Text(
                'Daftar CV',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Text(
              '${state.cvs.length} CV',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        const SizedBox(height: 11),
        if (state.cvs.isEmpty)
          AppEmptyState(
            icon: LucideIcons.fileText,
            title: 'Belum Ada CV',
            message:
                'Mulai CV pertamamu. Kamu bisa membuat versi lain kapan saja '
                'untuk peluang yang berbeda.',
            actionLabel: 'Buat CV pertama',
            onAction: createCv,
          )
        else
          ...state.cvs.map(
            (cv) => Padding(
              padding: const EdgeInsets.only(bottom: 11),
              child: _CvCard(
                cv: cv,
                onEdit: () {
                  controller.edit(cv);
                  context.push('/cv/editor');
                },
                onPreview: () {
                  controller.edit(cv);
                  context.push('/cv/preview');
                },
                onDelete: () => _confirmDelete(context, ref, cv),
              ),
            ),
          ),
        const SizedBox(height: AppSpacing.sm),
        AppButton(
          label: 'Buat CV baru',
          icon: LucideIcons.plus,
          onPressed: createCv,
        ),
        const SizedBox(height: 10),
        Text(
          'Kamu bisa mengedit dan membuat versi baru tanpa menghapus CV '
          'yang lama.',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    SavedCv cv,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus CV?'),
        content: Text('"${cv.displayTitle}" akan dihapus dari perangkat ini.'),
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
      ref.read(cvProvider.notifier).delete(cv.id);
    }
  }
}

class _CvCard extends StatelessWidget {
  const _CvCard({
    required this.cv,
    required this.onEdit,
    required this.onPreview,
    required this.onDelete,
  });

  final SavedCv cv;
  final VoidCallback onEdit;
  final VoidCallback onPreview;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(15),
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
                  LucideIcons.fileText,
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
                      cv.displayTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      cv.data.fullName.trim().isEmpty
                          ? 'Nama belum diisi'
                          : cv.data.fullName.trim(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              AppIconButton(
                icon: LucideIcons.trash2,
                label: 'Hapus ${cv.displayTitle}',
                size: 32,
                iconSize: 16,
                background: AppColors.background,
                foreground: AppColors.danger,
                onPressed: onDelete,
              ),
            ],
          ),
          const SizedBox(height: 11),
          Row(
            children: [
              AppTag(label: cv.data.template.label),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Diperbarui ${_formatDate(cv.updatedAt)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(height: 1, color: AppColors.line),
          const SizedBox(height: 5),
          Row(
            children: [
              TextButton.icon(
                onPressed: onEdit,
                icon: const Icon(LucideIcons.pencil, size: 15),
                label: const Text('Edit'),
              ),
              TextButton.icon(
                onPressed: onPreview,
                icon: const Icon(LucideIcons.eye, size: 15),
                label: const Text('Pratinjau'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime value) {
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
