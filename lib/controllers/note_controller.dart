import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glassy_notes_app/core/firebase/firebase_service.dart';
import 'package:glassy_notes_app/models/note_model.dart';

class NoteController extends GetxController {
  final FirebaseService _firebaseService = FirebaseService();

  final RxList<NoteModel> notes = <NoteModel>[].obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    listenToNotes();
  }

  void listenToNotes() {
    _firebaseService.getNotes().listen((noteList) {
      notes.value = noteList;
      isLoading.value = false;
    });
  }

  Future<void> addNote(String title, String description) async {
    try {
      await _firebaseService.addNote(title, description);
      Get.back();
      Get.snackbar(
        'Success',
        'Note added successfully',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to add note',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Colors.white,
      );
    }
  }

  Future<void> updateNote(String noteId, String title, String description) async {
    try {
      await _firebaseService.updateNote(noteId, title, description);
      Get.back();
      Get.snackbar(
        'Success',
        'Note updated successfully',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update note',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Colors.white,
      );
    }
  }

  Future<void> deleteNote(String noteId) async {
    try {
      await _firebaseService.deleteNote(noteId);
      Get.snackbar(
        'Success',
        'Note deleted successfully',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete note',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Colors.white,
      );
    }
  }
}