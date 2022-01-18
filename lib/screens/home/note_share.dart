import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_app/data/user_dao.dart';
import 'package:my_app/di/injection_container.dart';
import 'package:my_app/models/user.dart';
import 'package:my_app/services/auth_service.dart';

class ShareNote extends StatefulWidget {
  final int noteKey;
  const ShareNote({Key? key, required this.noteKey}) : super(key: key);

  @override
  _ShareNoteState createState() => _ShareNoteState();
}

class _ShareNoteState extends State<ShareNote> {
  final UserDao _dao = sl.get<UserDao>();
  final AuthService _auth = sl.get<AuthService>();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  Key _listKey = Key('first');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown,
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
      ),
      body: Column(
        children: [
          _buildSearchBox(),
          Flexible(
            child: FirebaseAnimatedList(
              key: _listKey,
              query: _dao.getUserByName(_searchQuery),
              itemBuilder: (context, snapshot, animation, index) {
                final json = snapshot.value as Map<dynamic, dynamic>;
                final user = CustomUser.fromJsonAndKey(json, snapshot.key!);
                final bool isCurrentUser = user.uid == _auth.getCurrentUser().uid;
                return isCurrentUser? const SizedBox() : ListTile(
                  onTap: () {
                    _dao.shareNote(user.uid, widget.noteKey, user.displayName!);
                    showDialog(
                        context: context,
                        builder: (_) => const AlertDialog(
                          title: Text('Note shared!'),
                        )
                    );
                  },
                  title: Text(user.displayName!),
                );
              },
            ),
          )
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
            onChanged: _onSearchTextChanged,
          ),
          trailing: IconButton(
            icon: const Icon(Icons.cancel),
            onPressed: () {
              _searchController.clear();
              _onSearchTextChanged('');
            },
          ),
        ),
      ),
    );
  }

  void _onSearchTextChanged(String text) => setState(() {
    _searchQuery = text;
    _listKey = Key(_searchQuery);
  });
}
