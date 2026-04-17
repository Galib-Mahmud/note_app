import 'package:go_router/go_router.dart';
import 'package:glassy_notes_app/views/splash_screen.dart';
import 'package:glassy_notes_app/views/login_page.dart';
import 'package:glassy_notes_app/views/registration_page.dart';
import 'package:glassy_notes_app/views/home_page.dart';
import 'package:glassy_notes_app/views/add_note_page.dart';
import 'package:glassy_notes_app/controllers/auth_controller.dart';
import 'package:get/get.dart';

class AppRouter {
  final AuthController authController = Get.find<AuthController>();

  late final GoRouter router = GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) {
      final isLoggedIn = authController.isLoggedIn.value;
      final isSplash = state.uri.toString() == '/splash';
      final isLogin = state.uri.toString() == '/login';
      final isRegister = state.uri.toString() == '/register';

      if (isLoggedIn && (isLogin || isRegister || isSplash)) {
        return '/home';
      }

      if (!isLoggedIn && !isLogin && !isRegister && !isSplash) {
        return '/login';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegistrationPage(),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/add-note',
        name: 'add-note',
        builder: (context, state) => const AddNotePage(),
      ),
    ],
  );
}