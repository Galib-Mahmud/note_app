import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glassy_notes_app/core/firebase/firebase_service.dart';

class AuthController extends GetxController {
  final FirebaseService _firebaseService = FirebaseService();

  final RxBool isLoading = false.obs;
  final RxBool isLoggedIn = false.obs;
  final RxString errorMessage = ''.obs;

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
        isLoggedIn.value = true;
        Get.snackbar(
          'Success',
          'Account created successfully!',
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Colors.white,
      );
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
        Get.snackbar(
          'Success',
          'Welcome back!',
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    await _firebaseService.signOut();
    isLoggedIn.value = false;
    Get.offAllNamed('/login');
  }
}