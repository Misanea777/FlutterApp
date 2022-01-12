import 'package:firebase_database/firebase_database.dart';
import 'package:my_app/models/note.dart';
import 'package:my_app/services/auth_service.dart';

class UserDao {
  AuthService auth;
  final DatabaseReference _usersRef =
      FirebaseDatabase.instance.ref('users');

  UserDao({required this.auth});

  void initUser() {
    saveNote(Note('First note', 'This is the first note!'), DateTime.now().toUtc().millisecondsSinceEpoch);
  }

  void saveNote(Note note, int key) {
    _usersRef.child("${auth.getCurrentUser().uid}/notes/${key.toString()}").ref
        .set(note.toJson());
  }

  DatabaseReference getNotesRef() =>  _usersRef.child("${auth.getCurrentUser().uid}/notes").ref;

}