import 'package:e_catalog/models/sales_order.dart';
import 'package:flutter/material.dart';
import 'package:e_catalog/constants.dart';
import 'package:e_catalog/components/custom_raised_button.dart';

class QuotationDetail extends StatelessWidget {

  final SalesOrder quotation;

  QuotationDetail({Key key, this.quotation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail Quotation", style: kCalibriBold),
        centerTitle: false,
        backgroundColor: kBlueMainColor,
        elevation: 0,
      ),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(top:size.height / 50),
        padding: EdgeInsets.all(size.height / 100),
        decoration: BoxDecoration(color: Colors.white),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  quotation.id,
                  style: kCalibriBold.copyWith(color: kBlueDarkColor),
                ),
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
                                  quotation.creationDate != null
                                      ? "${quotation.creationDate.day}-${quotation.creationDate.month}-${quotation.creationDate.year}"
                                      : "Undefined",
                                  style: kCalibri)),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        children: [
                          Expanded(child: Text("Produk :", style: kCalibriBold)),
                          Expanded(
                              child: Text(quotation.itemName, style: kCalibri)),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        children: [
                          Expanded(child: Text("Jumlah :", style: kCalibriBold)),
                          Expanded(
                              child: Text("${quotation.count}", style: kCalibri)),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(child: Text("Nama Penyedia :", style: kCalibriBold)),
                          Expanded(
                              child: Text(quotation.seller, style: kCalibri)),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(child: Text("PP :", style: kCalibriBold)),
                          Expanded(
                              child: Text(quotation.ppName, style: kCalibri)),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: Text("Harga Satuan :", style: kCalibriBold)),
                          Expanded(
                              child: Text((quotation.totalPrice/quotation.count).truncate().toString(),
                                style: kCalibri
                              ),
                            ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: Text("Total Harga :", style: kCalibriBold)),
                          Expanded(
                              child: Text(quotation.totalPrice.toString(),
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
                              height: size.height / 25,
                              width: size.width / 4,
                              child: CustomRaisedButton(
                                buttonChild: Text(
                                  "TOLAK",
                                  style: kCalibriBold.copyWith(color: Colors.white),
                                ),
                                callback: () {
                                  //Fungsi tolak quotation
                                },
                                color: kRedButtonColor,
                              ),
                            ),
                          ),
                          Expanded(
                                                      child: Container(
                              height: size.height / 25,
                              width: size.width / 4,
                              child: CustomRaisedButton(
                                buttonChild: Text(
                                  "TERIMA",
                                  style: kCalibriBold.copyWith(color: Colors.white),
                                ),
                                callback: () {
                                  //Fungsi terima quotation
                                },
                                color: kBlueMainColor,
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