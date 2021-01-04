//model buat sales order
import 'package:e_catalog/models/cart.dart';

class SalesOrder{

  String id;
  String docId;
  String itemName;
  String itemId;
  List itemImage;
  int count;
  int totalPrice;
  String seller; 
  String sellerUid; 
  DateTime creationDate;
  //shipping
  String namaPenerima;
  String namaAlamat;
  String teleponPenerima;
  String address;
  int status;
  String ppUid;
  String ppName;
  String ppkUid;
  String ppkName;
  int unit;
  int tax;
  int unitPrice;
  String feedback;

  SalesOrder({this.id, this.docId, this.itemName, this.itemImage, this.ppkName, this.creationDate, this.itemId, this.count, this.totalPrice, this.seller, this.sellerUid, this.status, this.ppName, this.ppUid, this.ppkUid, this.unit, this.address, this.namaAlamat, this.namaPenerima,this.teleponPenerima,this.unitPrice, this.feedback, this.tax});

  factory SalesOrder.fromDb(Map<String , dynamic> parsedData, String docId){
    return SalesOrder(
      docId: docId,
      id: parsedData['id'],
      seller: parsedData['seller'],
      sellerUid: parsedData['sellerUid'],
      count: parsedData['count'],
      creationDate: DateTime.parse(parsedData['creationDate'].toDate().toString()),
      itemId: parsedData['itemId'],
      itemName: parsedData['itemName'],
      itemImage: parsedData['itemImage'],
      status: parsedData['status'],
      totalPrice: parsedData['totalPrice'],
      ppName: parsedData['ppName'],
      ppUid: parsedData['ppUid'],
      unit: parsedData['unit'],
      ppkUid: parsedData['ppkUid'],
      ppkName: parsedData['ppkName'],
      address: parsedData['address'],
      namaAlamat: parsedData['namaAlamat'],
      namaPenerima: parsedData['namaPenerima'],
      teleponPenerima: parsedData['teleponPenerima'],
      feedback: parsedData['feedback']!=null?parsedData['feedback']:'',
      tax: parsedData['tax'],
      unitPrice: parsedData['unitPrice'],
    );
  }

  Map<String , dynamic> toMap(){
    return{
      'id' : this.id,
      'seller' : this.seller,
      'sellerUid' : this.sellerUid,
      'itemName' : this.itemName,
      'itemId' : this.itemId,
      'count' : this.count,
      'creationDate' : this.creationDate,
      'totalPrice' : this.totalPrice,
      'status' : this.status,
      'ppName' : this.ppName,
      'ppUid' : this.ppUid,
      'ppkName' : this.ppkName,
      'ppkUid' : this.ppkUid,
      'unit' : this.unit,
      'address' : this.address,
      'namaAlamat' : this.namaAlamat,
      'namaPenerima' : this.namaPenerima,
      'teleponPenerima' : this.teleponPenerima,
      'feedback' : this.feedback,
      'tax' : this.tax,
      'unitPrice' : this.unitPrice,
      'itemImage' : this.itemImage,
    };
  }

  String getStatus(){
    switch(this.status){
      case 0:
        return "Belum Disetujui";
      case 1:
        return "Disetujui";
      case 2:
        return "Ditolak";
      case 3:
        return "Segera Dikirim";
      case 4:
        return "Dibatalkan Penyedia";
      case 5:
        return "Dibatalkan PPK";
      case 6:
        return "Menunggu Pembayaran";
      case 7:
        return "Selesai";
      default:
        return "Undefined";
    }
  }

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

  String getStatusPenyedia(){
    switch(this.status){
      case 0:
        return "Belum Diterima";
      case 1:
        return "Menunggu Respon";
      case 2:
        return "Ditolak";
      case 3:
        return "Segera Dikirim";
      case 4:
        return "Dibatalkan Penyedia";
      case 5:
        return "Dibatalkan PPK";
      case 6:
        return "Menunggu Pembayaran";
      case 7:
        return "Selesai";
      default:
        return "Undefined";
    }
  }
}

// Status SalesOrder
// 0 : Belum Disetujui PPK
// 1 : Disetujui PPK 
// 2 : Ditolak PPK
// 3 : Segera Dikirim
// 4 : Dibatalkan Penyedia
// 5 : Dibatalkan PPK
// 6 : Menunggu Pembayaran
// 7 : Selesai
