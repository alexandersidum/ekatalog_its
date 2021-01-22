import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_catalog/models/sales_order.dart';
import 'package:e_catalog/models/cart.dart';
import 'package:e_catalog/models/shipping_address.dart';
import 'package:collection/collection.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as p;

class OrderServices {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseStorage _fstorage = FirebaseStorage.instance;
  String salesOrderPath = 'sales_order';
  String unitPath = 'unit';
  String miscPath = 'misc';
  String usersPath = 'users';
  

  Future<bool> uploadPembayaranBPP(
      {String salesOrderDocId, String keterangan, String imageBuktiUrl}) async {
    Map<String, dynamic> input = {
      "status": 8,
      "keteranganPembayaran": keterangan!=null?keterangan : "",
      "imageBuktiUrl" : imageBuktiUrl
    };
    return _firestore
        .collection(salesOrderPath)
        .doc(salesOrderDocId)
        .update(input).then((value) => true).catchError((Object error)=>false);
  }

  // Future<bool> konfirmasiPembayaranPenyedia(
  //     {String salesOrderDocId, String keterangan, bool isAccepted}) async {
  //   Map<String, dynamic> input = {
  //     "status": 8,
  //     "keteranganPembayaran": keterangan!=null?keterangan : "",
  //     "imageBuktiUrl" : imageBuktiUrl
  //   };
  //   return _firestore
  //       .collection(salesOrderPath)
  //       .doc(salesOrderDocId)
  //       .update(input).then((value) => true).catchError((Object error)=>false);
  // }

  Future<void> uploadBuktiPembayaran(File buktiPhoto, Function callback) async {
    String fileName = p.basename(buktiPhoto.path);
    Reference storageRef = _fstorage.ref().child('foto_bukti/$fileName');
    await storageRef.putFile(buktiPhoto);
    await storageRef
        .getDownloadURL()
        .then((value) => callback(value))
        .catchError((Object error) => callback(null));
  }



   Future<bool> konfirmasiPembayaranPenyedia(
      {SalesOrder order,
      bool isAccepted,
      String keterangan, 
      int unit,
      Function callback}) async {
        //STEP TERAKHIR JADI DIMASUKKAN LAPORAN
    bool output = false;
    var salesOrderRef = _firestore.collection(salesOrderPath);
    var unitRef = _firestore.collection(unitPath);
    Map <String, dynamic> input = {"status":isAccepted?10:9};
    if(keterangan!=null) input["keterangan"]=keterangan;

    await _firestore.runTransaction((transaction) async{
      await transaction.update(salesOrderRef
        .doc(order.docId), input);
      if(isAccepted){
        await transaction.set(unitRef
        .doc(order.unit.toString()).collection("laporan").doc(order.creationDate.year.toString()),{
          'pengeluaran': FieldValue.increment(order.totalPrice),
          'jumlahPengadaan': FieldValue.increment(1),
          'pembelianTerakhir' : order.id
        }, SetOptions(merge:true));
      }
    }).then((value) {
      output = true;
      callback(true);
    } ).catchError((Object error){
      print(error);
      output = false;
      callback(false);
    });
    return output;
  }

  Stream<List<SalesOrder>> getSalesOrder({int unit, List<int> status}) {
    //Sales order sesuai unit
    return _firestore
        .collection(salesOrderPath)
        .where("unit", isEqualTo:  unit)
        .where('status', whereIn: status)
        .snapshots()
        .map((QuerySnapshot snapshot) => snapshot.docs
            .map((DocumentSnapshot e) => SalesOrder.fromDb(e.data(), e.id))
            .toList());
  }

  Stream<List<SalesOrder>> getBPPSalesOrder(int unit, List<int> status) {
    //Sales order buat bpp
    return _firestore
        .collection(salesOrderPath)
        .where("unit", isEqualTo: unit)
        .where("status", whereIn: status)
        .snapshots()
        .map((QuerySnapshot snapshot) => snapshot.docs
            .map((DocumentSnapshot e) => SalesOrder.fromDb(e.data(), e.id))
            .toList());
  }

  Stream<List<SalesOrder>> getPPSalesOrder(String ppUid, List<int> status) {
    //Sales order buat pp
    return _firestore
        .collection(salesOrderPath)
        .where("ppUid", isEqualTo: ppUid)
        .where("status", whereIn: status)
        .snapshots()
        .map((QuerySnapshot snapshot) => snapshot.docs
            .map((DocumentSnapshot e) => SalesOrder.fromDb(e.data(), e.id))
            .toList());
  }

  Stream<List<SalesOrder>> getSellerSalesOrder(
      String sellerUid, List<int> status) {
    //Sales order sesuai seller dan status
    return _firestore
        .collection(salesOrderPath)
        .where("sellerUid", isEqualTo: sellerUid)
        .where("status", whereIn: status)
        .snapshots()
        .map((QuerySnapshot snapshot) => snapshot.docs
            .map((DocumentSnapshot e) => SalesOrder.fromDb(e.data(), e.id))
            .toList());
  }

  Future<bool> setShippingAddress(
      String ppUid, ShippingAddress newAddress) async {
    bool isSuccess = true;
    await _firestore
        .collection(usersPath)
        .doc(ppUid)
        .collection("shipping")
        .doc(newAddress.id)
        .set(newAddress.toMap(), SetOptions(merge: true))
        .catchError((Object error) {
      isSuccess = false;
      print("ERROR setShippingAddress");
    });
    return isSuccess;
  }

  Future<bool> createShippingAddress(
      String ppUid, ShippingAddress newAddress) async {
    bool isSuccess = true;
    await _firestore
        .collection(usersPath)
        .doc(ppUid)
        .collection("shipping")
        .add(newAddress.toMap())
        .then((value) => value != null ? isSuccess = true : isSuccess = false)
        .catchError((Object error) {
      isSuccess = false;
    });
    return isSuccess;
  }

  Stream<List<ShippingAddress>> getShippingAddress(String ppUid) {
    return _firestore
        .collection(usersPath)
        .doc(ppUid)
        .collection("shipping")
        .snapshots()
        .map((event) => event.docs
            .map((e) => ShippingAddress.fromDb(e.data(), e.id))
            .toList());
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

  // Future<void> changeOrderStatus({String orderId, int newStatus, String keterangan, Function callback})async{
  //   var docRef = _firestore.collection(salesOrderPath);
  //   await docRef.where('id',  isEqualTo: orderId).get().then(
  //     (snapshot) => snapshot.docs.forEach((element) {
  //       docRef.doc(element.id).update(
  //         keterangan!=null?
  //         {"status":newStatus,
  //         "keterangan":keterangan}:
  //         {"status":newStatus}
  //         ).then((value) {callback(true);}).catchError((Object error){
  //         callback(false);
  //       });
  //     }));
  // }

  Future<bool> changeOrderStatus(
      {String docId,
      int newStatus,
      String keterangan,
      Function callback}) async {
    bool output = false;
    var docRef = _firestore.collection(salesOrderPath);
    await docRef
        .doc(docId)
        .update(keterangan != null
            ? {"status": newStatus, "keterangan": keterangan}
            : {"status": newStatus})
        .then((value) {
      output = true;
      callback(true);
    }).catchError((Object error) {
      print(error);
      output = false;
      callback(false);
    });
    return output;
  }

  Future<bool> changeSubOrderStatus(
      {String docId,
      int newTotalPrice,
      List<Order> newOrderList,
      Function callback}) async {
    var docRef = _firestore.collection(salesOrderPath);
    bool output = false;
    bool isTotalDeclined = true;
    bool isPartialDeclined = false;

    newOrderList.forEach((element) {
      if (element.status == 0) isTotalDeclined = false;
      else if (element.status == 1) isPartialDeclined = true;
    });

    Map<String,dynamic> input = {"listOrder": newOrderList.map((e) => e.toMap()).toList()};
    if (newTotalPrice != null) input['totalPrice'] = newTotalPrice;
    if (isTotalDeclined) input['status'] = 5;
    else if (isPartialDeclined) input['status'] = 3;
    else {input['status'] = 4;}
    await docRef.doc(docId).update(input).then((value) {
      print("SAKSES");
      output = true;
      callback(true);
    });
    return output;
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
      ShippingAddress shippingAddress,
      Function onComplete}) async {
    var docRef = _firestore.collection(salesOrderPath);
    try {
      String ppkName;
      String ppkUid;
      await _firestore
          .collection(miscPath)
          .doc('ppk_info')
          .get()
          .then((value) async {
        if (!value.exists) {
          throw ("PPK INFO NOT EXIST");
        } else {
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
        }
      });
      itemList.forEach((element) async {
        var order = SalesOrder(
            id: await getLatestSalesOrderID(),
            ppName: ppName,
            ppUid: ppUid,
            unit: unit,
            creationDate: DateTime.now(),
            ppkName: ppkName,
            ppkUid: ppkUid,
            seller: element.item.seller,
            sellerUid: element.item.sellerUid,
            status: 0,
            address: shippingAddress.address,
            namaAlamat: shippingAddress.namaAlamat,
            namaPenerima: shippingAddress.namaPenerima,
            teleponPenerima: shippingAddress.teleponPenerima,
            totalPrice: ((element.item.price * element.count) *
                    (1 + element.item.taxPercentage / 100))
                .round());
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

  Future<void> batchCreateSalesOrderGroup(
      {List<LineItem> itemList,
      String ppName,
      String ppUid,
      int unit,
      ShippingAddress shippingAddress,
      Function onComplete}) async {
    var docRef = _firestore.collection(salesOrderPath);
    var ppkInfoRef = _firestore.collection(miscPath).doc('ppk_info');

    var groupedItemMap = groupBy(itemList, (LineItem lineItem) {
      return lineItem.item.sellerUid;
    });
    String ppkName;
    String ppkUid;

    Future.forEach(groupedItemMap.entries,
        (MapEntry<String, List<LineItem>> element) async {
      DocumentSnapshot ppkSnap = await ppkInfoRef.get();
      if (!ppkSnap.exists) {
        print("PPK TIDAK ADA");
        throw Exception("PPK INFO TIDAK EXIST!");
      }
      //ambil data ppk dulu
      ppkUid = ppkSnap.data()[unit.toString()]['ppkUid'];
      ppkName = ppkSnap.data()[unit.toString()]['ppkName'];

      int totalPrice = 0;
      List<LineItem> list = element.value;
      List<Order> orderlist = [];
      //hitung total price so
      list.forEach((element) {
        print("lineitem foreach");
        totalPrice = totalPrice +
            ((element.item.price * element.count) *
                    (1 + (element.item.taxPercentage / 100)))
                .round();
      });
      //Looping cart menjadi Order
      element.value.forEach((LineItem lineItem) {
        Order order = Order(
            count: lineItem.count,
            itemId: lineItem.item.id,
            itemImage: lineItem.item.image,
            itemName: lineItem.item.name,
            status: 0,
            tax: lineItem.item.taxPercentage,
            unitPrice: lineItem.item.price,
            orderPrice: ((lineItem.item.price * lineItem.count) *
                    (1 + lineItem.item.taxPercentage / 100))
                .round());
        print(order.itemName);
        orderlist.add(order);
      });
      // await Future.forEach(element.value, (LineItem lineItem)async{

      // });

      var order = SalesOrder(
          id: await getLatestSalesOrderID().catchError((Object onError) {
            print("GAGAL NGAMBIL ORDER ID");
          }),
          ppName: ppName,
          ppUid: ppUid,
          sellerUid: element.key,
          seller: element.value[0].item.seller,
          unit: unit,
          creationDate: DateTime.now(),
          ppkName: ppkName,
          ppkUid: ppkUid,
          status: 0,
          address: shippingAddress.address,
          namaAlamat: shippingAddress.namaAlamat,
          namaPenerima: shippingAddress.namaPenerima,
          teleponPenerima: shippingAddress.teleponPenerima,
          totalPrice: totalPrice,
          listOrder: orderlist);
      print("ADD");
      await docRef.add(order.toMap());
    }).then((value) => onComplete(true)).catchError((Object error) {
      onComplete(false);
      print("Error");
    });
  }
}
