import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:my_app/data/user_dao.dart';
import 'package:my_app/di/injection_container.dart';
import 'package:my_app/models/note.dart';
import 'package:my_app/models/notification.dart';
import 'package:my_app/screens/menus/drawer.dart';
import 'package:tuple/tuple.dart';

import 'create_save.dart';
import 'note_update.dart';

class Home extends StatefulWidget {
  PushNotification _notification;
  Home(PushNotification this._notification);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final UserDao _dao = sl.get<UserDao>();
  final ScrollController _controller = ScrollController(keepScrollOffset: false);
  final TextEditingController _searchController = TextEditingController();

  bool _isScrollDownButtonVisible = true;
  bool _isSearchBarVisible = false;

  String _searchQuery = '';

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
                onTap: () => setState(() {
                  _isSearchBarVisible = !_isSearchBarVisible;
                }),
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
          Visibility(
              visible: _isSearchBarVisible,
              child: _buildSearchBox()
          ),
          Flexible(
            child: FirebaseAnimatedList(
              controller: _controller,
              query: _dao.getNotesRef(),
              itemBuilder: (context, snapshot, animation, index) {
                final json = snapshot.value as Map<dynamic, dynamic>;
                final note = Note.fromJson(json);
                final Tuple2 matched = _isMatched(note, _searchQuery);
                final bool notMatched = (matched.item1 <0 && matched.item2 <0);
                return notMatched? const SizedBox() : ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UpdateNote(note, int.parse(snapshot.key!)))
                    );
                  },
                  title: _buildHighlightedText(note.title, matched.item1,
                      const TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500)),
                  subtitle: _buildHighlightedText(note.text, matched.item2,
                      const TextStyle(fontSize: 15.0, fontWeight: FontWeight.normal)),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBox() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: ListTile(
          leading: const Icon(Icons.search),
          title: TextField(
            controller: _searchController,
            decoration: const InputDecoration(
                hintText: 'Search', border: InputBorder.none),
            onChanged: onSearchTextChanged,
          ),
          trailing: IconButton(
            icon: const Icon(Icons.cancel),
            onPressed: () {
              _searchController.clear();
              onSearchTextChanged('');
            },
          ),
        ),
      ),
    );
  }

  void onSearchTextChanged(String text) => setState(() {
    _searchQuery = text;
  });

  Tuple2<int, int> _isMatched(Note note, String query) => Tuple2(
      _getIndexOfMatch(note.title, query),
      _getIndexOfMatch(note.text, query));

  int _getIndexOfMatch(String text, String query) => text.toLowerCase().indexOf(query.toLowerCase());

  Widget _buildHighlightedText(String text, int matchIndex, TextStyle style) {
    return matchIndex<0? Text(text) :
        RichText(
          text:TextSpan(
            text: text.substring(0, matchIndex),
            style: TextStyle(color: Colors.black, fontSize: style.fontSize, fontWeight: style.fontWeight),
            children: [
              TextSpan(
                text: text.substring(matchIndex, matchIndex+_searchQuery.length),
                style: TextStyle(color: Colors.amber, fontSize: style.fontSize, fontWeight: style.fontWeight),
              ),
              TextSpan(
                text: text.substring(matchIndex+_searchQuery.length),
                style: TextStyle(color: Colors.black, fontSize: style.fontSize, fontWeight: style.fontWeight),
              ),
            ]
          ),
        );
  }

}


