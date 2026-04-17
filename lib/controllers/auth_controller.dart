import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:glassy_notes_app/core/firebase/firebase_service.dart';

class AuthController extends GetxController {
  final FirebaseService _firebaseService = FirebaseService();

  final RxBool isLoading = false.obs;
  final RxBool isLoggedIn = false.obs;
  final RxString errorMessage = ''.obs;

  void _showSnackbar(String message, {bool isError = false}) {
    final context = Get.context;
    if (context == null) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  void onInit() {
    super.onInit();
    _checkAuthStatus();
  }

  void _checkAuthStatus() {
    isLoggedIn.value = _firebaseService.getCurrentUser() != null;
  }

  Future<void> signUp(String email, String password, String name) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final user = await _firebaseService.signUp(email, password, name);
      if (user != null) {
        isLoggedIn.value = false;
        _showSnackbar('Account created! Please sign in.');
        // ✅ After signup → go to login
        final context = Get.context;
        if (context != null) {
          GoRouter.of(context).go('/login');
        }
      }
    } catch (e) {
      errorMessage.value = e.toString();
      _showSnackbar(errorMessage.value, isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signIn(String email, String password) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final user = await _firebaseService.signIn(email, password);
      if (user != null) {
        isLoggedIn.value = true;
        _showSnackbar('Welcome back!');
        // ✅ After signin → go to home
        final context = Get.context;
        if (context != null) GoRouter.of(context).go('/home');
      }
    } catch (e) {
      errorMessage.value = e.toString();
      _showSnackbar(errorMessage.value, isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    await _firebaseService.signOut();
    isLoggedIn.value = false;
    final context = Get.context;
    if (context != null) GoRouter.of(context).go('/login');
  }
}