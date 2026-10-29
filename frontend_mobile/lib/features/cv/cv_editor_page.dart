import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_labeled_field.dart';
import '../../core/widgets/app_page_header.dart';
import '../../core/widgets/app_progress.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../core/widgets/app_tag.dart';
import '../../core/widgets/sticky_action_bar.dart';
import '../../data/models/cv_data.dart';
import '../../providers/cv_controller.dart';

class CvEditorPage extends ConsumerWidget {
  const CvEditorPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cv = ref.watch(cvProvider);
    final controller = ref.read(cvProvider.notifier);
    final draft = cv.draft;

    final steps = [
      draft.fullName.trim().isNotEmpty && draft.email.trim().isNotEmpty,
      draft.education.isNotEmpty,
      draft.experiences.isNotEmpty || draft.projects.isNotEmpty,
      draft.skills.isNotEmpty,
    ];
    final completed = steps.where((item) => item).length;

    void updateEducation(
      int index,
      EducationEntry Function(EducationEntry item) updater,
    ) {
      controller.update((data) {
        final list = [...data.education];
        list[index] = updater(list[index]);
        return data.copyWith(education: list);
      });
    }

    void updateExperience(
      int index,
      ExperienceEntry Function(ExperienceEntry item) updater, {
      bool organization = false,
    }) {
      controller.update((data) {
        final source = organization ? data.organizations : data.experiences;
        final list = [...source];
        list[index] = updater(list[index]);
        return organization
            ? data.copyWith(organizations: list)
            : data.copyWith(experiences: list);
      });
    }

    void updateProject(
      int index,
      ProjectEntry Function(ProjectEntry item) updater,
    ) {
      controller.update((data) {
        final list = [...data.projects];
        list[index] = updater(list[index]);
        return data.copyWith(projects: list);
      });
    }

    void updateCertificate(
      int index,
      CertificateEntry Function(CertificateEntry item) updater,
    ) {
      controller.update((data) {
        final list = [...data.certificates];
        list[index] = updater(list[index]);
        return data.copyWith(certificates: list);
      });
    }

    void updateLanguage(
      int index,
      LanguageEntry Function(LanguageEntry item) updater,
    ) {
      controller.update((data) {
        final list = [...data.languages];
        list[index] = updater(list[index]);
        return data.copyWith(languages: list);
      });
    }

    return AppScaffold(
      bottomNavigationBar: StickyActionBar(
        primaryLabel: 'Pilih template',
        primaryIcon: LucideIcons.layoutTemplate,
        onPrimary: () {
          if (controller.validate()) {
            context.push('/cv/template');
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Lengkapi nama dan email sebelum melanjutkan.'),
              ),
            );
          }
        },
        note: 'Data CV tersimpan di daftar CV selama sesi ini.',
      ),
      children: [
        AppPageHeader(
          title: 'CV dan Lamaran',
          action: AppIconButton(
            icon: LucideIcons.save,
            label: 'Simpan CV',
            onPressed: () {
              if (controller.saveCv()) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('CV tersimpan.')),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Lengkapi nama dan email sebelum menyimpan.'),
                  ),
                );
              }
            },
          ),
        ),
        AppCard(
          color: AppColors.tealSoft,
          borderColor: AppColors.tealSoft,
          showShadow: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const AppTag(label: 'Progres CV'),
                  const Spacer(),
                  Text(
                    '$completed dari 4 langkah',
                    style: const TextStyle(
                      fontFamily: 'DM Sans',
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppColors.tealDark,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 11),
              AppProgress(
                value: completed / 4 * 100,
                color: AppColors.teal,
                background: Colors.white.withValues(alpha: 0.7),
                semanticLabel: 'Progres pengisian CV',
              ),
              const SizedBox(height: 8),
              Text(
                'Mulai dari data dasar. Kamu bisa menambahkan bagian lain '
                'kapan saja.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.tealDark,
                    ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        _FormSection(
          icon: LucideIcons.user,
          title: 'Data Dasar',
          subtitle: 'Nama dan kontak yang akan tampil di CV.',
          children: [
            AppLabeledField(
              label: 'Nama CV',
              hint: 'Contoh: CV Magang Data',
              initialValue: draft.title,
              optional: true,
              onChanged: (value) => controller.update(
                (data) => data.copyWith(title: value),
              ),
            ),
            const SizedBox(height: 13),
            AppLabeledField(
              label: 'Nama lengkap',
              hint: 'Contoh: Raka Aditya',
              initialValue: draft.fullName,
              errorText: cv.errors['fullName'],
              onChanged: (value) => controller.update(
                (data) => data.copyWith(fullName: value),
              ),
            ),
            const SizedBox(height: 13),
            AppLabeledField(
              label: 'Email',
              hint: 'nama@email.com',
              keyboardType: TextInputType.emailAddress,
              initialValue: draft.email,
              errorText: cv.errors['email'],
              onChanged: (value) => controller.update(
                (data) => data.copyWith(email: value),
              ),
            ),
            const SizedBox(height: 13),
            AppLabeledField(
              label: 'Nomor telepon',
              hint: '08xxxxxxxxxx',
              keyboardType: TextInputType.phone,
              initialValue: draft.phone,
              optional: true,
              onChanged: (value) => controller.update(
                (data) => data.copyWith(phone: value),
              ),
            ),
            const SizedBox(height: 13),
            AppLabeledField(
              label: 'Ringkasan profil',
              hint:
                  'Ceritakan fokus, kekuatan, dan arah karier yang kamu tuju.',
              initialValue: draft.summary,
              maxLines: 4,
              maxLength: 320,
              optional: true,
              onChanged: (value) => controller.update(
                (data) => data.copyWith(summary: value),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        _FormSection(
          icon: LucideIcons.graduationCap,
          title: 'Pendidikan',
          subtitle: 'Tambahkan riwayat pendidikan terbaru.',
          onAdd: () => controller.update(
            (data) => data.copyWith(
              education: [
                ...data.education,
                const EducationEntry(institution: '', major: ''),
              ],
            ),
          ),
          children: [
            if (draft.education.isEmpty)
              const _EmptySectionHint(
                text: 'Belum ada pendidikan. Tekan tambah untuk mengisi.',
              ),
            ...List.generate(draft.education.length, (index) {
              final item = draft.education[index];
              return _EntryShell(
                title: 'Pendidikan ${index + 1}',
                onDelete: () => controller.update(
                  (data) => data.copyWith(
                    education: [...data.education]..removeAt(index),
                  ),
                ),
                children: [
                  AppLabeledField(
                    label: 'Institusi',
                    hint: 'Nama kampus atau sekolah',
                    initialValue: item.institution,
                    onChanged: (value) => updateEducation(
                      index,
                      (entry) => entry.copyWith(institution: value),
                    ),
                  ),
                  const SizedBox(height: 12),
                  AppLabeledField(
                    label: 'Jurusan',
                    hint: 'Program studi',
                    initialValue: item.major,
                    onChanged: (value) => updateEducation(
                      index,
                      (entry) => entry.copyWith(major: value),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: AppLabeledField(
                          label: 'Mulai',
                          hint: '2023',
                          initialValue: item.startYear,
                          optional: true,
                          onChanged: (value) => updateEducation(
                            index,
                            (entry) => entry.copyWith(startYear: value),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: AppLabeledField(
                          label: 'Selesai',
                          hint: 'Sekarang',
                          initialValue: item.endYear,
                          optional: true,
                          onChanged: (value) => updateEducation(
                            index,
                            (entry) => entry.copyWith(endYear: value),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  AppLabeledField(
                    label: 'Catatan',
                    hint: 'IPK, fokus studi, atau pencapaian singkat.',
                    initialValue: item.description,
                    maxLines: 3,
                    optional: true,
                    onChanged: (value) => updateEducation(
                      index,
                      (entry) => entry.copyWith(description: value),
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        _FormSection(
          icon: LucideIcons.briefcase,
          title: 'Pengalaman',
          subtitle: 'Magang, kerja lepas, atau pengalaman relevan.',
          onAdd: () => controller.update(
            (data) => data.copyWith(
              experiences: [
                ...data.experiences,
                const ExperienceEntry(title: '', organization: ''),
              ],
            ),
          ),
          children: [
            if (draft.experiences.isEmpty)
              const _EmptySectionHint(
                text: 'Belum ada pengalaman. Kamu bisa melewati bagian ini.',
              ),
            ...List.generate(draft.experiences.length, (index) {
              final item = draft.experiences[index];
              return _EntryShell(
                title: 'Pengalaman ${index + 1}',
                onDelete: () => controller.update(
                  (data) => data.copyWith(
                    experiences: [...data.experiences]..removeAt(index),
                  ),
                ),
                children: [
                  AppLabeledField(
                    label: 'Posisi',
                    hint: 'Contoh: Asisten Riset',
                    initialValue: item.title,
                    onChanged: (value) => updateExperience(
                      index,
                      (entry) => entry.copyWith(title: value),
                    ),
                  ),
                  const SizedBox(height: 12),
                  AppLabeledField(
                    label: 'Organisasi / perusahaan',
                    hint: 'Nama tempat kamu berkegiatan',
                    initialValue: item.organization,
                    onChanged: (value) => updateExperience(
                      index,
                      (entry) => entry.copyWith(organization: value),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: AppLabeledField(
                          label: 'Mulai',
                          hint: 'Jun 2025',
                          initialValue: item.startDate,
                          optional: true,
                          onChanged: (value) => updateExperience(
                            index,
                            (entry) => entry.copyWith(startDate: value),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: AppLabeledField(
                          label: 'Selesai',
                          hint: 'Agu 2025',
                          initialValue: item.endDate,
                          optional: true,
                          onChanged: (value) => updateExperience(
                            index,
                            (entry) => entry.copyWith(endDate: value),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  AppLabeledField(
                    label: 'Deskripsi',
                    hint: 'Tugas dan hasil yang kamu capai.',
                    initialValue: item.description,
                    maxLines: 3,
                    optional: true,
                    onChanged: (value) => updateExperience(
                      index,
                      (entry) => entry.copyWith(description: value),
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        _FormSection(
          icon: LucideIcons.users,
          title: 'Organisasi',
          subtitle: 'Peran di organisasi, komunitas, atau kepanitiaan.',
          onAdd: () => controller.update(
            (data) => data.copyWith(
              organizations: [
                ...data.organizations,
                const ExperienceEntry(title: '', organization: ''),
              ],
            ),
          ),
          children: [
            if (draft.organizations.isEmpty)
              const _EmptySectionHint(
                text: 'Belum ada organisasi. Tambahkan bila relevan.',
              ),
            ...List.generate(draft.organizations.length, (index) {
              final item = draft.organizations[index];
              return _EntryShell(
                title: 'Organisasi ${index + 1}',
                onDelete: () => controller.update(
                  (data) => data.copyWith(
                    organizations: [...data.organizations]..removeAt(index),
                  ),
                ),
                children: [
                  AppLabeledField(
                    label: 'Peran',
                    hint: 'Contoh: Ketua Divisi Acara',
                    initialValue: item.title,
                    onChanged: (value) => updateExperience(
                      index,
                      (entry) => entry.copyWith(title: value),
                      organization: true,
                    ),
                  ),
                  const SizedBox(height: 12),
                  AppLabeledField(
                    label: 'Organisasi',
                    hint: 'Nama organisasi',
                    initialValue: item.organization,
                    onChanged: (value) => updateExperience(
                      index,
                      (entry) => entry.copyWith(organization: value),
                      organization: true,
                    ),
                  ),
                  const SizedBox(height: 12),
                  AppLabeledField(
                    label: 'Deskripsi',
                    hint: 'Kontribusi dan hasil yang kamu capai.',
                    initialValue: item.description,
                    maxLines: 3,
                    optional: true,
                    onChanged: (value) => updateExperience(
                      index,
                      (entry) => entry.copyWith(description: value),
                      organization: true,
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        _FormSection(
          icon: LucideIcons.folderKanban,
          title: 'Proyek',
          subtitle: 'Tugas kuliah atau proyek pribadi yang relevan.',
          onAdd: () => controller.update(
            (data) => data.copyWith(
              projects: [
                ...data.projects,
                const ProjectEntry(name: ''),
              ],
            ),
          ),
          children: [
            if (draft.projects.isEmpty)
              const _EmptySectionHint(
                text: 'Belum ada proyek. Satu proyek relevan sudah cukup.',
              ),
            ...List.generate(draft.projects.length, (index) {
              final item = draft.projects[index];
              return _EntryShell(
                title: 'Proyek ${index + 1}',
                onDelete: () => controller.update(
                  (data) => data.copyWith(
                    projects: [...data.projects]..removeAt(index),
                  ),
                ),
                children: [
                  AppLabeledField(
                    label: 'Nama proyek',
                    hint: 'Contoh: Sistem Informasi Kampus',
                    initialValue: item.name,
                    onChanged: (value) => updateProject(
                      index,
                      (entry) => entry.copyWith(name: value),
                    ),
                  ),
                  const SizedBox(height: 12),
                  AppLabeledField(
                    label: 'Peran',
                    hint: 'Apa kontribusimu?',
                    initialValue: item.role,
                    optional: true,
                    onChanged: (value) => updateProject(
                      index,
                      (entry) => entry.copyWith(role: value),
                    ),
                  ),
                  const SizedBox(height: 12),
                  AppLabeledField(
                    label: 'Deskripsi',
                    hint: 'Masalah, proses, dan hasil proyek.',
                    initialValue: item.description,
                    maxLines: 3,
                    optional: true,
                    onChanged: (value) => updateProject(
                      index,
                      (entry) => entry.copyWith(description: value),
                    ),
                  ),
                  const SizedBox(height: 12),
                  AppLabeledField(
                    label: 'Alat',
                    hint: 'Figma, Excel, Canva (pisahkan dengan koma)',
                    initialValue: item.tools.join(', '),
                    optional: true,
                    onChanged: (value) => updateProject(
                      index,
                      (entry) => entry.copyWith(tools: _split(value)),
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        _FormSection(
          icon: LucideIcons.sparkles,
          title: 'Keterampilan',
          subtitle: 'Pisahkan dengan koma. Tulis yang benar-benar kamu kuasai.',
          children: [
            AppLabeledField(
              label: 'Keterampilan',
              hint: 'Riset pengguna, Excel, komunikasi',
              initialValue: draft.skills.join(', '),
              maxLines: 2,
              onChanged: (value) => controller.update(
                (data) => data.copyWith(skills: _split(value)),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        _FormSection(
          icon: LucideIcons.award,
          title: 'Sertifikat',
          subtitle: 'Sertifikat atau pelatihan yang relevan.',
          onAdd: () => controller.update(
            (data) => data.copyWith(
              certificates: [
                ...data.certificates,
                const CertificateEntry(name: '', issuer: ''),
              ],
            ),
          ),
          children: [
            if (draft.certificates.isEmpty)
              const _EmptySectionHint(text: 'Belum ada sertifikat.'),
            ...List.generate(draft.certificates.length, (index) {
              final item = draft.certificates[index];
              return _EntryShell(
                title: 'Sertifikat ${index + 1}',
                onDelete: () => controller.update(
                  (data) => data.copyWith(
                    certificates: [...data.certificates]..removeAt(index),
                  ),
                ),
                children: [
                  AppLabeledField(
                    label: 'Nama sertifikat',
                    initialValue: item.name,
                    onChanged: (value) => updateCertificate(
                      index,
                      (entry) => entry.copyWith(name: value),
                    ),
                  ),
                  const SizedBox(height: 12),
                  AppLabeledField(
                    label: 'Penerbit',
                    initialValue: item.issuer,
                    onChanged: (value) => updateCertificate(
                      index,
                      (entry) => entry.copyWith(issuer: value),
                    ),
                  ),
                  const SizedBox(height: 12),
                  AppLabeledField(
                    label: 'Tahun',
                    initialValue: item.year,
                    optional: true,
                    onChanged: (value) => updateCertificate(
                      index,
                      (entry) => entry.copyWith(year: value),
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        _FormSection(
          icon: LucideIcons.languages,
          title: 'Bahasa',
          subtitle: 'Bahasa yang kamu kuasai dan tingkat kemampuannya.',
          onAdd: () => controller.update(
            (data) => data.copyWith(
              languages: [
                ...data.languages,
                const LanguageEntry(name: '', proficiency: ''),
              ],
            ),
          ),
          children: [
            if (draft.languages.isEmpty)
              const _EmptySectionHint(text: 'Belum ada bahasa.'),
            ...List.generate(draft.languages.length, (index) {
              final item = draft.languages[index];
              return _EntryShell(
                title: 'Bahasa ${index + 1}',
                onDelete: () => controller.update(
                  (data) => data.copyWith(
                    languages: [...data.languages]..removeAt(index),
                  ),
                ),
                children: [
                  AppLabeledField(
                    label: 'Bahasa',
                    hint: 'Indonesia, Inggris',
                    initialValue: item.name,
                    onChanged: (value) => updateLanguage(
                      index,
                      (entry) => entry.copyWith(name: value),
                    ),
                  ),
                  const SizedBox(height: 12),
                  AppLabeledField(
                    label: 'Tingkat',
                    hint: 'Dasar, Menengah, Mahir',
                    initialValue: item.proficiency,
                    onChanged: (value) => updateLanguage(
                      index,
                      (entry) => entry.copyWith(proficiency: value),
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          'Tips: gunakan kalimat singkat dan spesifik. Hindari menulis '
          'keterampilan yang belum bisa kamu tunjukkan.',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  static List<String> _split(String value) {
    return value
        .split(',')
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList();
  }
}

class _FormSection extends StatelessWidget {
  const _FormSection({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.children,
    this.onAdd,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final List<Widget> children;
  final VoidCallback? onAdd;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.tealSoft,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(icon, size: 18, color: AppColors.teal),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleMedium),
                    Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
              if (onAdd != null)
                AppIconButton(
                  icon: LucideIcons.plus,
                  label: 'Tambah $title',
                  size: 34,
                  iconSize: 17,
                  background: AppColors.background,
                  onPressed: onAdd!,
                ),
            ],
          ),
          if (children.isNotEmpty) ...[
            const SizedBox(height: 15),
            ...children,
          ],
        ],
      ),
    );
  }
}

class _EntryShell extends StatelessWidget {
  const _EntryShell({
    required this.title,
    required this.children,
    required this.onDelete,
  });

  final String title;
  final List<Widget> children;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'DM Sans',
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: AppColors.navy,
                  ),
                ),
              ),
              AppIconButton(
                icon: LucideIcons.trash2,
                label: 'Hapus $title',
                size: 30,
                iconSize: 15,
                background: Colors.white,
                foreground: AppColors.danger,
                onPressed: onDelete,
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }
}

class _EmptySectionHint extends StatelessWidget {
  const _EmptySectionHint({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }
}

