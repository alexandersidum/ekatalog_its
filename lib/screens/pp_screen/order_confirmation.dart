import 'package:e_catalog/auth.dart';
import 'package:e_catalog/constants.dart';
import 'package:e_catalog/models/account.dart';
import 'package:e_catalog/models/sales_order.dart';
import 'package:e_catalog/utilities/order_services.dart';
import "package:flutter/material.dart";
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class OrderConfirmationPP extends StatefulWidget {
  @override
  _OrderConfirmationPPState createState() => _OrderConfirmationPPState();
}

class _OrderConfirmationPPState extends State<OrderConfirmationPP> {
  OrderServices orderService = OrderServices();
  bool onSearch = false;
  String searchQuery = '';
  sortedBy sorted = sortedBy.Default;
  Stream<List<SalesOrder>> orderStreams;
  PejabatPengadaan pp ;


  @override
  void didChangeDependencies() {
    pp = Provider.of<Auth>(context, listen: false).getUserInfo as PejabatPengadaan;
    orderStreams = orderService.getPPSalesOrder(pp.uid, [0,1,2,3,4,5,6,7]);
    super.didChangeDependencies();
  }
  
  bool itemChecker(List<Order> listOrder, String searched){
    bool output = false;
    listOrder.forEach((element) { if(element.itemName.toLowerCase().trim().contains(searched.toLowerCase().trim())){
      output = true;
    };});
    return output;
  }

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
                image: NetworkImage(element.listOrder[0].itemImage[0] != null
                    ? element.listOrder[0].itemImage[0]
                    : ""),
              ),
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
                        element.getStatusPP(),
                        style: kCalibriBold.copyWith(
                            fontSize: 16, color: Colors.orange),
                      ),
                      Text(
                        element.seller,
                        style: kCalibriBold.copyWith(
                            fontSize: 14, color: kBlueMainColor),
                      ),
                      Text(
                        element.getUnit,
                        style: kCalibriBold.copyWith(fontSize: 14),
                      ),
                      Column(
                        children: element.listOrder
                            .map((Order e){
                              //Kalau sub ordernya ditolak tidak ditampilkan
                              return e.status==0?orderInfo(size, e):SizedBox();
                            } )
                            .toList(),
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

  Container orderInfo(Size size, Order element) {
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
              Expanded(flex: 5, child: Text(element.itemName, style: kCalibri)),
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
                  child: Text(element.count.toString() + " unit",
                      style: kCalibri)),
            ],
          ),
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
        order.status == 3 || order.status == 4
            ? TextButton(
                onPressed: () async {
                  await orderService.changeOrderStatus(
                      docId: order.docId,
                      newStatus: 7,
                      callback: (isSuccess) => print(isSuccess));
                },
                child: Text(
                  "Konfirmasi Penerimaan Barang",
                  style: kCalibriBold.copyWith(color: kBlueMainColor),
                ),
              )
            : SizedBox()
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    
    Size size = MediaQuery.of(context).size;
    
    return Scaffold(
      body: pp!=null?
      Column(
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
                  else if (snapshot == null || snapshot.data == null) {
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
                            return itemChecker(element.listOrder, searchQuery) ||
                            element.ppkName
                                .toLowerCase()
                                .contains(searchQuery.toLowerCase());
                          }).toList()
                        : snapshot.data;
                    sortItem(finalItemList);

                    return finalItemList.length > 0
                        ? ListView(
                            children: finalItemList
                                .map((e) => itemTile(context, e ))
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
      )
      :CircularProgressIndicator(),
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
