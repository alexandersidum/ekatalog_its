class Account {
  Account({
    this.name,
    this.email,
    this.telepon,
    this.registrationDate,
    this.role,
    this.uid,
    this.imageUrl,
    this.isBlocked,
    this.isAccepted,
  });


  static Map<int, String> mapRole = {
    0: 'Guest',
    1: 'Pejabat Pengadaan',
    2: 'Penyedia',
    3: 'Pejabat Pembuat Komitmen',
    4: 'UKPBJ',
    5: 'Audit',
    6: 'BPP',
    7: 'Pejabat Penerima',
    9 : 'Admin'
  };

  static List<int> unitRole = [1, 6, 7];
  String name;
  String email;
  String imageUrl;
  String telepon;
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
      registrationDate: DateTime.now(),
      role: 0,
      telepon: parsedData['telepon'],
      uid: parsedData['uid'],
      isAccepted: parsedData['is_accepted'],
      isBlocked: parsedData['is_blocked'] ?? false,
    );
  }

  factory Account.generateGuest() {
    return Account(
      email: "",
      name: "Pengunjung",
      imageUrl: "",
      registrationDate: DateTime.now(),
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
    print("GENERATE ${parsedData["name"]}");
    print("GENERATE ${parsedData["role"]}");
    switch (parsedData['role']) {
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
  }

  String get getRole {
    return mapRole[this.role];
  }
}

class Seller extends Account {
  String location;
  String namaPerusahaan;
  String namaBank;
  String atasNamaRekening;
  String nomorRekening;
  static List<String> bankNames = [
    'BRI',
    'BCA',
    'Mandiri',
    'BNI',
    'Bank Jatim',
    'BTN',
    'CIMB Niaga',
    'Danamon',
    'BTPN',
    'Panin'
  ];

  Seller(
      {String name,
      String email,
      String telepon,
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
            isAccepted: isAccepted);

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
}

class PejabatPengadaan extends Account {
  int unit;
  String ppkCode;
  String namaUnit;

  PejabatPengadaan(
      {String name,
      String email,
      String imageUrl,
      String telepon,
      DateTime registrationDate,
      String uid,
      int role,
      bool isBlocked,
      bool isAccepted,
      this.ppkCode,
      this.namaUnit,
      this.unit})
      : super(
            name: name,
            email: email,
            telepon: telepon,
            imageUrl: imageUrl,
            registrationDate: registrationDate,
            uid: uid,
            isBlocked: isBlocked,
            isAccepted: isAccepted,
            role: role);

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
      ppkCode: parsedData['ppkCode'],
      namaUnit: parsedData['namaUnit'],
    );
  }
}

class PejabatPembuatKomitmen extends Account {
  String namaDivisi;
  String ppkCode;

  PejabatPembuatKomitmen(
      {String name,
      String email,
      String imageUrl,
      String telepon,
      DateTime registrationDate,
      String uid,
      this.namaDivisi,
      int role,
      bool isBlocked,
      bool isAccepted,
      this.ppkCode})
      : super(
            name: name,
            email: email,
            telepon: telepon,
            imageUrl: imageUrl,
            registrationDate: registrationDate,
            uid: uid,
            isBlocked: isBlocked,
            isAccepted: isAccepted,
            role: role);

  factory PejabatPembuatKomitmen.fromDb(Map<String, dynamic> parsedData) {
    return PejabatPembuatKomitmen(
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
      ppkCode: parsedData['ppkCode'],
      namaDivisi: parsedData['namaDivisiPPK'],
    );
  }
}

class UnitKerjaPengadaan extends Account {
  UnitKerjaPengadaan(
      {String name,
      String email,
      String imageUrl,
      String telepon,
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
            isAccepted: isAccepted,
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
  Audit(
      {String name,
      String email,
      String imageUrl,
      String telepon,
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
            isAccepted: isAccepted,
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
  String namaUnit;

  BendaharaPengeluaran(
      {String name,
      String email,
      String imageUrl,
      String telepon,
      DateTime registrationDate,
      String uid,
      bool isBlocked,
      bool isAccepted,
      int role,
      this.namaUnit,
      this.unit})
      : super(
            name: name,
            email: email,
            telepon: telepon,
            imageUrl: imageUrl,
            registrationDate: registrationDate,
            uid: uid,
            isBlocked: isBlocked,
            isAccepted: isAccepted,
            role: role);

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
      namaUnit: parsedData['namaUnit'],
    );
  }
}

class Admin extends Account {
  Admin(
      {String name,
      String email,
      String imageUrl,
      String telepon,
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
            isAccepted: isAccepted,
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

class PejabatPenerima extends Account {
  int unit;
  String namaUnit;

  PejabatPenerima(
      {String name,
      String email,
      String imageUrl,
      String telepon,
      DateTime registrationDate,
      String uid,
      int role,
      bool isBlocked,
      bool isAccepted,
      this.namaUnit,
      this.unit})
      : super(
            name: name,
            email: email,
            telepon: telepon,
            imageUrl: imageUrl,
            registrationDate: registrationDate,
            uid: uid,
            isBlocked: isBlocked,
            isAccepted: isAccepted,
            role: role);



  factory PejabatPenerima.fromDb(Map<String, dynamic> parsedData) {
    return PejabatPenerima(
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
        namaUnit: parsedData['namaUnit'],);
  }
}
