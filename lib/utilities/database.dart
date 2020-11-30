import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_catalog/models/item.dart';

class Database {

  Database({this.uid});

  final String uid;
  Firestore _firestore = Firestore.instance;

  String itemsPath = 'items';
  String usersPath = 'users';



  Stream<List<Item>> getItems() {
    return _firestore.collection(itemsPath).snapshots().map(
        (QuerySnapshot snapshot) => snapshot.documents
            .map((DocumentSnapshot document) => Item.fromDb(document.data)).toList());
  }

  //Belum diberi method
  Future<void> deleteItem() async{
    
  }

  Future<void> updateItem() async{

  }

  Future<void> addItem(Item item, Function callback) async{
    await _firestore.collection(itemsPath).add(item.toMap()).then((value) async{
      value!=null? callback(value.path.toString(), await _firestore.document(value.path).documentID.toString()) : callback('GAGAL', 'GAGAL');
    }).timeout(Duration(seconds: 10)).catchError((error){callback('GAGAL EROR $error');});
  }



}
