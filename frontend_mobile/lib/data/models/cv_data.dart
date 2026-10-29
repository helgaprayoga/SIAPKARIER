enum CvTemplate { focus, classic, modern }

extension CvTemplateX on CvTemplate {
  String get label => switch (this) {
        CvTemplate.focus => 'Fokus',
        CvTemplate.classic => 'Klasik',
        CvTemplate.modern => 'Modern',
      };

  String get description => switch (this) {
        CvTemplate.focus => 'Direkomendasikan',
        CvTemplate.classic => 'Rapi dan formal',
        CvTemplate.modern => 'Segar dan ringkas',
      };
}

class CvLink {
  const CvLink({required this.label, required this.url});

  final String label;
  final String url;
}

class EducationEntry {
  const EducationEntry({
    required this.institution,
    required this.major,
    this.degree,
    this.startYear,
    this.endYear,
    this.description,
  });

  final String institution;
  final String major;
  final String? degree;
  final String? startYear;
  final String? endYear;
  final String? description;

  EducationEntry copyWith({
    String? institution,
    String? major,
    String? degree,
    String? startYear,
    String? endYear,
    String? description,
  }) {
    return EducationEntry(
      institution: institution ?? this.institution,
      major: major ?? this.major,
      degree: degree ?? this.degree,
      startYear: startYear ?? this.startYear,
      endYear: endYear ?? this.endYear,
      description: description ?? this.description,
    );
  }
}

class ExperienceEntry {
  const ExperienceEntry({
    required this.title,
    required this.organization,
    this.startDate,
    this.endDate,
    this.description,
  });

  final String title;
  final String organization;
  final String? startDate;
  final String? endDate;
  final String? description;

  ExperienceEntry copyWith({
    String? title,
    String? organization,
    String? startDate,
    String? endDate,
    String? description,
  }) {
    return ExperienceEntry(
      title: title ?? this.title,
      organization: organization ?? this.organization,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      description: description ?? this.description,
    );
  }
}

class ProjectEntry {
  const ProjectEntry({
    required this.name,
    this.role,
    this.description,
    this.tools = const [],
    this.result,
    this.link,
  });

  final String name;
  final String? role;
  final String? description;
  final List<String> tools;
  final String? result;
  final String? link;

  ProjectEntry copyWith({
    String? name,
    String? role,
    String? description,
    List<String>? tools,
    String? result,
    String? link,
  }) {
    return ProjectEntry(
      name: name ?? this.name,
      role: role ?? this.role,
      description: description ?? this.description,
      tools: tools ?? this.tools,
      result: result ?? this.result,
      link: link ?? this.link,
    );
  }
}

class CertificateEntry {
  const CertificateEntry({
    required this.name,
    required this.issuer,
    this.year,
    this.credentialUrl,
  });

  final String name;
  final String issuer;
  final String? year;
  final String? credentialUrl;

  CertificateEntry copyWith({
    String? name,
    String? issuer,
    String? year,
    String? credentialUrl,
  }) {
    return CertificateEntry(
      name: name ?? this.name,
      issuer: issuer ?? this.issuer,
      year: year ?? this.year,
      credentialUrl: credentialUrl ?? this.credentialUrl,
    );
  }
}

class LanguageEntry {
  const LanguageEntry({required this.name, required this.proficiency});

  final String name;
  final String proficiency;

  LanguageEntry copyWith({String? name, String? proficiency}) {
    return LanguageEntry(
      name: name ?? this.name,
      proficiency: proficiency ?? this.proficiency,
    );
  }
}

class CvData {
  const CvData({
    this.title = '',
    this.fullName = '',
    this.email = '',
    this.phone = '',
    this.summary = '',
    this.links = const [],
    this.education = const [],
    this.experiences = const [],
    this.organizations = const [],
    this.projects = const [],
    this.skills = const [],
    this.certificates = const [],
    this.languages = const [],
    this.template = CvTemplate.focus,
  });

  final String title;
  final String fullName;
  final String email;
  final String phone;
  final String summary;
  final List<CvLink> links;
  final List<EducationEntry> education;
  final List<ExperienceEntry> experiences;
  final List<ExperienceEntry> organizations;
  final List<ProjectEntry> projects;
  final List<String> skills;
  final List<CertificateEntry> certificates;
  final List<LanguageEntry> languages;
  final CvTemplate template;

  CvData copyWith({
    String? title,
    String? fullName,
    String? email,
    String? phone,
    String? summary,
    List<CvLink>? links,
    List<EducationEntry>? education,
    List<ExperienceEntry>? experiences,
    List<ExperienceEntry>? organizations,
    List<ProjectEntry>? projects,
    List<String>? skills,
    List<CertificateEntry>? certificates,
    List<LanguageEntry>? languages,
    CvTemplate? template,
  }) {
    return CvData(
      title: title ?? this.title,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      summary: summary ?? this.summary,
      links: links ?? this.links,
      education: education ?? this.education,
      experiences: experiences ?? this.experiences,
      organizations: organizations ?? this.organizations,
      projects: projects ?? this.projects,
      skills: skills ?? this.skills,
      certificates: certificates ?? this.certificates,
      languages: languages ?? this.languages,
      template: template ?? this.template,
    );
  }

  bool get hasContent =>
      education.isNotEmpty ||
      experiences.isNotEmpty ||
      organizations.isNotEmpty ||
      projects.isNotEmpty;
}

class SavedCv {
  const SavedCv({
    required this.id,
    required this.data,
    required this.updatedAt,
  });

  final String id;
  final CvData data;
  final DateTime updatedAt;

  String get displayTitle {
    final value = data.title.trim();
    if (value.isNotEmpty) return value;
    final name = data.fullName.trim();
    return name.isEmpty ? 'CV Tanpa Judul' : 'CV $name';
  }

  SavedCv copyWith({CvData? data, DateTime? updatedAt}) {
    return SavedCv(
      id: id,
      data: data ?? this.data,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
