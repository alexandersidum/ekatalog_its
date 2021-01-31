//model buat sales order
import 'package:e_catalog/models/cart.dart';

class SalesOrder{

  String id;
  String docId;
  List<Order> listOrder;
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
  String feedback;
  String imageBuktiPembayaran;
  String imageBuktiPenerimaan;
  String keteranganPembayaran;


  SalesOrder({this.id, this.docId, this.listOrder, this.ppkName, 
  this.creationDate, this.totalPrice, this.seller, 
  this.sellerUid, this.status, this.ppName, this.ppUid, 
  this.ppkUid, this.unit, this.address, this.namaAlamat, 
  this.namaPenerima,this.teleponPenerima, this.feedback, this.imageBuktiPembayaran, this.imageBuktiPenerimaan, this.keteranganPembayaran});

  factory SalesOrder.fromDb(Map<String , dynamic> parsedData, String docId){
    List<Order> orderList = parsedData['listOrder'].map<Order>((e) {
      var order = Map<String, dynamic>.from(e);
      // print(z['itemName']);
      return Order.fromMap(order);
    }).toList();
    print(parsedData['status']);
    return SalesOrder(
      docId: docId,
      id: parsedData['id'],
      seller: parsedData['seller'],
      sellerUid: parsedData['sellerUid'],
      creationDate: DateTime.parse(parsedData['creationDate'].toDate().toString()),
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
      listOrder: orderList,
      imageBuktiPembayaran: parsedData['imageBuktiUrl'],
      imageBuktiPenerimaan: parsedData['bukti_penerimaan'],
      keteranganPembayaran: parsedData['keteranganPembayaran'],
      // listOrder : parsedData['listOrder'].map<Order>((Map<String, dynamic> e)=>Order.fromMap(e)).toList()
    );
  }

  Map<String , dynamic> toMap(){
    return{
      'id' : this.id,
      'seller' : this.seller,
      'sellerUid' : this.sellerUid,
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
      'listOrder' : this.listOrder.map((e) => e.toMap()).toList(),
      'keyword' : generateKeyword()
    };
  }

  List<String> generateKeyword() {
    List<String> output = List();
    output.add(this.id.toLowerCase());
    this.listOrder.forEach((order){
      if(order.status==0){
      output.add(order.itemName.toLowerCase());
      List<String> words = order.itemName.split(" ");
      words.forEach((word){
        output.add(word.toLowerCase());
      });
      }
    });
    output.add(this.seller.toLowerCase());
    List<String> sellerWord = this.seller.replaceAll("."," ").split(" ");
    sellerWord.forEach((sWord){
        if(sWord.isNotEmpty){
          output.add(sWord.toLowerCase());
        }
      }
    );
    output.add(this.ppName.toLowerCase());
    List<String> ppWord = this.ppName.replaceAll("."," ").split(" ");
    ppWord.forEach((pWord){
        output.add(pWord.toLowerCase());
      }
    );
    output.add(this.getUnit.toLowerCase());
    return output;
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
        return "Disanggupi dan Segera Dikirim";
      case 4:
        return "Disanggupi Sebagian dan Segera Dikirim";
      case 5:
        return "Dibatalkan Penyedia";
      case 6:
        return "Dibatalkan PPK";
      case 7:
        return "Menunggu Pembayaran";
      case 8:
        return "Menunggu Konfirmasi Pembayaran";
      case 9:
        return "Pembayaran ditolak";
      case 10:
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
        return "Segera Dikirim";
      case 5:
        return "Dibatalkan Penyedia";
      case 6:
        return "Dibatalkan PPK";
      case 7:
        return "Menunggu Pembayaran";
      case 8:
        return "Menunggu Konfirmasi Pembayaran";
      case 9:
        return "Pembayaran ditolak";
      case 10:
        return "Selesai";
      default:
        return "Undefined";
    }
  }

  String getStatusPP(){
    switch(this.status){
      case 0:
        return "Menunggu Persetujuan PPK";
      case 1:
        return "Disetujui PPK";
      case 2:
        return "Ditolak PPK";
      case 3:
        return "Disanggupi sebagian dan Segera Dikrim";
      case 4:
        return "Disanggupi dan Segera Dikrim";
      case 5:
        return "Dibatalkan Penyedia";
      case 6:
        return "Dibatalkan PPK";
      case 7:
        return "Menunggu Pembayaran";
      case 8:
        return "Menunggu Konfirmasi Pembayaran";
      case 9:
        return "Pembayaran ditolak Penyedia";
      case 10:
        return "Selesai";
      default:
        return "Undefined";
    }
  }
}

class Order{
  String docId;
  String itemName;
  String itemId;
  List<String> itemImage;
  int count;
  int status;
  int unitPrice;
  int tax;
  int orderPrice;

  Order({this.docId, this.orderPrice ,this.itemId,this.itemName, this.itemImage, this.count, this.status, this.tax, this.unitPrice});

  factory Order.fromMap(Map<String , dynamic> parsedData){

    return Order(
      itemId: parsedData['itemId'],
      itemName: parsedData['itemName'],
      itemImage: (parsedData['itemImage'] as List).cast<String>(),
      count : parsedData['count'],
      status: parsedData['status'],
      tax: parsedData['tax'],
      unitPrice: parsedData['unitPrice'],
      orderPrice : parsedData['orderPrice']
    );
  }

  Map<String , dynamic> toMap(){
    return{
      'itemName' : this.itemName,
      'itemId' : this.itemId,
      'count' : this.count,
      'status' : this.status,
      'itemImage' : this.itemImage,
      'tax' : this.tax,
      'unitPrice' : this.unitPrice,
      'orderPrice' : this.orderPrice,
    };
  }

  

  void setStatus(int newStatus){
    this.status = newStatus;
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
