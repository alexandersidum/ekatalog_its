//model buat sales order
import 'package:e_catalog/models/cart.dart';

class SalesOrder{

  String id;
  String docId;
  String itemName;
  String itemId;
  int count;
  int totalPrice;
  String seller; 
  String sellerUid; 
  DateTime creationDate;
  int status;
  String ppUid;
  String ppName;
  String ppkUid;
  String ppkName;
  int unit;
  String shippingAddress;
  int tax;
  int unitPrice;
  String responseFeedback;

  SalesOrder({this.id, this.itemName, this.ppkName, this.creationDate, this.itemId, this.count, this.totalPrice, this.seller, this.sellerUid, this.status, this.ppName, this.ppUid, this.ppkUid, this.unit});

  factory SalesOrder.fromDb(Map<String , dynamic> parsedData){
    
    return SalesOrder(
      id: parsedData['id'],
      seller: parsedData['seller'],
      sellerUid: parsedData['sellerUid'],
      count: parsedData['count'],
      creationDate: DateTime.parse(parsedData['creationDate'].toDate().toString()),
      itemId: parsedData['itemId'],
      itemName: parsedData['itemName'],
      status: parsedData['status'],
      totalPrice: parsedData['totalPrice'],
      ppName: parsedData['ppName'],
      ppUid: parsedData['ppUid'],
      unit: parsedData['unit'],
      ppkUid: parsedData['ppkUid'],
      ppkName: parsedData['ppkName']
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
      'unit' : this.unit
    };
  }

  String getStatus(){
    switch(this.status){
      case 0:
        return "Belum Diterima";
      case 1:
        return "Diterima";
      case 2:
        return "Ditolak";
      case 3:
        return "Dibatalkan";
      default:
        return "Undefined";
    }
  }

}