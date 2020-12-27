class ShippingAddress{
  String id;
  String namaPenerima;
  String namaAlamat;
  String teleponPenerima;
  String address;

  ShippingAddress({String id, String address, String namaPenerima, String teleponPenerima, String namaAlamat}){
    this.id = id;
    this.address = address;
    this.namaAlamat = namaAlamat;
    this.namaPenerima = namaPenerima;
    this.teleponPenerima = teleponPenerima;
  }

  factory ShippingAddress.fromDb(Map<String,dynamic> parsedData, String docId){
    return ShippingAddress( 
      id: docId,
      address: parsedData['address'],
      namaAlamat: parsedData['nama_alamat'],
      namaPenerima: parsedData['nama_penerima'],
      teleponPenerima: parsedData['telepon_penerima']
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'address' : this.address,
      'nama_alamat' : this.namaAlamat,
      'nama_penerima' : this.namaPenerima,
      'telepon_penerima' : this.teleponPenerima
    }; 
  }

}