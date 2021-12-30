import 'package:flutter/material.dart';
import 'package:my_app/models/user.dart';
import 'package:my_app/screens/auth/auth.dart';
import 'package:my_app/screens/home/home.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CustomUser?>(context);
    if(user == null) {
      return Authenticate();
    } else {
      return Home();
    }
  }
}
