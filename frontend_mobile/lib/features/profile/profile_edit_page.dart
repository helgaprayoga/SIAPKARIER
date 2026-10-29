import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_page_header.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/sticky_action_bar.dart';
import '../../providers/auth_controller.dart';

class ProfileEditPage extends ConsumerStatefulWidget {
  const ProfileEditPage({super.key});

  @override
  ConsumerState<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends ConsumerState<ProfileEditPage> {
  late final TextEditingController _name;
  late final TextEditingController _program;
  late final TextEditingController _semester;
  late final TextEditingController _interest;
  late final TextEditingController _email;

  @override
  void initState() {
    super.initState();
    final user = ref.read(authProvider);
    _name = TextEditingController(text: user?.fullName ?? '');
    _program = TextEditingController(text: user?.studyProgram ?? '');
    _semester = TextEditingController(text: user?.semester?.toString() ?? '');
    _interest = TextEditingController(text: user?.careerInterest ?? '');
    _email = TextEditingController(text: user?.email ?? '');
  }

  @override
  void dispose() {
    _name.dispose();
    _program.dispose();
    _semester.dispose();
    _interest.dispose();
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      bottomNavigationBar: StickyActionBar(
        primaryLabel: 'Simpan profil',
        primaryIcon: LucideIcons.check,
        onPrimary: _save,
        note: 'Perubahan disimpan di perangkat ini.',
      ),
      children: [
        AppPageHeader(
          title: 'Profil',
          onBack: () => context.pop(),
        ),
        AppCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              AppTextField(
                label: 'Nama lengkap',
                controller: _name,
                hint: 'Nama yang ingin ditampilkan',
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 14),
              AppTextField(
                label: 'Program studi',
                controller: _program,
                hint: 'Contoh: Sistem Informasi',
                textInputAction: TextInputAction.next,
                optional: true,
              ),
              const SizedBox(height: 14),
              AppTextField(
                label: 'Semester',
                controller: _semester,
                hint: 'Contoh: 5',
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                optional: true,
              ),
              const SizedBox(height: 14),
              AppTextField(
                label: 'Minat karier',
                controller: _interest,
                hint: 'Contoh: Produk Digital',
                textInputAction: TextInputAction.next,
                optional: true,
              ),
              const SizedBox(height: 14),
              AppTextField(
                label: 'Email',
                controller: _email,
                hint: 'nama@email.com',
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          'Data ini hanya dipakai untuk personalisasi pengalaman di aplikasi.',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  void _save() {
    final name = _name.text.trim();
    final email = _email.text.trim();
    if (name.isEmpty || email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama dan email wajib diisi.')),
      );
      return;
    }

    final current = ref.read(authProvider);
    if (current == null) return;

    ref.read(authProvider.notifier).updateProfile(
          current.copyWith(
            fullName: name,
            studyProgram: _program.text.trim(),
            semester: int.tryParse(_semester.text.trim()),
            careerInterest: _interest.text.trim(),
            email: email,
          ),
        );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profil diperbarui.')),
    );
    context.pop();
  }
}

