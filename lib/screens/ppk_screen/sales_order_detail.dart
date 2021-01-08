import 'package:e_catalog/components/bottom_sheet_decline_info.dart';
import 'package:e_catalog/components/modal_bottom_sheet_app.dart';
import 'package:e_catalog/models/sales_order.dart';
import 'package:e_catalog/utilities/order_services.dart';
import 'package:flutter/material.dart';
import 'package:e_catalog/constants.dart';
import 'package:e_catalog/components/custom_raised_button.dart';
import 'package:intl/intl.dart';

class SalesOrderDetail extends StatelessWidget {
  OrderServices os = OrderServices();
  final SalesOrder salesOrder;

  SalesOrderDetail({Key key, this.salesOrder}) : super(key: key);

  List<Widget> produkInfo(List<Order> listOrder) {
    var output = listOrder
        .map((e) => Row(
              textBaseline: TextBaseline.alphabetic,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              children: [
                Text(
                  e.count.toString() + "x ",
                  style: kCalibriBold.copyWith(color: kBlueMainColor),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(e.itemName, style: kCalibri),
                      Text(
                          "@" +
                              NumberFormat.currency(
                                      name: "Rp ", decimalDigits: 0)
                                  .format(e.unitPrice),
                          style: kCalibri.copyWith(color: Colors.orange)),
                    ],
                  ),
                ),
                SizedBox(height: 10),
              ],
            ))
        .toList();
    return output;
  }

  int totalTax(List<Order> listOrder) {
    int output = 0;
    listOrder.forEach((element) {
      output = output +
          ((element.tax / 100) * element.unitPrice * element.count).round();
    });
    return output;
  }

  @override
  Widget build(BuildContext context) {
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
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      salesOrder.id,
                      style: kCalibriBold.copyWith(
                          color: kBlueDarkColor, fontSize: size.width / 22),
                    ),
                    SizedBox(height: size.height / 100),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: size.width / 20),
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
                                  child: Text(salesOrder.getStatus(),
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
                                  child: Column(
                                      children:
                                          produkInfo(salesOrder.listOrder))),
                            ],
                          ),
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
                              Expanded(
                                  child: Text("PP :", style: kCalibriBold)),
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
                                  child: Text(salesOrder.unit.toString(),
                                      style: kCalibri)),
                            ],
                          ),
                          SizedBox(height: size.height / 100),
                          Row(
                            children: [
                              Expanded(
                                  child: Text("Harga Satuan :",
                                      style: kCalibriBold)),
                              Expanded(
                                child: Text(
                                    NumberFormat.currency(
                                            name: "Rp ", decimalDigits: 0)
                                        .format(
                                            salesOrder.listOrder[0].unitPrice),
                                    style: kCalibri),
                              ),
                            ],
                          ),
                          SizedBox(height: size.height / 100),
                          Row(
                            children: [
                              Expanded(
                                  child: Text("Pajak :", style: kCalibriBold)),
                              Expanded(
                                child: Text(
                                    NumberFormat.currency(
                                            name: "Rp ", decimalDigits: 0)
                                        .format(totalTax(salesOrder.listOrder)),
                                    style: kCalibri),
                              ),
                            ],
                          ),
                          SizedBox(height: size.height / 100),
                          Row(
                            children: [
                              Expanded(
                                  child: Text("Total Harga :",
                                      style: kCalibriBold)),
                              Expanded(
                                  child: Text(
                                      NumberFormat.currency(
                                              name: "Rp ", decimalDigits: 0)
                                          .format(salesOrder.totalPrice),
                                      style: kCalibri)),
                            ],
                          ),
                          SizedBox(
                            height: size.height / 50,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Container(
                                  height: size.height / 20,
                                  width: size.width / 4,
                                  child: CustomRaisedButton(
                                    buttonChild: Text(
                                      "BATALKAN",
                                      style: kCalibriBold.copyWith(
                                          color: Colors.white),
                                    ),
                                    callback: () {
                                      showModalBottomSheetApp(
                                          context: context,
                                          builder: (context) {
                                            return DeclineBottomSheet(
                                              id: salesOrder.id,
                                              callback: (keterangan) {
                                                print(keterangan);
                                                os.changeOrderStatus(
                                                    docId: salesOrder.docId,
                                                    newStatus: 2,
                                                    keterangan: keterangan,
                                                    callback: (bool result) {
                                                      result
                                                          ? Navigator.of(
                                                                  context)
                                                              .pop()
                                                          : null;
                                                    });
                                              },
                                            );
                                          });
                                    },
                                    color: kRedButtonColor,
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
