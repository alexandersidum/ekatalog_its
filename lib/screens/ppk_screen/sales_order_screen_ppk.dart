import 'package:e_catalog/auth.dart';
import 'package:e_catalog/components/custom_raised_button.dart';
import 'package:e_catalog/models/account.dart';
import 'package:e_catalog/models/sales_order.dart';
import 'package:e_catalog/screens/ppk_screen/quotation_detail.dart';
import 'package:e_catalog/screens/ppk_screen/sales_order_detail.dart';
import 'package:e_catalog/utilities/order_services.dart';
import 'package:flutter/material.dart';
import 'package:e_catalog/constants.dart';
import 'package:provider/provider.dart';

class SalesOrderPPK extends StatefulWidget {
  static const routeId = "SalesOrderPPK";

  @override
  State<StatefulWidget> createState() => SalesOrderPPKState();
}

class SalesOrderPPKState extends State<SalesOrderPPK> {
  sortedBy sorted = sortedBy.Default;
  List<SalesOrder> finalOrderList = [];
  OrderServices os = OrderServices();
  String searchQuery;
  bool onSearch = false;

  void manageOrder(List<SalesOrder> initialList) {
    if (initialList == null) return;
    else{
      finalOrderList = List.from(initialList);
    }
    switch (sorted) {
      case sortedBy.Terbaru:
        finalOrderList.sort((a, b) {
          return a.creationDate.compareTo(b.creationDate);
        });
        break;
      case sortedBy.Terlama:
        finalOrderList.sort((a, b) {
          return b.creationDate.compareTo(a.creationDate);
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
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SalesOrderDetail(salesOrder: order,),
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
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      children: [
                        Expanded(child: Text("Status :", style: kCalibriBold)),
                        Expanded(
                            child: Text(order.getStatus(), style: kCalibriBold)),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      children: [
                        Expanded(child: Text("Produk :", style: kCalibriBold)),
                        Expanded(
                            child: Text(order.itemName, style: kCalibri)),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      children: [
                        Expanded(child: Text("Jumlah :", style: kCalibriBold)),
                        Expanded(
                            child: Text("${order.count}", style: kCalibri)),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(child: Text("PP :", style: kCalibriBold)),
                        Expanded(
                            child: Text(order.ppName, style: kCalibri)),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(child: Text("Penyedia :", style: kCalibriBold)),
                        Expanded(
                            child: Text(order.seller, style: kCalibri)),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: Text("Total Harga :", style: kCalibriBold)),
                        Expanded(
                            child: Text(order.totalPrice.toString(),
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

  List<SalesOrder> searchedList(String searchQuery) {
    return finalOrderList
        .where((element) =>
            element.itemName
                .toLowerCase()
                .contains(searchQuery.toLowerCase()) ||
            element.ppName.toLowerCase().contains(searchQuery.toLowerCase()) ||
            element.id.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    List<SalesOrder> listOrder = Provider.of<List<SalesOrder>>(context);
    if(listOrder!=null){
      listOrder = listOrder.where((element) => element.status == 1).toList();
    }
    var size = MediaQuery.of(context).size;
    
    manageOrder(listOrder);

    return Scaffold(
      appBar: AppBar(
        title: Text("Sales Order", style: kCalibriBold),
        centerTitle: false,
        backgroundColor: kBlueMainColor,
        elevation: 0,
      ),
      body: Container(
        child: Column(
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
                child: ListView.builder(
                    itemCount:
                        finalOrderList != null ? finalOrderList.length : 0,
                    itemBuilder: (context, index) {
                      return orderTile(finalOrderList[index], size);
                    }))
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
