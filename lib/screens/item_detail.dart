import 'package:e_catalog/models/cart.dart';
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
  //Appbar khusus untuk search
  //Constant style
  //Jumlah itemnya belum

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
        height: 6,
        width: 6,
        decoration: BoxDecoration(
          color: i == imageSelected ? Colors.grey[700] : Colors.grey[300],
          shape: BoxShape.circle,
        ),
      ));
    }
    return output;
  }

  @override
  Widget build(BuildContext context) {
    //Image list sementara
    Item item = ModalRoute.of(context).settings.arguments;
    List imageUrls = [
      item.image,
      'https://picsum.photos/300/300',
      'https://picsum.photos/400/300'
    ];

    Size size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          //Searchbar belum dikasi
          toolbarHeight: size.height * 0.07,
          centerTitle: true,
          title: Text(item.name.toUpperCase()),
          backgroundColor: kBlueDarkColor.withOpacity(0.7),
          elevation: 2,
        ),
        body: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Expanded(
            child: ListView(
              children: [
                Stack(
                  children: [
                    CarouselSlider(
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
                                  "Description",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w800, fontSize: 18),
                                ),
                                SizedBox(
                                  height: size.height * 0.01,
                                ),
                                Container(
                                  child: Text(
                                    descText,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                    ),
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
      color: kBlueDarkColor,
      height: size.height * 0.08,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        Container(
          child: Row(
            children: [
              Container(
                height: size.height * 0.07,
                child: IconButton(
                    icon: Icon(
                      Icons.add_circle,
                      color: kGrayMainColor,
                      size: size.height * 0.05,
                    ),
                    onPressed: () {
                      setState(() {
                        itemCount >= 0 ? itemCount += 1 : itemCount = itemCount;
                        count.text = itemCount.toString();
                      });
                    }),
              ),
              Container(
                width: size.width * 0.1,
                child: TextField(
                  style: TextStyle(
                      color: kGrayMainColor,
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
                      itemCount = int.parse(value);
                    });
                  },
                  controller: count,
                ),
              ),
              Container(
                height: size.height * 0.07,
                child: IconButton(
                    icon: Icon(
                      Icons.remove_circle,
                      color: kGrayMainColor,
                      size: size.height * 0.05,
                    ),
                    onPressed: () {
                      setState(() {
                        itemCount >= 1 ? itemCount -= 1 : itemCount = itemCount;
                        count.text = itemCount.toString();
                      });
                    }),
              ),
            ],
          ),
        ),
        Container(
          child: RaisedButton.icon(
              onPressed: () {
                Provider.of<Cart>(context, listen: false)
                    .addToCart(item, itemCount);
              },
              icon: Icon(Icons.shopping_cart),
              label: Text('Add to Cart')),
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
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 22,
          ),
        ),
        SizedBox(
          height: size.height * 0.008,
        ),
        Container(
          width: size.width,
          padding: EdgeInsets.only(bottom: 5),
          margin: EdgeInsets.only(bottom: 5),
          child: Text(
            item.name.toUpperCase(),
            style: TextStyle(
              fontSize: 17,
            ),
          ),
        ),
        Container(
            width: size.width,
            padding: EdgeInsets.only(bottom: 5),
            margin: EdgeInsets.only(bottom: 5),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: kGrayConcreteColor, width: 1))),
            child: Row(
              children: [
                Text('Terjual 12'),
                SizedBox(
                  width: size.width * 0.06,
                ),
                starRating(4),
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
                  fontSize: 13,
                ),
              ),
              //Hyperlink untuk membuka page seller belum
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, SellerCatalog.routeId,
                      arguments: item.seller);
                },
                child: Text(
                  '${item.seller}',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
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
