import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:e_catalog/models/account.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

//Kenapa selalu imageurlnya kosong
//Ubah Password belum
//Register belum sempurna
//Signout belum sempurna

class Auth {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseStorage _fstorage = FirebaseStorage.instance;
  User _user;
  //apa dynamic?
  Account _userInfo;

  User get getUser => _user;
  Account get getUserInfo => _userInfo;

  Auth() {
    _auth.authStateChanges().listen((currentUser) {
      print('Current User : $currentUser');
      _user = currentUser;
    });
  }

  Future<bool> checkAuth() async {
    if (_auth.currentUser != null) {
      await checkUserInfo(_auth.currentUser.uid);
      if (_userInfo.isBlocked) {
        await _auth.signOut();
        return false;
      }
      return true;
    } else {
      return false;
    }
  }

  void signUp(
      String _email,
      String _password,
      int role,
      int unit,
      String name,
      String namaPerusahaan,
      String lokasiPerusahaan,
      String telepon,
      Function onComplete,
      File image) async {
    try {
      await _auth
          .createUserWithEmailAndPassword(email: _email, password: _password)
          .then((result) async {
        if (result.user != null) {
          await uploadImage(image).then((value) async {
            await _firestore.collection('users').doc(result.user.uid).set({
              'uid': result.user.uid,
              'registrationDate': FieldValue.serverTimestamp(),
              'email': result.user.email,
              'name': name,
              'role': role,
              'unit': unit,
              'telepon': telepon,
              'namaPerusahaan': namaPerusahaan,
              'alamat': lokasiPerusahaan,
              'imageUrl': value != null ? value : "",
              'is_accepted': false,
            }).then((value) => onComplete(AuthResultStatus.successful));
          });
        } else {
          onComplete(AuthResultStatus.undefined);
        }
      });
    } catch (error) {
      onComplete(AuthExceptionHandler.handleException(error));
    }
  }

  Future<String> uploadImage(File image) async {
    String fileName = p.basename(image.path);
    Reference storageRef = _fstorage.ref().child('upload/$fileName');
    await storageRef.putFile(image);
    return await storageRef.getDownloadURL();
  }

  Future<void> signIn(
      String email, String password, Function onComplete) async {
    if (email.isNotEmpty && password.isNotEmpty) {
      try {
        await _auth
            .signInWithEmailAndPassword(email: email, password: password)
            .then((value) async {
          if (value.user != null) {
            print("value user not null");
            await checkUserInfo(value.user.uid);
            if (_userInfo.isBlocked) {
              print("user is blocked");
              await _auth.signOut();
              onComplete(AuthResultStatus.blocked);
            }
            else{
              onComplete(AuthResultStatus.successful);
            }
          } else {
            onComplete(AuthResultStatus.undefined);
          }
        });
      } catch (error) {
        onComplete(AuthExceptionHandler.handleException(error));
      }
    } else {
      onComplete(AuthResultStatus.undefined);
    }
  }

  Stream<Account> streamUserInfo(uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .snapshots()
        .map((DocumentSnapshot document) {
      var role = document.data()['role'];
      if (!document.data()['is_accepted']) {
        _userInfo = Account.generateUnacceptedAccount(document.data());
      } else {
        switch (role) {
          case 0:
            _userInfo = Account.generateGuest();
            break;
          case 1:
            _userInfo = PejabatPengadaan.fromDb(document.data());
            break;
          case 2:
            _userInfo = Seller.fromDb(document.data());
            break;
          case 3:
            _userInfo = PejabatPembuatKomitmen.fromDb(document.data());
            break;
          case 4:
            _userInfo = UnitKerjaPengadaan.fromDb(document.data());
            break;
          case 5:
            _userInfo = Audit.fromDb(document.data());
            break;
          case 6:
            _userInfo = BendaharaPengeluaran.fromDb(document.data());
            break;
          default:
            _userInfo = Account.fromDb(document.data());
        }
      }
      return _userInfo;
    });
  }

  Future<void> checkUserInfo(uid) async {
    print("Checkuserinfo ");
    await _firestore.collection('users').doc(uid).get().then((value) {
      if (value.exists) {
        print("Checkuserinfo VALUE EXIST ");
        bool isAccepted = value.data()['is_accepted'];
        int role = value.data()['role'];
        if (!isAccepted) {
          print("Checkuserinfo VALUE EXIST ");
          _userInfo = Account.generateUnacceptedAccount(value.data());
        } else {
          switch (role) {
            case 0:
              _userInfo = Account.generateGuest();
              break;
            case 1:
              _userInfo = PejabatPengadaan.fromDb(value.data());
              break;
            case 2:
              _userInfo = Seller.fromDb(value.data());
              break;
            case 3:
              _userInfo = PejabatPembuatKomitmen.fromDb(value.data());
              break;
            case 4:
              _userInfo = UnitKerjaPengadaan.fromDb(value.data());
              break;
            case 5:
              _userInfo = Audit.fromDb(value.data());
              break;
            case 6:
              _userInfo = BendaharaPengeluaran.fromDb(value.data());
              break;
            case 9:
              _userInfo = Admin.fromDb(value.data());
              break;
            default:
              _userInfo = Account.fromDb(value.data());
          }
        }
      }
    });
  }

  Future<void> signOut(BuildContext context, Function callback) async {
    await _auth.signOut().whenComplete(() {
      if (_user == null) {
        Navigator.pushNamedAndRemoveUntil(
            context, LoginScreen.routeId, (Route<dynamic> route) => false);
        callback();
      }
    });
  }
}

class AuthExceptionHandler {
  static handleException(e) {
    var status;
    switch (e.code) {
      case "ERROR_INVALID_EMAIL":
      case "invalid-email":
        status = AuthResultStatus.invalidEmail;
        break;
      case "ERROR_WRONG_PASSWORD":
      case "wrong-password":
        status = AuthResultStatus.wrongPassword;
        break;
      case "ERROR_USER_NOT_FOUND":
      case "user-not-found":
        status = AuthResultStatus.userNotFound;
        break;
      case "ERROR_USER_DISABLED":
      case "user-disabled":
        status = AuthResultStatus.userDisabled;
        break;
      case "ERROR_TOO_MANY_REQUESTS":
        status = AuthResultStatus.tooManyRequests;
        break;
      case "ERROR_OPERATION_NOT_ALLOWED":
      case "operation-not-allowed":
        status = AuthResultStatus.operationNotAllowed;
        break;
      case "ERROR_EMAIL_ALREADY_IN_USE":
      case "account-exists-with-different-credential":
      case "email-already-in-use":
        status = AuthResultStatus.emailAlreadyExists;
        break;
      default:
        status = AuthResultStatus.undefined;
    }
    return status;
  }

  ///
  /// Accepts AuthExceptionHandler.errorType
  ///
  static generateExceptionMessage(exceptionCode) {
    String errorMessage;
    switch (exceptionCode) {
      case AuthResultStatus.invalidEmail:
        errorMessage = "Email yang dimasukkan tidak valid.";
        break;
      case AuthResultStatus.wrongPassword:
        errorMessage = "Username/Password Salah.";
        break;
      case AuthResultStatus.userNotFound:
        errorMessage = "User tidak ditemukan.";
        break;
      case AuthResultStatus.userDisabled:
        errorMessage = "User telah dinonaktifkan.";
        break;
      case AuthResultStatus.tooManyRequests:
        errorMessage = "Too many requests. Try again later.";
        break;
      case AuthResultStatus.operationNotAllowed:
        errorMessage = "Signing in with Email and Password is not enabled.";
        break;
      case AuthResultStatus.emailAlreadyExists:
        errorMessage = "Email telah digunakan pada akun lain.";
        break;
      case AuthResultStatus.blocked:
        errorMessage = "Akun diblokir";
        break;
      default:
        errorMessage = "Terjadi kesalahan dalam proses.";
    }

    return errorMessage;
  }
}

enum AuthResultStatus {
  successful,
  emailAlreadyExists,
  wrongPassword,
  invalidEmail,
  userNotFound,
  userDisabled,
  operationNotAllowed,
  tooManyRequests,
  undefined,
  //in firestore
  blocked,
}
