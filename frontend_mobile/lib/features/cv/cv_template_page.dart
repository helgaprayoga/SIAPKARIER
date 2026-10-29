import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_page_header.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../core/widgets/app_tag.dart';
import '../../core/widgets/sticky_action_bar.dart';
import '../../data/models/cv_data.dart';
import '../../providers/cv_controller.dart';

class CvTemplatePage extends ConsumerStatefulWidget {
  const CvTemplatePage({super.key});

  @override
  ConsumerState<CvTemplatePage> createState() => _CvTemplatePageState();
}

class _CvTemplatePageState extends ConsumerState<CvTemplatePage> {
  late CvTemplate _selected;

  @override
  void initState() {
    super.initState();
    _selected = ref.read(cvProvider).draft.template;
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      bottomNavigationBar: StickyActionBar(
        primaryLabel: 'Gunakan template',
        primaryIcon: LucideIcons.arrowRight,
        onPrimary: () {
          ref.read(cvProvider.notifier).setTemplate(_selected);
          context.push('/cv/preview');
        },
        note: 'Kamu bisa mengganti template kapan saja.',
      ),
      children: [
        AppPageHeader(
          title: 'CV dan Lamaran',
          onBack: () => context.pop(),
        ),
        Text(
          'Pilih tampilan yang paling nyaman untukmu. Isi CV tetap sama.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: AppSpacing.xl),
        ...CvTemplate.values.map((template) {
          final selected = _selected == template;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: AppCard(
              onTap: () => setState(() => _selected = template),
              padding: const EdgeInsets.all(14),
              borderColor: selected ? AppColors.teal : AppColors.line,
              semanticLabel: 'Pilih template ${template.label}',
              child: Row(
                children: [
                  _TemplateThumbnail(template: template, selected: selected),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              template.label,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            if (template == CvTemplate.focus) ...[
                              const SizedBox(width: 7),
                              const AppTag(label: 'Disarankan'),
                            ],
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(
                          template.description,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          switch (template) {
                            CvTemplate.focus =>
                              'Aksen teal, rapi, dan mudah dibaca.',
                            CvTemplate.classic =>
                              'Format formal dengan aksen navy.',
                            CvTemplate.modern =>
                              'Aksen hangat dan tata letak ringkas.',
                          },
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 23,
                    height: 23,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: selected ? AppColors.teal : Colors.transparent,
                      border: Border.all(
                        color: selected ? AppColors.teal : AppColors.line,
                        width: 1.5,
                      ),
                    ),
                    child: selected
                        ? const Icon(
                            LucideIcons.check,
                            color: Colors.white,
                            size: 14,
                          )
                        : null,
                  ),
                ],
              ),
            ),
          );
        }),
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
                LucideIcons.lightbulb,
                size: 18,
                color: Color(0xFF916C22),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  'Template yang sederhana biasanya lebih mudah dibaca oleh '
                  'perekrut. Pilih yang paling sesuai dengan bidangmu.',
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

class _TemplateThumbnail extends StatelessWidget {
  const _TemplateThumbnail({
    required this.template,
    required this.selected,
  });

  final CvTemplate template;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final accent = switch (template) {
      CvTemplate.focus => AppColors.teal,
      CvTemplate.classic => AppColors.navy,
      CvTemplate.modern => AppColors.gold,
    };

    return Container(
      width: 70,
      height: 92,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: selected ? accent : AppColors.line,
          width: selected ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(width: 30, height: 4, color: accent),
          const SizedBox(height: 5),
          Container(width: 48, height: 4, color: AppColors.navy),
          const SizedBox(height: 3),
          Container(width: 36, height: 3, color: AppColors.line),
          const SizedBox(height: 8),
          Container(width: 22, height: 3, color: accent),
          const SizedBox(height: 4),
          Container(width: 54, height: 2, color: AppColors.line),
          const SizedBox(height: 3),
          Container(width: 50, height: 2, color: AppColors.line),
          const SizedBox(height: 3),
          Container(width: 44, height: 2, color: AppColors.line),
          const SizedBox(height: 8),
          Container(width: 22, height: 3, color: accent),
          const SizedBox(height: 4),
          Container(width: 54, height: 2, color: AppColors.line),
          const SizedBox(height: 3),
          Container(width: 40, height: 2, color: AppColors.line),
        ],
      ),
    );
  }
}

