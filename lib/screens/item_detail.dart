import 'package:e_catalog/components/custom_raised_button.dart';
import 'package:e_catalog/components/modal_bottom_sheet_app.dart';
import 'package:e_catalog/models/cart.dart';
import 'package:e_catalog/models/menu_state.dart';
import 'package:e_catalog/screens/catalog_home.dart';
import 'package:e_catalog/screens/seller_catalog.dart';
import 'package:e_catalog/utilities/item_services.dart';
import 'package:flutter/material.dart';
import 'package:e_catalog/models/item.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:e_catalog/constants.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:e_catalog/components/item_counter.dart';

class ItemDetail extends StatefulWidget {
  //Multiple photo belum support
  //Review dan rating
  bool isWithOption;
  bool isInfoOnly;
  Item infoItem;

  ItemDetail(
      {this.isInfoOnly = false, this.infoItem, this.isWithOption = true});

  static const routeId = 'itemDetail';

  @override
  State<StatefulWidget> createState() => ItemDetailState();
}

class ItemDetailState extends State<ItemDetail> {
  @override
  void initState() {
    isInfoOnly = widget.isInfoOnly;
    isWithOption = widget.isWithOption;
    if (isInfoOnly) {
      item = widget.infoItem;
    }
    super.initState();
  }

  @override
  void dispose() {
    count.dispose();
    super.dispose();
  }

  Widget bottomOptionManager(Size size) {
    if (isInfoOnly && isWithOption) {
      return buildBottomOptionPengajuan(size, item);
    } else if (isInfoOnly && isWithOption == false) {
      return SizedBox();
    } else {
      return buildBottomOption(size, item);
    }
  }

  ItemService itemService = ItemService();
  Item item;
  bool isInfoOnly;
  bool isWithOption;
  int imageSelected = 0;
  int itemCount = 0;
  int tempTerjual = 12;
  String descText =
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";

  TextEditingController count = TextEditingController(text: '0');

  List<Widget> dotIndicator(List image) {
    List<Widget> output = [];
    for (int i = 0; i < image.length; i++) {
      output.add(Container(
        margin: EdgeInsets.symmetric(horizontal: 3, vertical: 4),
        height: 8,
        width: 8,
        decoration: BoxDecoration(
          color: i == imageSelected ? Colors.grey[700] : Colors.grey[300],
          shape: BoxShape.circle,
        ),
      ));
    }
    return output;
  }

  Widget bottomSheetKeranjang(BuildContext context, Item item) {
    var size = MediaQuery.of(context).size;
    return StatefulBuilder(builder: (context, setState) {
      return Container(
        height: size.height / 4,
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                  top: Radius.circular(size.height / 30))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: size.height/50,
              ),
              Text(
                "Masukkan Keranjang",
                style: kMavenBold,
              ),
              SizedBox(
                height: size.height/50,
              ),
              ItemCounterButton(
                    componentHeight: size.height / 20,
                    componentWidth: size.height / 20,
                    fieldText: itemCount.toString(),
                    itemAdd: () {
                      itemCount >= 0 ? itemCount += 1 : itemCount = itemCount;
                      setState(() {});
                    },
                    itemReduce: () {
                      itemCount >= 1 ? itemCount -= 1 : itemCount = itemCount;
                      count.text = itemCount.toString();
                      setState(() {});
                    },
                    onTextSubmit: (value) {
                      itemCount = int.parse(value);
                      setState(() {});
                    },
                  ),
                  SizedBox(
                height: size.height/40,
              ),
              Container(
                height: size.height / 20,
                width: size.width / 3,
                child: CustomRaisedButton(
                  color: kBlueMainColor,
                  callback: () {
                    Provider.of<Cart>(context, listen: false)
                        .addToCart(item, itemCount);
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

  @override
  Widget build(BuildContext context) {
    //Image list sementara

    if (item == null) item = ModalRoute.of(context).settings.arguments;
    List<String> imageUrls = item.image.cast<String>();

    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          //Searchbar belum dikasi
          toolbarHeight: size.height * 0.07,
          centerTitle: true,
          title: Text(
            item.name,
            style: kCalibriBold,
          ),
          backgroundColor: kBlueMainColor,
          elevation: 2,
          actions: [
            isInfoOnly
                ? SizedBox()
                : InkWell(
                    onTap: () {
                      Provider.of<MenuState>(context, listen: false)
                          .setMenuSelected(1);
                      Navigator.pushNamedAndRemoveUntil(context,
                          CatalogHome.routeId, (Route<dynamic> route) => false);
                    },
                    child: Icon(Icons.shopping_cart),
                  ),
            SizedBox(width: size.width / 30)
          ],
        ),
        body: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Expanded(
            child: ListView(
              children: [
                Stack(
                  children: [
                    CarouselSlider(
                        //Diganti images dari item nanti
                        items: imageUrls.map((url) {
                          return Builder(builder: (context) {
                            return Container(
                              margin: EdgeInsets.all(2),
                              width: size.width,
                              child: Image(
                                  width: size.width,
                                  image: NetworkImage(url),
                                  fit: BoxFit.contain),
                            );
                          });
                        }).toList(),
                        options: CarouselOptions(
                          onPageChanged: (index, reason) {
                            setState(() {
                              imageSelected = index;
                            });
                          },
                          aspectRatio: size.width / size.height,
                          viewportFraction: 1,
                          height: size.height * 0.55,
                          enableInfiniteScroll: false,
                        )),
                    Positioned(
                      bottom: 2,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: dotIndicator(imageUrls),
                      ),
                    ),
                  ],
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: TopInfo(
                              item: item,
                              isInfoOnly: isInfoOnly,
                            ),
                          ),
                          Container(
                            child: Container(
                              color: Color(0xFFF2F4F5),
                              height: size.height * 0.01,
                              width: double.infinity,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: size.height / 100,
                                horizontal: size.width / 50),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Deskripsi Produk",
                                  style: kCalibriBold.copyWith(
                                      fontSize: size.height * 0.027),
                                ),
                                SizedBox(
                                  height: size.height * 0.01,
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: size.height / 100,
                                      horizontal: size.width / 50),
                                  child: Text(item.description,
                                      style: kCalibri.copyWith(
                                        fontSize: size.height * 0.025,
                                      )),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          bottomOptionManager(size)
        ]));
  }

  Container buildBottomOption(
    Size size,
    Item item,
  ) {
    return Container(
      //warna sementara dan desain masih jelek
      color: Colors.white,
      height: size.height * 0.08,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        Expanded(
          flex: 2,
          child: Padding(
            padding: EdgeInsets.all(size.width / 120),
            child: FlatButton(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(size.width / 40),
                    side: BorderSide(
                        width: size.width / 200, color: kBlueMainColor)),
                child: Text(
                  "Beli Sekarang",
                  style: kCalibriBold.copyWith(
                      color: kBlueDarkColor, fontSize: size.width / 23),
                ),
                onPressed: () {
                  Provider.of<Cart>(context, listen: false)
                      .addToCart(item, itemCount == 0 ? 1 : itemCount);
                  Provider.of<MenuState>(context, listen: false)
                      .setMenuSelected(1);
                  Navigator.pushNamedAndRemoveUntil(context,
                      CatalogHome.routeId, (Route<dynamic> route) => false);
                  //TODO Fungsi untuk beli sekarang
                }),
          ),
        ),
        Expanded(
          flex: 3,
          child: Padding(
            padding: EdgeInsets.all(size.width / 120),
            child: FlatButton(
                minWidth: size.width / 2.5,
                color: kBlueMainColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(size.width / 40),
                    side: BorderSide(
                        width: size.width / 200, color: kBlueMainColor)),
                child: Text(
                  "Masukkan Keranjang",
                  style: kCalibriBold.copyWith(
                      color: Colors.white, fontSize: size.width / 23),
                ),
                onPressed: () {
                  showModalBottomSheetApp(
                      context: context,
                      builder: (context) {
                        return bottomSheetKeranjang(context, item);
                      });
                }),
          ),
        ),
      ]),
    );
  }

  Container buildBottomOptionPengajuan(Size size, Item item) {
    return Container(
      //warna sementara dan desain masih jelek
      color: Colors.white,
      height: size.height * 0.08,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        Expanded(
          child: Column(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(2),
                  child: CustomRaisedButton(
                    buttonChild: FittedBox(
                      child: Text(
                        "TOLAK",
                        style: kCalibriBold.copyWith(color: Colors.white),
                      ),
                    ),
                    callback: () async {
                      bool isSuccess =
                          await itemService.setItemStatus(item.id, 5);
                      print(isSuccess);
                    },
                    color: kRedButtonColor,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(2),
                  child: CustomRaisedButton(
                      buttonChild: FittedBox(
                        child: Text(
                          "NEGOSIASI",
                          style: kCalibriBold.copyWith(color: Colors.white),
                        ),
                      ),
                      callback: () async {},
                      color: Colors.lightBlue),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(size.width / 120),
            child: Container(
              width: size.width / 5,
              child: CustomRaisedButton(
                buttonChild: FittedBox(
                  child: Text(
                    "TERIMA",
                    style: kCalibriBold.copyWith(color: Colors.white),
                  ),
                ),
                callback: () async {
                  bool isSuccess = await itemService.acceptItemProposal(item);
                  isSuccess ? Navigator.of(context).pop() : print("GAGAL");
                },
                color: kBlueMainColor,
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

class TopInfo extends StatelessWidget {
  final Item item;
  final bool isInfoOnly;
  TopInfo({this.item, this.isInfoOnly});

  Widget starRating(double rating) {
    var starFilled = Icon(Icons.star, color: Colors.orange, size: 20);
    return Row(children: [
      Text(
        '$rating',
        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
      ),
      starFilled,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          // "${item.price}",
          NumberFormat.currency(name: "Rp ", decimalDigits: 0)
              .format(isInfoOnly ? item.sellerPrice : item.price),
          style: kCalibriBold.copyWith(
              fontSize: size.height / 30, color: kBlueMainColor),
        ),
        SizedBox(
          height: size.height * 0.001,
        ),
        Container(
          width: size.width,
          padding: EdgeInsets.only(bottom: 5),
          margin: EdgeInsets.only(bottom: 5),
          child: Text(item.name,
              style: kCalibri.copyWith(fontSize: size.height / 30)),
        ),
        Container(
            padding: EdgeInsets.only(bottom: 5),
            margin: EdgeInsets.only(bottom: 5),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: kGrayConcreteColor, width: 1))),
            child: Row(
              children: [
                Text('Tersedia : ${item.stock}'),
                SizedBox(
                  width: size.width * 0.06,
                ),
                Text('Terjual : ${item.sold}'),
                // starRating(4),
              ],
            )),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            children: [
              Text(
                'Dijual oleh ',
                style: kCalibri,
              ),
              Icon(
                Icons.store,
                color: kBlueDarkColor,
              ),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, SellerCatalog.routeId,
                      arguments: item.seller);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                      vertical: size.height * 0.005,
                      horizontal: size.width / 30),
                  height: size.height / 25,
                  constraints: BoxConstraints(maxWidth: size.width / 1.7),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      color: kBlueMainColor),
                  child: Text(
                    '${item.seller}'.toUpperCase(),
                    style: kCalibriBold.copyWith(
                        color: Colors.white, fontSize: size.height * 0.021),
                  ),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
