class UserProfile {
  const UserProfile({
    required this.id,
    required this.fullName,
    this.studyProgram,
    this.semester,
    this.careerInterest,
    this.email,
  });

  final String id;
  final String fullName;
  final String? studyProgram;
  final int? semester;
  final String? careerInterest;
  final String? email;

  String get initials {
    final parts = fullName.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return 'SK';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }

  UserProfile copyWith({
    String? fullName,
    String? studyProgram,
    int? semester,
    String? careerInterest,
    String? email,
  }) {
    return UserProfile(
      id: id,
      fullName: fullName ?? this.fullName,
      studyProgram: studyProgram ?? this.studyProgram,
      semester: semester ?? this.semester,
      careerInterest: careerInterest ?? this.careerInterest,
      email: email ?? this.email,
    );
  }
}
