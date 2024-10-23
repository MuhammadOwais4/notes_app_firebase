import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myapp/screens/create_note.dart';
import 'package:myapp/screens/services/firebase_services.dart';
import 'package:myapp/screens/update_notes.dart';


class ShowNotes extends StatefulWidget {
  const ShowNotes({super.key});

  @override
  State<ShowNotes> createState() => _ShowNotesState();
}

class _ShowNotesState extends State<ShowNotes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Show Notes'),
      ),
      body: StreamBuilder(
        stream: FirebaseServices.getAllNotes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator.adaptive();
          } else if (
              snapshot.hasData) {
                List notes = snapshot.data!.docs;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Number of cards in each row
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                ),
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot noteDoc=notes[index];
                  String docId=noteDoc.id;
                  Map<String,dynamic> note=
                  noteDoc.data() as Map <String,dynamic>;
                  return GestureDetector(
                    onTap: () {
                    Navigator.push(context,
                      MaterialPageRoute(builder: (context){
                        return UpdateNotes(note: note,id:  docId);
                      })
                    );
                    },
                    onLongPress: (){
                      showDialog(context: context, builder: (context){
                        return  AlertDialog(
                          title: const Text("Are you sure ?"),
                          actions: [
                            TextButton(onPressed: (){
                              Navigator.pop(context);
                            }, child: const Text("No")),
                             TextButton(onPressed: (){
                          FirebaseServices.deleteNoteFromDb(docId);
                              Navigator.pop(context);
                            }, child: const Text("delete"))
                             ],
                             

                             
                        );
                      });
                    },
                    child: Card(
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              notes[index]['title']!,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              notes[index]['description']!,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          } else {
            return const Text('No notes found');
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return CreateNote();
              },
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
