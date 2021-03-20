import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_catalog/models/account.dart';
import 'package:e_catalog/models/unit.dart';

// Role code :

// 0 : Guest
// 1 : PP
// 2 : Penyedia
// 3 : PPK
// 4 : UKPBJ
// 5 : Audit
// 6 : BPP
// 7:  Penerima
// 9 : Admin

class AccountService {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String usersPath = 'users';
  String unitPath = 'unit';
  String divisiPath = 'ppk_info';

  Future<bool> setRekeningPembayaran(String uid, String namaBank,
      String atasNamaRekening, String nomorRekening) async {
    bool isSuccess = false;
    await _firestore
        .collection(usersPath)
        .doc(uid)
        .update({
          'namaBank': namaBank,
          'atasNamaRekening': atasNamaRekening,
          'nomorRekening': nomorRekening
        })
        .then((value) => isSuccess = true)
        .catchError((Object error) {
          isSuccess = false;
        });
    return isSuccess;
  }

  
  Future<Seller> getSellerInfo(String sellerUid) async {
    Seller seller = await _firestore
        .collection(usersPath)
        .doc(sellerUid)
        .get()
        .then((value) => Seller.fromDb(value.data()))
        .catchError((Object error) {});
    return seller;
  }

  Future<bool> setAccountStatus({bool isAccepted, String uid}) async {
    bool output = false;
    await _firestore
        .collection(usersPath)
        .doc(uid)
        .update({'is_accepted': isAccepted})
        .then((v) => output = true)
        .catchError((e) => output = false);
    return output;
  }

  Future<bool> setAccountBlock({bool isBlocked, String uid}) async {
    bool output = false;
    await _firestore
        .collection(usersPath)
        .doc(uid)
        .update({'is_blocked': isBlocked})
        .then((v) => output = true)
        .catchError((e) => output = false);
    return output;
  }

  Stream<List<Account>> getStreamPendingAccount() {
    return _firestore
        .collection(usersPath)
        .where('is_blocked', isEqualTo: false)
        .where('is_accepted', isEqualTo: false)
        .limit(20)
        .snapshots()
        .map((e) => e.docs
            .map((d) => Account.generateRoleBasedAccount(d.data()))
            .toList());
  }

  //Belum dimap ke child class account
  Stream<List<Account>> getStreamAllAccount() {
    return _firestore
        .collection(usersPath)
        .where('is_blocked', isEqualTo: false)
        .limit(40)
        .snapshots()
        .map((e) => e.docs
            .map((d) => Account.generateRoleBasedAccount(d.data()))
            .toList());
  }

  Stream<List<Account>> getStreamBlockedAccount() {
    return _firestore
        .collection(usersPath)
        .where('is_blocked', isEqualTo: true)
        .limit(40)
        .snapshots()
        .map((e) => e.docs
            .map((d) => Account.generateRoleBasedAccount(d.data()))
            .toList());
  }

  Future<String> getPPKCode(int unit) async {
    return await _firestore
        .collection(unitPath)
        .doc(unit.toString())
        .get()
        .then((e) => e.data()['ppkCode']);
  }

  Future<Seller> getSellerData(String sellerUid) async {
    return await _firestore
        .collection(usersPath)
        .doc(sellerUid)
        .get()
        .then((snap) => Seller.fromDb(snap.data()))
        .catchError((e) => null);
  }

  Future<List<Unit>> getUnit() async {
    return await _firestore.collection(unitPath).get().then(
        (e) => e.docs.map((doc) => Unit.fromDb(doc.data(), doc.id)).toList());
  }

  Future<List<DivisiPPK>> getDivisiPPK() async {
    return await _firestore.collection(divisiPath).get().then((e) =>
        e.docs.map((doc) => DivisiPPK.fromDb(doc.data(), doc.id)).toList());
  }

  //Setting block di data is blocked pada document user di firestore
  Future<bool> acceptPPK({bool isAccepted, PejabatPembuatKomitmen ppk}) async {
    bool output = false;
    var userRef = _firestore.collection(usersPath).doc(ppk.uid);
    var ppkRef = _firestore.collection(divisiPath).doc(ppk.ppkCode);
    await _firestore
        .runTransaction((transaction) async {
          transaction.update(userRef, {'is_accepted': isAccepted});
          transaction.update(ppkRef, {'ppk_uid': isAccepted ? ppk.uid : null});
          transaction
              .update(ppkRef, {'ppk_name': isAccepted ? ppk.name : null});
        })
        .then((e) async{
          try{
            await updatePPKUnit(ppk);
          }
          catch(e){
            throw("Gagal");
          }
          output = true;
        })
        .catchError((e) => output = false);
    return output;
  }

  Future<bool> updatePPKUnit(PejabatPembuatKomitmen ppk) async {
    bool output = false;
    var unitRef = _firestore.collection(unitPath);
    await unitRef.where('ppkCode',isEqualTo: ppk.ppkCode).get().then((snap)async{
      await Future.forEach(snap.docs,(DocumentSnapshot doc)async{
        await unitRef.doc(doc.id).set({
          "namaPPK":ppk.name,
          "ppkCode":ppk.ppkCode,
          "ppkUid":ppk.uid,
        },SetOptions(merge: true));
      });
    });
    return output;
  }

  //Setting block di data is blocked pada document user di firestore
  Future<bool> setPPKBlock({bool isBlocked, PejabatPembuatKomitmen ppk}) async {
    bool output = false;
    var userRef = _firestore.collection(usersPath).doc(ppk.uid);
    var ppkRef = _firestore.collection(divisiPath).doc(ppk.ppkCode);
    await _firestore
        .runTransaction((transaction) async {
          transaction.update(userRef, {'is_blocked': isBlocked});
          transaction.update(ppkRef, {'ppk_uid': !isBlocked ? ppk.uid : null});
          transaction
              .update(ppkRef, {'ppk_name': !isBlocked ? ppk.name : null});
        })
        .then((e) => output = true)
        .catchError((e) => output = false);
    return output;
  }
}
