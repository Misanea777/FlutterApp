import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_app/services/authserv.dart';
import 'package:my_app/util/extensions.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({required this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
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
        title: Text('Sign in'),
        actions: [
          TextButton.icon(
              onPressed: () {
                widget.toggleView();
              },
              icon: Icon(Icons.person),
              label: Text('Register')
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 20.0,),
              SizedBox(
                height: 30.0,
                width: 300.0,

                child: OutlinedButton.icon(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blueGrey),
                  ),
                  onPressed: () {
                    _auth.signInwithGoogle();
                  },
                  icon: FaIcon(FontAwesomeIcons.google),
                  label: Text(
                    'Sign In With Google',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(
                height: 30.0,
                width: 300.0,

                child: OutlinedButton.icon(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blueGrey),
                  ),
                  onPressed: () {
                    _auth.signInWithFacebook();
                  },
                  icon: FaIcon(FontAwesomeIcons.facebook),
                  label: Text(
                    'Sign In With Facebook',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                validator: (val) => val!.isEmpty ? 'Enter an email' : null,
                onChanged: (val) {
                  setState(() {
                    email = val;
                  });
                },
              ),
              SizedBox(height: 20.0,),
              TextFormField(
                decoration: InputDecoration(labelText: 'Password'),
                validator: (val) => val!.isEmpty ? 'Enter an password' : null,
                obscureText: true,
                onChanged: (val) {
                  setState(() {
                    password = val;
                  });
                },
              ),
              SizedBox(height: 20.0,),
              ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      try{
                        await _auth.signInWithEmailAndPassword(email, password);
                      } catch(e) {
                        setState(() {
                          err = e.toString().cutAllBefore(']');
                        });
                      }
                    }
                  },
                  child: Text(
                    'Sign In',
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
