import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart' as p;
import 'dart:io';
import 'package:e_catalog/models/item.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ItemService {
  ItemService({this.uid});
  //TODO apa perlu uid?
  final String uid;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseStorage _fstorage = FirebaseStorage.instance;

  String itemsPath = 'items';
  String usersPath = 'users';

  Stream<List<Item>> getAllItems() {
    return _firestore.collection(itemsPath).snapshots().map(
        (QuerySnapshot snapshot) => snapshot.docs
            .map((DocumentSnapshot document) =>
                Item.fromDb(document.data()))
            .toList());
  }

  Stream<List<Item>> getItemsWithStatus(int status) {
    return _firestore.collection(itemsPath).where('status', isEqualTo: status).snapshots().map(
        (QuerySnapshot snapshot) => snapshot.docs
            .map((DocumentSnapshot document) =>
                Item.fromDb(document.data()))
            .toList());
  }

  //Belum diberi method
  Future<void> deleteItem() async {}

  Future<void> updateItem() async {}

  Future<void> proposeItem(
      {Item item, List<File> images, Function callback}) async {
    try {
      print("Sampai uploaditemimage TRY");
      await uploadItemImage(images,
      (List<String> listImage)async{
        if (listImage.length <= 0) {
          print("Sampai uploaditemimage value length <=0");
          throw ("Image Upload Failed");
        } else {
          print("Sampai uploaditemimage value length >0");
          await _firestore
              .collection(itemsPath)
              .add(item.toMap())
              .then((value) async {
                print("Sukses add item map");
                value != null
                    ? await _firestore
                        .doc(value.path)
                        .update({
                          'id': _firestore.doc(value.path).id.toString(),
                          'creationDate': FieldValue.serverTimestamp(),
                          'image' : listImage
                        })
                        .then((value) {
                          callback(true);
                          print("sukses set id date");
                        } )
                        .catchError(() {
                          print("error set id date");
                          callback(false);
                        })
                    : throw ("Image Upload Failed");
              })
              .timeout(Duration(seconds: 10))
              .catchError((error) {
                throw ("Upload Failed");
              });
        }
      }
      );
      // .then((List<String> value) async {
      //   if (value.length <= 0) {
      //     print("Sampai uploaditemimage value length <=0");
      //     throw ("Image Upload Failed");
      //   } else {
      //     print("Sampai uploaditemimage value length >0");
      //     await _firestore
      //         .collection(itemsPath)
      //         .add(item.toMap())
      //         .then((value) async {
      //           print("Sukses add item map");
      //           value != null
      //               ? await _firestore
      //                   .doc(value.path)
      //                   .set({
      //                     'id': _firestore.doc(value.path).id.toString(),
      //                     'creationDate': FieldValue.serverTimestamp()
      //                   })
      //                   .then((value) {
      //                     callback(true);
      //                     print("sukses set id date");
      //                   } )
      //                   .catchError(() {
      //                     print("error set id date");
      //                     callback(false);
      //                   })
      //               : throw ("Image Upload Failed");
      //         })
      //         .timeout(Duration(seconds: 10))
      //         .catchError((error) {
      //           throw ("Upload Failed");
      //         });
      //   }
      // });
    } catch (error) {
      callback(false);
    }
  }

  Future<void> uploadItemImage(List<File> itemImage, Function callback) async {
    print("Sampai uploaditemimage");
    print(itemImage);
    List<String> output = [];
    itemImage.forEach((image) async {
      if (image != null) {
        print("Sampai uploaditemimage item != null");
        String fileName = p.basename(image.path);
        Reference storageRef = _fstorage.ref().child('item_images/$fileName');
        await storageRef.putFile(image);
        output.add(await storageRef.getDownloadURL());
      }
      callback(output);
    });
    
  }
}
