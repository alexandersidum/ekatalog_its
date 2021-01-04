import 'package:cloud_firestore/cloud_firestore.dart';

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



}