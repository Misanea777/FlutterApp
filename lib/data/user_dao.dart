import 'package:firebase_database/firebase_database.dart';
import 'package:my_app/models/Note.dart';
import 'package:my_app/services/authserv.dart';

class UserDao {
  final AuthService _auth = AuthService();
  final DatabaseReference _usersRef =
      FirebaseDatabase.instance.ref('users');

  void saveUser() {
    createNote(Note('First post', 'This is the first post!'));
  }

  void createNote(Note note) {
    _usersRef.child("${_auth.getCurrentUser().uid}/posts/${DateTime.now().toUtc().millisecondsSinceEpoch}").ref
        .set(note.toJson());
  }

  DatabaseReference getPostsRef() =>  _usersRef.child("${_auth.getCurrentUser().uid}/posts").ref;

}