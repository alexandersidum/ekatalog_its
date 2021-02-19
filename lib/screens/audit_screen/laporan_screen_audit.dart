import 'package:e_catalog/constants.dart';
import 'package:e_catalog/models/sales_order.dart';
import 'package:e_catalog/models/unit.dart';
import 'package:e_catalog/utilities/account_services.dart';
import 'package:e_catalog/utilities/report_services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LaporanScreenAudit extends StatefulWidget {
  @override
  _LaporanScreenAuditState createState() => _LaporanScreenAuditState();
}

class _LaporanScreenAuditState extends State<LaporanScreenAudit> {
  ReportServices _reportServices = ReportServices();
  AccountService _accountService = AccountService();
  bool isInit = true;
  bool isLoading = false;
  bool isLoadUnit = true;
  int selectedYear = DateTime.now().year;
  int selectedUnitId;
  Unit selectedUnit;
  List<Unit> listUnit = [];
  Report report;

  @override
  void initState() {
    super.initState();
    getListUnit();
  }

  getListUnit() async {
    setState(() {
      isLoadUnit = true;
    });
    listUnit = await _accountService.getUnit();
    setState(() {
      isLoadUnit = false;
    });
  }

  List<Widget> produkInfo(List<Order> listOrder) {
    var output = listOrder
        .map((e) => e.status == 1
            ? SizedBox()
            : Row(
                textBaseline: TextBaseline.alphabetic,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                children: [
                  Text(
                    e.count.toString() + "x ",
                    style: kCalibriBold.copyWith(color: kBlueMainColor),
                  ),
                  Expanded(child: Text(e.itemName, style: kCalibri)),
                  SizedBox(height: 10),
                ],
              ))
        .toList();
    return output;
  }

  Widget salesOrderTile(context, SalesOrder element) {
    Size size = MediaQuery.of(context).size;
    return Container(
      color: Colors.white,
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.symmetric(
          horizontal: size.width / 20, vertical: size.height / 100),
      child: Column(
        children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(
              child: Stack(children: [
                Container(
                  padding: EdgeInsets.only(
                      top: size.height / 100, right: size.width / 50),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        children: [
                          Expanded(
                              flex: 1,
                              child: Text("ID :", style: kCalibriBold)),
                          Expanded(
                              flex: 2,
                              child: Text(element.id,
                                  style: kCalibriBold.copyWith(
                                      color: kBlueMainColor))),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        children: [
                          Expanded(
                              flex: 1,
                              child: Text("Status :", style: kCalibriBold)),
                          Expanded(
                              flex: 2,
                              child: Text(element.getStatus(),
                                  style: kCalibriBold)),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        children: [
                          Expanded(
                              flex: 1,
                              child: Text("PP :", style: kCalibriBold)),
                          Expanded(
                              flex: 2,
                              child: Text(element.ppName, style: kCalibriBold)),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        children: [
                          Expanded(
                              flex: 1,
                              child: Text("Penyedia :", style: kCalibriBold)),
                          Expanded(
                              flex: 2,
                              child: Text(element.seller, style: kCalibri)),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        children: [
                          Expanded(
                              flex: 1,
                              child: Text("Produk :", style: kCalibriBold)),
                          Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: produkInfo(element.listOrder),
                              )),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        children: [
                          Expanded(
                              flex: 1,
                              child:
                                  Text("Total Biaya :", style: kCalibriBold)),
                          Expanded(
                              flex: 2,
                              child: Text(
                                  NumberFormat.currency(
                                          name: "Rp ", decimalDigits: 0)
                                      .format(element.totalPrice),
                                  style: kCalibriBold)),
                        ],
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          ]),
        ],
      ),
    );
  }

  Widget orderInfo(Size size, Order order) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: size.height / 200),
      padding: EdgeInsets.symmetric(
          horizontal: size.width / 25, vertical: size.height / 120),
      color: kBackgroundMainColor,
      child: Column(
        children: [
          Row(
            textBaseline: TextBaseline.alphabetic,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            children: [
              Expanded(flex: 2, child: Text("Produk :", style: kCalibriBold)),
              Expanded(flex: 5, child: Text(order.itemName, style: kCalibri)),
            ],
          ),
          Row(
            textBaseline: TextBaseline.alphabetic,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            children: [
              Expanded(flex: 2, child: Text("Jumlah :", style: kCalibriBold)),
              Expanded(
                  flex: 5,
                  child:
                      Text(order.count.toString() + " unit", style: kCalibri)),
            ],
          ),
        ],
      ),
    );
  }

  List<DropdownMenuItem> dropDownSort(Size size) {
    List<DropdownMenuItem> output = listUnit.map((unit) {
      return DropdownMenuItem(
        value: unit.unitId,
        child: Text(
          unit.namaUnit,
          style: kMaven.copyWith(fontSize: size.height / 50),
        ),
      );
    }).toList();
    return output;
  }

  List<DropdownMenuItem> dropDownSortYear(Size size) {
    List<DropdownMenuItem> output = [];
    List<int> listYear = [];
    for (int i = 5; i >= 0; i--) {
      listYear.add(DateTime.now().year - i);
    }
    listYear.forEach((value) {
      output.add(DropdownMenuItem(
        value: value,
        child: Text(
          value.toString(),
          style: kMaven.copyWith(fontSize: size.height / 50),
        ),
      ));
    });
    return output;
  }

  getUnitReport() async {
    setState(() {
      isLoading = true;
    });
    selectedUnit = null;
    report = null;
    selectedUnit = await _reportServices
        .getUnitReport(unit: selectedUnitId, callback: (isSuccess) {})
        .catchError((Object e) {
      setState(() {
        isLoading = false;
      });
    });
    if (selectedUnit != null) {
      
      try {
        report = selectedUnit.listLaporan
            .singleWhere((element) => element.tahun == selectedYear);
      } catch (e) {
        report = null;
      }
    } else {
      //Kalau unit belum dipilih melakukan apa
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Laporan E-Katalog", style: kCalibriBold),
        centerTitle: false,
        backgroundColor: kBlueMainColor,
        elevation: 0,
      ),
      body: ModalProgressHUD(
        inAsyncCall: isLoadUnit,
        child: Container(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: size.width / 100, vertical: size.height / 200),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: size.width / 100),
                      height: size.height / 20,
                      padding: EdgeInsets.only(
                          right: size.width / 100, left: size.width / 50),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white,
                          border: Border.all(
                              color: kGrayConcreteColor,
                              width: 1,
                              style: BorderStyle.solid)),
                      child: Theme(
                        data:
                            Theme.of(context).copyWith(canvasColor: Colors.white),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                              hint: Text(
                                "Pilih Unit",
                                style: kCalibri,
                              ),
                              value: selectedUnitId,
                              items: dropDownSort(size),
                              onChanged: (value) {
                                setState(() {
                                  isInit = false;
                                  selectedUnitId = value;
                                  getUnitReport();
                                });
                              }),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(right: size.width / 100),
                      height: size.height / 20,
                      padding: EdgeInsets.only(
                          right: size.width / 100, left: size.width / 50),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white,
                          border: Border.all(
                              color: kGrayConcreteColor,
                              width: 1,
                              style: BorderStyle.solid)),
                      child: Theme(
                        data:
                            Theme.of(context).copyWith(canvasColor: Colors.white),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                              hint: Text(
                                "Pilih Tahun",
                                style: kCalibri,
                              ),
                              value: selectedYear,
                              items: dropDownSortYear(size),
                              onChanged: (value) {
                                setState(() {
                                  isInit = false;
                                  selectedYear = value;
                                  getUnitReport();
                                });
                              }),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              isInit
                  ? Expanded(
                      child: Center(
                      child: Text("Silahkan pilih Unit dan Tanggal",
                          style: kCalibri),
                    ))
                  : isLoading
                      ? Container(
                          padding: EdgeInsets.symmetric(
                              vertical: size.height / 25,
                              horizontal: size.width / 12),
                          width: size.width / 3,
                          height: size.width / 3,
                          child: CircularProgressIndicator())
                      : selectedUnit == null || report == null
                          ? Expanded(
                              child: Center(
                              child:
                                  Text("Data tidak ditemukan", style: kCalibri),
                            ))
                          : Expanded(
                              child: Container(
                                  child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(
                                        top: size.height / 40,
                                        left: size.width / 30,
                                        bottom: size.height / 100),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Laporan',
                                      style: kCalibriBold,
                                    ),
                                  ),
                                  Container(
                                    color: Colors.white,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: size.width / 20),
                                      child: Column(
                                          children: ListTile.divideTiles(
                                              context: context,
                                              tiles: [
                                            ListTile(
                                              title: Text('Nama Unit',
                                                  style: kCalibri),
                                              trailing: Text(
                                                  selectedUnit.namaUnit,
                                                  style: kCalibri),
                                            ),
                                            ListTile(
                                              title: Text('Nama PPK',
                                                  style: kCalibri),
                                              trailing: Text(selectedUnit.namaPPK,
                                                  style: kCalibri),
                                            ),
                                            ListTile(
                                              title: Text('Total Pengadaan',
                                                  style: kCalibri),
                                              trailing: Text(
                                                  report.jumlahPengadaan
                                                          .toString() +
                                                      " x",
                                                  style: kCalibri),
                                            ),
                                            ListTile(
                                              title: Text('Total Pengeluaran',
                                                  style: kCalibri),
                                              trailing: Text(
                                                  NumberFormat.currency(
                                                          name: "Rp",
                                                          decimalDigits: 0)
                                                      .format(report.pengeluaran),
                                                  style: kCalibri),
                                            ),
                                          ]).toList()),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(
                                        top: size.height / 40,
                                        left: size.width / 30,
                                        bottom: size.height / 100),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Sales Order Terakhir',
                                      style: kCalibriBold,
                                    ),
                                  ),
                                  Expanded(
                                    child: StreamBuilder(
                                        stream:
                                            _reportServices.getSalesOrderLimited(
                                          unit: selectedUnitId,
                                          limit: 3,
                                        ),
                                        builder: (context,
                                                AsyncSnapshot<List<SalesOrder>>
                                                    snap) =>
                                            ListView.builder(
                                              itemCount: snap.hasData
                                                  ? snap.data.length
                                                  : 0,
                                              itemBuilder: (context, index) {
                                                if (snap.hasData) {
                                                  return salesOrderTile(
                                                      context, snap.data[index]);
                                                } else if (snap == null) {
                                                  return Center(
                                                    child: Text(
                                                      "Mengambil data",
                                                      style: kCalibriBold,
                                                    ),
                                                  );
                                                } else {
                                                  return Center(
                                                    child: Text(
                                                      "Tidak ada data",
                                                      style: kCalibriBold,
                                                    ),
                                                  );
                                                }
                                              },
                                            )),
                                  )
                                ],
                              )),
                            ),
            ],
          ),
        ),
      ),
    );
  }
}
