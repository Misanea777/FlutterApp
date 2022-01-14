
import 'package:flutter/material.dart';
import 'package:my_app/di/injection_container.dart';
import 'package:my_app/services/auth_service.dart';
import 'package:my_app/services/user_service.dart';
import 'package:my_app/util/extensions.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({required this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final UserService _userService = sl.get<UserService>();
  final AuthService _auth = sl.get<AuthService>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _passKey = GlobalKey<FormFieldState>();

  String username = '';
  String email = '';
  String password = '';
  String err = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown,
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        title: const Text('Register'),
        actions: [
          TextButton.icon(
              onPressed: () {
                widget.toggleView();
              },
              icon: const Icon(Icons.person),
              label: const Text('Sign In')
          )
        ],
      ),
      body: Container(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 20.0,),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Username'),
                  validator: (val) => val.isValidUsernameWithErrCode(),
                  onChanged: (val) {
                    setState(() {
                      username = val;
                    });
                  },
                ),
                const SizedBox(height: 20.0,),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (val) => val.isValidEmailWithErrCode(),
                  onChanged: (val) {
                    setState(() {
                      email = val;
                    });
                  },
                ),
                const SizedBox(height: 20.0,),
                TextFormField(
                  key: _passKey,
                  decoration: const InputDecoration(labelText: 'Password'),
                  validator: (password) => password!.length < 6 ? 'Password should have at least 6 characters' : null,
                  obscureText: true,
                  onChanged: (val) {
                    setState(() {
                      password = val;
                    });
                  },
                ),
                const SizedBox(height: 20.0,),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Confirm the password'),
                  validator: (confirmation) {
                    String password = _passKey.currentState?.value;
                    return confirmation == password ? null : "Confirm Password should match password";
                  },
                  obscureText: true,
                  onChanged: (val) {

                  },
                ),
                const SizedBox(height: 20.0,),
                ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        try{
                          await _auth.registerWithEmailAndPassword(email, password, username).then((user) =>
                              _userService.initUserIfNew(user!));

                        } catch(e) {
                          setState(() {
                            err = e.toString().cutAllBefore(']');
                          });
                        }
                      }
                    },
                    child: const Text(
                      'Register',
                      style: TextStyle(color: Colors.white),
                    )
                ),
                const SizedBox(height: 12.0,),
                Text(
                  err,
                  style: const TextStyle(color: Colors.red, fontSize: 14.0),
                )
              ],
            ),
          )
      ),
    );
  }
}
