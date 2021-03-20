import 'package:e_catalog/auth.dart';
import 'package:e_catalog/components/custom_raised_button.dart';
import 'package:e_catalog/models/account.dart';
import 'package:e_catalog/models/sales_order.dart';
import 'package:e_catalog/screens/ppk_screen/quotation_detail.dart';
import 'package:e_catalog/screens/ppk_screen/sales_order_detail.dart';
import 'package:e_catalog/utilities/order_services.dart';
import 'package:flutter/material.dart';
import 'package:e_catalog/constants.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SalesOrderPPK extends StatefulWidget {
  static const routeId = "SalesOrderPPK";

  @override
  State<StatefulWidget> createState() => SalesOrderPPKState();
}

class SalesOrderPPKState extends State<SalesOrderPPK> {
  sortedBy sorted = sortedBy.Default;
  List<SalesOrder> finalOrderList = [];
  List<SalesOrder> listOrder = [];
  OrderServices os = OrderServices();
  String searchQuery;
  bool onSearch = false;
  bool isLoading = true;

  @override
  void initState() {
    getSalesOrder();
    super.initState();
  }

  getSalesOrder() async {
    isLoading = true;
    print("GETSALESORDER");
    //unitnya
    listOrder = await os.getSalesOrderPPK(
        status: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
        ppkCode: (Provider.of<Auth>(context, listen: false).getUserInfo
                as PejabatPembuatKomitmen)
            .ppkCode);
    print(listOrder.length);
    finalOrderList = listOrder;
    isLoading = false;
    setState(() {});
    
  }

  getSearchedSalesOrder(String keyword) async {
    isLoading = true;
    print("keyword : $keyword");
    //unitnya
    finalOrderList = await os.getSalesOrderBySearch(
        keyword: keyword,
        isCompleted: false,
        ppkCode: (Provider.of<Auth>(context, listen: false).getUserInfo
                as PejabatPembuatKomitmen)
            .ppkCode);
    print("DonE");
    isLoading = false;
    setState(() {});
  }

  // bool itemChecker(List<Order> listOrder, String searched) {
  //   bool output = false;
  //   listOrder.forEach((element) {
  //     if (element.itemName
  //         .toLowerCase()
  //         .trim()
  //         .contains(searched.toLowerCase().trim())) {
  //       output = true;
  //     }
  //     ;
  //   });
  //   return output;
  // }

void sortItem(List<SalesOrder> initialList) {
    switch (sorted) {
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
                Expanded(child: Text(e.itemName, style: kCalibri)),
                SizedBox(height: 10),
              ],
            ))
        .toList();
    return output;
  }

  Widget orderTile(SalesOrder order, Size size) {
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
                        builder: (context) => SalesOrderDetail(
                          salesOrder: order,
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
                order.id,
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
                                order.creationDate != null
                                    ? "${order.creationDate.day}-${order.creationDate.month}-${order.creationDate.year}"
                                    : "Undefined",
                                style: kCalibri)),
                      ],
                    ),
                    Row(
                      textBaseline : TextBaseline.alphabetic,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      children: [
                        Expanded(child: Text("Status :", style: kCalibriBold)),
                        Expanded(
                            child:
                                Text(order.getStatus(), style: kCalibriBold)),
                      ],
                    ),
                    Row(
                      textBaseline : TextBaseline.alphabetic,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      children: [
                        Expanded(child: Text("Produk :", style: kCalibriBold)),
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: produkInfo(order.listOrder),
                        )),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(child: Text("PP :", style: kCalibriBold)),
                        Expanded(child: Text(order.ppName, style: kCalibri)),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: Text("Penyedia :", style: kCalibriBold)),
                        Expanded(child: Text(order.seller, style: kCalibri)),
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
                                    .format(order.totalPrice),
                                style: kCalibri)),
                      ],
                    ),
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

  // List<SalesOrder> searchedList(String searchQuery) {
  //   return finalOrderList
  //       .where((element) =>
  //           itemChecker(element.listOrder, searchQuery) ||
  //           element.ppName.toLowerCase().contains(searchQuery.toLowerCase()) ||
  //           element.id.toLowerCase().contains(searchQuery.toLowerCase()))
  //       .toList();
  // }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    // manageOrder(listOrder);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Sales Order", style: kCalibriBold),
          centerTitle: false,
          backgroundColor: kBlueMainColor,
          elevation: 0,
        ),
        body: Container(
          child: isLoading?Center(child:CircularProgressIndicator()):Column(
            children: [
              Container(
                color: kBlueMainColor,
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
                        data: Theme.of(context)
                            .copyWith(canvasColor: Colors.white),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                              value: sorted,
                              items: dropDownSort(size),
                              onChanged: (value) {
                                setState(() {
                                  sorted = value;
                                  sortItem(finalOrderList);
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
                          textInputAction: TextInputAction.search,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(top: 5, left: 5),
                              suffixIcon: Icon(Icons.search),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                borderSide: BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                ),
                              ),
                              hintText: 'Search'),
                          onSubmitted: (value) {
                            if (value.isNotEmpty) {
                              onSearch = true;
                              searchQuery = value;
                              getSearchedSalesOrder(value);
                            } else {
                              onSearch = false;
                              searchQuery = value;
                              setState(() {
                                finalOrderList = listOrder;
                              });
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
                  child: finalOrderList.length > 0
                      ? ListView.builder(
                          itemCount: finalOrderList != null
                              ? finalOrderList.length
                              : 0,
                          itemBuilder: (context, index) {
                            return orderTile(finalOrderList[index], size);
                          })
                      : Center(
                          child: Text(
                              onSearch
                                  ? "'$searchQuery' tidak ditemukan"
                                  : "Tidak ada Sales Order",
                              style: kCalibriBold)))
            ],
          ),
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
