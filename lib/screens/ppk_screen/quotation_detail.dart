import 'package:e_catalog/components/bottom_sheet_decline_info.dart';
import 'package:e_catalog/components/modal_bottom_sheet_app.dart';
import 'package:e_catalog/models/sales_order.dart';
import 'package:e_catalog/utilities/order_services.dart';
import 'package:flutter/material.dart';
import 'package:e_catalog/constants.dart';
import 'package:e_catalog/components/custom_raised_button.dart';

class QuotationDetail extends StatelessWidget {
  OrderServices os = OrderServices();
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
                  style: kCalibriBold.copyWith(
                    color: kBlueDarkColor,
                    fontSize: size.width/22),
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
                                  quotation.creationDate != null
                                      ? "${quotation.creationDate.day}-${quotation.creationDate.month}-${quotation.creationDate.year}"
                                      : "Undefined",
                                  style: kCalibri)),
                        ],
                      ),
                      SizedBox(height: size.height / 100),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        children: [
                          Expanded(child: Text("Produk :", style: kCalibriBold)),
                          Expanded(
                              child: Text(quotation.itemName, style: kCalibri)),
                        ],
                      ),
                      SizedBox(height: size.height / 100),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        children: [
                          Expanded(child: Text("Jumlah :", style: kCalibriBold)),
                          Expanded(
                              child: Text("${quotation.count}", style: kCalibri)),
                        ],
                      ),
                      SizedBox(height: size.height / 100),
                      Row(
                        children: [
                          Expanded(child: Text("Nama Penyedia :", style: kCalibriBold)),
                          Expanded(
                              child: Text(quotation.seller, style: kCalibri)),
                        ],
                      ),
                      SizedBox(height: size.height / 100),
                      Row(
                        children: [
                          Expanded(child: Text("PP :", style: kCalibriBold)),
                          Expanded(
                              child: Text(quotation.ppName, style: kCalibri)),
                        ],
                      ),
                      SizedBox(height: size.height / 100),
                      Row(
                        children: [
                          Expanded(
                              child: Text("Harga Satuan :", style: kCalibriBold)),
                          Expanded(
                              child: Text((quotation.unitPrice).toString(),
                                style: kCalibri
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: size.height / 100),
                      Row(
                        children: [
                          Expanded(
                              child: Text("Pajak :", style: kCalibriBold)),
                          Expanded(
                              child: Text((quotation.tax.toString()+"%"),
                                style: kCalibri
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: size.height / 100),
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
                              showModalBottomSheetApp(
                                  context: context,
                                  builder: (context) {
                                    return DeclineBottomSheet(
                                      id: quotation.id,
                                      callback: (keterangan) {
                                        print(keterangan);
                                        os.changeOrderStatus(
                                            docId: quotation.docId,
                                            newStatus: 2,
                                            keterangan: keterangan,
                                            callback: (bool result) {
                                              result
                                                  ? print("SUKSES")
                                                  : print("GAGAL");
                                            });
                                        Navigator.of(context).pop();
                                      },
                                    );
                                  });
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
                                  os.changeOrderStatus(
                                  docId: quotation.docId,
                                  newStatus: 1,
                                  callback: (bool result) {
                                    result ? Navigator.of(context).pop(): null;
                                  });
                                  
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