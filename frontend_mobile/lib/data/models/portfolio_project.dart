class PortfolioProject {
  const PortfolioProject({
    required this.id,
    required this.title,
    required this.role,
    this.problem = '',
    this.process = '',
    this.result = '',
    this.tools = const [],
    this.skills = const [],
    this.reflection = '',
    this.imageUrl,
    this.link,
    required this.createdAt,
  });

  final String id;
  final String title;
  final String role;
  final String problem;
  final String process;
  final String result;
  final List<String> tools;
  final List<String> skills;
  final String reflection;
  final String? imageUrl;
  final String? link;
  final DateTime createdAt;

  PortfolioProject copyWith({
    String? title,
    String? role,
    String? problem,
    String? process,
    String? result,
    List<String>? tools,
    List<String>? skills,
    String? reflection,
    String? imageUrl,
    String? link,
  }) {
    return PortfolioProject(
      id: id,
      title: title ?? this.title,
      role: role ?? this.role,
      problem: problem ?? this.problem,
      process: process ?? this.process,
      result: result ?? this.result,
      tools: tools ?? this.tools,
      skills: skills ?? this.skills,
      reflection: reflection ?? this.reflection,
      imageUrl: imageUrl ?? this.imageUrl,
      link: link ?? this.link,
      createdAt: createdAt,
    );
  }
}
