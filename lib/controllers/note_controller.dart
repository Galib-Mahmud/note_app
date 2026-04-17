import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:glassy_notes_app/core/firebase/firebase_service.dart';
import 'package:glassy_notes_app/models/note_model.dart';

class NoteController extends GetxController {
  final FirebaseService _firebaseService = FirebaseService();

  final RxList<NoteModel> notes = <NoteModel>[].obs;
  final RxBool isLoading = true.obs;

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
      _showSnackbar('Note added successfully');
      final context = Get.context;
      if (context != null) GoRouter.of(context).go('/home');
    } catch (e) {
      _showSnackbar('Failed to add note', isError: true);
    }
  }

  Future<void> updateNote(String noteId, String title, String description) async {
    try {
      await _firebaseService.updateNote(noteId, title, description);
      _showSnackbar('Note updated successfully');
    } catch (e) {
      _showSnackbar('Failed to update note', isError: true);
    }
  }

  Future<void> deleteNote(String noteId) async {
    try {
      await _firebaseService.deleteNote(noteId);
      _showSnackbar('Note deleted successfully');
    } catch (e) {
      _showSnackbar('Failed to delete note', isError: true);
    }
  }
}