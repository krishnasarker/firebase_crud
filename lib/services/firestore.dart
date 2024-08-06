import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class FirestoreService{

  //get collection of note

  final CollectionReference notes=FirebaseFirestore.instance.collection("notes");

  //Create
  Future <void> addNote(String note){
  return notes.add({
    "note": note,
    "timestamp":Timestamp.now(),
  });
  }
  //Read get note from database
  Stream <QuerySnapshot> getNoteStream(){
  final noteStream=notes.orderBy("timestamp",descending: true).snapshots();
  return noteStream;
}
  //Update
Future <void> updateNote(String docID, String newNote){
 return notes.doc(docID).update({
   "note": newNote,
   "timestamp": Timestamp.now()
 });
}


  //Delete
Future <void> deleteNote(String docId){
return notes.doc(docId).delete();
}

}