import 'package:firebase_database/firebase_database.dart';
import 'package:my_app/models/note.dart';
import 'package:my_app/services/auth_service.dart';

class UserDao {
  final AuthService _auth = AuthService();
  final DatabaseReference _usersRef =
      FirebaseDatabase.instance.ref('users');

  void initUser() {
    createNote(Note('First note', 'This is the first note!'));
  }

  void createNote(Note note) {
    _usersRef.child("${_auth.getCurrentUser().uid}/notes/${DateTime.now().toUtc().millisecondsSinceEpoch}").ref
        .set(note.toJson());
  }

  DatabaseReference getNotesRef() =>  _usersRef.child("${_auth.getCurrentUser().uid}/notes").ref;

}