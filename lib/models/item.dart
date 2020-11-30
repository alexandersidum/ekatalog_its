class Item {

//Masih prototype
//Perlu isAccepted, Deskripsi, sellerUid, stock, tanggal

  String name;
  String image;
  String seller;
  bool isReady;
  int price;

  Item({this.name, this.image, this.seller, this.isReady, this.price});

  factory Item.fromDb(Map<String, dynamic> parsedData){
    return(
      Item(
        name: parsedData['name'],
        image: parsedData['image'],
        seller : parsedData['seller'],
        isReady : parsedData['isReady'],
        price : parsedData['price'],
      ));
  }

  Map<String , dynamic> toMap(){
    return{
      'name' : this.name,
      'image' : this.image,
      'seller' : this.seller,
      'isReady' : this.isReady,
      'price' : this.price
    };
  }

}