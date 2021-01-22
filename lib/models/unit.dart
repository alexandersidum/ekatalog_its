import "sales_order.dart";

class Unit {

String namaUnit;
String unitId;
String namaPPK;
String ppkUid;
List<Report> listLaporan;

Unit({this.listLaporan, this.namaPPK, this.namaUnit, this.ppkUid, this.unitId});

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