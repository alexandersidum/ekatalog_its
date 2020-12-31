import 'package:e_catalog/auth.dart';
import 'package:e_catalog/components/bottom_sheet_decline_info.dart';
import 'package:e_catalog/components/custom_raised_button.dart';
import 'package:e_catalog/components/modal_bottom_sheet_app.dart';
import 'package:e_catalog/components/negotiation_bottom_sheet.dart';
import 'package:e_catalog/models/account.dart';
import 'package:e_catalog/models/item.dart';
import 'package:e_catalog/utilities/item_services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../item_detail.dart';

class NegotationScreenPenyedia extends StatefulWidget {
  @override
  _NegotationScreenPenyediaState createState() => _NegotationScreenPenyediaState();
}

class _NegotationScreenPenyediaState extends State<NegotationScreenPenyedia> {
  ItemService itemService = ItemService();
  bool onSearch = false;
  String searchQuery = '';
  sortedBy sorted = sortedBy.Default;

  void sortItem(List<Item> initialList) {
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

  Widget itemTile(context, Item element) {
    Size size = MediaQuery.of(context).size;
    String sellerPrice = NumberFormat.currency(name: "Rp ", decimalDigits: 0)
        .format(element.sellerPrice);
    String ukpbjPrice = NumberFormat.currency(name: "Rp ", decimalDigits: 0)
        .format(element.ukpbjPrice);
    return Container(
      // height: size.height * 0.15,
      color: Colors.white,
      margin: EdgeInsets.all(5),
      child: Column(
        children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              height: size.height * 0.145,
              width: size.width * 0.3,
              margin: EdgeInsets.only(right: 10),
              child: Image(
                fit: BoxFit.cover,
                image: NetworkImage(element.image[0].toString()),
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
                              builder: (context) => ItemDetail(
                                infoItem: element,
                                isWithOption: false,
                                isInfoOnly: true,
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
                  padding: EdgeInsets.only(top: size.height / 100),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top:size.height/100,right: size.width / 6),
                        child: Text(
                          element.name,
                          style: kCalibriBold.copyWith(
                              fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                      ),
                      Text(
                        "Harga Awal : $sellerPrice",
                        style: kCalibriBold.copyWith(
                            fontSize: 14, color: Colors.orange),
                      ),
                      Text(
                        "Harga Penawaran : $ukpbjPrice",
                        style: kCalibriBold.copyWith(
                            fontSize: 14, color: kBlueMainColor),
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          ]),
          buttonListWidget(size, element)
        ],
      ),
    );
  }

  Widget buttonListWidget(Size size, Item item) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        
        Container(
          height: size.height / 27,
          width: size.width / 5,
          child: CustomRaisedButton(
            buttonChild: FittedBox(
              child: Text(
                "TOLAK",
                style: kCalibriBold.copyWith(color: Colors.white),
              ),
            ),
            callback: ()async {
                        bool isSuccess = await itemService
                            .acceptItemNegotiation(item, false);
                        print("MENOLAK $isSuccess");
                      },
            color: kRedButtonColor,
          ),
        ),
        Container(
          height: size.height / 27,
          width: size.width / 5,
          child: CustomRaisedButton(
            buttonChild: FittedBox(
              child: Text(
                "TERIMA",
                style: kCalibriBold.copyWith(color: Colors.white),
              ),
            ),
            callback: ()async {
                        bool isSuccess = await itemService
                            .acceptItemNegotiation(item, true);
                        print("MENERIMA $isSuccess");
                      },
            color: kRedButtonColor,
          ),
        ),
        TextButton(
          onPressed: ()async {
                        bool isSuccess = await itemService
                            .acceptItemNegotiation(item, true);
                        print("MENERIMA $isSuccess");
                      },
          child: Text("TERIMA"),
        )
      ],
    );
  }



  @override
  Widget build(BuildContext context) {
    Seller seller = Provider.of<Auth>(context).getUserInfo;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Negosiasi Produk", style: kCalibriBold),
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
                stream: itemService.getSellerItemsWithStatus([2], seller.uid),
                builder: (context, AsyncSnapshot<List<Item>> snapshot) {
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
                          "Tidak ada Produk",
                          style: kCalibriBold,
                        ),
                      ),
                    );
                  } else if (snapshot.data.length <= 0) {
                    return Container(
                      decoration: BoxDecoration(color: kBackgroundMainColor),
                      child: Center(
                        child: Text(
                          "Tidak ada Produk",
                          style: kCalibriBold,
                        ),
                      ),
                    );
                  } else {
                    List<Item> finalItemList = onSearch
                        ? snapshot.data.where((element) {
                            return element.name
                                    .toLowerCase()
                                    .contains(searchQuery.toLowerCase()) ||
                                element.seller
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
                                "Produk Tidak Ditemukan",
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
