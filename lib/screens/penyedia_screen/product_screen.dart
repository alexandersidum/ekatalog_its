import 'package:e_catalog/auth.dart';
import 'package:e_catalog/components/bottom_sheet_decline_info.dart';
import 'package:e_catalog/components/custom_alert_dialog.dart';
import 'package:e_catalog/components/custom_raised_button.dart';
import 'package:e_catalog/components/custom_text_field.dart';
import 'package:e_catalog/components/modal_bottom_sheet_app.dart';
import 'package:e_catalog/models/account.dart';
import 'package:e_catalog/models/item.dart';
import 'package:e_catalog/screens/add_product_screen.dart';
import 'package:e_catalog/screens/item_detail.dart';
import 'package:flutter/material.dart';
import 'package:e_catalog/utilities/item_services.dart';
import 'package:intl/intl.dart';
import 'package:e_catalog/components/negotiation_bottom_sheet.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';

class ProductScreenPenyedia extends StatefulWidget {
  int initialTab = 0;
  ProductScreenPenyedia({this.initialTab});

  @override
  _ProductPenyediaState createState() => _ProductPenyediaState();
}

class _ProductPenyediaState extends State<ProductScreenPenyedia> {
  int selectedTab = 0;
  ItemService itemService = ItemService();
  bool onSearch = false;
  String searchQuery = '';
  sortedBy sorted = sortedBy.Default;
  Stream<List<Item>> firstTabStream;
  Stream<List<Item>> secondTabStream;
  Seller seller;
  bool isLoading = false;
  List<int> listPendingStatusCode = [0, 2, 3, 4, 6, 7];

  @override
  void initState() {
    seller = Provider.of<Auth>(context, listen: false).getUserInfo;
    if (widget.initialTab != null) {
      selectedTab = widget.initialTab;
    }
    firstTabStream = itemService.getSellerItemsWithStatus([1], seller.uid);
    secondTabStream =
        itemService.getSellerItemsWithStatus([0, 2, 3, 4, 6, 7], seller.uid);
    super.initState();
  }

  void sortItem(List<Item> initialList) {
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

  Widget changePriceBottomSheet({Size size, Item item, Function callback}) {
    String lastPrice =
        NumberFormat.currency(name: "Rp ", decimalDigits: 0).format(item.price);
    int newSellerPrice;
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
                  "${item.name}",
                  textAlign: TextAlign.center,
                  style: kCalibriBold,
                ),
              ),
              Container(
                padding: EdgeInsets.all(size.width / 100),
                child: Text(
                  "Harga sebelumnya $lastPrice",
                  textAlign: TextAlign.center,
                  style: kCalibriBold.copyWith(color: Colors.orange),
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
                    Text("Harga Baru",
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
                      newSellerPrice = int.parse(value);
                      print(newSellerPrice);
                    },
                    hintText: "Masukkan harga baru",
                    maxLength: 100,
                  )),
              Container(
                padding: EdgeInsets.symmetric(horizontal: size.width / 20),
                child: Text(
                    "Penggantian harga perlu persetujuan, jika haga telah disetujui maka harga akan diubah",
                    style: kCalibriBold.copyWith(
                      color: kRedButtonColor,
                      fontSize: size.height * 0.022,
                    )),
              ),
              Container(
                height: size.height / 20,
                width: size.width / 3,
                child: CustomRaisedButton(
                  color: kRedButtonColor,
                  callback: () {
                    callback(newSellerPrice);
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
              height: size.height * 0.12,
              width: size.height * 0.12,
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
                      element.status==7?
                      Row(
                      children: [
                        Text("Keterangan : ", style: kCalibriBold),
                        Expanded(
                            child:
                                Text(element.keteranganPengajuan, style: kCalibri)),
                      ],
                    ):SizedBox(),
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
          //Button untuk item pending
          listPendingStatusCode.contains(element.status)
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    //Kalau status perubahan ditolak muncul tombol ganti harga lagi
                    if(element.status == 7)TextButton(
                        onPressed: () {
                          showModalBottomSheetApp(
                              context: context,
                              builder: (context) {
                                return NegosiasiBottomSheet(
                                  item: element,
                                  isChangePrice: true,
                                  id: element.id,
                                );
                              });
                        },
                        child: Text(
                          "UBAH HARGA",
                          style: kCalibriBold.copyWith(color: Colors.orange),
                        )),
                    TextButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) => CustomAlertDialog(
                                    title: "Pembatalan Pengajuan",
                                    content:
                                        "Apakah anda yakin akan Membatalkan ?",
                                    noFunction: () {
                                      Navigator.pop(context);
                                    },
                                    yesFunction: () async {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      bool isPerubahanHarga = element.status == 6 || element.status == 7;

                                      await itemService.setItemStatus(
                                          element.id, isPerubahanHarga?1:8);
                                      Navigator.pop(context);
                                      setState(() {
                                        isLoading = false;
                                      });
                                    },
                                  ));
                        },
                        child: Text(
                          "BATALKAN",
                          style: kCalibriBold.copyWith(color: kRedButtonColor),
                        )),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () {
                          showModalBottomSheetApp(
                              context: context,
                              builder: (context) {
                                return NegosiasiBottomSheet(
                                  item: element,
                                  isChangePrice: true,
                                  id: element.id,
                                );
                              });
                        },
                        child: Text(
                          "UBAH HARGA",
                          style: kCalibriBold.copyWith(color: Colors.orange),
                        )),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return AddProductScreen(
                              isEdit: true,
                              item: element,
                            );
                          }));
                        },
                        child: Text(
                          "UBAH INFO",
                          style: kCalibriBold,
                        )),
                    TextButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) => CustomAlertDialog(
                                    title: "Hapus Produk",
                                    content:
                                        "Apakah anda yakin akan menghapus ${element.name} ?",
                                    noFunction: () {
                                      Navigator.pop(context);
                                    },
                                    yesFunction: () async {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      await itemService.setItemStatus(
                                          element.id, 8);
                                          Navigator.pop(context);
                                      setState(() {
                                        isLoading = false;
                                      });
                                    },
                                  ));
                        },
                        child: Text(
                          "HAPUS",
                          style: kCalibriBold.copyWith(color: kRedButtonColor),
                        )),
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
          title: Text("Product Saya", style: kCalibriBold),
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
        body: ModalProgressHUD(
          inAsyncCall: isLoading,
          child: Column(
            children: [
              Container(
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
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
                child: TabBarView(children: [
                  StreamBuilder(
                      stream: firstTabStream,
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
                                  return element.name.toLowerCase().contains(
                                          searchQuery.toLowerCase()) ||
                                      element.seller
                                          .toLowerCase()
                                          .contains(searchQuery.toLowerCase());
                                }).toList()
                              : snapshot.data;
                          sortItem(finalItemList);
                          return finalItemList.length > 0
                              ? ListView(
                                  children: finalItemList
                                      .map((e) => itemTile(context, e,
                                          withOption: false))
                                      .toList())
                              : Container(
                                  decoration: BoxDecoration(
                                      color: kBackgroundMainColor),
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
                      stream: secondTabStream,
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
                                  return element.name.toLowerCase().contains(
                                          searchQuery.toLowerCase()) ||
                                      element.seller
                                          .toLowerCase()
                                          .contains(searchQuery.toLowerCase());
                                }).toList()
                              : snapshot.data;
                          sortItem(finalItemList);
                          return finalItemList.length > 0
                              ? ListView(
                                  children: finalItemList
                                      .map((e) => itemTile(context, e,
                                          withOption: false))
                                      .toList())
                              : Container(
                                  decoration: BoxDecoration(
                                      color: kBackgroundMainColor),
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
      ),
    );
  }
}

enum sortedBy {
  Terbaru,
  Terlama,
  Default,
}
