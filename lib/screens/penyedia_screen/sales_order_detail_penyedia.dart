import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_catalog/components/bottom_sheet_decline_info.dart';
import 'package:e_catalog/components/custom_raised_button.dart';
import 'package:e_catalog/components/modal_bottom_sheet_app.dart';
import 'package:e_catalog/constants.dart';
import 'package:e_catalog/models/sales_order.dart';
import 'package:e_catalog/utilities/order_services.dart';
import "package:flutter/material.dart";
import 'package:intl/intl.dart';

class SalesOrderDetailPenyedia extends StatefulWidget {
  AsyncSnapshot<List<SalesOrder>> streamOrder;
  SalesOrder order;
  int index;
  SalesOrderDetailPenyedia({this.index, this.streamOrder, this.order});

  @override
  State<StatefulWidget> createState() => SalesOrderDetailState();
}

class SalesOrderDetailState extends State<SalesOrderDetailPenyedia> {
  SalesOrder salesOrder;
  OrderServices orderServices = OrderServices();

  @override
  Widget build(BuildContext context) {
    salesOrder = widget.order;
    // salesOrder = widget.streamOrder.data[widget.index];
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
          child: SingleChildScrollView(
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
                        SizedBox(height: size.height / 100),
                        Row(
                          children: [
                            Expanded(
                                child: Text("Nama Penyedia :",
                                    style: kCalibriBold)),
                            Expanded(
                                child:
                                    Text(salesOrder.seller, style: kCalibri)),
                          ],
                        ),
                        SizedBox(height: size.height / 100),
                        Row(
                          children: [
                            Expanded(child: Text("PP :", style: kCalibriBold)),
                            Expanded(
                                child:
                                    Text(salesOrder.ppName, style: kCalibri)),
                          ],
                        ),
                        SizedBox(height: size.height / 100),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          children: [
                            Expanded(
                                child: Text("Unit :", style: kCalibriBold)),
                            Expanded(
                                child:
                                    Text(salesOrder.getUnit, style: kCalibri)),
                          ],
                        ),
                        Column(children: orderList(size)),
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
                                    style: kCalibriBold)),
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
                        horizontal: size.width / 20,
                        vertical: size.height / 100),
                    child: Column(children: [
                      Row(
                        children: [
                          Expanded(
                              flex: 1,
                              child: Text("Nama :", style: kCalibriBold)),
                          Expanded(
                            flex: 2,
                            child: Text((salesOrder.namaPenerima),
                                style: kCalibri),
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
                              style:
                                  kCalibriBold.copyWith(color: Colors.white)),
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
                      //Hanya muncul saat salesOrder belum dibatalkan / disanggupi (setelah disetujui PPK)
                      salesOrder.status==1?
                      Container(
                        width: size.width / 3,
                        height: size.height / 20,
                        child: CustomRaisedButton(
                          buttonChild: Text("Konfirmasi",
                              style:
                                  kCalibriBold.copyWith(color: Colors.white)),
                          color: kBlueMainColor,
                          callback: () async {
                            print("konfirmasi pressed");
                            int status = 4;
                            bool isTotalDeclined = true;
                            bool isPartialDeclined = false;
                            salesOrder.listOrder.forEach((element) {
                              if (element.status == 0) isTotalDeclined = false;
                              if (element.status == 1) isPartialDeclined = true;
                            });
                            if(isPartialDeclined) status = 3;
                            if(isTotalDeclined) status = 5;

                            await orderServices.changeOrderStatus(
                                docId: salesOrder.docId,
                                newStatus: status,
                                callback: (isSuccess) => print(isSuccess));
                          },
                        ),
                      ):SizedBox(),
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }

  List<Widget> orderList(Size size) {
    return salesOrder.listOrder.map((e) {
      return Container(
        color: kBackgroundMainColor,
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            height: size.width * 0.25,
            width: size.width * 0.25,
            margin: EdgeInsets.only(right: 10),
            child: Image(
              fit: BoxFit.contain,
              image: NetworkImage(e.itemImage[0] != null ? e.itemImage[0] : ""),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(top: size.height / 100),
              child: Column(children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  children: [
                    Expanded(
                        flex: 2, child: Text("Produk :", style: kCalibriBold)),
                    Expanded(flex: 5, child: Text(e.itemName, style: kCalibri)),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  children: [
                    Expanded(
                        flex: 2, child: Text("Jumlah :", style: kCalibriBold)),
                    Expanded(
                        flex: 5,
                        child: Text(e.count.toString(), style: kCalibri)),
                  ],
                ),
                Row(children: [
                  Expanded(
                      flex: 2, child: Text("Harga :", style: kCalibriBold)),
                  Expanded(
                      flex: 5,
                      child: Text(
                          NumberFormat.currency(name: "Rp ", decimalDigits: 0)
                              .format(e.orderPrice),
                          style: kCalibri)),
                ]),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  children: [
                    Expanded(
                        flex: 2, child: Text("Status :", style: kCalibriBold)),
                    Expanded(
                        flex: 5,
                        child: Text(
                            e.status == 0
                                ? "Sanggup"
                                : e.status == 1
                                    ? "Dibatalkan"
                                    : e.status.toString(),
                            style: kCalibri)),
                  ],
                ),
                //Hanya muncul saat sales order status belum dikonfirmasi penyedia
                e.status == 0 && salesOrder.status==1
                    ? Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                        InkWell(
                          onTap: () {
                            e.setStatus(1);
                            orderServices.changeSubOrderStatus(
                                docId: salesOrder.docId,
                                newOrderList: salesOrder.listOrder,
                                newTotalPrice:
                                    salesOrder.totalPrice - e.orderPrice,
                                callback: (bool isSuccess) {
                                  setState(() {});
                                  //TODO Yang dilakukan saat sukses/ gagal
                                });
                          },
                          child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: size.width / 30,
                                  vertical: size.height / 100),
                              child: Text(
                                "Batalkan",
                                style: kCalibriBold.copyWith(
                                    color: kRedButtonColor),
                              )),
                        ),
                      ])
                    : SizedBox()
              ]),
            ),
          ),
        ]),
      );
    }).toList();
  }
}
