import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//Ubah Password belum
//Register belum sempurna
//Signout belum sempurna

class Auth with ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;
  Firestore _firestore = Firestore.instance;
  FirebaseUser _user;

  Auth() {
    _auth.onAuthStateChanged.listen((event) {
      _user = event;
    });
  }

  Future<FirebaseUser> checkAuth(){
    return _auth.currentUser();
  }

  void signUp(String _email, String _password, int role, String name, String displayName, Function onComplete) async{
   //ExceptionHandlingnya masih ga work
    try{
      FirebaseUser user = await _auth.createUserWithEmailAndPassword(email: _email, password: _password)
    .then((result) {
      _firestore.collection('users').document().setData(
        {'uid':result.user.uid,
          'email':result.user.email,
          'name' : name,
          'role' : role,
          'displayName': displayName
        }
      ).then((value) => onComplete('COMPLETE REGIS'));
    });
    }
    catch(error){
      switch(error){
        case "ERROR_EMAIL_ALREADY_IN_USE":
        {
          //yang dilakukan apa?
          onComplete('ERROR_EMAIL_ALREADY_IN_USE');
          break;
        }
        case "ERROR_WEAK_PASSWORD":
        {
          //yang dilakukan
          break;
        }
        //Case lainnya
      }

    }
    
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
