import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_catalog/models/account.dart';

class AccountService {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String usersPath = 'users';

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
        .catchError((Object error) {
      print("Error");
    });
    return seller;
  }

  Future<bool> setAccountStatus({bool isAccepted, String uid}) async{
    bool output = false;
    await _firestore
        .collection(usersPath)
        .doc(uid).update({'is_accepted':isAccepted}).then((v)=>output=true).catchError((e)=>output=false);
    return output;
  }

  Future<bool> setAccountBlock({bool isBlocked, String uid}) async{
    bool output = false;
    await _firestore
        .collection(usersPath)
        .doc(uid).update({'is_blocked':isBlocked}).then((v)=>output=true).catchError((e)=>output=false);
    return output;
  }

  Stream<List<Account>> getStreamPendingAccount() {
    return _firestore
        .collection(usersPath)
        .where('is_accepted', isEqualTo: false).limit(20)
        .snapshots()
        .map((e) => e.docs.map((d) => Account.generateRoleBasedAccount(d.data())).toList());
  }

  //Belum dimap ke child class account
  Stream<List<Account>> getStreamAllAccount() {
    return _firestore
        .collection(usersPath).where('is_blocked', isEqualTo: false).limit(40)
        .snapshots()
        .map((e) => e.docs.map((d) => Account.generateRoleBasedAccount(d.data())).toList());
  }

  Stream<List<Account>> getStreamBlockedAccount() {
    return _firestore
        .collection(usersPath).where('is_blocked', isEqualTo: true).limit(40)
        .snapshots()
        .map((e) => e.docs.map((d) => Account.generateRoleBasedAccount(d.data())).toList());
  }

}