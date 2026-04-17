import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:glassy_notes_app/app/routes/app_routes.dart';
import 'package:glassy_notes_app/app/themes/app_theme.dart';
import 'package:glassy_notes_app/controllers/auth_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // ✅ Put AuthController before runApp so AppRouter can find it
  Get.put(AuthController(), permanent: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router( // ✅ plain MaterialApp.router, not GetMaterialApp
      title: 'Glassy Notes',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      routerConfig: AppRouter().router, // ✅ now works correctly
    );
  }
}