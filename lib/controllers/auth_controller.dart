import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:glassy_notes_app/core/firebase/firebase_service.dart';
import 'package:glassy_notes_app/main.dart';

class AuthController extends GetxController {
  final FirebaseService _firebaseService = FirebaseService();

  final RxBool isLoading = false.obs;
  final RxBool isLoggedIn = false.obs;
  final RxString errorMessage = ''.obs;

  void _showSnackbar(String message, {bool isError = false}) {
    final context = navigatorKey.currentContext;
    if (context == null) {
      debugPrint('❌ Snackbar context is null');
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _navigate(String path) {
    final context = navigatorKey.currentContext;
    debugPrint('🧭 Navigating to $path — context null: ${context == null}');
    if (context == null) return;
    GoRouter.of(context).go(path);
  }

  // ✅ strips "Exception: " prefix cleanly
  String _cleanError(Object e) {
    return e.toString().replaceFirst('Exception: ', '');
  }

  @override
  void onInit() {
    super.onInit();
    _checkAuthStatus();
  }

  void _checkAuthStatus() {
    final user = _firebaseService.getCurrentUser();
    isLoggedIn.value = user != null;
    debugPrint('🔍 Auth check — isLoggedIn: ${isLoggedIn.value}');
  }

  Future<void> signUp(String email, String password, String name) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final user = await _firebaseService.signUp(email, password, name);
      debugPrint('📝 SignUp result — user: $user');
      if (user != null) {
        isLoggedIn.value = false;
        _showSnackbar('Account created! Please sign in.');
        _navigate('/login');
      }
    } catch (e) {
      debugPrint('❌ SignUp error: $e');
      errorMessage.value = _cleanError(e); // ✅
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
      debugPrint('🔐 SignIn result — user: $user');
      if (user != null) {
        isLoggedIn.value = true;
        debugPrint('✅ isLoggedIn set to true, navigating to /home');
        _showSnackbar('Welcome back!');
        _navigate('/home');
      } else {
        debugPrint('❌ SignIn returned null user');
      }
    } catch (e, stack) {
      debugPrint('❌ SignIn error: $e');
      debugPrint('📚 Stack: $stack');
      errorMessage.value = _cleanError(e); // ✅
      _showSnackbar(errorMessage.value, isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    await _firebaseService.signOut();
    isLoggedIn.value = false;
    debugPrint('🚪 Signed out, navigating to /login');
    _navigate('/login');
  }
}