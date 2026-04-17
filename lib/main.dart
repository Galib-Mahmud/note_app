import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:glassy_notes_app/app/themes/app_theme.dart';
import 'package:glassy_notes_app/controllers/auth_controller.dart';
import 'package:glassy_notes_app/views/splash_screen.dart';
import 'package:glassy_notes_app/views/login_page.dart';
import 'package:glassy_notes_app/views/registration_page.dart';
import 'package:glassy_notes_app/views/home_page.dart';
import 'package:glassy_notes_app/views/add_note_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Glassy Notes',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      initialBinding: BindingsBuilder(() {
        Get.put(AuthController(), permanent: true);
      }),
      initialRoute: '/splash',
      getPages: [
        GetPage(name: '/splash', page: () => const SplashScreen()),
        GetPage(name: '/login', page: () => const LoginPage()),
        GetPage(name: '/register', page: () => const RegistrationPage()),
        GetPage(name: '/home', page: () => const HomePage()),
        GetPage(name: '/add-note', page: () => const AddNotePage()),
      ],
    );
  }
}