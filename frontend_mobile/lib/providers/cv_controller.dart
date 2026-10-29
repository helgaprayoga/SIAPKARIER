import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/cv_data.dart';

class CvState {
  const CvState({
    this.cvs = const [],
    this.draft = const CvData(),
    this.errors = const {},
    this.editingId,
  });

  final List<SavedCv> cvs;
  final CvData draft;
  final Map<String, String> errors;
  final String? editingId;

  bool get isSaved => editingId != null;

  CvState copyWith({
    List<SavedCv>? cvs,
    CvData? draft,
    Map<String, String>? errors,
    String? editingId,
    bool clearEditing = false,
  }) {
    return CvState(
      cvs: cvs ?? this.cvs,
      draft: draft ?? this.draft,
      errors: errors ?? this.errors,
      editingId: clearEditing ? null : (editingId ?? this.editingId),
    );
  }
}

final cvProvider = NotifierProvider<CvController, CvState>(CvController.new);

class CvController extends Notifier<CvState> {
  @override
  CvState build() => const CvState();

  void startNew() {
    state = state.copyWith(
      draft: const CvData(),
      errors: const {},
      clearEditing: true,
    );
  }

  void edit(SavedCv cv) {
    state = CvState(cvs: state.cvs, draft: cv.data, editingId: cv.id);
  }

  void update(CvData Function(CvData draft) updater) {
    state = state.copyWith(draft: updater(state.draft), errors: const {});
  }

  void setTemplate(CvTemplate template) {
    state = state.copyWith(draft: state.draft.copyWith(template: template));
  }

  bool validate() {
    final errors = <String, String>{};
    if (state.draft.fullName.trim().isEmpty) {
      errors['fullName'] = 'Nama lengkap wajib diisi.';
    }
    final email = state.draft.email.trim();
    if (email.isEmpty) {
      errors['email'] = 'Email wajib diisi.';
    } else if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
      errors['email'] = 'Format email belum sesuai.';
    }
    state = state.copyWith(errors: errors);
    return errors.isEmpty;
  }

  bool saveCv() {
    if (!validate()) return false;

    final now = DateTime.now();
    final id = state.editingId ?? now.microsecondsSinceEpoch.toString();
    final title = state.draft.title.trim().isEmpty
        ? (state.draft.fullName.trim().isEmpty
            ? 'CV Tanpa Judul'
            : 'CV ${state.draft.fullName.trim()}')
        : state.draft.title.trim();
    final data = state.draft.copyWith(title: title);
    final saved = SavedCv(id: id, data: data, updatedAt: now);

    final cvs = [...state.cvs];
    final index = cvs.indexWhere((item) => item.id == id);
    if (index >= 0) {
      cvs[index] = saved;
    } else {
      cvs.insert(0, saved);
    }

    state = CvState(cvs: cvs, draft: data, editingId: id);
    return true;
  }

  void delete(String id) {
    final cvs = state.cvs.where((item) => item.id != id).toList();
    final deletedActive = state.editingId == id;
    state = CvState(
      cvs: cvs,
      draft: deletedActive ? const CvData() : state.draft,
      editingId: deletedActive ? null : state.editingId,
    );
  }

  void reset() {
    state = const CvState();
  }
}
