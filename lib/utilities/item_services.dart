import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart' as p;
import 'dart:io';
import 'package:e_catalog/models/item.dart';
import 'package:firebase_storage/firebase_storage.dart';

// Status Item
// 0 : Belum Disetujui UKPBJ
// 1 : Disetujui UKPBJ
// 2 : Proses Negosiasi
// 3 : Negosiasi Diterima Penyedia
// 4 : Negosiasi Ditolak Penyedia
// 5 : Ditolak UKPBJ
// 6 : Negosiasi Perubahan Harga
// 7 : Perubahan Harga ditolak UKPBJ
// 8 : Dihapus Penyedia


class ItemService {
  ItemService({this.uid});
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
        .where('status', whereIn: status).orderBy('creationDate',descending: true)
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
            .map((DocumentSnapshot document) {
              return Item.fromDb(document.data());} )
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
      await uploadItemImage(images, (List<String> listImage) async {
        if (listImage.length <= 0) {
          throw ("Image Upload Failed");
        } else {
          await _firestore
              .collection(itemsPath)
              .add(item.toMap())
              .then((value) async {
                value != null
                    ? await _firestore.doc(value.path).update({
                        'id': _firestore.doc(value.path).id.toString(),
                        'creationDate': FieldValue.serverTimestamp(),
                        'image': listImage
                      }).then((value) {
                        callback(true);
                      }).catchError(() {
                        callback(false);
                      })
                    : throw ("Image Upload Failed");
              })
              .timeout(Duration(seconds: 30), onTimeout: (){throw ("Error Timeout");})
              .catchError((error) {
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
    if (images != null) {
      await editItemImage(images, (List<String> listImage) async {
        if (listImage.length <= 0) {
          throw ("Image Upload Failed");
        } else {
          Map<String, dynamic> mapItem = item.toMap();
          mapItem['image'] = listImage;
          await _firestore
              .collection(itemsPath)
              .doc(item.id)
              .update(mapItem)
              .then((value) async {
            callback(true);
          }).timeout(Duration(seconds: 30), onTimeout: () {
            callback(false);
          }).catchError((error) {
            callback(false);
            throw ("Upload Failed");
          });
        }
      });
    }
  }

  Future<void> uploadItemImage(List<File> itemImage, Function callback) async {
    List<String> output = [];
    await Future.forEach(itemImage, (image) async {
      if (image != null) {
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
    List<String> output = [];
    await Future.forEach(itemImage, (ImageEditInfo image) async {
      if (image == null) {

      } else if (image.isChanged && image.imageFile != null) {
        //Jika image berubah dan filenya tidak kosong berarti image diganti
        //delete dulu sebelum upload image baru
        if (image.existingUrl != null) {
          await _fstorage.refFromURL(image.existingUrl).delete();
        }
        String fileName = p.basename(image.imageFile.path);
        Reference storageRef = _fstorage.ref().child('item_images/$fileName');
        await storageRef.putFile(image.imageFile);
        output.add(await storageRef.getDownloadURL());
      } else if (image.imageFile != null &&
          image.existingUrl != null &&
          !image.isChanged) {
        //Jika image tidak berubah dan url tidak kosong berarti image tetap
        output.add(image.existingUrl);
      } else if (image.isChanged &&
          image.imageFile == null &&
          image.existingUrl != null) {
        //Kalau berubah tapi tidak ada file yang diberikan berarti dihapus
        if (image.existingUrl != null) {
          await _fstorage.refFromURL(image.existingUrl).delete();
        }
      }
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
      try {
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
         await _firestore.collection(categoryPath).add({
            'name' : name,
            'thumbnail' : url
          }).then((a)=>output = true).catchError((e)=>throw ("Gagal add Category ke Database"));
        }
        else{
          throw ("Gagal add Category ImageUrl null");
        }
      }
    ).catchError((a){output = false;});
    return output;
  }

  Future<List<Item>> getItemListByCategory(String selectedCategory)async {
    return await _firestore
        .collection(itemsPath).where('categoryLower', isEqualTo: selectedCategory).where('status', isEqualTo: 1).get()
        .then((value) => value.docs.map((e) => Item.fromDb(e.data())).toList()).catchError((Object err)=>List<Item>());
  }

  //Get item list dengan keyword
  Future<List<Item>> getItemListBySearch(String keyword, {int status})async {
    List<String> keywords = keyword.trim().toLowerCase().split(" ");
    return await _firestore
        .collection(itemsPath).where('keywords', arrayContainsAny: keywords).where('status', isEqualTo:status?? 1).get()
        .then((value) => value.docs.map((e) => Item.fromDb(e.data())).toList()).catchError((Object err)=>List<Item>());
  }
}

//Class tambahan untuk mempermudah manage gambar saat edit produk
class ImageEditInfo {
  String existingUrl;
  File imageFile;
  bool isChanged = false;
  ImageEditInfo({this.existingUrl, this.imageFile, this.isChanged = false});
  void changeStatus(bool status) => isChanged = status;
}
