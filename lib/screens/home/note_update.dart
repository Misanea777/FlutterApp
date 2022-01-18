import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_app/di/injection_container.dart';
import 'package:my_app/models/note.dart';
import 'package:my_app/services/user_service.dart';
import 'package:my_app/util/extensions.dart';

class UpdateNote extends StatefulWidget {
  final Note _note;
  final int _noteKey;
  final String? senderUid;
  const UpdateNote(this._note, this._noteKey, {this.senderUid});

  @override
  _UpdateNoteState createState() => _UpdateNoteState();
}

class _UpdateNoteState extends State<UpdateNote> {
  final UserService _userService = sl.get<UserService>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _title = '';
  String _text = '';
  String _err = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown,
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
      ),
      body: Container(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 20.0,),
                TextFormField(
                  onSaved: (val) => _title = val!,
                  initialValue: widget._note.title,
                  decoration: const InputDecoration(labelText: 'Title'),
                  validator: (val) =>
                  val!.isEmpty
                      ? 'Title cannot be empty'
                      : null,
                ),
                const SizedBox(height: 20.0,),
                TextFormField(
                  onSaved: (val) => _text = val!,
                  initialValue: widget._note.text,
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: 5,
                  maxLength: 500,
                  decoration: const InputDecoration(labelText: 'Text'),
                  validator: (val) => null,
                ),
                const SizedBox(height: 20.0,),
                ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        try {
                          _formKey.currentState?.save();
                          Note _noteToSave = Note(_title, _text);
                          print(widget.senderUid);
                          widget.senderUid != null? _userService.saveForeignNote(_noteToSave, widget._noteKey, widget.senderUid!):
                          _userService.saveNote(_noteToSave, widget._noteKey);
                          Navigator.pop(context);
                        } catch (e) {
                          setState(() {
                            _err = e.toString().cutAllBefore(']');
                          });
                        }
                      }
                    },
                    child: const Text(
                      'Save',
                      style: TextStyle(color: Colors.white),
                    )
                ),
                const SizedBox(height: 12.0,),
                Text(
                  _err,
                  style: const TextStyle(color: Colors.red, fontSize: 14.0),
                )
              ],
            ),
          )
      ),
    );
  }
}



