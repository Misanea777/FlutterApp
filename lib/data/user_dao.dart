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
        .update(note.toJson());
  }

  void saveForeignNote(Note note, int key, String senderUid) {
    _usersRef.child("$senderUid/notes/${key.toString()}").ref
        .update(note.toJson());
  }

  DatabaseReference getNotesRef() =>  _usersRef.child("${auth.getCurrentUser().uid}/notes").ref;

  DatabaseReference getSharedWithMeRef() =>  _usersRef.child("${auth.getCurrentUser().uid}/sharedWithMe").ref;

  Query getUserByName(String queryText) {
    Query q = _usersRef.orderByChild('name')
      .startAt(queryText)
      .endAt("$queryText\uf8ff");
    return q;
  }

  void shareNote(String receiverUid, int key, String receiverName) {
    getNotesRef().child(key.toString()).update({receiverUid: receiverName});
    _usersRef.child(receiverUid).child('sharedWithMe')
        .child(auth.getCurrentUser().uid)
        .update({'name': auth.getCurrentUser().displayName});
  }



  Query getSharedNotes(String senderUid) {
    // getNotesRef().orderByChild('V3MBkJelO1br4YUpwUwbx28lQWD2')
    //     .equalTo('Mihail Filipescu')
    //     .get()
    //     .then((value) => print(value.value));
    return _usersRef.child(senderUid).child('notes')
        .orderByChild(auth.getCurrentUser().uid)
        .equalTo(auth.getCurrentUser().displayName);
  }
}