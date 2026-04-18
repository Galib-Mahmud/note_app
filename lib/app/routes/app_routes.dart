import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:glassy_notes_app/views/splash_screen.dart';
import 'package:glassy_notes_app/views/login_page.dart';
import 'package:glassy_notes_app/views/registration_page.dart';
import 'package:glassy_notes_app/views/home_page.dart';
import 'package:glassy_notes_app/views/add_note_page.dart';
import 'package:glassy_notes_app/controllers/auth_controller.dart';
import 'package:glassy_notes_app/main.dart'; // ✅ navigatorKey
import 'package:get/get.dart';

class AppRouter {
  final AuthController authController = Get.find<AuthController>();

  late final GoRouter router = GoRouter(
    navigatorKey: navigatorKey, // ✅
    initialLocation: '/splash',
    redirect: (context, state) {
      final isLoggedIn = authController.isLoggedIn.value;
      final path = state.uri.toString();

      final isPublic = path == '/splash' ||
          path == '/login' ||
          path == '/register';

      if (isLoggedIn && isPublic) return '/home';
      if (!isLoggedIn && !isPublic) return '/login';
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