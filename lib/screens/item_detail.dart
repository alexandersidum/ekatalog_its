import 'package:e_catalog/models/cart.dart';
import 'package:e_catalog/models/menu_state.dart';
import 'package:e_catalog/screens/catalog_home.dart';
import 'package:e_catalog/screens/seller_catalog.dart';
import 'package:flutter/material.dart';
import 'package:e_catalog/models/item.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:e_catalog/constants.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ItemDetail extends StatefulWidget {
  //Multiple photo belum support
  //Review dan rating

  static const routeId = 'itemDetail';

  @override
  State<StatefulWidget> createState() => ItemDetailState();
}

class ItemDetailState extends State<ItemDetail> {
  @override
  void dispose() {
    count.dispose();
    super.dispose();
  }

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

  Widget bottomSheetKeranjang (BuildContext context, Item item){
    var size = MediaQuery.of(context).size;
    return Container(
      height: size.height/4,
      color: Colors.transparent,
      child: Container(
        decoration : BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top:Radius.circular(size.height/30))
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Masukkan Keranjang",
            style: kMavenBold,
            ),
            Container(
              height: size.height/10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children : [
                  IconButton(icon: Icon(Icons.add_circle), onPressed: (){
                    itemCount >= 0 ? itemCount += 1 : itemCount = itemCount;
                        count.text = itemCount.toString();
                  }),
                   Container(
                width: size.width * 0.1,
                child: TextField(
                  style: TextStyle(
                      color: kGrayTextColor,
                      fontWeight: FontWeight.w800,
                      fontSize: size.height * 0.035),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (value) {
                    setState(() {
                      try{itemCount = int.parse(value);}
                      catch(e){}
                    });
                  },
                  controller: count,
                ),
              ),
                  IconButton(icon: Icon(Icons.remove_circle), onPressed: (){
                    itemCount >= 1 ? itemCount -= 1 : itemCount = itemCount;
                        count.text = itemCount.toString();
                  }),
                ],
                
              ),
            ),
            RaisedButton(onPressed: (){
              Provider.of<Cart>(context, listen: false)
                    .addToCart(item, itemCount);
            },
            child: Text("Submit"),)
          ],
        ),

      ),
    );

  }

  @override
  Widget build(BuildContext context) {
    //Image list sementara
    Item item = ModalRoute.of(context).settings.arguments;
    List<String> imageUrls = item.image.cast<String>();

    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          //Searchbar belum dikasi
          toolbarHeight: size.height * 0.07,
          centerTitle: true,
          title: Text(item.name,
            style: kCalibriBold,
          ),
          backgroundColor: kBlueMainColor,
          elevation: 2,
          actions: [
            InkWell(
              onTap: (){
                Provider.of<MenuState>(context, listen: false).setMenuSelected(1);
                Navigator.pushNamed(context, CatalogHome.routeId);
              },
              child: Icon(Icons.shopping_cart),

            ),
            SizedBox(
              width: size.width/30
            )
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
                                  fit: BoxFit.cover),
                            );
                          });
                        }).toList(),
                        options: CarouselOptions(
                          onPageChanged: (index, reason) {
                            setState(() {
                              imageSelected = index;
                            });
                          },
                          aspectRatio: size.width / size.height * 0.5,
                          viewportFraction: 1,
                          height: size.height * 0.5,
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
                            padding: const EdgeInsets.symmetric(vertical : 5, horizontal:7),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Deskripsi Produk",
                                  style: kCalibriBold.copyWith(
                                    fontSize: size.height * 0.03),
                                ),
                                SizedBox(
                                  height: size.height * 0.01,
                                ),
                                Container(
                                  child: Text(
                                    item.description,
                                    style:kCalibri.copyWith(
                                      fontSize: size.height * 0.025,
                                    )
                                  ),
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
          buildBottomOption(size, item)
        ])
        );
  }

  Container buildBottomOption(Size size, Item item) {
    return Container(
      //warna sementara dan desain masih jelek
      color: Colors.white,
      height: size.height * 0.08,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, 
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(size.width/120),
            child: FlatButton(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(size.width/40),
                side: BorderSide(width:size.width/200, color: kBlueMainColor)
              ),
              child: Text("Beli Sekarang",
              style: kCalibriBold.copyWith(
                  color: kBlueDarkColor,
                  fontSize: size.width/23
                ),
              ),
              onPressed: (){
                //TODO Fungsi untuk beli sekarang
                
              }),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(size.width/120),
            child: FlatButton(
              minWidth: size.width/2.5,
              color: kBlueMainColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(size.width/40),
                side: BorderSide(width:size.width/200,color: kBlueMainColor)
              ),
              child: Text("Masukkan Keranjang",
                style: kCalibriBold.copyWith(
                  color: Colors.white,
                  fontSize: size.width/23
                ),
              ),
              onPressed: (){
                showModalBottomSheet(context: context, builder: (context){
                  return bottomSheetKeranjang(context, item);
                });
              }),
          ),
        ),
      ]),
    );
  }
}

class TopInfo extends StatelessWidget {
  final Item item;

  TopInfo({this.item});

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
      padding: EdgeInsets.symmetric(horizontal : 15, vertical : 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, 
        children: [
        Text(
          'Rp ${item.price.toString()}',
          style: kCalibriBold.copyWith(
            fontSize: size.height/25,
            color: kBlueMainColor
          ),
        ),
        SizedBox(
          height: size.height * 0.001,
        ),
        Container(
          width: size.width,
          padding: EdgeInsets.only(bottom: 5),
          margin: EdgeInsets.only(bottom: 5),
          child: Text(
            item.name,
            style: kCalibri.copyWith(
              fontSize : size.height/30
            )
          ),
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
                Text('Terjual : 12'),
                // starRating(4),
              ],
            )),
        Padding(
          padding: const EdgeInsets.symmetric(vertical : 5),
          child: Row(
            children: [
              Text(
                'Dijual oleh ',
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: size.height * 0.02,
                ),
              ),
              //Hyperlink untuk membuka page seller belum
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, SellerCatalog.routeId,
                      arguments: item.seller);
                },
                child: Container(
                  padding: EdgeInsets.all(size.height * 0.007),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: kGrayConcreteColor
                  ),
                  child: Text(
                    '${item.seller}',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: size.height * 0.022,
                    ),
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
