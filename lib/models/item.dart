import 'package:e_catalog/utilities/item_services.dart';

class Item {

//Masih prototype
//Perlu isAccepted, Deskripsi, sellerUid, stock, tanggal
//enum untuk status item

  String id;
  String name;
  List<String> image;
  String description;
  String category;
  String seller;
  String sellerUid;
  DateTime creationDate;
  int sellerPrice;
  int ukpbjPrice;
  int taxPercentage;
  int stock;
  int price;
  int status;
  int sold;
  String keteranganPengajuan;

  //0 belum disetujui 1 disetujui 2 proses negosiasi 3 ditolak

  Item({this.id, this.name, this.image, this.creationDate, this.keteranganPengajuan, this.description,this.category, this.ukpbjPrice, this.sellerPrice, this.seller, this.stock, this.price, this.sold, this.taxPercentage, this.sellerUid, this.status});
  
  factory Item.fromDb(Map<String, dynamic> parsedData){

    return(
      Item(
        id : parsedData['id'],
        name: parsedData['name'],
        image: (parsedData['image'] as List).cast<String>(),
        description: parsedData['description'],
        creationDate: DateTime.parse(parsedData['creationDate'].toDate().toString()),
        category: parsedData['category'],
        seller : parsedData['seller'],
        sellerUid : parsedData['sellerUid'],
        sellerPrice: parsedData['sellerPrice'],
        ukpbjPrice: parsedData['ukpbjPrice'],
        stock : parsedData['stock'],
        price : parsedData['price'],
        sold: parsedData['sold'],
        taxPercentage : parsedData['taxPercentage'],
        status : parsedData['status'],
        keteranganPengajuan : parsedData['keteranganPengajuan'],
        // keywords : (parsedData['keywords'] as List).cast<String>(),
      ));
  }

  updateItemKeyword(String id, String name)async{
    await ItemService().updateItemKeyword(this.id, keywordGenerator(this.name));
  }

  Map<String , dynamic> toMap(){
    return{
      'name' : this.name,
      'image' : this.image,
      'description' : this.description,
      'seller' : this.seller,
      'sellerUid' : this.sellerUid,
      'category' : this.category.trim(),
      'categoryLower' : this.category.trim().toLowerCase(),
      'price' : this.price,
      'sold' : this.sold,
      'sellerPrice' : this.sellerPrice,
      'ukpbjPrice' : this.ukpbjPrice,
      'stock' : this.stock,
      'taxPercentage' : this.taxPercentage,
      'status' : this.status,
      'keteranganPengajuan' : this.keteranganPengajuan,
      'keywords' : keywordGenerator(this.name)
    };
  }

  List<String> keywordGenerator(String name) {
    List<String> output = List();
    var words = name.split(" ");
    words.forEach((e) {
      String temp = '';
      for (int i = 0; i < e.length; i++) {
        temp = temp + e[i];
        output.add(temp.toLowerCase());
      }
    });
    return output;
  }

  String getStatus(){
    switch (this.status) {
      case 0:
        return "Belum Disetujui";
        break;
      case 1:
        return "Disetujui";
        break;
      case 2:
        return "Proses Negosiasi";
        break;
      case 3:
        return "Negosiasi Diterima Penyedia";
        break;
      case 4:
        return "Negosiasi Ditolak Penyedia";
        break;
      case 5:
        return "Ditolak UKPBJ";
        break;
      case 6:
        return "Pengajuan Perubahan Harga";
        break;
      case 7:
        return "Perubahan Harga ditolak";
        break;
      case 8:
        return "Dihapus Penyedia";
        break;
      default:
        return "Undefined";
    }
  }

}

class Category{
  String docId;
  String name;
  String thumbnailUrl;

  Category({this.name, this.thumbnailUrl, this.docId});

  factory Category.fromDb(Map<String, dynamic> parsedData, String id){
    return(
      Category(
        name: parsedData['name'],
        thumbnailUrl: parsedData['thumbnail'],
        docId: id
      ));
  }

  Map<String, dynamic> toMap(){
    return {
      'name': name,
      'thumbnail' : thumbnailUrl
    };
  }

}
