import 'package:flutter/material.dart';
import 'package:my_app/services/authserv.dart';

class Home extends StatelessWidget {
  final AuthService _auth = AuthService();

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
    );
  }
}
