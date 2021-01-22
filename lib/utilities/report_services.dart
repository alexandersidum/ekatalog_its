import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_catalog/models/sales_order.dart';
import 'package:e_catalog/models/shipping_address.dart';
import 'package:e_catalog/models/unit.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ReportServices {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseStorage _fstorage = FirebaseStorage.instance;
  String salesOrderPath = 'sales_order';
  String unitPath = 'unit';
  String miscPath = 'misc';
  String usersPath = 'users';
  
  Future<Unit> getUnitReport({int unit, Function callback}) async{
    //Sales order sesuai unit
  String namaUnit;
  String namaPPK;
  String ppkUid;

  await _firestore
        .collection(unitPath).doc(unit.toString()).get().then((value) {
          namaUnit = value.data()['namaUnit'].toString();
          namaPPK = value.data()['namaPPK'].toString();
          ppkUid = value.data()['ppkUid'].toString();
        },);

  List<Report> listReport = await _firestore
        .collection(unitPath).doc(unit.toString()).collection('laporan').get().then((value) {
          print("CALLED THEN LAPORAN");
          return value.docs.map((e) => Report.fromDb(e.data(), int.parse(e.id))).toList();
        });

  return Unit(
    listLaporan : listReport,
    namaPPK: namaPPK,
    namaUnit: namaUnit,
    ppkUid: ppkUid,
    unitId: unit.toString(),
  );
  }

  Stream<List<SalesOrder>> getSalesOrderLimited({int unit, List<int> status, int limit}) {
    //Sales order sesuai unit
    return _firestore
        .collection(salesOrderPath)
        .where("unit", isEqualTo:  unit)
        .where('status', whereIn: status).orderBy('creationDate',descending: true).limit(limit)
        .snapshots()
        .map((QuerySnapshot snapshot) => snapshot.docs
            .map((DocumentSnapshot e) => SalesOrder.fromDb(e.data(), e.id))
            .toList());
  }


}
