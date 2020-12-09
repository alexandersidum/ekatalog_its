import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_catalog/models/item.dart';

class Account {
  //Belum tau propertinya apa aja
  //enum untuk role?
  Account({this.name, this.email, this.telepon, this.registrationDate, this.role, this.uid});
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String name;
  String email;
  int telepon;
  String registrationDate;
  String uid;
  int role;

  factory Account.fromDb(Map<String, dynamic> parsedData){
    return Account(
      email: parsedData['email'],
      name:parsedData['name'],
      registrationDate:parsedData['registrationDate'].toString(),
      role:parsedData['role'],
      telepon:parsedData['telepon'],
      uid:parsedData['uid'],
    );
  }
}

class Seller extends Account{
  String location;
  String namaPerusahaan;
  

  Seller({String name, String email, int telepon, String registrationDate, String uid, int role, this.location, this.namaPerusahaan})
  :super(name: name, email: email, telepon: telepon, registrationDate: registrationDate, uid: uid, role: role);

  factory Seller.fromDb(Map<String, dynamic> parsedData){
    return Seller(
      email: parsedData['email'],
      name:parsedData['name'],
      registrationDate:parsedData['registrationDate'].toString(),
      role:parsedData['role'],
      telepon:parsedData['telepon'],
      uid:parsedData['uid'],
      location: parsedData['alamat'],
      namaPerusahaan: parsedData['namaPerusahaan'],
    );
  }

  Stream<List<Item>> listProduct(){
    return super.firestore.collection('items').where('sellerUid',isEqualTo: this.uid).orderBy('price').snapshots()
    .map((event) => event.docs.map((doc) => Item.fromDb(doc.data())).toList());
  }
}

class PejabatPengadaan extends Account{
  String unit;

  PejabatPengadaan({String name, String email, int telepon, String registrationDate, String uid, int role, this.unit})
  :super(name: name, email: email, telepon: telepon, registrationDate: registrationDate, uid: uid, role: role);

  factory PejabatPengadaan.fromDb(Map<String, dynamic> parsedData){
    return PejabatPengadaan(
      unit:parsedData['unit'],
      email: parsedData['email'],
      name:parsedData['name'],
      registrationDate:parsedData['registrationDate'].toString(),
      role:parsedData['role'],
      telepon:parsedData['telepon'],
      uid:parsedData['uid'],
    );
  }
}