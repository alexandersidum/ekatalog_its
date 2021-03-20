import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_catalog/models/sales_order.dart';
import 'package:e_catalog/models/cart.dart';
import 'package:e_catalog/models/shipping_address.dart';
import 'package:collection/collection.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as p;

// Status SalesOrder
// 0 : Belum Disetujui PPK
// 1 : Disetujui PPK 
// 2 : Ditolak PPK
// 3 : Disanggupi sebagian
// 4 : Disanggupi dan Segera Dikirim 
// 5 : Dibatalkan Penyedia
// 6 : Dibatalkan PPK
// 7 : Menunggu Pembayaran
// 8 : Menunggu Konfirmasi Pembayaran 
// 9 : Pembayaran ditolak penyedia
// 10 : Selesai

// Status subOrder
// 0 : Belum direspon
// 1: Disanggupi
// 2 : Dibatalkan

class OrderServices {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseStorage _fstorage = FirebaseStorage.instance;
  String salesOrderPath = 'sales_order';
  String unitPath = 'unit';
  String miscPath = 'misc';
  String usersPath = 'users';
  String ppkPath = 'ppk_info';
  List<int> completeStatus = [2, 5, 6, 10];

  Future<bool> uploadPembayaranBPP(
      {String salesOrderDocId, String keterangan, String imageBuktiUrl}) async {
        var activeDocRef =
        _firestore.collection(salesOrderPath).doc("active").collection("order");

    Map<String, dynamic> input = {
      "status": 8,
      "keteranganPembayaran": keterangan != null ? keterangan : "",
      "imageBuktiUrl": imageBuktiUrl
    };
    return activeDocRef
        .doc(salesOrderDocId)
        .update(input)
        .then((value) => true)
        .catchError((Object error) => false);
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

  Future<void> uploadBuktiPenerimaan(File buktiPhoto, Function callback) async {
    String fileName = p.basename(buktiPhoto.path);
    Reference storageRef =
        _fstorage.ref().child('foto_bukti_penerimaan/$fileName');
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
    var unitRef = _firestore.collection(unitPath);
    int status = isAccepted ? 10 : 9;
    Map<String, dynamic> input = {"status": status};
    if (keterangan != null) input["keterangan"] = keterangan;

    changeOrderStatus(
        docId: order.docId,
        keterangan: keterangan,
        newStatus: status,
        order: order,
        callback: (isSuccess) async {
          if (isSuccess) {
            await _firestore.runTransaction((transaction) async {
              if (isAccepted) {
                await transaction.set(
                    unitRef
                        .doc(order.unit.toString())
                        .collection("laporan")
                        .doc(order.creationDate.year.toString()),
                    {
                      'pengeluaran': FieldValue.increment(order.totalPrice),
                      'jumlahPengadaan': FieldValue.increment(1),
                      'pembelianTerakhir': order.id
                    },
                    SetOptions(merge: true));
              }
            }).then((value) {
              output = true;
              callback(true);
            }).catchError((Object error) {
              output = false;
              callback(false);
            });
          }
        });
    return output;
  }

  Stream<List<SalesOrder>> getSalesOrder({String ppkCode, List<int> status}) {
    //Sales order sesuai unit
    var docRef =
        _firestore.collection(salesOrderPath).doc("active").collection("order");
    return docRef
        .where("ppkCode", isEqualTo: ppkCode)
        .where('status', whereIn: status)
        .orderBy("creationDate", descending: true)
        .limit(20)
        .snapshots()
        .map((QuerySnapshot snapshot) => snapshot.docs
            .map((DocumentSnapshot e) => SalesOrder.fromDb(e.data(), e.id))
            .toList());
  }

  Future<List<SalesOrder>> getSalesOrderPPK(
      {String ppkCode, List<int> status}) async {
    //Sales order sesuai unit
    var docRef =
        _firestore.collection(salesOrderPath).doc("active").collection("order");
    return await docRef
        .where("ppkCode", isEqualTo: ppkCode)
        .where('status', whereIn: status)
        .orderBy("creationDate", descending: true)
        .limit(20)
        .get()
        .then((e) {
      return e.docs
          .map((DocumentSnapshot e) => SalesOrder.fromDb(e.data(), e.id))
          .toList();
    }).catchError((e) {
      return null;
    });
  }

  Future<List<SalesOrder>> getSalesOrderHistoryPPK(
      {String ppkCode}) async {
    //Sales order sesuai unit
    var docRef =
        _firestore.collection(salesOrderPath).doc("completed").collection("order");
    return await docRef
        .where("ppkCode", isEqualTo: ppkCode)
        .orderBy("creationDate", descending: true)
        .limit(20)
        .get()
        .then((e) {
      return e.docs
          .map((DocumentSnapshot e) => SalesOrder.fromDb(e.data(), e.id))
          .toList();
    }).catchError((e) {
      return null;
    });
  }

  Stream<SalesOrder> getSingleSalesOrder({String docId}) {
    //Sales order sesuai unit
    var docRef =
        _firestore.collection(salesOrderPath).doc("active").collection("order");
    return docRef
        .doc(docId)
        .snapshots()
        .map((e) => SalesOrder.fromDb(e.data(), e.id));
  }

  Stream<List<SalesOrder>> getBPPSalesOrder(int unit, List<int> status) {
    //Sales order buat bpp
    var docRef =
        _firestore.collection(salesOrderPath).doc("active").collection("order");
    return docRef
        .where("unit", isEqualTo: unit)
        .where("status", whereIn: status)
        .snapshots()
        .map((QuerySnapshot snapshot) => snapshot.docs
            .map((DocumentSnapshot e) => SalesOrder.fromDb(e.data(), e.id))
            .toList());
  }

  Stream<List<SalesOrder>> getPPSalesOrder(String ppUid, List<int> status) {
    //Sales order buat pp
    var docRef =
        _firestore.collection(salesOrderPath).doc("active").collection("order");
    return docRef
        .where("ppUid", isEqualTo: ppUid)
        .where("status", whereIn: status)
        .snapshots()
        .map((QuerySnapshot snapshot) => snapshot.docs
            .map((DocumentSnapshot e) => SalesOrder.fromDb(e.data(), e.id))
            .toList());
  }

  Stream<List<SalesOrder>> getUnitActiveSalesOrder(int unit) {
    //Sales order buat pp
    var docRef =
        _firestore.collection(salesOrderPath).doc("active").collection("order");
    return docRef
        .where("unit", isEqualTo: unit)
        .snapshots()
        .map((QuerySnapshot snapshot) => snapshot.docs
            .map((DocumentSnapshot e) => SalesOrder.fromDb(e.data(), e.id))
            .toList());
  }

  Stream<List<SalesOrder>> getUnitActiveSalesOrderByStatus(int unit, List<int> status) {
    //Sales order buat pp
    var docRef =
        _firestore.collection(salesOrderPath).doc("active").collection("order");
    return docRef
        .where("unit", isEqualTo: unit)
        .where("status", whereIn : status)
        .snapshots()
        .map((QuerySnapshot snapshot) => snapshot.docs
            .map((DocumentSnapshot e) => SalesOrder.fromDb(e.data(), e.id))
            .toList());
  }

  Stream<List<SalesOrder>> getSellerSalesOrder(
      String sellerUid, List<int> status) {
    //Sales order sesuai seller dan status
    var docRef =
        _firestore.collection(salesOrderPath).doc("active").collection("order");
    return docRef
        .where("sellerUid", isEqualTo: sellerUid)
        .where("status", whereIn: status)
        .orderBy('creationDate', descending: true)
        .snapshots()
        .map((QuerySnapshot snapshot) => snapshot.docs
            .map((DocumentSnapshot e) => SalesOrder.fromDb(e.data(), e.id))
            .toList());
  }

  Stream<List<SalesOrder>> getSellerSalesOrderHistory(
      String sellerUid) {
    //Sales order sesuai seller dan status
    var docRef =
        _firestore.collection(salesOrderPath).doc("completed").collection("order");
    return docRef
        .where("sellerUid", isEqualTo: sellerUid)
        .orderBy('creationDate', descending: true)
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

  Future<bool> setProductReceiveStatus(
      {String docId,
      int newStatus,
      File buktiPenerimaan,
      String keterangan,
      Function callback}) async {
    bool output = false;
    var docRef =
        _firestore.collection(salesOrderPath).doc("active").collection("order");
    if (buktiPenerimaan != null) {
      await uploadBuktiPenerimaan(buktiPenerimaan, (url) async {
        if (url != null) {
          await docRef
              .doc(docId)
              .update(keterangan != null
                  ? {
                      "status": newStatus,
                      "keterangan": keterangan,
                      "bukti_penerimaan": url
                    }
                  : {"status": newStatus, "bukti_penerimaan": url})
              .then((value) {
            output = true;
            callback(true);
          }).catchError((Object error) {
            output = false;
            callback(false);
          });
        } else {
          output = false;
          callback(false);
        }
      });
    } else {
      await docRef
          .doc(docId)
          .update(keterangan != null
              ? {
                  "status": newStatus,
                  "keterangan": keterangan,
                  "bukti_penerimaan": ""
                }
              : {"status": newStatus, "bukti_penerimaan": ""})
          .then((value) {
        output = true;
        callback(true);
      }).catchError((Object error) {
        output = false;
        callback(false);
      });
    }
    return output;
  }

  Future<bool> changeOrderStatus(
      {String docId,
      int newStatus,
      String keterangan,
      Function callback,
      SalesOrder order}) async {
    bool output = false;
    var activeDocRef =
        _firestore.collection(salesOrderPath).doc("active").collection("order");
    var completedDocRef = _firestore
        .collection(salesOrderPath)
        .doc("completed")
        .collection("order");
    if (completeStatus.contains(newStatus)) {
      await _firestore
          .runTransaction((transaction) async {
            transaction
                .set(completedDocRef.doc(order.docId), order.toMap())
                .update(
                    completedDocRef.doc(order.docId),
                    keterangan != null
                        ? {"status": newStatus, "keterangan": keterangan}
                        : {"status": newStatus});
            transaction.delete(activeDocRef.doc(order.docId));
          })
          .then((e) => callback(true))
          .catchError((e) => callback(false));
    } else {
      await activeDocRef
          .doc(docId)
          .update(keterangan != null
              ? {"status": newStatus, "keterangan": keterangan}
              : {"status": newStatus})
          .then((value) {
        output = true;
        callback(true);
      }).catchError((Object error) {
        output = false;
        callback(false);
      });
    }
    return output;
  }

  //Untuk change status salesorder yang selesai dibatalkan / selesai
  Future<bool> changeOrderStatusCompleted(
      {String docId,
      int newStatus,
      String keterangan,
      Function callback,
      SalesOrder order}) async {
    bool output = false;
    var activeDocRef =
        _firestore.collection(salesOrderPath).doc("active").collection("order");
    var completedDocRef = _firestore
        .collection(salesOrderPath)
        .doc("completed")
        .collection("order");
    await _firestore
        .runTransaction((transaction) async {
          transaction
              .set(completedDocRef.doc(order.docId), order.toMap())
              .update(
                  completedDocRef.doc(order.docId),
                  keterangan != null
                      ? {"status": newStatus, "keterangan": keterangan}
                      : {"status": newStatus});
          transaction.delete(activeDocRef.doc(order.docId));
        })
        .then((e) => callback(true))
        .catchError((e) => callback(false));
    return output;
  }

  Future<bool> changeSubOrderStatus(
      {String docId,
      int newTotalPrice,
      List<Order> newOrderList,
      Function callback}) async {
    var docRef = _firestore.collection(salesOrderPath).doc("active").collection("order");
    bool output = false;

    Map<String, dynamic> input = {
      "listOrder": newOrderList.map((e) => e.toMap()).toList()
    };
    if (newTotalPrice != null) input['totalPrice'] = newTotalPrice;
    await docRef.doc(docId).update(input).then((value) {
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


  Future<void> batchCreateSalesOrderGroup(
      {List<LineItem> itemList,
      String ppName,
      String ppUid,
      String ppkCode,
      int unit,
      String namaUnit,
      ShippingAddress shippingAddress,
      Function onComplete}) async {
    var ppkInfoRef = _firestore.collection(ppkPath).doc(ppkCode);
    var docRef =
        _firestore.collection(salesOrderPath).doc("active").collection("order");
    var groupedItemMap = groupBy(itemList, (LineItem lineItem) {
      return lineItem.item.sellerUid;
    });
    String ppkName;
    String ppkUid;
    Future.forEach(groupedItemMap.entries,
        (MapEntry<String, List<LineItem>> element) async {
      DocumentSnapshot ppkSnap = await ppkInfoRef.get();
      if (!ppkSnap.exists) {
        throw Exception("PPK Not Assigned");
      }
      //ambil data ppk dulu
      ppkUid = ppkSnap.data()['ppk_uid'];
      ppkName = ppkSnap.data()['ppk_name'];
      if(ppkUid==null||ppkName==null){
        throw Exception("PPK Not Assigned");
      }
      int totalPrice = 0;
      List<LineItem> list = element.value;
      List<Order> orderlist = [];
      //hitung total price so
      list.forEach((element) {
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
        orderlist.add(order);
      });
      var order = SalesOrder(
          id: await getLatestSalesOrderID().catchError((Object onError) {
            throw Exception("Error mengambil id Sales Order");
          }),
          ppName: ppName,
          ppUid: ppUid,
          ppkCode :ppkCode,
          sellerUid: element.key,
          seller: element.value[0].item.seller,
          unit: unit,
          creationDate: DateTime.now(),
          ppkName: ppkName,
          ppkUid: ppkUid,
          status: 0,
          namaUnit: namaUnit,
          address: shippingAddress.address,
          namaAlamat: shippingAddress.namaAlamat,
          namaPenerima: shippingAddress.namaPenerima,
          teleponPenerima: shippingAddress.teleponPenerima,
          totalPrice: totalPrice,
          listOrder: orderlist);
      await docRef.add(order.toMap());
    }).then((value) => onComplete(true)).catchError((Object error) {
      onComplete(false);
    });
  }

  Future<List<SalesOrder>> getSalesOrderBySearch(
      {String keyword, bool isCompleted, String ppkCode}) async {
    //Unit diganti kode ppk
    var docRef = isCompleted
        ? _firestore
            .collection(salesOrderPath)
            .doc("completed")
            .collection("order")
        : _firestore
            .collection(salesOrderPath)
            .doc("active")
            .collection("order");
    List<String> keywords = keyword.trim().toLowerCase().split(" ");
    return await docRef
        .where("ppkCode", isEqualTo: ppkCode)
        .where('keyword', arrayContainsAny: keywords)
        .get()
        .then((value) =>
            value.docs.map((e) => SalesOrder.fromDb(e.data(), e.id)).toList())
        .catchError((Object err) => List<SalesOrder>());
  }
}
