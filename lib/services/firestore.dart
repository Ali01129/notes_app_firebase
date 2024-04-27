import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService{

  //notes
  final CollectionReference notes=FirebaseFirestore.instance.collection('notes');
  //create note
  Future <void> addNote(String note){
    return notes.add({
      'note':note,
      'timestamp':Timestamp.now(),
    });
  }

  //read note

  Stream<QuerySnapshot> getNoteStream(){
      final noteStream=notes.orderBy('timestamp',descending: true).snapshots();
      return noteStream;
  }

  //update note

  Future<void> updateNote(String docID,String newnote){
    return notes.doc(docID).update({
      'note':newnote,
      'timestamp':Timestamp.now(),
    });
  }

  //delete note

  Future<void> deleteNote(String docID){
    return notes.doc(docID).delete();
  }

}