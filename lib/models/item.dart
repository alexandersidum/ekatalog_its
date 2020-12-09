class Item {

//Masih prototype
//Perlu isAccepted, Deskripsi, sellerUid, stock, tanggal
//enum untuk status item

  String name;
  String image;
  String description;
  String category;
  String seller;
  String sellerUid;
  int sellerPrice;
  int ukpbjPrice;
  int taxPercentage;
  int stock;
  int price;
  var status;

  Item({this.name, this.image, this.description,this.category, this.ukpbjPrice, this.sellerPrice, this.seller, this.stock, this.price, this.taxPercentage, this.sellerUid, this.status});
  // {
  //   this.status = stringToEnum(this.status);
  // }

  factory Item.fromDb(Map<String, dynamic> parsedData){
    return(
      Item(
        name: parsedData['name'],
        image: parsedData['image'],
        description: parsedData['description'],
        seller : parsedData['seller'],
        sellerUid : parsedData['sellerUid'],
        sellerPrice: parsedData['sellerPrice'],
        ukpbjPrice: parsedData['ukpbjPrice'],
        stock : parsedData['stock'],
        price : parsedData['price'],
        taxPercentage : parsedData['taxPercentage'],
        status : parsedData['status'],
      ));
  }

  Map<String , dynamic> toMap(){
    return{
      'name' : this.name,
      'image' : this.image,
      'seller' : this.seller,
      'price' : this.price
    };
  }

  ItemStatus getStatus(){
    switch (this.status) {
      case 0:
        return ItemStatus.BelumDiterima;
        break;
      case 1:
        return ItemStatus.Diterima;
        break;
      case 2:
        return ItemStatus.Ditolak;
        break;
      default:
        return ItemStatus.Error;
    }
  }

  String enumToString(Object a)=> a.toString().split(".").last;

  ItemStatus stringToEnum(String a){
    ItemStatus.values.forEach((element) {
      if (a == enumToString(element )){
        return element;
      }
     });
  }
}

enum ItemStatus{
  Diterima, Ditolak, BelumDiterima, Error
}
