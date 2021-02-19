import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_catalog/models/sales_order.dart';
import 'package:e_catalog/models/unit.dart';

class ReportServices {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
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

  Stream<List<SalesOrder>> getSalesOrderLimited({int unit, int limit}) {
    //Sales order sesuai unit
    var activeDocRef =
        _firestore.collection(salesOrderPath).doc("active").collection("order");
    var completedDocRef = _firestore
        .collection(salesOrderPath)
        .doc("completed")
        .collection("order");

    return completedDocRef
        .where("unit", isEqualTo:  unit).orderBy('creationDate',descending: true).limit(limit)
        .snapshots()
        .map((QuerySnapshot snapshot) => snapshot.docs
            .map((DocumentSnapshot e) => SalesOrder.fromDb(e.data(), e.id))
            .toList());
  }
}
