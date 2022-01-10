import 'package:my_app/data/user_dao.dart';
import 'package:my_app/models/note.dart';
import 'package:my_app/models/user.dart';

class UserService {
  final UserDao _dao = UserDao();

  void createNote(Note note) {
    _dao.createNote(note);
  }

  void initUserIfNew(CustomUser user) => user.isNewUser ?
  _dao.initUser() : null;

}