import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:glassy_notes_app/controllers/auth_controller.dart';
import 'package:glassy_notes_app/controllers/note_controller.dart';
import 'package:glassy_notes_app/widgets/glass_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final noteController = Get.put(NoteController());

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFDCEEFD),
              Color(0xFFEDE7F6),
              Color(0xFFFCE4EC),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ── Header ──
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 12, 8),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.note_alt_rounded,
                          color: Color(0xFF6C63FF), size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('My Notes',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[900],
                              )),
                          Obx(() => Text(
                            '${noteController.notes.length} notes',
                            style: TextStyle(
                                fontSize: 13, color: Colors.grey[600]),
                          )),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => _confirmSignOut(context, authController),
                      icon: Icon(Icons.logout_rounded, color: Colors.grey[700]),
                      tooltip: 'Sign out',
                    ),
                  ],
                ),
              ),

              // ── Notes list ──
              Expanded(
                child: Obx(() {
                  if (noteController.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (noteController.notes.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Icon(Icons.note_add_outlined,
                                size: 44, color: Colors.grey[500]),
                          ),
                          const SizedBox(height: 20),
                          Text('No notes yet',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[700])),
                          const SizedBox(height: 8),
                          Text('Tap + to create your first note',
                              style: TextStyle(
                                  fontSize: 14, color: Colors.grey[500])),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                    itemCount: noteController.notes.length,
                    itemBuilder: (context, index) {
                      final note = noteController.notes[index];
                      return _NoteCard(
                        note: note,
                        onTap: () => _showEditDialog(
                            context, noteController, note.id,
                            note.title, note.description),
                        onDelete: () => _showDeleteConfirmation(
                            context, noteController, note.id),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/add-note'),
        icon: const Icon(Icons.add),
        label: const Text('New Note'),
        backgroundColor: const Color(0xFF6C63FF),
        foregroundColor: Colors.white,
      ),
    );
  }

  void _confirmSignOut(BuildContext context, AuthController authController) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sign out?'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              authController.signOut();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Sign out'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, NoteController noteController,
      String noteId, String currentTitle, String currentDescription) {
    final titleController = TextEditingController(text: currentTitle);
    final descController = TextEditingController(text: currentDescription);
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: GlassCard(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Edit Note',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[900])),
                const SizedBox(height: 16),
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(
                      labelText: 'Title', border: OutlineInputBorder()),
                  validator: (v) =>
                  v == null || v.isEmpty ? 'Enter a title' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: descController,
                  decoration: const InputDecoration(
                      labelText: 'Description', border: OutlineInputBorder()),
                  maxLines: 4,
                  validator: (v) =>
                  v == null || v.isEmpty ? 'Enter a description' : null,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6C63FF),
                            foregroundColor: Colors.white),
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            noteController.updateNote(noteId,
                                titleController.text, descController.text);
                            Navigator.pop(ctx);
                          }
                        },
                        child: const Text('Update'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(
      BuildContext context, NoteController noteController, String noteId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete note?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              noteController.deleteNote(noteId);
              Navigator.pop(ctx);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

// ── Note card widget ──
class _NoteCard extends StatelessWidget {
  final dynamic note;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _NoteCard(
      {required this.note, required this.onTap, required this.onDelete});

  String _formatDate(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inDays > 7) return '${date.day}/${date.month}/${date.year}';
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m ago';
    return 'Just now';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.55),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.8), width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      note.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[900],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  GestureDetector(
                    onTap: onDelete,
                    child: Icon(Icons.delete_outline,
                        size: 20, color: Colors.grey[500]),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                note.description,
                style: TextStyle(
                    fontSize: 14, color: Colors.grey[700], height: 1.5),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.access_time_rounded,
                      size: 12, color: Colors.grey[500]),
                  const SizedBox(width: 4),
                  Text(
                    _formatDate(note.updatedAt),
                    style:
                    TextStyle(fontSize: 12, color: Colors.grey[500]),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}