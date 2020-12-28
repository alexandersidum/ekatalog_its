import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_catalog/models/item.dart';
import 'package:e_catalog/utilities/order_services.dart';

class Account {
  //Belum tau propertinya apa aja
  //enum untuk role?
  Account(
      {this.name,
      this.email,
      this.telepon,
      this.registrationDate,
      this.role,
      this.uid,
      this.imageUrl});

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<String> listRole = ['Guest','Pejabat Pengadaan', 'Penyedia', 'Pejabat Pembuat Komitmen', 'UKPBJ', 'Audit', 'BPP'];
  String name;
  String email;
  String imageUrl;
  int telepon;
  DateTime registrationDate;
  String uid;
  int role;

  factory Account.generateGuest() {
    return Account(
      email: "guest",
      name: "guest",
      imageUrl: "",
      registrationDate:
          DateTime.now(),
      role: 0,
      telepon: null,
      uid: "guest",
    );
  }

  factory Account.fromDb(Map<String, dynamic> parsedData) {
    return Account(
      email: parsedData['email'],
      name: parsedData['name'],
      imageUrl: parsedData['imageUrl'],
      registrationDate:
          DateTime.parse(parsedData['registrationDate'].toDate().toString()),
      role: parsedData['role'],
      telepon: parsedData['telepon'],
      uid: parsedData['uid'],
    );
  }

  String get getRole {
    return listRole[this.role];
  }
}

class Seller extends Account {
  String location;
  String namaPerusahaan;

  Seller(
      {String name,
      String email,
      int telepon,
      String imageUrl,
      DateTime registrationDate,
      String uid,
      int role,
      this.location,
      this.namaPerusahaan})
      : super(
            name: name,
            email: email,
            imageUrl: imageUrl,
            telepon: telepon,
            registrationDate: registrationDate,
            uid: uid,
            role: role);

  factory Seller.fromDb(Map<String, dynamic> parsedData) {
    return Seller(
      email: parsedData['email'],
      name: parsedData['name'],
      registrationDate:
          DateTime.parse(parsedData['registrationDate'].toDate().toString()),
      role: parsedData['role'],
      telepon: parsedData['telepon'],
      imageUrl: parsedData['imageUrl'],
      uid: parsedData['uid'],
      location: parsedData['alamat'],
      namaPerusahaan: parsedData['namaPerusahaan'],
    );
  }

  Stream<List<Item>> listProduct() {
    return super
        .firestore
        .collection('items')
        .where('sellerUid', isEqualTo: this.uid)
        .orderBy('price')
        .snapshots()
        .map((event) =>
            event.docs.map((doc) => Item.fromDb(doc.data())).toList());
  }
}

class PejabatPengadaan extends Account {
  int unit;
  List<String> listUnit = [
    'Unit Urutan 0',
    'Unit Urutan 1',
    'Unit Urutan 2',
    'Unit Urutan 3',
    'Unit Urutan 4',
    'Unit Urutan 5',
    'Unit Urutan 6',
    'Unit Urutan 7',
    'Unit Urutan 8',
    'Unit Urutan 9',
  ];

  PejabatPengadaan(
      {String name,
      String email,
      String imageUrl,
      int telepon,
      DateTime registrationDate,
      String uid,
      int role,
      this.unit})
      : super(
            name: name,
            email: email,
            telepon: telepon,
            imageUrl: imageUrl,
            registrationDate: registrationDate,
            uid: uid,
            role: role);

  String get getUnit {
    switch (this.unit) {
      case 0:
        return listUnit[0];
        break;
      case 1:
        return listUnit[1];
        break;
      case 2:
        return listUnit[2];
        break;
      case 3:
        return listUnit[3];
        break;
      case 4:
        return listUnit[4];
        break;
      default:
        return "Unit Tidak terdefinisi";
        break;
    }
  }

  factory PejabatPengadaan.fromDb(Map<String, dynamic> parsedData) {
    return PejabatPengadaan(
      unit: parsedData['unit'],
      email: parsedData['email'],
      name: parsedData['name'],
      imageUrl: parsedData['imageUrl'],
      registrationDate:
          DateTime.parse(parsedData['registrationDate'].toDate().toString()),
      role: parsedData['role'],
      telepon: parsedData['telepon'],
      uid: parsedData['uid'],
    );
  }
}

class PejabatPembuatKomitmen extends Account {
  //TODO Fungsi khusus PPK
  int unit;
  List<String> listUnit = [
    'Unit Urutan 0',
    'Unit Urutan 1',
    'Unit Urutan 2',
    'Unit Urutan 3',
    'Unit Urutan 4',
    'Unit Urutan 5',
    'Unit Urutan 6',
    'Unit Urutan 7',
    'Unit Urutan 8',
    'Unit Urutan 9',
  ];

  PejabatPembuatKomitmen(
      {String name,
      String email,
      String imageUrl,
      int telepon,
      DateTime registrationDate,
      String uid,
      int role,
      this.unit})
      : super(
            name: name,
            email: email,
            telepon: telepon,
            imageUrl: imageUrl,
            registrationDate: registrationDate,
            uid: uid,
            role: role);

  String get getUnit {
    switch (this.unit) {
      case 0:
        return listUnit[0];
        break;
      case 1:
        return listUnit[1];
        break;
      case 2:
        return listUnit[2];
        break;
      case 3:
        return listUnit[3];
        break;
      case 4:
        return listUnit[4];
        break;
      default:
        return "Unit Tidak terdefinisi";
        break;
    }
  }

  factory PejabatPembuatKomitmen.fromDb(Map<String, dynamic> parsedData) {
    return PejabatPembuatKomitmen(
      unit: parsedData['unit'],
      email: parsedData['email'],
      name: parsedData['name'],
      imageUrl: parsedData['imageUrl'],
      registrationDate:
          DateTime.parse(parsedData['registrationDate'].toDate().toString()),
      role: parsedData['role'],
      telepon: parsedData['telepon'],
      uid: parsedData['uid'],
    );
  }
}

class UnitKerjaPengadaan extends Account {
  //TODO Fungsi khusus UKPBJ
 
  UnitKerjaPengadaan(
      {String name,
      String email,
      String imageUrl,
      int telepon,
      DateTime registrationDate,
      String uid,
      int role})
      : super(
            name: name,
            email: email,
            telepon: telepon,
            imageUrl: imageUrl,
            registrationDate: registrationDate,
            uid: uid,
            role: role);


  factory UnitKerjaPengadaan.fromDb(Map<String, dynamic> parsedData) {
    return UnitKerjaPengadaan(
      email: parsedData['email'],
      name: parsedData['name'],
      imageUrl: parsedData['imageUrl'],
      registrationDate:
          DateTime.parse(parsedData['registrationDate'].toDate().toString()),
      role: parsedData['role'],
      telepon: parsedData['telepon'],
      uid: parsedData['uid'],
    );
  }
}

class Audit extends Account {
  //TODO Fungsi khusus Audit
 
  Audit(
      {String name,
      String email,
      String imageUrl,
      int telepon,
      DateTime registrationDate,
      String uid,
      int role})
      : super(
            name: name,
            email: email,
            telepon: telepon,
            imageUrl: imageUrl,
            registrationDate: registrationDate,
            uid: uid,
            role: role);


  factory Audit.fromDb(Map<String, dynamic> parsedData) {
    return Audit(
      email: parsedData['email'],
      name: parsedData['name'],
      imageUrl: parsedData['imageUrl'],
      registrationDate:
          DateTime.parse(parsedData['registrationDate'].toDate().toString()),
      role: parsedData['role'],
      telepon: parsedData['telepon'],
      uid: parsedData['uid'],
    );
  }
}

class BendaharaPengeluaran extends Account {
  //TODO Fungsi khusus BPP
  int unit;
  List<String> listUnit = [
    'Unit Urutan 0',
    'Unit Urutan 1',
    'Unit Urutan 2',
    'Unit Urutan 3',
    'Unit Urutan 4',
    'Unit Urutan 5',
    'Unit Urutan 6',
    'Unit Urutan 7',
    'Unit Urutan 8',
    'Unit Urutan 9',
  ];

  BendaharaPengeluaran(
      {String name,
      String email,
      String imageUrl,
      int telepon,
      DateTime registrationDate,
      String uid,
      int role,
      this.unit})
      : super(
            name: name,
            email: email,
            telepon: telepon,
            imageUrl: imageUrl,
            registrationDate: registrationDate,
            uid: uid,
            role: role);

  String get getUnit {
    switch (this.unit) {
      case 0:
        return listUnit[0];
        break;
      case 1:
        return listUnit[1];
        break;
      case 2:
        return listUnit[2];
        break;
      case 3:
        return listUnit[3];
        break;
      case 4:
        return listUnit[4];
        break;
      default:
        return "Unit Tidak terdefinisi";
        break;
    }
  }

  factory BendaharaPengeluaran.fromDb(Map<String, dynamic> parsedData) {
    return BendaharaPengeluaran(
      unit: parsedData['unit'],
      email: parsedData['email'],
      name: parsedData['name'],
      imageUrl: parsedData['imageUrl'],
      registrationDate:
          DateTime.parse(parsedData['registrationDate'].toDate().toString()),
      role: parsedData['role'],
      telepon: parsedData['telepon'],
      uid: parsedData['uid'],
    );
  }
}