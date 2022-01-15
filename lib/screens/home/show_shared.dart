
import 'package:firebase_database/ui/firebase_animated_list.dart';
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
      body: FirebaseAnimatedList(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        query: _dao.getSharedWithMeRef(),
        itemBuilder: (context, snapshot, animation, index) {
          final json = snapshot.value as Map<dynamic, dynamic>;
          final name = json['name'] as String;
          return ListTile(
            title: Text(name),
            subtitle: _buildSharedFromUserNotes(snapshot.key!),
          );
        }
      )
    );
  }

  Widget _buildSharedFromUserNotes(String senderUid) {
    return FirebaseAnimatedList(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        query: _dao.getSharedNotes(senderUid),
        itemBuilder:  (context, snapshot, animation, index) {
          final json = snapshot.value as Map<dynamic, dynamic>;
          final note = Note.fromJson(json);
          return ListTile(
            title: Text(note.title),
            subtitle: Text(note.text),
          );
        }
    );
  }

}
