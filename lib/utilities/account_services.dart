import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_catalog/models/account.dart';

class AccountService {

FirebaseFirestore _firestore = FirebaseFirestore.instance;

String usersPath = 'users';

Future<bool> setRekeningPembayaran(String uid, String namaBank, String atasNamaRekening, String nomorRekening) async{
    bool isSuccess = false;
    await _firestore
        .collection(usersPath)
        .doc(uid)
        .update({
          'namaBank': namaBank,
          'atasNamaRekening': atasNamaRekening,
          'nomorRekening' :nomorRekening
        })
        .then((value) => isSuccess = true)
        .catchError((Object error) {
          isSuccess = false;
        });
    return isSuccess;
}

Future<Seller> getSellerInfo(String sellerUid)async{
   Seller seller = await _firestore
        .collection(usersPath)
        .doc(sellerUid).get().then((value) => Seller.fromDb(value.data())).catchError((Object error){print("Error");});
  return seller;
}



}