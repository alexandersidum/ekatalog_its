import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_catalog/auth.dart';
import 'package:e_catalog/components/custom_raised_button.dart';
import 'package:e_catalog/constants.dart';
import 'package:e_catalog/models/account.dart';
import 'package:e_catalog/models/sales_order.dart';
import 'package:e_catalog/screens/bpp_screen/pembayaran_detail_screen.dart';
import 'package:e_catalog/utilities/order_services.dart';
import "package:flutter/material.dart";
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:e_catalog/components/photo_detail.dart';

class PembayaranScreen extends StatefulWidget {
  @override
  _PembayaranScreenState createState() => _PembayaranScreenState();
}

class _PembayaranScreenState extends State<PembayaranScreen> {
  OrderServices orderService = OrderServices();
  bool onSearch = false;
  String searchQuery = '';
  sortedBy sorted = sortedBy.Default;
  Stream<List<SalesOrder>> orderStreams;
  BendaharaPengeluaran bpp;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    bpp = Provider.of<Auth>(context, listen: false).getUserInfo
        as BendaharaPengeluaran;
    orderStreams = orderService.getBPPSalesOrder(bpp.unit, [7, 8, 9]);
    super.didChangeDependencies();
  }

  List<Widget> produkInfo(List<Order> listOrder) {
    var output = listOrder
        .map((e) => e.status != 2
            ? Row(
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
              )
            : SizedBox())
        .toList();
    return output;
  }

  bool itemChecker(List<Order> listOrder, String searched) {
    bool output = false;
    listOrder.forEach((element) {
      if (element.itemName
          .toLowerCase()
          .trim()
          .contains(searched.toLowerCase().trim())) {
        output = true;
      }
      ;
    });
    return output;
  }

  Widget itemTile(context, SalesOrder element) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.all(5),
      color: Colors.white,
      margin: EdgeInsets.all(5),
      child: Column(
        children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Container(
            //   height: size.width * 0.25,
            //   width: size.width * 0.25,
            //   margin: EdgeInsets.only(right: 10),
            //   child: Image(
            //     fit: BoxFit.contain,
            //     image: NetworkImage(element.listOrder[0].itemImage[0] != null
            //         ? element.listOrder[0].itemImage[0]
            //         : ""),
            //   ),
            // ),
            element.imageBuktiPenerimaan != null
                ? Container(
                    height: size.width * 0.25,
                    width: size.width * 0.25,
                    margin: EdgeInsets.only(right: 10),
                    child: (element.imageBuktiPenerimaan.trim().isNotEmpty)
                        ? GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => PhotoDetail(
                                        heroTag: element.docId,
                                        imageUrl: element.imageBuktiPenerimaan,
                                      )));
                            },
                            child: Hero(
                              tag: element.docId,
                              child: Container(
                                width: size.width / 4,
                                height: size.width / 4,
                                child: CachedNetworkImage(
                                  placeholder: (context, url) =>
                                      CircularProgressIndicator(),
                                  imageUrl: element.imageBuktiPenerimaan,
                                  errorWidget: (context, url, err) =>
                                      Icon(Icons.error),
                                ),
                              ),
                            ),
                          )
                        : Center(child: Text("No image", style: kCalibri)),
                  )
                : Container(
                    height: size.width * 0.25,
                    width: size.width * 0.25,
                    margin: EdgeInsets.only(right: 10),
                    child: Center(child: Text("No image", style: kCalibri)),
                  ),
            Expanded(
              child: Stack(children: [
                // Positioned(
                //     top: 0,
                //     right: 0,
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.end,
                //       children: [
                //         GestureDetector(
                //           onTap: () {
                //             //NAVIGATE
                //           },
                //           child: Container(
                //             child: Text(
                //               "Detail",
                //               style: kCalibri,
                //             ),
                //           ),
                //         ),
                //         Container(child: Icon(Icons.chevron_right))
                //       ],
                //     )),
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
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: kBlueMainColor),
                        ),
                      ),
                      Text(
                        element.getStatusPenyedia(),
                        style: kCalibriBold.copyWith(
                            fontSize: 16, color: Colors.orange),
                      ),
                      Text(
                        element.seller,
                        style: kCalibriBold.copyWith(
                            fontSize: 14, color: kBlueMainColor),
                      ),
                      Text(
                        element.namaUnit,
                        style: kCalibriBold.copyWith(fontSize: 14),
                      ),
                      Text(
                        element.status == 7
                            ? "Barang sudah diterima, silahkan melakukan pembayaran"
                            : element.status == 8
                                ? "Pembayaran sudah dilakukan, menunggu konfirmasi penyedia"
                                : element.status == 9
                                    ? "Pembayaran ditolak penyedia, silahkan followup"
                                    : "Error mengambil data",
                        style: kCalibri.copyWith(
                            fontSize: 13, color: kRedButtonColor),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        children: [
                          Expanded(
                              flex: 2,
                              child: Text("Produk :  ", style: kCalibriBold)),
                          Expanded(
                              flex: 5,
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
                              flex: 2,
                              child: Text("Total :  ", style: kCalibriBold)),
                          Expanded(
                              flex: 5,
                              child: Text(
                                  NumberFormat.currency(
                                          name: "Rp ", decimalDigits: 0)
                                      .format(element.totalPrice),
                                  style: kCalibriBold)),
                        ],
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
    return Container(
      padding: EdgeInsets.symmetric(vertical: size.height / 60),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          order.status == 7 || order.status == 9
              ? Container(
                  width: size.width / 2,
                  height: size.height / 20,
                  // padding: EdgeInsets.symmetric(horizontal:size.width/10, vertical: size.height/50),
                  child: CustomRaisedButton(
                    buttonChild: FittedBox(
                      child: Text("Lakukan Pembayaran",
                          style: kCalibriBold.copyWith(color: Colors.white)),
                    ),
                    color: kBlueMainColor,
                    callback: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => PembayaranDetailScreen(
                                order: order,
                              )));
                    },
                  ),
                )
              : SizedBox()
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("Pembayaran", style: kCalibriBold),
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
                stream: orderStreams,
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
                            // return element.itemName
                            //         .toLowerCase()
                            //         .contains(searchQuery.toLowerCase()) ||
                            return itemChecker(
                                    element.listOrder, searchQuery) ||
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
