import 'package:e_catalog/components/bottom_sheet_decline_info.dart';
import 'package:e_catalog/components/custom_raised_button.dart';
import 'package:e_catalog/components/custom_text_field.dart';
import 'package:e_catalog/components/modal_bottom_sheet_app.dart';
import 'package:e_catalog/models/item.dart';
import 'package:e_catalog/screens/item_detail.dart';
import 'package:flutter/material.dart';
import 'package:e_catalog/utilities/item_services.dart';
import 'package:intl/intl.dart';
import 'package:e_catalog/components/negotiation_bottom_sheet.dart';

import '../../constants.dart';

class ManageProduct extends StatefulWidget {
  int initialTab = 0;
  ManageProduct({this.initialTab});

  @override
  _ManageProductState createState() => _ManageProductState();
}

class _ManageProductState extends State<ManageProduct> {
  int selectedTab = 0;
  ItemService itemService = ItemService();
  bool onSearch = false;
  String searchQuery = '';
  sortedBy sorted = sortedBy.Default;

  @override
  void initState() {
    if (widget.initialTab != null) {
      selectedTab = widget.initialTab;
    }
    super.initState();
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

  Widget negosiasiBottomSheet(Size size, String id, String docId,
      String sellerPrice, Function callback) {
    int ukpbjPrice;
    return StatefulBuilder(builder: (context, setState) {
      return Container(
        height: size.height / 2,
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
              color: kBackgroundMainColor,
              borderRadius: BorderRadius.vertical(
                  top: Radius.circular(size.height / 30))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(size.width / 100),
                child: Text(
                  "Negosiasi $id",
                  textAlign: TextAlign.center,
                  style: kMavenBold,
                ),
              ),
              Container(
                padding: EdgeInsets.all(size.width / 100),
                child: Text(
                  "Harga awal $sellerPrice",
                  textAlign: TextAlign.center,
                  style: kMavenBold.copyWith(color: Colors.orange),
                ),
              ),
              SizedBox(
                height: size.height / 20,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.03,
                    vertical: size.height * 0.015),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Penawaran",
                        style: kCalibriBold.copyWith(
                          color: kGrayTextColor,
                          fontSize: size.height * 0.025,
                        )),
                  ],
                ),
              ),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: size.width / 20),
                  height: size.height / 6,
                  child: CustomTextField(
                    keyboardType: TextInputType.number,
                    callback: (value) {
                      ukpbjPrice = int.parse(value);
                      print(ukpbjPrice);
                    },
                    hintText: "Harga Penawaran",
                    maxLength: 100,
                  )),
              SizedBox(
                height: size.height / 100,
              ),
              Container(
                height: size.height / 20,
                width: size.width / 3,
                child: CustomRaisedButton(
                  color: kRedButtonColor,
                  callback: () {
                    callback(ukpbjPrice);
                  },
                  buttonChild: Text("Submit",
                      style: kCalibriBold.copyWith(color: Colors.white)),
                ),
              )
            ],
          ),
        ),
      );
    });
  }

  Widget itemTile(context, Item element, {bool withOption = true}) {
    Size size = MediaQuery.of(context).size;
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
                                isWithOption: withOption,
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
                        padding: EdgeInsets.only(right: size.width / 6),
                        child: Text(
                          element.name,
                          style: kCalibriBold.copyWith(
                              fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                      ),
                      Text(
                        // NumberFormat.currency(name: "Rp ", decimalDigits: 0)
                        //     .format(element.price),
                        element.status == 1
                            ? NumberFormat.currency(
                                    name: "Rp ", decimalDigits: 0)
                                .format(element.price)
                            : NumberFormat.currency(
                                    name: "Rp ", decimalDigits: 0)
                                .format(element.sellerPrice),
                        style: kCalibri.copyWith(
                            fontSize: 16, color: Colors.orange),
                      ),
                      Text(
                        '${element.getStatus()}',
                        style: kCalibriBold.copyWith(
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        '${element.seller}',
                        style: kCalibri.copyWith(
                          fontSize: 13,
                        ),
                      ),
                      element.status == 1
                          ? Row(
                              children: [
                                Expanded(
                                    child: Text("Sisa Stok : ${element.stock}",
                                        style: kCalibri)),
                                Expanded(
                                    child: Text("Terjual : ${element.sold}",
                                        style: kCalibri)),
                              ],
                            )
                          : SizedBox(),
                    ],
                  ),
                ),
              ]),
            ),
          ]),
          element.status == 0
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () {
                          showModalBottomSheetApp(
                              context: context,
                              builder: (context) => NegosiasiBottomSheet(
                                    id: element.name,
                                    docId: element.id,
                                    sellerPrice: NumberFormat.currency(
                                            name: "Rp ", decimalDigits: 0)
                                        .format(element.sellerPrice),
                                  ));
                        },
                        child: Text(
                          "NEGOSIASI",
                          style: kCalibriBold,
                        )),
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
                        callback: () {
                          showModalBottomSheetApp(
                              context: context,
                              builder: (context) {
                                return DeclineBottomSheet(
                                  id: element.name,
                                  callback: (keterangan) async {
                                    bool isSuccess = await itemService
                                        .setItemStatus(element.id, 5,
                                            keterangan: keterangan);
                                    print(isSuccess);
                                  },
                                );
                              });
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
                        callback: () async {
                          bool isSuccess =
                              await itemService.acceptItemProposal(element);
                          print(isSuccess);
                        },
                        color: kBlueMainColor,
                      ),
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      height: size.height / 25,
                      width: size.width / 4,
                      child: CustomRaisedButton(
                        buttonChild: Text(
                          "Hapus",
                          style: kCalibriBold.copyWith(color: Colors.white),
                        ),
                        callback: () {
                          showModalBottomSheetApp(
                              context: context,
                              builder: (context) {
                                return DeclineBottomSheet(
                                  id: element.name,
                                  callback: (keterangan) {},
                                );
                              });
                        },
                        color: kRedButtonColor,
                      ),
                    ),
                  ],
                )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return DefaultTabController(
      initialIndex: selectedTab,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Manage Product", style: kCalibriBold),
          centerTitle: false,
          backgroundColor: kBlueMainColor,
          elevation: 0,
          bottom: TabBar(
            unselectedLabelColor: Colors.white,
            indicatorWeight: size.height / 150,
            indicatorColor: kOrangeButtonColor,
            tabs: [
              Tab(
                iconMargin: EdgeInsets.only(bottom: 10),
                text: "Approved",
              ),
              Tab(
                text: "Pending",
              )
            ],
          ),
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
              child: TabBarView(children: [
                StreamBuilder(
                    stream: itemService.getItemsWithStatus([1]),
                    builder: (context, AsyncSnapshot<List<Item>> snapshot) {
                      if (snapshot.hasError) {
                        return Container(
                          decoration:
                              BoxDecoration(color: kBackgroundMainColor),
                          child: Text(
                            "Error Mengambil Data",
                            style: kCalibriBold,
                          ),
                        );
                      }
                      if (snapshot == null || snapshot.data == null) {
                        return Container(
                          decoration:
                              BoxDecoration(color: kBackgroundMainColor),
                          child: Center(
                            child: Text(
                              "Tidak ada Produk",
                              style: kCalibriBold,
                            ),
                          ),
                        );
                      } else if (snapshot.data.length <= 0) {
                        return Container(
                          decoration:
                              BoxDecoration(color: kBackgroundMainColor),
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

                        return finalItemList.length > 0
                            ? ListView(
                                children: finalItemList
                                    .map((e) => itemTile(context, e, withOption: false))
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
                StreamBuilder(
                    stream: itemService.getItemsWithStatus([0]),
                    builder: (context, AsyncSnapshot<List<Item>> snapshot) {
                      if (snapshot.hasError) {
                        return Container(
                          decoration:
                              BoxDecoration(color: kBackgroundMainColor),
                          child: Center(
                            child: Text(
                              "Error Mengambil Data",
                              style: kCalibriBold,
                            ),
                          ),
                        );
                      }
                      if (snapshot == null || snapshot.data == null) {
                        return Container(
                          decoration:
                              BoxDecoration(color: kBackgroundMainColor),
                          child: Center(
                            child: Text(
                              "Tidak ada Produk",
                              style: kCalibriBold,
                            ),
                          ),
                        );
                      } else if (snapshot.data.length <= 0) {
                        return Container(
                          decoration:
                              BoxDecoration(color: kBackgroundMainColor),
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
                    })
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

// class NegosiasiBottomSheet extends StatefulWidget {
//   String id, sellerPrice, docId;

//   NegosiasiBottomSheet({this.id, this.sellerPrice, this.docId});

//   @override
//   _NegosiasiBottomSheetState createState() => _NegosiasiBottomSheetState();
// }

// class _NegosiasiBottomSheetState extends State<NegosiasiBottomSheet> {
//   ItemService itemService = ItemService();
//   int ukpbjPrice;
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return Container(
//       height: size.height / 2,
//       color: Colors.transparent,
//       child: Container(
//         decoration: BoxDecoration(
//             color: kBackgroundMainColor,
//             borderRadius:
//                 BorderRadius.vertical(top: Radius.circular(size.height / 30))),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               padding: EdgeInsets.all(size.width / 100),
//               child: Text(
//                 "Negosiasi ${widget.id}",
//                 textAlign: TextAlign.center,
//                 style: kMavenBold,
//               ),
//             ),
//             Container(
//               padding: EdgeInsets.all(size.width / 100),
//               child: Text(
//                 "Harga awal ${widget.sellerPrice}",
//                 textAlign: TextAlign.center,
//                 style: kMavenBold.copyWith(color: Colors.orange),
//               ),
//             ),
//             SizedBox(
//               height: size.height / 20,
//             ),
//             Padding(
//               padding: EdgeInsets.symmetric(
//                   horizontal: size.width * 0.03, vertical: size.height * 0.015),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text("Penawaran",
//                       style: kCalibriBold.copyWith(
//                         color: kGrayTextColor,
//                         fontSize: size.height * 0.025,
//                       )),
//                 ],
//               ),
//             ),
//             Container(
//                 padding: EdgeInsets.symmetric(horizontal: size.width / 20),
//                 height: size.height / 6,
//                 child: CustomTextField(
//                   keyboardType: TextInputType.number,
//                   callback: (value) {
//                     ukpbjPrice = int.parse(value);
//                     print(ukpbjPrice);
//                   },
//                   hintText: "Harga Penawaran",
//                   maxLength: 100,
//                 )),
//             SizedBox(
//               height: size.height / 100,
//             ),
//             Container(
//               height: size.height / 20,
//               width: size.width / 3,
//               child: CustomRaisedButton(
//                 color: kRedButtonColor,
//                 callback: () async {
//                   print(ukpbjPrice);
//                   if (ukpbjPrice != null) {
//                     print(await itemService.negotiateItem(
//                         widget.docId, ukpbjPrice));
//                     Navigator.of(context).pop();
//                   } else {
//                     //Jika tidak valid ukpbjprice
//                   }
//                 },
//                 buttonChild: Text("Submit",
//                     style: kCalibriBold.copyWith(color: Colors.white)),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

enum sortedBy {
  Terbaru,
  Terlama,
  Default,
}
