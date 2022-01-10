import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:my_app/data/user_dao.dart';
import 'package:my_app/models/Note.dart';
import 'package:my_app/models/notification.dart';
import 'package:my_app/services/authserv.dart';

import 'note_create.dart';


class Home extends StatelessWidget {
  PushNotification _notification;
  Home(PushNotification this._notification);
  final AuthService _auth = AuthService();
  final UserDao _dao = UserDao();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown,
      appBar: AppBar(
        title: Text('MyApp'),
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        actions: [
          TextButton.icon(
              onPressed: () async {
                _auth.singOut();
              },
              icon: Icon(Icons.pedal_bike),
              label: Text('Logout')
          )
        ],
      ),
      body: Column(
        children: [
          Flexible(
            child: FirebaseAnimatedList(
              query: _dao.getPostsRef(),
              itemBuilder: (context, snapshot, animation, index) {
                final json = snapshot.value as Map<dynamic, dynamic>;
                final note = Note.fromJson(json);
                return ListTile(
                  title: Text(note.title),
                  subtitle: Text(note.text),
                );
              },
            ),
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => CreateNote())
                );
              },
              child: Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}


