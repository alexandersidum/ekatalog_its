import 'package:e_catalog/auth.dart';
import 'package:e_catalog/components/bottom_sheet_decline_info.dart';
import 'package:e_catalog/components/modal_bottom_sheet_app.dart';
import 'package:e_catalog/constants.dart';
import 'package:e_catalog/models/account.dart';
import 'package:e_catalog/models/item.dart';
import 'package:e_catalog/models/sales_order.dart';
import 'package:e_catalog/screens/item_detail.dart';
import 'package:e_catalog/screens/penyedia_screen/sales_order_detail_penyedia.dart';
import 'package:e_catalog/utilities/order_services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SalesOrderPenyedia extends StatefulWidget {
  @override
  _SalesOrderPenyediaState createState() => _SalesOrderPenyediaState();
}

class _SalesOrderPenyediaState extends State<SalesOrderPenyedia> {
  OrderServices orderService = OrderServices();
  bool onSearch = false;
  String searchQuery = '';
  sortedBy sorted = sortedBy.Default;

  Widget itemTile(context, SalesOrder element) {
    Size size = MediaQuery.of(context).size;
    return Container(
      color: Colors.white,
      margin: EdgeInsets.all(5),
      child: Column(
        children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              height: size.width * 0.25,
              width: size.width * 0.25,
              margin: EdgeInsets.only(right: 10),
              child: Image(
                fit: BoxFit.contain,
                image: NetworkImage(
                    element.itemImage != null ? element.itemImage[0] : ""),
              ),
            ),
            Expanded(
              child: Stack(children: [
                Positioned(
                    top: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => SalesOrderDetailPenyedia(
                                salesOrder: element,
                              ),
                              fullscreenDialog: true,
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
                Container(
                  padding: EdgeInsets.only(
                      top: size.height / 100, right: size.width / 50),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: size.width / 6),
                        child: Text(
                          element.id,
                          style: kCalibriBold.copyWith(
                              fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                      ),
                      Text(
                        element.getStatusPenyedia(),
                        style: kCalibriBold.copyWith(
                            fontSize: 16, color: Colors.orange),
                      ),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                            horizontal: size.width / 20,
                            vertical: size.height / 100),
                        color: kBackgroundMainColor,
                        child: Column(
                          children: [
                            Row(
                              textBaseline: TextBaseline.alphabetic,
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              children: [
                                Expanded(
                                    flex: 1,
                                    child:
                                        Text("Produk ", style: kCalibriBold)),
                                Expanded(
                                    flex: 2,
                                    child: Text(element.itemName,
                                        style: kCalibri)),
                              ],
                            ),
                            Row(
                              textBaseline: TextBaseline.alphabetic,
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              children: [
                                Expanded(
                                    flex: 1,
                                    child:
                                        Text("Jumlah ", style: kCalibriBold)),
                                Expanded(
                                    flex: 2,
                                    child: Text(
                                        element.count.toString() + " Unit",
                                        style: kCalibri)),
                              ],
                            ),
                            Row(
                              textBaseline: TextBaseline.alphabetic,
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              children: [
                                Expanded(
                                    flex: 1,
                                    child: Text("Harga ", style: kCalibriBold)),
                                Expanded(
                                    flex: 2,
                                    child: Text(
                                        NumberFormat.currency(
                                                name: "Rp ", decimalDigits: 0)
                                            .format(element.totalPrice),
                                        style: kCalibri)),
                              ],
                            ),
                            Row(
                              textBaseline: TextBaseline.alphabetic,
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              children: [
                                Expanded(
                                    flex: 1,
                                    child:
                                        Text("Pemesan ", style: kCalibriBold)),
                                Expanded(
                                    flex: 2,
                                    child:
                                        Text(element.getUnit, style: kCalibri)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      buttonListWidget(size, element)
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

  void sortItem(List<SalesOrder> initialList) {
    switch (sorted) {
      //TODO Terbaru terlamanya sepertinya kebalik
      case sortedBy.Terbaru:
        initialList.sort((a, b) {
          return b.creationDate.compareTo(a.creationDate);
        });
        break;
      case sortedBy.Terlama:
        initialList.sort((a, b) {
          return a.creationDate.compareTo(b.creationDate);
        });
        break;
      case sortedBy.Default:
        initialList = initialList;
        break;
      default:
        initialList = initialList;
    }
    // return initialList;
  }

  Widget buttonListWidget(Size size, SalesOrder order) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () {
            showModalBottomSheetApp(
                context: context,
                builder: (context) => DeclineBottomSheet(
                      id: order.id,
                      callback: (keterangan) async {
                        await orderService.changeOrderStatus(
                            docId: order.docId,
                            keterangan: keterangan,
                            newStatus: 4,
                            callback: (isSuccess) => print(isSuccess));
                      },
                    ));
          },
          child: Text(
            "Batalkan",
            style: kCalibriBold.copyWith(color: kRedButtonColor),
          ),
        ),
        order.status==1?TextButton(
          onPressed: () async {
            print("konfirmasi pressed");
            await orderService.changeOrderStatus(
                docId: order.docId,
                newStatus: 3,
                callback: (isSuccess) => print(isSuccess));
          },
          child: Text(
            "Konfirmasi",
            style: kCalibriBold.copyWith(color: kBlueMainColor),
          ),
        ):SizedBox()
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Seller seller = Provider.of<Auth>(context).getUserInfo;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Sales Order", style: kCalibriBold),
        centerTitle: false,
        backgroundColor: kBlueMainColor,
        elevation: 0,
      ),
      body: Column(
        children: [
          Row(
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
          Expanded(
            child: StreamBuilder(
                stream: orderService.getSellerSalesOrder(seller.uid, [1, 3, 6]),
                builder: (context, AsyncSnapshot<List<SalesOrder>> snapshot) {
                  if (snapshot.hasError) {
                    return Container(
                      decoration: BoxDecoration(color: kBackgroundMainColor),
                      child: Text(
                        "Error Mengambil Data",
                        style: kCalibriBold,
                      ),
                    );
                  }
                  if (snapshot == null || snapshot.data == null) {
                    return Container(
                      decoration: BoxDecoration(color: kBackgroundMainColor),
                      child: Center(
                        child: Text(
                          "Tidak ada Order",
                          style: kCalibriBold,
                        ),
                      ),
                    );
                  } else if (snapshot.data.length <= 0) {
                    return Container(
                      decoration: BoxDecoration(color: kBackgroundMainColor),
                      child: Center(
                        child: Text(
                          "Tidak ada Order",
                          style: kCalibriBold,
                        ),
                      ),
                    );
                  } else {
                    List<SalesOrder> finalItemList = onSearch
                        ? snapshot.data.where((element) {
                            return element.itemName
                                    .toLowerCase()
                                    .contains(searchQuery.toLowerCase()) ||
                                element.ppkName
                                    .toLowerCase()
                                    .contains(searchQuery.toLowerCase());
                          }).toList()
                        : snapshot.data;
                    sortItem(finalItemList);

                    return finalItemList.length > 0
                        ? ListView(
                            children: finalItemList
                                .map((e) => itemTile(context, e))
                                .toList())
                        : Container(
                            decoration:
                                BoxDecoration(color: kBackgroundMainColor),
                            child: Center(
                              child: Text(
                                "Order Tidak Ditemukan",
                                style: kCalibriBold,
                              ),
                            ),
                          );
                  }
                }),
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
}

enum sortedBy {
  Terbaru,
  Terlama,
  Default,
}
