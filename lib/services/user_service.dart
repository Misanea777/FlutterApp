import 'package:my_app/data/user_dao.dart';
import 'package:my_app/models/note.dart';
import 'package:my_app/models/user.dart';

class UserService {
  final UserDao dao;

  UserService({required this.dao});

  void saveNote(Note note, int key) {
    dao.saveNote(note, key);
  }

  void initUserIfNew(CustomUser user) => user.isNewUser ?
  dao.initUser() : null;



}