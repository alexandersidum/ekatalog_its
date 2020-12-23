class Item {

//Masih prototype
//Perlu isAccepted, Deskripsi, sellerUid, stock, tanggal
//enum untuk status item

  String id;
  String name;
  List image;
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
  //0 belum disetujui 1 disetujui 2 proses negosiasi 3 ditolak

  Item({this.id, this.name, this.image, this.creationDate, this.description,this.category, this.ukpbjPrice, this.sellerPrice, this.seller, this.stock, this.price, this.sold, this.taxPercentage, this.sellerUid, this.status});

  factory Item.fromDb(Map<String, dynamic> parsedData){
    return(
      Item(
        id : parsedData['id'],
        name: parsedData['name'],
        image: parsedData['image'],
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
      ));
  }

  Map<String , dynamic> toMap(){
    return{
      'name' : this.name,
      'image' : this.image,
      'description' : this.description,
      'seller' : this.seller,
      'sellerUid' : this.sellerUid,
      'category' : this.category,
      'price' : this.price,
      'sold' : this.sold,
      'sellerPrice' : this.sellerPrice,
      'ukpbjPrice' : this.ukpbjPrice,
      'stock' : this.stock,
      'taxPercentage' : this.taxPercentage,
      'status' : this.status,
    };
  }

  // ItemStatus getStatus(){
  //   switch (this.status) {
  //     case 0:
  //       return ItemStatus.BelumDiterima;
  //       break;
  //     case 1:
  //       return ItemStatus.Diterima;
  //       break;
  //     case 2:
  //       return ItemStatus.Ditolak;
  //       break;
  //     default:
  //       return ItemStatus.Error;
  //   }
  // }

  // String enumToString(Object a)=> a.toString().split(".").last;

  // ItemStatus stringToEnum(String a){
  //   ItemStatus.values.forEach((element) {
  //     if (a == enumToString(element )){
  //       return element;
  //     }
  //    });
  // }
}

enum ItemStatus{
  Diterima, Ditolak, BelumDiterima, Error
}
