import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_app/data/user_dao.dart';
import 'package:my_app/di/injection_container.dart';
import 'package:my_app/models/note.dart';
import 'package:my_app/util/extensions.dart';

class CreateNote extends StatefulWidget {
  const CreateNote({Key? key}) : super(key: key);

  @override
  _CreateNoteState createState() => _CreateNoteState();
}

class _CreateNoteState extends State<CreateNote> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final UserDao _dao = sl.get<UserDao>();
  String title = '';
  String text = '';
  String err = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown,
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
      ),
      body: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 20.0,),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Title'),
                  validator: (val) =>
                  val!.isEmpty
                      ? 'Title cannot be empty'
                      : null,
                  onChanged: (val) {
                    setState(() {
                      title = val;
                    });
                  },
                ),
                const SizedBox(height: 20.0,),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Text'),
                  validator: (val) => null,
                  onChanged: (val) {
                    setState(() {
                      text = val;
                    });
                  },
                ),
                const SizedBox(height: 20.0,),
                ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        try {
                          _dao.createNote(Note(title, text));
                          Navigator.pop(context);
                        } catch (e) {
                          setState(() {
                            err = e.toString().cutAllBefore(']');
                          });
                        }
                      }
                    },
                    child: Text(
                      'Create',
                      style: TextStyle(color: Colors.white),
                    )
                ),
                SizedBox(height: 12.0,),
                Text(
                  err,
                  style: TextStyle(color: Colors.red, fontSize: 14.0),
                )
              ],
            ),
          )
      ),
    );
  }
}
