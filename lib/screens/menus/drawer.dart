import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_app/di/injection_container.dart';
import 'package:my_app/services/auth_service.dart';

class AppDrawer extends StatelessWidget {
  AppDrawer({Key? key}) : super(key: key);
  final AuthService _auth = sl.get<AuthService>();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _createHeader(),
          _createDrawerItem(
              icon: Icons.person,
              text: 'Log out',
              subtitle: _auth.getCurrentUser().displayName ?? _auth.getCurrentUser().email!,
              onTap: ()=>  _auth.singOut()
          ),

        ],
      ),
    );
  }

  Widget _createHeader() {
    return  DrawerHeader(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      decoration: const BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.fill,
          image: AssetImage('assets/images/background.jpg'),
        )
      ),
      child: Stack(children: const [
        Positioned(
          bottom: 12.0,
          left: 16.0,
          child: Text(
            'My app',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        )
      ],),
    );
  }

  Widget _createDrawerItem(
        {required IconData icon,  required String text,  required GestureTapCallback onTap, String? subtitle}
      ) {
    return ListTile(
      title: Row(
        children: [
          Icon(icon),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
              child: Text(text),
          )
        ],
      ),
      onTap: onTap,
      subtitle: Text(subtitle ?? ''),
    );
  }
}
