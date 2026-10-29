import 'package:go_router/go_router.dart';

import '../../features/auth/login_page.dart';
import '../../features/auth/register_page.dart';
import '../../features/cv/cv_editor_page.dart';
import '../../features/cv/cv_list_page.dart';
import '../../features/cv/cv_preview_page.dart';
import '../../features/cv/cv_template_page.dart';
import '../../features/home/home_page.dart';
import '../../features/learn/learn_detail_page.dart';
import '../../features/learn/learn_page.dart';
import '../../features/portfolio/portfolio_form_page.dart';
import '../../features/portfolio/portfolio_page.dart';
import '../../features/portfolio/portfolio_preview_page.dart';
import '../../features/profile/privacy_page.dart';
import '../../features/profile/profile_edit_page.dart';
import '../../features/profile/profile_page.dart';
import '../../features/readiness/readiness_intro_page.dart';
import '../../features/readiness/readiness_quiz_page.dart';
import '../../features/readiness/readiness_result_page.dart';
import '../../features/safe/safe_checklist_page.dart';
import '../../features/safe/safe_job_page.dart';

final appRouter = GoRouter(
  initialLocation: '/home',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/readiness',
      builder: (context, state) => const ReadinessIntroPage(),
    ),
    GoRoute(
      path: '/readiness/quiz',
      builder: (context, state) => const ReadinessQuizPage(),
    ),
    GoRoute(
      path: '/readiness/result',
      builder: (context, state) => const ReadinessResultPage(),
    ),
    GoRoute(
      path: '/cv',
      builder: (context, state) => const CvListPage(),
    ),
    GoRoute(
      path: '/cv/editor',
      builder: (context, state) => const CvEditorPage(),
    ),
    GoRoute(
      path: '/cv/template',
      builder: (context, state) => const CvTemplatePage(),
    ),
    GoRoute(
      path: '/cv/preview',
      builder: (context, state) => const CvPreviewPage(),
    ),
    GoRoute(
      path: '/portfolio',
      builder: (context, state) => const PortfolioPage(),
    ),
    GoRoute(
      path: '/portfolio/form',
      builder: (context, state) => const PortfolioFormPage(),
    ),
    GoRoute(
      path: '/portfolio/preview/:id',
      builder: (context, state) => PortfolioPreviewPage(
        projectId: state.pathParameters['id']!,
      ),
    ),
    GoRoute(
      path: '/learn',
      builder: (context, state) => const LearnPage(),
    ),
    GoRoute(
      path: '/learn/:slug',
      builder: (context, state) => LearnDetailPage(
        slug: state.pathParameters['slug']!,
      ),
    ),
    GoRoute(
      path: '/safe',
      builder: (context, state) => const SafeJobPage(),
    ),
    GoRoute(
      path: '/safe/checklist',
      builder: (context, state) => const SafeChecklistPage(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfilePage(),
    ),
    GoRoute(
      path: '/profile/edit',
      builder: (context, state) => const ProfileEditPage(),
    ),
    GoRoute(
      path: '/profile/privacy',
      builder: (context, state) => const PrivacyPage(),
    ),
  ],
);
