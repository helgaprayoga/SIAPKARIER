import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/mock/mock_data.dart';
import '../data/models/user_profile.dart';

final authProvider = NotifierProvider<AuthController, UserProfile?>(
  AuthController.new,
);

class AuthController extends Notifier<UserProfile?> {
  @override
  UserProfile? build() => MockData.user;

  void login({String? email}) {
    state = MockData.user.copyWith(
      email: email ?? MockData.user.email,
    );
  }

  void register({
    required String name,
    required String email,
    String? studyProgram,
  }) {
    state = UserProfile(
      id: 'local-user',
      fullName: name,
      email: email,
      studyProgram: studyProgram,
      semester: 1,
    );
  }

  void updateProfile(UserProfile profile) {
    state = profile;
  }

  void logout() {
    state = null;
  }
}
