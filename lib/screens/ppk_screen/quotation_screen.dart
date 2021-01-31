import 'package:e_catalog/auth.dart';
import 'package:e_catalog/components/custom_raised_button.dart';
import 'package:e_catalog/components/modal_bottom_sheet_app.dart';
import 'package:e_catalog/models/account.dart';
import 'package:e_catalog/models/sales_order.dart';
import 'package:e_catalog/screens/ppk_screen/quotation_detail.dart';
import 'package:e_catalog/utilities/order_services.dart';
import 'package:flutter/material.dart';
import 'package:e_catalog/constants.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:e_catalog/components/bottom_sheet_decline_info.dart';

class QuotationScreen extends StatefulWidget {
  static const routeId = "Quotation";

  @override
  State<StatefulWidget> createState() => QuotationScreenState();
}

class QuotationScreenState extends State<QuotationScreen> {
  sortedBy sorted = sortedBy.Default;
  List<SalesOrder> finalOrderList = [];
  OrderServices os = OrderServices();
  String searchQuery;
  bool onSearch = false;

  void manageQuotation(List<SalesOrder> initialList) {
    if (initialList == null)
      return;
    else {
      finalOrderList = List.from(initialList);
    }
    switch (sorted) {
      case sortedBy.Terbaru:
        finalOrderList.sort((a, b) {
          return b.creationDate.compareTo(a.creationDate);
        });
        break;
      case sortedBy.Terlama:
        finalOrderList.sort((a, b) {
          return a.creationDate.compareTo(b.creationDate);
        });
        break;
      case sortedBy.Default:
        finalOrderList = List.from(initialList);
        break;
      default:
        finalOrderList = List.from(initialList);
    }
    if (onSearch) {
      finalOrderList = searchedList(searchQuery);
    }
    setState(() {});
  }

  List<Widget> produkInfo(List<Order> listOrder){
    var output = listOrder
        .map((e) => Row(
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

  Widget quotationTile(SalesOrder quotation, Size size) {
    return Container(
      margin: EdgeInsets.all(size.width / 50),
      padding: EdgeInsets.all(size.height / 100),
      decoration: BoxDecoration(color: Colors.white),
      child: Stack(
        children: [
          Positioned(
              top: 1,
              right: 1,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => QuotationDetail(
                          quotation: quotation,
                        ),
                      ));
                    },
                    child: Container(
                      child: Text(
                        "Detail",
                        style: kCalibri,
                      ),
                    ),
                  ),
                  Container(child: Icon(Icons.chevron_right))
                ],
              )),
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
                            child: Column(
                              children: produkInfo(quotation.listOrder),
                            )),
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
                            child: Text("Penyedia :", style: kCalibriBold)),
                        Expanded(
                            child: Text(quotation.seller, style: kCalibri)),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: Text("Total Harga :", style: kCalibriBold)),
                        Expanded(
                            child: Text(
                                NumberFormat.currency(
                                        name: "Rp ", decimalDigits: 0)
                                    .format(quotation.totalPrice),
                                style: kCalibri)),
                      ],
                    ),
                    SizedBox(
                      height: size.height / 50,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
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
                                      },
                                    );
                                  });
                            },
                            color: kRedButtonColor,
                          ),
                        ),
                        Container(
                          height: size.height / 25,
                          width: size.width / 4,
                          child: CustomRaisedButton(
                            buttonChild: Text(
                              "TERIMA",
                              style: kCalibriBold.copyWith(color: Colors.white),
                            ),
                            callback: () async {
                              //Fungsi terima quotation
                              os.changeOrderStatus(
                                  docId: quotation.docId,
                                  newStatus: 1,
                                  callback: (bool result) {
                                    result ? print("SUKSES") : print("GAGAL");
                                  });
                            },
                            color: kBlueMainColor,
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
    );
  }

  List<DropdownMenuItem> dropDownSort(Size size) {
    List<DropdownMenuItem> output = [];
    sortedBy.values.forEach((element) {
      output.add(DropdownMenuItem(
        value: element,
        child: Text(
          element.toString().split(".").last,
          style: kMaven.copyWith(fontSize: size.height / 50),
        ),
      ));
    });
    return output;
  }

  List<SalesOrder> searchedList(String searchQuery) {
    return finalOrderList
        .where((element) =>
            // element.itemName
            //     .toLowerCase()
            //     .contains(searchQuery.toLowerCase()) ||
            element.ppName.toLowerCase().contains(searchQuery.toLowerCase()) ||
            element.id.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    List<SalesOrder> listOrder = Provider.of<List<SalesOrder>>(context);
    if (listOrder != null) {
      listOrder = listOrder.where((element) => element.status == 0).toList();
    }
    var size = MediaQuery.of(context).size;

    manageQuotation(listOrder);

    return Scaffold(
      appBar: AppBar(
        title: Text("Quotation", style: kCalibriBold),
        centerTitle: false,
        backgroundColor: kBlueMainColor,
        elevation: 0,
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              
                      color: kBlueMainColor,
              padding: EdgeInsets.symmetric(horizontal : size.width/100, vertical:size.height/200),
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
                      data: Theme.of(context).copyWith(canvasColor: Colors.white),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                            value: sorted,
                            items: dropDownSort(size),
                            onChanged: (value) {
                              setState(() {
                                sorted = value;
                              });
                            }),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: MediaQuery.of(context).size.height / 18,
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: TextField(
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(top: 5, left: 5),
                            suffixIcon: Icon(Icons.search),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                              borderSide: BorderSide(
                                width: 0,
                                style: BorderStyle.none,
                              ),
                            ),
                            hintText: 'Search'),
                        onChanged: (value) {
                          if (value.isNotEmpty || value != null) {
                            onSearch = true;
                            searchQuery = value;
                          } else {
                            onSearch = false;
                            searchQuery = value;
                          }
                          setState(() {});
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
                child: finalOrderList.length>0 ?ListView.builder(
                    itemCount:
                        finalOrderList != null ? finalOrderList.length : 0,
                    itemBuilder: (context, index) {
                      return quotationTile(finalOrderList[index], size);
                    }):Center(
                      child : Text("Tidak ada Quotation",
                      style: kCalibriBold)
                    ))
          ],
        ),
      ),
    );
  }
}

enum sortedBy {
  Terbaru,
  Terlama,
  Default,
}
