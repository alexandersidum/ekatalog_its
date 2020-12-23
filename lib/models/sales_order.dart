//model buat sales order
import 'package:e_catalog/models/cart.dart';

class SalesOrder{

  String id;
  String itemName;
  String itemId;
  int count;
  int totalPrice;
  String seller; 
  String sellerUid; 
  int status;
  String ppUid;
  String ppName;
  String ppkUid;
  String ppkName;
  int unit;

  SalesOrder({this.id, this.itemName, this.ppkName, this.itemId, this.count, this.totalPrice, this.seller, this.sellerUid, this.status, this.ppName, this.ppUid, this.ppkUid, this.unit});

  factory SalesOrder.fromDb(Map<String , dynamic> parsedData){
    
    return SalesOrder(
      id: parsedData['id'],
      seller: parsedData['seller'],
      sellerUid: parsedData['sellerUid'],
      count: parsedData['count'],
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
      'totalPrice' : this.totalPrice,
      'status' : this.status,
      'ppName' : this.ppName,
      'ppUid' : this.ppUid,
      'ppkName' : this.ppkName,
      'ppkUid' : this.ppkUid,
      'unit' : this.unit
    };
  }

}