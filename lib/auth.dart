import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

//Ubah Password belum
//Register belum

class Auth with ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser _user;

  Auth() {
    _auth.onAuthStateChanged.listen((event) {
      _user = event;
    });
  }

  Future<FirebaseUser> checkAuth(){
    return _auth.currentUser();
  }

  Future<void> signIn(
      String email, String password, Function onComplete) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
    onComplete();
    notifyListeners();
  }

  Future<void> signOut(BuildContext context) async {
    await _auth
        .signOut()
        .whenComplete(() => Navigator.pushNamedAndRemoveUntil(context, LoginScreen.routeId, (Route<dynamic> route)=>false ));
  }

  FirebaseUser get getUser => _user;
}
