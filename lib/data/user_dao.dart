import 'package:firebase_database/firebase_database.dart';
import 'package:my_app/models/note.dart';
import 'package:my_app/services/auth_service.dart';

class UserDao {
  AuthService auth;
  final DatabaseReference _usersRef =
      FirebaseDatabase.instance.ref('users');

  UserDao({required this.auth});

  void initUser() {
    _usersRef.child(auth.getCurrentUser().uid).set({'name': auth.getCurrentUser().displayName!});
    saveNote(Note('First note', 'This is the first note!'), DateTime.now().toUtc().millisecondsSinceEpoch);
  }

  void saveNote(Note note, int key) {
    _usersRef.child("${auth.getCurrentUser().uid}/notes/${key.toString()}").ref
        .set(note.toJson());
  }

  DatabaseReference getNotesRef() =>  _usersRef.child("${auth.getCurrentUser().uid}/notes").ref;

  Query getUserByName(String queryText) {
    Query q = _usersRef.orderByChild('name')
      .startAt(queryText)
      .endAt("$queryText\uf8ff");
    return q;
  }

  void shareNote(String receiver, int noteId) {
    _usersRef.child(receiver).child('sharedWithMe')
        .update({noteId.toString(): auth.getCurrentUser().uid});
  }

  DatabaseReference getSharedWithMeNotes() {
    return _usersRef.child(auth.getCurrentUser().uid).child('sharedWithMe')
        .ref;
  }

  Future<DataSnapshot> getNoteByUserAndId(String uid, int noteId) {
    return _usersRef.child(uid).child('notes').child(noteId.toString()).ref.get();
  }
}