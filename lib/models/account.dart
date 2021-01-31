import 'package:e_catalog/models/item.dart';

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
      this.imageUrl,
      this.isBlocked,
      this.isAccepted,
      });

  List<String> listRole = ['Guest','Pejabat Pengadaan', 'Penyedia', 'Pejabat Pembuat Komitmen', 'UKPBJ', 'Audit', 'BPP'];
  String name;
  String email;
  String imageUrl;
  int telepon;
  DateTime registrationDate;
  String uid;
  int role;
  bool isBlocked;
  bool isAccepted;

  factory Account.generateUnacceptedAccount(Map<String, dynamic> parsedData) {
    return Account(
      email: parsedData['email'],
      name: parsedData['name'],
      imageUrl: parsedData['imageUrl'],
      registrationDate:
          DateTime.now(),
      role: 0,
      telepon: null,
      uid: parsedData['uid'],
      isAccepted: parsedData['is_accepted'],
      isBlocked: parsedData['is_blocked'],
    );
  }

  factory Account.generateGuest() {
    return Account(
      email: "",
      name: "Pengunjung",
      imageUrl: "",
      registrationDate:
          DateTime.now(),
      role: 0,
      telepon: null,
      uid: "guest",
      isAccepted: true,
      isBlocked: false,
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
      isAccepted: parsedData['is_accepted'],
      isBlocked: parsedData['is_blocked'],
    );
  }

  factory Account.generateRoleBasedAccount(Map<String, dynamic> parsedData) {
    switch(parsedData['role']){
      case 0:
            return Account.generateGuest();
            break;
          case 1:
            return PejabatPengadaan.fromDb(parsedData);
            break;
          case 2:
            return Seller.fromDb(parsedData);
            break;
          case 3:
            return PejabatPembuatKomitmen.fromDb(parsedData);
            break;
          case 4:
            return UnitKerjaPengadaan.fromDb(parsedData);
            break;
          case 5:
            return Audit.fromDb(parsedData);
            break;
          case 6:
            return BendaharaPengeluaran.fromDb(parsedData);
            break;
          case 9:
            return Admin.fromDb(parsedData);
            break;
          default:
            return Account.fromDb(parsedData);

    }
    // return Account(
    //   email: parsedData['email'],
    //   name: parsedData['name'],
    //   imageUrl: parsedData['imageUrl'],
    //   registrationDate:
    //       DateTime.parse(parsedData['registrationDate'].toDate().toString()),
    //   role: parsedData['role'],
    //   telepon: parsedData['telepon'],
    //   uid: parsedData['uid'],
    // );
  }

  String get getRole {
    return this.role==9?"Admin":listRole[this.role];
  }
}

class Seller extends Account {
  String location;
  String namaPerusahaan;
  String namaBank;
  String atasNamaRekening;
  String nomorRekening;
  static List<String> bankNames = ['BRI', 'BCA', 'Mandiri', 'BNI', 'Bank Jatim', 'BTN','CIMB Niaga', 'Danamon', 'BTPN', 'Panin'];

  Seller(
      {String name,
      String email,
      int telepon,
      String imageUrl,
      DateTime registrationDate,
      String uid,
      int role,
      bool isBlocked,
      bool isAccepted,
      this.location,
      this.namaPerusahaan,
      this.namaBank,
      this.atasNamaRekening,
      this.nomorRekening})
      : super(
            name: name,
            email: email,
            imageUrl: imageUrl,
            telepon: telepon,
            registrationDate: registrationDate,
            uid: uid,
            role: role,
            isBlocked: isBlocked,
            isAccepted : isAccepted);

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
      namaBank: parsedData['namaBank'],
      atasNamaRekening: parsedData['atasNamaRekening'],
      nomorRekening: parsedData['nomorRekening'],
      isAccepted: parsedData['is_accepted'],
      isBlocked: parsedData['is_blocked'],
    );
  }


  // Stream<List<Item>> listProduct() {
  //   return super
  //       .firestore
  //       .collection('items')
  //       .where('sellerUid', isEqualTo: this.uid)
  //       .orderBy('price')
  //       .snapshots()
  //       .map((event) =>
  //           event.docs.map((doc) => Item.fromDb(doc.data())).toList());
  // }
}

class PejabatPengadaan extends Account {
  int unit;
  static List<String> listUnit = [
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

  static Map<int, String> mapUnit = {
    0:'Unit Urutan 0',
    1:'Unit Urutan 1',
    2:'Unit Urutan 2',
    3:'Unit Urutan 3',
    4:'Unit Urutan 4',
    5:'Unit Urutan 5',
    6:'Unit Urutan 6',
    7:'Unit Urutan 7',
    8:'Unit Urutan 8',
    9:'Unit Urutan 9',
  };

  PejabatPengadaan(
      {String name,
      String email,
      String imageUrl,
      int telepon,
      DateTime registrationDate,
      String uid,
      int role,
      bool isBlocked,
      bool isAccepted,
      this.unit})
      : super(
            name: name,
            email: email,
            telepon: telepon,
            imageUrl: imageUrl,
            registrationDate: registrationDate,
            uid: uid,
            isBlocked: isBlocked,
            isAccepted : isAccepted,
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
      isAccepted: parsedData['is_accepted'],
      isBlocked: parsedData['is_blocked'],
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
      bool isBlocked,
      bool isAccepted,
      this.unit})
      : super(
            name: name,
            email: email,
            telepon: telepon,
            imageUrl: imageUrl,
            registrationDate: registrationDate,
            uid: uid,
            isBlocked: isBlocked,
            isAccepted : isAccepted,
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
      isAccepted: parsedData['is_accepted'],
      isBlocked: parsedData['is_blocked'],
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
      bool isBlocked,
      bool isAccepted,
      int role})
      : super(
            name: name,
            email: email,
            telepon: telepon,
            imageUrl: imageUrl,
            registrationDate: registrationDate,
            uid: uid,
            isBlocked: isBlocked,
            isAccepted : isAccepted,
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
      isAccepted: parsedData['is_accepted'],
      isBlocked: parsedData['is_blocked'],
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
      bool isBlocked,
      bool isAccepted,
      int role})
      : super(
            name: name,
            email: email,
            telepon: telepon,
            imageUrl: imageUrl,
            registrationDate: registrationDate,
            uid: uid,
            isBlocked: isBlocked,
            isAccepted : isAccepted,
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
      isAccepted: parsedData['is_accepted'],
      isBlocked: parsedData['is_blocked'],
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
      bool isBlocked,
      bool isAccepted,
      int role,
      this.unit})
      : super(
            name: name,
            email: email,
            telepon: telepon,
            imageUrl: imageUrl,
            registrationDate: registrationDate,
            uid: uid,
            isBlocked: isBlocked,
            isAccepted : isAccepted,
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
      isAccepted: parsedData['is_accepted'],
      isBlocked: parsedData['is_blocked'],
    );
  }
}

class Admin extends Account {
  
  Admin(
      {String name,
      String email,
      String imageUrl,
      int telepon,
      DateTime registrationDate,
      bool isBlocked,
      bool isAccepted,
      String uid,
      int role})
      : super(
            name: name,
            email: email,
            telepon: telepon,
            imageUrl: imageUrl,
            registrationDate: registrationDate,
            uid: uid,
            isBlocked: isBlocked,
            isAccepted : isAccepted,
            role: role);


  factory Admin.fromDb(Map<String, dynamic> parsedData) {
    return Admin(
      email: parsedData['email'],
      name: parsedData['name'],
      imageUrl: parsedData['imageUrl'],
      registrationDate:
          DateTime.parse(parsedData['registrationDate'].toDate().toString()),
      role: parsedData['role'],
      telepon: parsedData['telepon'],
      uid: parsedData['uid'],
      isAccepted: parsedData['is_accepted'],
      isBlocked: parsedData['is_blocked'],
    );
  }
}