import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/cv_data.dart';

class CvPreview extends StatelessWidget {
  const CvPreview({super.key, required this.data});

  final CvData data;

  @override
  Widget build(BuildContext context) {
    final accent = switch (data.template) {
      CvTemplate.focus => AppColors.teal,
      CvTemplate.classic => AppColors.navy,
      CvTemplate.modern => AppColors.gold,
    };

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.line),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14183B56),
            blurRadius: 30,
            offset: Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(width: 46, height: 5, color: accent),
          const SizedBox(height: 11),
          Text(
            data.fullName.trim().isEmpty ? 'Nama Lengkap' : data.fullName.trim(),
            style: const TextStyle(
              fontFamily: 'Manrope',
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.navyDeep,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            [
              if (data.email.trim().isNotEmpty) data.email.trim(),
              if (data.phone.trim().isNotEmpty) data.phone.trim(),
              ...data.links.map((link) => '${link.label}: ${link.url}'),
            ].join('  |  '),
            style: const TextStyle(
              fontFamily: 'DM Sans',
              fontSize: 8.5,
              color: AppColors.muted,
            ),
          ),
          if (data.summary.trim().isNotEmpty) ...[
            const SizedBox(height: 15),
            _SectionTitle('Ringkasan Profil', accent),
            const SizedBox(height: 5),
            Text(
              data.summary.trim(),
              style: const TextStyle(
                fontFamily: 'DM Sans',
                fontSize: 9.5,
                height: 1.55,
                color: AppColors.ink,
              ),
            ),
          ],
          if (data.education.isNotEmpty) ...[
            const SizedBox(height: 15),
            _SectionTitle('Pendidikan', accent),
            ...data.education.map(
              (item) => _Entry(
                title: item.institution,
                subtitle: [
                  item.major,
                  if (item.degree != null) item.degree,
                ].whereType<String>().join(' - '),
                period: [
                  if (item.startYear != null) item.startYear,
                  if (item.endYear != null) item.endYear,
                ].whereType<String>().join(' - '),
                description: item.description,
              ),
            ),
          ],
          if (data.experiences.isNotEmpty) ...[
            const SizedBox(height: 15),
            _SectionTitle('Pengalaman', accent),
            ...data.experiences.map(
              (item) => _Entry(
                title: item.title,
                subtitle: item.organization,
                period: [
                  if (item.startDate != null) item.startDate,
                  if (item.endDate != null) item.endDate,
                ].whereType<String>().join(' - '),
                description: item.description,
              ),
            ),
          ],
          if (data.organizations.isNotEmpty) ...[
            const SizedBox(height: 15),
            _SectionTitle('Organisasi', accent),
            ...data.organizations.map(
              (item) => _Entry(
                title: item.title,
                subtitle: item.organization,
                period: [
                  if (item.startDate != null) item.startDate,
                  if (item.endDate != null) item.endDate,
                ].whereType<String>().join(' - '),
                description: item.description,
              ),
            ),
          ],
          if (data.projects.isNotEmpty) ...[
            const SizedBox(height: 15),
            _SectionTitle('Proyek', accent),
            ...data.projects.map(
              (item) => _Entry(
                title: item.name,
                subtitle: item.role ?? '',
                description: item.description,
                footer: item.tools.isEmpty
                    ? null
                    : 'Alat: ${item.tools.join(', ')}',
              ),
            ),
          ],
          if (data.skills.isNotEmpty) ...[
            const SizedBox(height: 15),
            _SectionTitle('Keterampilan', accent),
            const SizedBox(height: 6),
            Wrap(
              spacing: 5,
              runSpacing: 5,
              children: data.skills
                  .map(
                    (skill) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        skill,
                        style: const TextStyle(
                          fontFamily: 'DM Sans',
                          fontSize: 8.5,
                          color: AppColors.ink,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
          if (data.certificates.isNotEmpty) ...[
            const SizedBox(height: 15),
            _SectionTitle('Sertifikat', accent),
            ...data.certificates.map(
              (item) => Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text(
                  '${item.name} - ${item.issuer}${item.year == null ? '' : ' (${item.year})'}',
                  style: const TextStyle(
                    fontFamily: 'DM Sans',
                    fontSize: 9.5,
                    color: AppColors.ink,
                  ),
                ),
              ),
            ),
          ],
          if (data.languages.isNotEmpty) ...[
            const SizedBox(height: 15),
            _SectionTitle('Bahasa', accent),
            ...data.languages.map(
              (item) => Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text(
                  '${item.name} - ${item.proficiency}',
                  style: const TextStyle(
                    fontFamily: 'DM Sans',
                    fontSize: 9.5,
                    color: AppColors.ink,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title, this.accent);

  final String title;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 3, height: 12, color: accent),
        const SizedBox(width: 6),
        Text(
          title.toUpperCase(),
          style: const TextStyle(
            fontFamily: 'DM Sans',
            fontSize: 8.5,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.8,
            color: AppColors.navy,
          ),
        ),
      ],
    );
  }
}

class _Entry extends StatelessWidget {
  const _Entry({
    required this.title,
    this.subtitle,
    this.period,
    this.description,
    this.footer,
  });

  final String title;
  final String? subtitle;
  final String? period;
  final String? description;
  final String? footer;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 7),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'DM Sans',
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
              ),
              if (period != null && period!.isNotEmpty)
                Text(
                  period!,
                  style: const TextStyle(
                    fontFamily: 'DM Sans',
                    fontSize: 8,
                    color: AppColors.muted,
                  ),
                ),
            ],
          ),
          if (subtitle != null && subtitle!.isNotEmpty)
            Text(
              subtitle!,
              style: const TextStyle(
                fontFamily: 'DM Sans',
                fontSize: 9,
                color: AppColors.teal,
              ),
            ),
          if (description != null && description!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                description!,
                style: const TextStyle(
                  fontFamily: 'DM Sans',
                  fontSize: 8.5,
                  height: 1.5,
                  color: AppColors.ink,
                ),
              ),
            ),
          if (footer != null)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                footer!,
                style: const TextStyle(
                  fontFamily: 'DM Sans',
                  fontSize: 8,
                  color: AppColors.muted,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
