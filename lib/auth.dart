import 'package:e_catalog/models/account.dart';
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
  Account _userInfo;

  Auth() {
    _auth.onAuthStateChanged.listen((currentUser) {
      _user = currentUser;
    });
  }

  Future<FirebaseUser> checkAuth() {
    return _auth.currentUser();
  }

  void signUp(String _email, String _password, int role, String name,
      String displayName, Function onComplete) async {
    //ExceptionHandlingnya masih ga work
    try {
      await _auth
          .createUserWithEmailAndPassword(email: _email, password: _password)
          .then((result) {
        _firestore.collection('users').document().setData({
          'uid': result.user.uid,
          'email': result.user.email,
          'name': name,
          'role': role,
          'displayName': displayName
        }).then((value) => onComplete('COMPLETE REGIS'));
      });
    } catch (error) {
      switch (error) {
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
    await _auth.signInWithEmailAndPassword(email: email, password: password).then(
      (value) {
        if (value.user!=null){
          checkUserInfo(value.user.uid);
          onComplete(true);
        }else{
          onComplete(false);
        }
      });
    notifyListeners();
  }

  Future<Account> checkUserInfo(uid) async{
    await _firestore.collection('users').document(uid).get().then((value) {
      if(value.exists) {
        int role = value.data['role'];
        switch (role) {
          case 0:
            _userInfo = Account.fromDb(value.data);
            break;
          case 1:
            _userInfo = Seller.fromDb(value.data);
            break;
          case 2:
            _userInfo = PejabatPengadaan.fromDb(value.data);
            break;
          default:
            _userInfo = Account.fromDb(value.data);
        }
        }
    } 
    );
  }

  Future<void> signOut(BuildContext context) async {
    await _auth.signOut().whenComplete(() => Navigator.pushNamedAndRemoveUntil(
        context, LoginScreen.routeId, (Route<dynamic> route) => false));
  }

  FirebaseUser get getUser => _user;
  Account get getUserInfo => _userInfo;

}
