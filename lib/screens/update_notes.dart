import 'package:flutter/material.dart';
import 'package:myapp/screens/services/firebase_services.dart';

class UpdateNotes extends StatefulWidget {
final Map <String,dynamic> note;
final String id;
  const UpdateNotes({super.key, required this.note, required this.id});

  @override
  State<UpdateNotes> createState() => _UpdateNotesState();
}

class _UpdateNotesState extends State<UpdateNotes> {
  final TextEditingController titleController = TextEditingController();

  final TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Note'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Update Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: descriptionController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Update Description',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Map<String , dynamic> note = {
                  "title": titleController.text,
                  "description": descriptionController.text,
                };
                String msg = "";
                if (note["title"].toString().isNotEmpty &&
                    note["description"].toString().isNotEmpty) {
                    FirebaseServices.updateNoteFromDb(widget.id, note);
                  msg = "Note created successfully";
                  titleController.text = "";
                  descriptionController.text = "";
                  Navigator.pop(context);
                } else {
                  msg = "Empty note discarded";
                }
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(msg)));
              },
              child: const Text('Update Note'),
            ),
          ],
        ),
      ),
    );
  }
}
