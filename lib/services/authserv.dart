import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_app/data/user_dao.dart';
import 'package:my_app/models/user.dart';
import 'package:my_app/util/resource.dart';
import 'package:twitter_login/entity/auth_result.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  CustomUser? _userFromFirebaaseUser(User? user) {
    return user != null ? CustomUser(uid: user.uid) : null;
  }

  Stream<CustomUser?> get user {
    return _auth.authStateChanges().map(_userFromFirebaaseUser);
  }

  Future singInAnon() async {
    try {
      UserCredential result =  await _auth.signInAnonymously();
      User? user = result.user;
      return _userFromFirebaaseUser(user!);
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  Future singOut() async {
    try {
      return await _auth.signOut();
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  Future registerWithEmailAndPassword(String email, String password) async {
    UserCredential result =  await _auth.createUserWithEmailAndPassword(email: email, password: password);
    User? user = result.user;
    return _userFromFirebaaseUser(user);
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    UserCredential result =  await _auth.signInWithEmailAndPassword(email: email, password: password);
    User? user = result.user;
    return _userFromFirebaaseUser(user);
  }

  Future<bool> signInwithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
      await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      UserCredential authResult = await _auth.signInWithCredential(credential);
      return authResult.additionalUserInfo!.isNewUser;
    } on FirebaseAuthException catch (e) {
      print(e.message);
      throw e;
    }
  }



  Future<void> signOutFromGoogle() async{
    await _googleSignIn.signOut();
    return await _auth.signOut();
  }

  Future<bool> signInWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();

          final AuthCredential facebookCredential =
          FacebookAuthProvider.credential(result.accessToken!.token);
          final userCredential =
          await _auth.signInWithCredential(facebookCredential);
          return userCredential.additionalUserInfo!.isNewUser;
    } on FirebaseAuthException catch (e) {
      print(e);
      if (e.code == 'account-exists-with-different-credential') {
        List<String> emailList = await FirebaseAuth.instance
            .fetchSignInMethodsForEmail(e.email!);
        if (emailList.first == "google.com" || emailList.first == "twitter.com") {
          await signInwithGoogleCredential(e.credential);
        }
      }

      throw e;
    }
  }

  Future<String?> signInwithGoogleCredential(
       AuthCredential? authCredential) async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
      await _googleSignIn.signIn();

      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      UserCredential userCredential =
      await _auth.signInWithCredential(credential);

      return userCredential.user!.displayName;
    } on FirebaseAuthException catch (e) {
      print(e.message);
      throw e;
    }
  }

  User getCurrentUser() {
    return _auth.currentUser!;
  }

}