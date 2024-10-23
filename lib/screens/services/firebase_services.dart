import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseServices {
  static final CollectionReference notes =
      FirebaseFirestore.instance.collection("notes");

  static Future<void> addNoteToDb(Map<String, dynamic> note) {
    return notes.add(note);
  }

  static Stream<QuerySnapshot> getAllNotes() {
    final notesStream = notes.snapshots();
    return notesStream;
  }

static Future<void> deleteNoteFromDb(String docId){
  return notes.doc(docId).delete();
}

static Future<void> updateNoteFromDb(String docId,Map<String ,dynamic>note){
  return notes.doc(docId).update(note);
}
}