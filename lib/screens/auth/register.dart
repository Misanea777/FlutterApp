import 'package:flutter/material.dart';
import 'package:my_app/services/authserv.dart';
import 'package:my_app/util/extensions.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({required this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final AuthService _auth = AuthService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
        title: Text('Register'),
        actions: [
          TextButton.icon(
              onPressed: () {
                widget.toggleView();
              },
              icon: Icon(Icons.person),
              label: Text('Sign In')
          )
        ],
      ),
      body: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
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
                  decoration: const InputDecoration(labelText: 'Password'),
                  validator: (val) => val!.isEmpty ? 'Enter an password' : null,
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
                  validator: (val) => (val! == password )? 'Confirm the password' : null,
                  obscureText: true,
                  onChanged: (val) {

                  },
                ),
                const SizedBox(height: 20.0,),
                ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        try{
                          await _auth.registerWithEmailAndPassword(email, password);
                        } catch(e) {
                          setState(() {
                            err = e.toString().cutAllBefore(']');
                          });
                        }
                      }
                    },
                    child: Text(
                      'Register',
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
