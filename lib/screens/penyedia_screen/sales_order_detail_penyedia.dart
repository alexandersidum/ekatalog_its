import 'package:e_catalog/components/bottom_sheet_decline_info.dart';
import 'package:e_catalog/components/custom_raised_button.dart';
import 'package:e_catalog/components/modal_bottom_sheet_app.dart';
import 'package:e_catalog/constants.dart';
import 'package:e_catalog/models/sales_order.dart';
import 'package:e_catalog/utilities/order_services.dart';
import "package:flutter/material.dart";
import 'package:intl/intl.dart';

class SalesOrderDetailPenyedia extends StatelessWidget {
  final SalesOrder salesOrder;
  OrderServices orderServices = OrderServices();

  SalesOrderDetailPenyedia({this.salesOrder});

  @override
  Widget build(BuildContext context) {
    void closeScreen() {
      Navigator.pop(context);
    }

    var size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Text("Detail Sales Order", style: kCalibriBold),
          centerTitle: false,
          backgroundColor: kBlueMainColor,
          elevation: 0,
        ),
        body: SafeArea(
          child: Container(
            margin: EdgeInsets.only(top: size.height / 50),
            padding: EdgeInsets.all(size.height / 100),
            decoration: BoxDecoration(color: Colors.white),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  salesOrder.id,
                  style: kCalibriBold.copyWith(
                      color: kBlueDarkColor, fontSize: size.width / 22),
                ),
                SizedBox(height: size.height / 100),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: size.width / 20),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                              child: Text(
                            "Tanggal :",
                            style: kCalibriBold,
                          )),
                          Expanded(
                              child: Text(
                                  salesOrder.creationDate != null
                                      ? "${salesOrder.creationDate.day}-${salesOrder.creationDate.month}-${salesOrder.creationDate.year}"
                                      : "Undefined",
                                  style: kCalibri)),
                        ],
                      ),
                      SizedBox(height: size.height / 100),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        children: [
                          Expanded(
                              child: Text("Status :", style: kCalibriBold)),
                          Expanded(
                              child: Text(salesOrder.getStatusPenyedia(),
                                  style: kCalibriBold)),
                        ],
                      ),
                      SizedBox(height: size.height / 100),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        children: [
                          Expanded(
                              child: Text("Produk :", style: kCalibriBold)),
                          Expanded(
                              child:
                                  Text(salesOrder.itemName, style: kCalibri)),
                        ],
                      ),
                      SizedBox(height: size.height / 100),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        children: [
                          Expanded(
                              child: Text("Jumlah :", style: kCalibriBold)),
                          Expanded(
                              child:
                                  Text("${salesOrder.count}", style: kCalibri)),
                        ],
                      ),
                      SizedBox(height: size.height / 100),
                      Row(
                        children: [
                          Expanded(
                              child:
                                  Text("Nama Penyedia :", style: kCalibriBold)),
                          Expanded(
                              child: Text(salesOrder.seller, style: kCalibri)),
                        ],
                      ),
                      SizedBox(height: size.height / 100),
                      Row(
                        children: [
                          Expanded(child: Text("PP :", style: kCalibriBold)),
                          Expanded(
                              child: Text(salesOrder.ppName, style: kCalibri)),
                        ],
                      ),
                      SizedBox(height: size.height / 100),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        children: [
                          Expanded(child: Text("Unit :", style: kCalibriBold)),
                          Expanded(
                              child: Text(salesOrder.getUnit, style: kCalibri)),
                        ],
                      ),
                      SizedBox(height: size.height / 100),
                      Row(
                        children: [
                          Expanded(
                              child:
                                  Text("Harga Satuan :", style: kCalibriBold)),
                          Expanded(
                            child: Text(
                                NumberFormat.currency(
                                        name: "Rp ", decimalDigits: 0)
                                    .format(salesOrder.unitPrice),
                                style: kCalibri),
                          ),
                        ],
                      ),
                      SizedBox(height: size.height / 100),
                      Row(
                        children: [
                          Expanded(
                              child:
                                  Text("Total Harga :", style: kCalibriBold)),
                          Expanded(
                              child: Text(
                                  NumberFormat.currency(
                                          name: "Rp ", decimalDigits: 0)
                                      .format(salesOrder.totalPrice),
                                  style: kCalibri)),
                        ],
                      ),
                      SizedBox(height: size.height / 100),
                    ],
                  ),
                ),
                SizedBox(height: size.height / 100),
                Container(
                  child: Text(
                    "Info Pengiriman",
                    style: kCalibriBold.copyWith(
                        color: kBlueDarkColor, fontSize: size.width / 25),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: size.width / 20, vertical: size.height / 100),
                  child: Column(children: [
                    Row(
                      children: [
                        Expanded(
                            flex: 1,
                            child: Text("Nama :", style: kCalibriBold)),
                        Expanded(
                          flex: 2,
                          child:
                              Text((salesOrder.namaPenerima), style: kCalibri),
                        ),
                      ],
                    ),
                    SizedBox(height: size.height / 200),
                    Row(
                      textBaseline: TextBaseline.alphabetic,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      children: [
                        Expanded(
                            flex: 1,
                            child: Text("Alamat :", style: kCalibriBold)),
                        Expanded(
                          flex: 2,
                          child: Text((salesOrder.address), style: kCalibri),
                        ),
                      ],
                    ),
                    SizedBox(height: size.height / 200),
                    Row(
                      children: [
                        Expanded(
                            flex: 1,
                            child: Text("Kontak :", style: kCalibriBold)),
                        Expanded(
                          flex: 2,
                          child: Text((salesOrder.teleponPenerima),
                              style: kCalibri),
                        ),
                      ],
                    ),
                  ]),
                ),
                SizedBox(height: size.height / 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: size.width / 3,
                      height: size.height / 20,
                      child: CustomRaisedButton(
                        buttonChild: Text("Batalkan",
                            style: kCalibriBold.copyWith(color: Colors.white)),
                        color: kRedButtonColor,
                        callback: () {
                          showModalBottomSheetApp(
                              context: context,
                              builder: (context) => DeclineBottomSheet(
                                    id: salesOrder.id,
                                    callback: (keterangan) async {
                                      await orderServices.changeOrderStatus(
                                          docId: salesOrder.docId,
                                          keterangan: keterangan,
                                          newStatus: 4,
                                          callback: (isSuccess) {
                                            print(isSuccess);
                                            if (isSuccess) {
                                              closeScreen();
                                            }
                                          });
                                    },
                                  ));
                        },
                      ),
                    ),
                    Container(
                      width: size.width / 3,
                      height: size.height / 20,
                      child: CustomRaisedButton(
                        buttonChild: Text("Konfirmasi",
                            style: kCalibriBold.copyWith(color: Colors.white)),
                        color: kBlueMainColor,
                        callback: () async {
                          print("konfirmasi pressed");
                          await orderServices.changeOrderStatus(
                              docId: salesOrder.docId,
                              newStatus: 3,
                              callback: (isSuccess) => print(isSuccess));
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
