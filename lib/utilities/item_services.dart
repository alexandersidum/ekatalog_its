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
  String categoryPath = 'category';

  Stream<List<Item>> getAllItems() {
    return _firestore.collection(itemsPath).snapshots().map(
        (QuerySnapshot snapshot) => snapshot.docs
            .map((DocumentSnapshot document) => Item.fromDb(document.data()))
            .toList());
  }

  Stream<List<Item>> getItemsWithStatus(List<int> status) {
    return _firestore
        .collection(itemsPath)
        .where('status', whereIn: status)
        .snapshots()
        .map((QuerySnapshot snapshot) => snapshot.docs
            .map((DocumentSnapshot document) => Item.fromDb(document.data()))
            .toList());
  }

  Stream<List<Item>> getLatestApprovedItems() {
    return _firestore
        .collection(itemsPath).orderBy('creationDate',descending: true)
        .where('status', isEqualTo: 1).limit(10)
        .snapshots()
        .map((QuerySnapshot snapshot) => snapshot.docs
            .map((DocumentSnapshot document) => Item.fromDb(document.data()))
            .toList());
  }

  Stream<List<Item>> getSellerItemsWithStatus(
      List<int> status, String sellerUid) {
    return _firestore
        .collection(itemsPath)
        .where('sellerUid', isEqualTo: sellerUid)
        .where('status', whereIn: status)
        .snapshots()
        .map((QuerySnapshot snapshot) =>
            snapshot.docs.map((DocumentSnapshot document) {
              print(
                  "isfromcache = " + document.metadata.isFromCache.toString());
              return Item.fromDb(document.data());
            }).toList());
  }

  Future<bool> proposeItemPriceChange(
      {String itemId,
      int newSellerPrice,
      Function callback,
      String sellerUid}) {
    Map<String, dynamic> mappedData = {
      "sellerPrice": newSellerPrice,
      "status": 6
    };
    print(newSellerPrice);
    return _firestore
        .collection(itemsPath)
        .doc(itemId)
        .update(mappedData)
        .then((value) => callback(true))
        .catchError((Object err) => callback(false));
  }

  List<String> keywordGenerator(String name) {
    List<String> output = List();
    var words = name.split(" ");
    words.forEach((e) {
      output.add(e.toLowerCase());
      String temp = '';
      for (int i = 0; i < e.length; i++) {
        temp = temp + e[i];
        output.add(temp.toLowerCase());
      }
    });
    return output;
  }

  Future<void> proposeItem(
      {Item item, List<File> images, Function callback}) async {
    try {
      print("Sampai uploaditemimage TRY");
      await uploadItemImage(images, (List<String> listImage) async {
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
                    ? await _firestore.doc(value.path).update({
                        'id': _firestore.doc(value.path).id.toString(),
                        'creationDate': FieldValue.serverTimestamp(),
                        'image': listImage
                      }).then((value) {
                        callback(true);
                        print("sukses set id date");
                      }).catchError(() {
                        print("error set id date");
                        callback(false);
                      })
                    : throw ("Image Upload Failed");
              })
              .timeout(Duration(seconds: 10))
              .catchError((error) {
                //TODO Ada yang tidak beres disini
                throw ("Upload Failed");
              });
        }
      });
    } catch (error) {
      callback(false);
    }
  }

  Future<void> editItem(
      {Item item, List<ImageEditInfo> images, Function callback}) async {
    //Lakukan test lagi
    if (images != null) {
      await editItemImage(images, (List<String> listImage) async {
        if (listImage.length <= 0) {
          print("LIST IMAGE <0");
          throw ("Image Upload Failed");
        } else {
          print("else image length");
          Map<String, dynamic> mapItem = item.toMap();
          mapItem['image'] = listImage;
          print("Mappedimage");
          await _firestore
              .collection(itemsPath)
              .doc(item.id)
              .update(mapItem)
              .then((value) async {
            print("then firestore");
            callback(true);
          }).timeout(Duration(seconds: 30), onTimeout: () {
            callback(false);
          }).catchError((error) {
            //TODO Ada yang tidak beres disini
            callback(false);
            throw ("Upload Failed");
          });
        }
      });
    }
  }

  Future<void> uploadItemImage(List<File> itemImage, Function callback) async {
    print("Sampai uploaditemimage");
    print(itemImage);
    List<String> output = [];
    await Future.forEach(itemImage, (image) async {
      if (image != null) {
        print("Sampai uploaditemimage item != null");
        String fileName = p.basename(image.path);
        Reference storageRef = _fstorage.ref().child('item_images/$fileName');
        await storageRef.putFile(image);
        output.add(await storageRef.getDownloadURL());
      }
    });
    callback(output);
  }
  

  Future<void> editItemImage(
      List<ImageEditInfo> itemImage, Function callback) async {
    print("Sampai uploaditemimage");
    List<String> output = [];

    await Future.forEach(itemImage, (ImageEditInfo image) async {
      print("a");
      if (image == null) {
        print("image is null");
      } else if (image.isChanged && image.imageFile != null) {
        //Jika image berubah dan filenya tidak kosong berarti image diganti
        print("c");
        //delete dulu sebelum upload image baru
        if (image.existingUrl != null) {
          print("deleting");
          await _fstorage.refFromURL(image.existingUrl).delete();
          print("deleteddddddddddddddddddddddddddddddddddddddddddddddddd");
        }
        String fileName = p.basename(image.imageFile.path);
        Reference storageRef = _fstorage.ref().child('item_images/$fileName');
        await storageRef.putFile(image.imageFile);
        output.add(await storageRef.getDownloadURL());
      } else if (image.imageFile != null &&
          image.existingUrl != null &&
          !image.isChanged) {
        //Jika image tidak berubah dan url tidak kosong berarti image tetap
        print("e");
        output.add(image.existingUrl);
      } else if (image.isChanged &&
          image.imageFile == null &&
          image.existingUrl != null) {
        //Kalau berubah tapi tidak ada file yang diberikan berarti dihapus
        if (image.existingUrl != null) {
          print("deleting");
          await _fstorage.refFromURL(image.existingUrl).delete();
          print("deleteddddddddddddddddddddddddddddddddddddddddddddddddd");
        }
      }
      print(output);
    });
    callback(output);
  }

  Future<bool> setItemStatus(String id, int newStatus,
      {String keterangan}) async {
    bool isSuccess = false;
    if (keterangan != null) {
      await _firestore
          .collection(itemsPath)
          .doc(id)
          .update({
            'status': newStatus,
            'keteranganPengajuan': keterangan,
          })
          .then((value) => isSuccess = true)
          .catchError((Object error) {
            isSuccess = false;
          });
    } else {
      await _firestore
          .collection(itemsPath)
          .doc(id)
          .update({'status': newStatus})
          .then((value) => isSuccess = true)
          .catchError((Object error) {
            isSuccess = false;
          });
    }
    return isSuccess;
  }
//DELETE SOON
  Future<bool> updateItemKeyword(String id, List<String> keyword) async {
    bool isSuccess = false;
      await _firestore
          .collection(itemsPath)
          .doc(id)
          .update({
            'keyword': keyword,
          })
          .then((value) => isSuccess = true)
          .catchError((Object error) {
            isSuccess = false;
          });
    
    return isSuccess;
  }

  Future<bool> acceptItemProposal(Item item) async {
    bool isSuccess = false;

    await _firestore
        .collection(itemsPath)
        .doc(item.id)
        .update({
          'status': 1,
          'price': item.status == 3 ? item.ukpbjPrice : item.sellerPrice,
          //
        })
        .then((value) => isSuccess = true)
        .catchError((Object error) {
          isSuccess = false;
        });
    return isSuccess;
  }

  Future<bool> acceptPriceChange(Item item) async {
    bool isSuccess = false;
    await _firestore
        .collection(itemsPath)
        .doc(item.id)
        .update({
          'status': 1,
          'price': item.sellerPrice,
        })
        .then((value) => isSuccess = true)
        .catchError((Object error) {
          isSuccess = false;
        });
    return isSuccess;
  }

  Future<bool> negotiateItem(String itemId, int ukpbjPrice) async {
    bool isSuccess = false;
    await _firestore
        .collection(itemsPath)
        .doc(itemId)
        .update({
          'status': 2,
          'ukpbjPrice': ukpbjPrice,
        })
        .then((value) => isSuccess = true)
        .catchError((Object error) {
          isSuccess = false;
        });
    return isSuccess;
  }

  Future<bool> acceptItemNegotiation(Item item, bool isAccept) async {
    bool isSuccess = false;
    await _firestore
        .collection(itemsPath)
        .doc(item.id)
        .update({
          'status': isAccept ? 3 : 4,
        })
        .then((value) => isSuccess = true)
        .catchError((Object error) {
          isSuccess = false;
        });
    return isSuccess;
  }

  Stream<List<Category>> getStreamCategory(){
    return _firestore
        .collection(categoryPath).snapshots().map((e) => e.docs.map((e) => Category.fromDb(e.data(), e.id)).toList());
  }

  Future<List<Category>> getCategory()async {
    return await _firestore
        .collection(categoryPath).get().then((col)=>col.docs.map((doc)=>Category.fromDb(doc.data(), doc.id)).toList());
  }

  Future<String> uploadCategoryImage(File image) async {
    print("Sampai uploadcatimage");
      try {
        print("Sampai uploadcatimage try");
        String fileName = p.basename(image.path);
        Reference storageRef = _fstorage.ref().child('category_images/$fileName');
        await storageRef.putFile(image);
        return await storageRef.getDownloadURL();
      }
      catch(e){
        return null;
      }
  }

  Future<bool> addCategory(String name, File image) async {
    bool output = false;
    await uploadCategoryImage(image).then(
      (String url)async{
        if(url!=null){
          print("Sampai di url!=null");
         await _firestore.collection(categoryPath).add({
            'name' : name,
            'thumbnail' : url
          }).then((a)=>output = true).catchError((e)=>throw ("Gagal add Category ke Database"));
        }
        else{
          print("Sampai else url!=null");
          throw ("Gagal add Category ImageUrl null");
        }
      }
    ).catchError((a){output = false;});
    return output;
  }

  // Future<String> editCategory(Category category, File image) async {
  //   await uploadCategoryImage(image).then(
  //     (String url){
  //       if(url!=null){
  //         _firestore.collection(categoryPath).add()
  //       }
  //     }
  //   );
  // }

  Future<List<Item>> getItemListByCategory(String selectedCategory)async {
    return await _firestore
        .collection(itemsPath).where('categoryLower', isEqualTo: selectedCategory).where('status', isEqualTo: 1).get()
        .then((value) => value.docs.map((e) => Item.fromDb(e.data())).toList()).catchError((Object err)=>List<Item>());
  }

  Future<List<Item>> getItemListBySearch(String keyword)async {
    List<String> keywords = keyword.trim().toLowerCase().split(" ");
    keywords.forEach((element) {print(element);});
    return await _firestore
        .collection(itemsPath).where('keyword', arrayContainsAny: keywords).where('status', isEqualTo: 1).get()
        .then((value) => value.docs.map((e) => Item.fromDb(e.data())).toList()).catchError((Object err)=>List<Item>());
  }

}




//Class tambahan untuk mempermudah manage gambar
class ImageEditInfo {
  String existingUrl;
  File imageFile;
  bool isChanged = false;
  ImageEditInfo({this.existingUrl, this.imageFile, this.isChanged = false});

  void changeStatus(bool status) => isChanged = status;
}
