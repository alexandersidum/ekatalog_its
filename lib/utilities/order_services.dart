import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_catalog/models/sales_order.dart';
import 'package:e_catalog/models/cart.dart';
import 'package:e_catalog/models/shipping_address.dart';

class OrderServices {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String salesOrderPath = 'sales_order';
  String miscPath = 'misc';
  String usersPath = 'users';

  Stream<List<SalesOrder>> getSalesOrder(int unit) {
    //Sales order sesuai unit
    return _firestore
        .collection(salesOrderPath)
        .where("unit", whereIn: [unit])
        .snapshots()
        .map((QuerySnapshot snapshot) =>
            snapshot.docs
            .map((DocumentSnapshot e) => SalesOrder.fromDb(e.data())).toList());
  }

  Future<bool> setShippingAddress(String ppUid, ShippingAddress newAddress) async{
    bool isSuccess = true;
    await  _firestore.collection(usersPath).doc(ppUid).collection("shipping").doc(newAddress.id)
    .set(newAddress.toMap(), SetOptions(merge: true)).catchError((Object error){
      isSuccess = false;
      print("ERROR setShippingAddress");
    });
    return isSuccess;
  }

  Future<bool> createShippingAddress(String ppUid, ShippingAddress newAddress) async{
    bool isSuccess = true;
    await  _firestore.collection(usersPath).doc(ppUid).collection("shipping").add(newAddress.toMap()).then(
      (value) => value!=null?isSuccess = true:isSuccess =false).catchError((Object error){
        isSuccess = false;
      });
    return isSuccess;
  }


  Stream<List<ShippingAddress>> getShippingAddress(String ppUid){
    return _firestore.collection(usersPath).doc(ppUid).collection("shipping").snapshots().map(
      (event)=>event.docs.map((e) => ShippingAddress.fromDb(e.data(), e.id)).toList()
      );
  }

  Future<String> getLatestSalesOrderID() async {
    var docRef = _firestore.collection(miscPath).doc('latest_id');
    return await _firestore.runTransaction((transaction) async {
      return await transaction.get(docRef).then((value) {
        if (value.exists) {
          DateTime dataDate =
              DateTime.parse(value.data()['date'].toDate().toString());
          DateTime latestDate =
              DateTime(dataDate.year, dataDate.month, dataDate.day);
          DateTime dateNow = DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day);
          if (latestDate == dateNow) {
            var newId = value.data()['id'] + 1;
            transaction.update(docRef, {'id': newId, 'date': dateNow});
            return "SO${dateNow.day}${dateNow.month}${dateNow.year}${newId.toString().padLeft(3, '0')}";
          } else {
            transaction.update(docRef, {'id': 1, 'date': dateNow});
            return "SO${dateNow.day}${dateNow.month}${dateNow.year}001";
          }
        } else {
          throw Exception('Error getting Latest SalesOrderID');
        }
      });
    });
  }

  Future<void> changeOrderStatus({String orderId, int newStatus, Function callback})async{
    var docRef = _firestore.collection(salesOrderPath);
    await docRef.where('id',  isEqualTo: orderId).get().then(
      (snapshot) => snapshot.docs.forEach((element) {
        docRef.doc(element.id).update({"status":newStatus}).then((value) {callback(true);}).catchError((Object error){
          callback(false);
        });
      }));
  }

  Future<void> createSalesOrder(SalesOrder order, Function isSuccess) async {
    var docRef = _firestore.collection(salesOrderPath);
    await docRef.add(order.toMap()).then((value) {
      value != null ? isSuccess(true) : isSuccess(false);
    }).timeout(Duration(seconds: 10), onTimeout: () {
      isSuccess(false);
    });
  }

  Future<void> batchCreateSalesOrder(
      {List<LineItem> itemList,
      String ppName,
      String ppUid,
      int unit,
      Function onComplete}) async {
    var docRef = _firestore.collection(salesOrderPath);
    try {
      String ppkName;
      String ppkUid;
      await _firestore
          .collection(usersPath)
          .doc('ppk_info')
          .get()
          .then((value) async {
        if (!value.exists) {
          throw ("PPK INFO NOT EXIST");
        }
        await _firestore
            .collection(usersPath)
            .doc(value.data()[unit.toString()])
            .get()
            .then((value) {
          if (!value.exists) {
            throw ("PPK USER INFO NOT EXIST");
          }
          //TODO thrower jika gagal
          ppkUid = value.id;
          ppkName = value.data()['name'];
        });
      });
      itemList.forEach((element) async {
        var order = SalesOrder(
            id: await getLatestSalesOrderID(),
            count: element.count,
            ppName: ppName,
            ppUid: ppUid,
            unit: unit,
            creationDate: DateTime.now(),
            ppkName: ppkName,
            ppkUid: ppkUid,
            itemId: element.item.id,
            itemName: element.item.name,
            seller: element.item.seller,
            sellerUid: element.item.sellerUid,
            status: 0,
            totalPrice: element.item.price * element.count);
        _firestore.runTransaction((transaction) async {
          transaction.set(docRef.doc(), order.toMap());
        }).catchError((err) {
          onComplete(false);
          throw ("Error Creating Sales Order");
        });
      });
      onComplete(true);
    } catch (error) {
      print(error);
      onComplete(false);
    }
  }
}
