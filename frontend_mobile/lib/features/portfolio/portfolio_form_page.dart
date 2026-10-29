import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_labeled_field.dart';
import '../../core/widgets/app_page_header.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../core/widgets/sticky_action_bar.dart';
import '../../providers/portfolio_controller.dart';

class PortfolioFormPage extends ConsumerWidget {
  const PortfolioFormPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(portfolioProvider);
    final controller = ref.read(portfolioProvider.notifier);
    final draft = state.draft ?? const PortfolioDraft();

    void update(PortfolioDraft Function(PortfolioDraft value) updater) {
      controller.update(updater);
    }

    return AppScaffold(
      bottomNavigationBar: StickyActionBar(
        primaryLabel: state.editingId == null ? 'Simpan proyek' : 'Perbarui proyek',
        primaryIcon: LucideIcons.check,
        onPrimary: () {
          if (controller.save()) {
            context.pop();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Judul dan peran proyek wajib diisi.'),
              ),
            );
          }
        },
        note: 'Tulis dengan jujur dan spesifik. Kualitas lebih penting dari jumlah.',
      ),
      children: [
        AppPageHeader(
          title: 'Portfolio Starter Kit',
          onBack: () => context.pop(),
        ),
        Text(
          'Gunakan struktur sederhana: masalah, peran, proses, dan hasil. '
          'Kamu bisa menyempurnakannya nanti.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: AppSpacing.xl),
        AppCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              AppLabeledField(
                label: 'Judul proyek',
                hint: 'Contoh: Redesain Website Kampus',
                initialValue: draft.title,
                errorText: state.errors['title'],
                onChanged: (value) => update(
                  (data) => data.copyWith(title: value),
                ),
              ),
              const SizedBox(height: 13),
              AppLabeledField(
                label: 'Peranmu',
                hint: 'Contoh: Peneliti pengguna dan desainer UI',
                initialValue: draft.role,
                errorText: state.errors['role'],
                onChanged: (value) => update(
                  (data) => data.copyWith(role: value),
                ),
              ),
              const SizedBox(height: 13),
              AppLabeledField(
                label: 'Masalah',
                hint: 'Masalah apa yang ingin diselesaikan?',
                initialValue: draft.problem,
                maxLines: 3,
                optional: true,
                onChanged: (value) => update(
                  (data) => data.copyWith(problem: value),
                ),
              ),
              const SizedBox(height: 13),
              AppLabeledField(
                label: 'Proses',
                hint: 'Langkah atau pendekatan yang kamu gunakan.',
                initialValue: draft.process,
                maxLines: 4,
                optional: true,
                onChanged: (value) => update(
                  (data) => data.copyWith(process: value),
                ),
              ),
              const SizedBox(height: 13),
              AppLabeledField(
                label: 'Hasil',
                hint: 'Apa yang berubah atau apa yang kamu pelajari?',
                initialValue: draft.result,
                maxLines: 3,
                optional: true,
                onChanged: (value) => update(
                  (data) => data.copyWith(result: value),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        AppCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              AppLabeledField(
                label: 'Alat yang digunakan',
                hint: 'Figma, Notion, Excel (pisahkan dengan koma)',
                initialValue: draft.tools,
                optional: true,
                onChanged: (value) => update(
                  (data) => data.copyWith(tools: value),
                ),
              ),
              const SizedBox(height: 13),
              AppLabeledField(
                label: 'Keterampilan',
                hint: 'Riset pengguna, analisis data (pisahkan dengan koma)',
                initialValue: draft.skills,
                optional: true,
                onChanged: (value) => update(
                  (data) => data.copyWith(skills: value),
                ),
              ),
              const SizedBox(height: 13),
              AppLabeledField(
                label: 'Refleksi',
                hint: 'Apa hal yang akan kamu lakukan berbeda?',
                initialValue: draft.reflection,
                maxLines: 3,
                optional: true,
                onChanged: (value) => update(
                  (data) => data.copyWith(reflection: value),
                ),
              ),
              const SizedBox(height: 13),
              AppLabeledField(
                label: 'Tautan proyek',
                hint: 'https://...',
                keyboardType: TextInputType.url,
                initialValue: draft.link,
                optional: true,
                onChanged: (value) => update(
                  (data) => data.copyWith(link: value),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          'Jangan mencantumkan data sensitif atau karya orang lain tanpa izin.',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

