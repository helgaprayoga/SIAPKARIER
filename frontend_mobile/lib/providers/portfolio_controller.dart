import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/portfolio_project.dart';

class PortfolioDraft {
  const PortfolioDraft({
    this.title = '',
    this.role = '',
    this.problem = '',
    this.process = '',
    this.result = '',
    this.tools = '',
    this.skills = '',
    this.reflection = '',
    this.link = '',
  });

  final String title;
  final String role;
  final String problem;
  final String process;
  final String result;
  final String tools;
  final String skills;
  final String reflection;
  final String link;

  factory PortfolioDraft.fromProject(PortfolioProject project) {
    return PortfolioDraft(
      title: project.title,
      role: project.role,
      problem: project.problem,
      process: project.process,
      result: project.result,
      tools: project.tools.join(', '),
      skills: project.skills.join(', '),
      reflection: project.reflection,
      link: project.link ?? '',
    );
  }

  PortfolioDraft copyWith({
    String? title,
    String? role,
    String? problem,
    String? process,
    String? result,
    String? tools,
    String? skills,
    String? reflection,
    String? link,
  }) {
    return PortfolioDraft(
      title: title ?? this.title,
      role: role ?? this.role,
      problem: problem ?? this.problem,
      process: process ?? this.process,
      result: result ?? this.result,
      tools: tools ?? this.tools,
      skills: skills ?? this.skills,
      reflection: reflection ?? this.reflection,
      link: link ?? this.link,
    );
  }

  PortfolioProject toProject({required String id, required DateTime createdAt}) {
    return PortfolioProject(
      id: id,
      title: title.trim(),
      role: role.trim(),
      problem: problem.trim(),
      process: process.trim(),
      result: result.trim(),
      tools: _split(tools),
      skills: _split(skills),
      reflection: reflection.trim(),
      link: link.trim().isEmpty ? null : link.trim(),
      createdAt: createdAt,
    );
  }

  List<String> _split(String value) {
    return value
        .split(',')
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList();
  }
}

class PortfolioState {
  const PortfolioState({
    this.projects = const [],
    this.draft,
    this.editingId,
    this.errors = const {},
  });

  final List<PortfolioProject> projects;
  final PortfolioDraft? draft;
  final String? editingId;
  final Map<String, String> errors;

  PortfolioState copyWith({
    List<PortfolioProject>? projects,
    PortfolioDraft? draft,
    String? editingId,
    Map<String, String>? errors,
  }) {
    return PortfolioState(
      projects: projects ?? this.projects,
      draft: draft ?? this.draft,
      editingId: editingId ?? this.editingId,
      errors: errors ?? this.errors,
    );
  }
}

final portfolioProvider =
    NotifierProvider<PortfolioController, PortfolioState>(
  PortfolioController.new,
);

class PortfolioController extends Notifier<PortfolioState> {
  @override
  PortfolioState build() => const PortfolioState();

  void startNew() {
    state = const PortfolioState(draft: PortfolioDraft());
  }

  void edit(PortfolioProject project) {
    state = state.copyWith(
      draft: PortfolioDraft.fromProject(project),
      editingId: project.id,
      errors: const {},
    );
  }

  void update(PortfolioDraft Function(PortfolioDraft draft) updater) {
    final current = state.draft ?? const PortfolioDraft();
    state = state.copyWith(draft: updater(current), errors: const {});
  }

  bool save() {
    final draft = state.draft;
    if (draft == null) return false;

    final errors = <String, String>{};
    if (draft.title.trim().isEmpty) {
      errors['title'] = 'Judul proyek wajib diisi.';
    }
    if (draft.role.trim().isEmpty) {
      errors['role'] = 'Peranmu wajib diisi.';
    }
    if (errors.isNotEmpty) {
      state = state.copyWith(errors: errors);
      return false;
    }

    final now = DateTime.now();
    final id = state.editingId ?? now.microsecondsSinceEpoch.toString();
    final project = draft.toProject(id: id, createdAt: now);

    final existingIndex =
        state.projects.indexWhere((item) => item.id == project.id);
    final projects = List<PortfolioProject>.from(state.projects);
    if (existingIndex >= 0) {
      projects[existingIndex] = project;
    } else {
      projects.add(project);
    }

    state = PortfolioState(projects: projects);
    return true;
  }

  void delete(String id) {
    state = state.copyWith(
      projects: state.projects.where((item) => item.id != id).toList(),
    );
  }

  void clear() {
    state = const PortfolioState();
  }
}

