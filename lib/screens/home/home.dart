import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:my_app/data/user_dao.dart';
import 'package:my_app/di/injection_container.dart';
import 'package:my_app/models/note.dart';
import 'package:my_app/models/notification.dart';
import 'package:my_app/screens/menus/drawer.dart';
import 'package:my_app/services/auth_service.dart';

import 'note_create.dart';


class Home extends StatefulWidget {
  PushNotification _notification;
  Home(PushNotification this._notification);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final UserDao _dao = sl.get<UserDao>();
  final ScrollController _controller = ScrollController(keepScrollOffset: false);

  bool _isScrollDownButtonVisible = true;

  void _scrollDown() {
    _controller.jumpTo(_controller.position.maxScrollExtent);
  }

  void _toggleButtonVisible() => setState(() {_isScrollDownButtonVisible = !_isScrollDownButtonVisible;});


  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      (_controller.position.atEdge && _controller.position.pixels != 0) ?
        _toggleButtonVisible() : !_isScrollDownButtonVisible ? _toggleButtonVisible()  : null;

    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Visibility(
            visible: _isScrollDownButtonVisible,
            child: FloatingActionButton(
              heroTag: 'scrollDonwBtn',
              child: const Icon(Icons.arrow_downward_rounded),
              onPressed: () => _scrollDown(),
            ),
          ),
          const SizedBox(width: 20),
          FloatingActionButton(
            heroTag: 'createBtn',
            child: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateNote())
              );
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      backgroundColor: Colors.brown,
      appBar: AppBar(
        actionsIconTheme: const IconThemeData(
            size: 30.0,
            color: Colors.black,
            opacity: 10.0
        ),
        title: Text('Notes'),
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        actions: [
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {},
                child: const Icon(
                  Icons.search,
                  size: 26.0,
                ),
              )
          ),
          Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {},
                child: const Icon(
                    Icons.more_vert
                ),
              )
          ),
        ],
      ),
      body: Column(
        children: [
          Flexible(
            child: FirebaseAnimatedList(
              controller: _controller,
              query: _dao.getNotesRef(),
              itemBuilder: (context, snapshot, animation, index) {
                final json = snapshot.value as Map<dynamic, dynamic>;
                final note = Note.fromJson(json);
                return ListTile(
                  title: Text(
                      note.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20.0,
                      ),
                  ),
                  subtitle: Text(
                      note.text,
                    style: const TextStyle(
                      fontSize: 15.0,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}


