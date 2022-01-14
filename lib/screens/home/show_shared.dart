import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_app/data/user_dao.dart';
import 'package:my_app/di/injection_container.dart';
import 'package:my_app/models/note.dart';

class ShowSharedNotes extends StatefulWidget {
  const ShowSharedNotes({Key? key}) : super(key: key);

  @override
  _ShowSharedNotesState createState() => _ShowSharedNotesState();
}

class _ShowSharedNotesState extends State<ShowSharedNotes> {
  final UserDao _dao = sl.get<UserDao>();
  List<Note> _sharedNotes = List.empty();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown,
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
      ),
      body: ListView.builder(
        itemBuilder: (context, int) {
          _dao.getSharedWithMeNotes().get().then((value) => print(value.value));
          _dao.getSharedWithMeNotes().onChildChanged.forEach((element) {
            print(element.snapshot.value);
          });
          return ListTile(

          );
        },
      ),
    );
  }

  // void _initializeData() {
  //   _dao.getSharedWithMeNotes().get().then((noteList)  {
  //     final json = noteList.value as Map<dynamic, dynamic>;
  //     _dao.getNoteByUserAndId(uid, noteId)
  //   });
  //   _sharedNotes.add(value)
  // }
}
