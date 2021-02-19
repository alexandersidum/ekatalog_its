import "sales_order.dart";

class Unit {

String namaUnit;
String ppkCode;
String unitId;
String namaPPK;
String ppkUid;
List<Report> listLaporan;

Unit({this.listLaporan, this.namaPPK, this.namaUnit, this.ppkUid, this.unitId, this.ppkCode});

factory Unit.fromDb(Map<String, dynamic> data, String id){
  return Unit(
    namaUnit: data['namaUnit'],
    ppkCode : data['ppkCode'],
    unitId : id,
  );
}
}

class DivisiPPK {

String namaDivisi;
String ppkCode;

DivisiPPK({this.namaDivisi, this.ppkCode});

factory DivisiPPK.fromDb(Map<String, dynamic> data, String id){
  print(data['nama']);
  return DivisiPPK(
    namaDivisi: data['nama'],
    ppkCode : id,
  );
}

}

class Report{
int tahun;
int jumlahPengadaan;
int pengeluaran;
String pengadaanTerakhir;

Report({this.jumlahPengadaan, this.pengadaanTerakhir, this.pengeluaran, this.tahun});

factory Report.fromDb(parsedData, int tahun){
  return Report(
    jumlahPengadaan: parsedData['jumlahPengadaan'],
    pengadaanTerakhir: parsedData['pengadaanTerakhir'],
    pengeluaran: parsedData['pengeluaran'],
    tahun: tahun,
  );
}

}