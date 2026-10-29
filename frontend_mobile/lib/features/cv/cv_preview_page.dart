import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_page_header.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../core/widgets/sticky_action_bar.dart';
import '../../providers/cv_controller.dart';
import '../../services/cv_pdf_service.dart';
import 'widgets/cv_preview.dart';

class CvPreviewPage extends ConsumerStatefulWidget {
  const CvPreviewPage({super.key});

  @override
  ConsumerState<CvPreviewPage> createState() => _CvPreviewPageState();
}

class _CvPreviewPageState extends ConsumerState<CvPreviewPage> {
  bool _isGenerating = false;

  @override
  Widget build(BuildContext context) {
    final cv = ref.watch(cvProvider);
    final draft = cv.draft;

    return AppScaffold(
      bottomNavigationBar: StickyActionBar(
        primaryLabel: _isGenerating ? 'Menyiapkan PDF...' : 'Unduh / bagikan PDF',
        primaryIcon: LucideIcons.download,
        primaryEnabled: !_isGenerating,
        onPrimary: _sharePdf,
        secondaryLabel: 'Edit',
        secondaryIcon: LucideIcons.pencil,
        onSecondary: () => context.pop(),
        note: 'PDF dibuat dari data yang kamu isi. Periksa kembali sebelum dibagikan.',
      ),
      children: [
        AppPageHeader(
          title: 'CV dan Lamaran',
          onBack: () => context.pop(),
          action: TextButton(
            onPressed: _finish,
            child: const Text('Selesai'),
          ),
        ),
        if (draft.fullName.trim().isEmpty || draft.email.trim().isEmpty) ...[
          AppCard(
            color: AppColors.goldSoft,
            borderColor: AppColors.goldSoft,
            showShadow: false,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  LucideIcons.alertTriangle,
                  size: 18,
                  color: Color(0xFF916C22),
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Text(
                    'Nama dan email belum lengkap. Lengkapi data dasar agar CV '
                    'siap dibagikan.',
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
          const SizedBox(height: 14),
        ],
        CvPreview(data: draft),
        const SizedBox(height: 16),
        Text(
          'Tips: simpan PDF dengan nama yang jelas, misalnya '
          '"CV_NamaKamu.pdf".',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Future<void> _sharePdf() async {
    final controller = ref.read(cvProvider.notifier);
    if (!controller.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lengkapi nama dan email sebelum membuat PDF.'),
        ),
      );
      return;
    }

    final paperSize = await _choosePaperSize();
    if (!mounted || paperSize == null) return;

    setState(() => _isGenerating = true);
    try {
      await CvPdfService.share(
        ref.read(cvProvider).draft,
        paperSize: paperSize,
      );
      controller.saveCv();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('PDF belum bisa dibuat. Coba lagi sebentar lagi.'),
        ),
      );
    } finally {
      if (mounted) setState(() => _isGenerating = false);
    }
  }

  Future<CvPaperSize?> _choosePaperSize() {
    return showModalBottomSheet<CvPaperSize>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pilih ukuran PDF',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 5),
              Text(
                'Sesuaikan ukuran dengan kebutuhan lamaranmu.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 12),
              for (final size in CvPaperSize.values)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(LucideIcons.fileText),
                  title: Text(size.label),
                  subtitle: Text(
                    size == CvPaperSize.a4
                        ? 'Ukuran dokumen standar'
                        : 'Ukuran folio panjang',
                  ),
                  onTap: () => Navigator.of(context).pop(size),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _finish() {
    ref.read(cvProvider.notifier).saveCv();
    context.go('/cv');
  }
}

