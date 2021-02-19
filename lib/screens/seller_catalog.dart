import 'package:e_catalog/components/item_tile.dart';
import 'package:e_catalog/constants.dart';
import 'package:e_catalog/models/account.dart';
import 'package:e_catalog/models/item.dart';
import 'package:e_catalog/utilities/item_services.dart';
import 'package:flutter/material.dart';
import 'package:e_catalog/utilities/account_services.dart';
import 'package:flutter/src/rendering/sliver_persistent_header.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'item_detail.dart';
import '../auth.dart';

//Belum ditampilkan sesuai seller name atau uid

class SellerCatalog extends StatefulWidget {
  static const routeId = 'sellerCatalog';

  @override
  _SellerCatalogState createState() => _SellerCatalogState();
}

class _SellerCatalogState extends State<SellerCatalog> {

  String sellerUid;
  Seller sellerData;
  Stream<List<Item>> sellerItemsStream;
  ItemService _itemService = ItemService();
  AccountService _accountService = AccountService();


  @override
  void didChangeDependencies() {
     sellerUid = ModalRoute.of(context).settings.arguments;
    getSellerItems();
    getSellerData();
    super.didChangeDependencies();
    
  }

  getSellerItems()async{
    sellerItemsStream =  _itemService.getSellerItemsWithStatus([1], sellerUid);
  }

  getSellerData()async{
     sellerData = await _accountService.getSellerData(sellerUid);
     setState(() {
            
          });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Item>>(
      stream: sellerItemsStream,
      initialData: [],
      builder: (context, AsyncSnapshot<List<Item>> snapshot){
        if(snapshot.hasData && sellerData!=null){
          return Etalase(listItem: snapshot.data, sellerData: sellerData,);
        }
        else{
          return Center(child : CircularProgressIndicator());
        }
      },
      );
  }
}


class Etalase extends StatelessWidget {
  List<Item> listItem;
  Seller sellerData;
  Etalase({this.listItem, this.sellerData});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Container(
              color: kBlueMainColor,
              height: size.height*0.4,
              width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //Seller Image Belum Ada
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      maxRadius: size.width/6.9,
                      child: CircleAvatar(
                        backgroundColor: kGrayTextColor,
                        maxRadius: size.width/7,
                        backgroundImage: NetworkImage(sellerData.imageUrl),
                      ),
                    ),
                    SizedBox(
                      height: size.height/50,
                    ),
                    //Seller Name
                    Text(
                      sellerData.name.toString(),
                      style: kCalibri.copyWith(
                        fontSize: 18,
                        color: Colors.white
                      ),),
                      Text(
                      sellerData.namaPerusahaan.toString(),
                      style: kCalibri.copyWith(
                        fontSize: 18,
                        color: kOrangeButtonColor,
                      ),),
                      SizedBox(
                      height: size.height/50,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [

                      Text("Jumlah Produk : ${listItem.length}",
                      style: kCalibri.copyWith(
                        fontSize: 14,
                        color: Colors.white
                      )),
                      Text("Jumlah Transaksi : Soon",
                      style: kCalibri.copyWith(
                        fontSize: 14,
                        color: Colors.white
                      ))
                    ],)
                    //Rating, jumlah transaksi, ulasan info
                  ],
                ),
    ),
            ),
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.symmetric(
                    vertical: size.height / 100, horizontal: size.width / 50),
                child: Text("PRODUK DARI ${sellerData.namaPerusahaan.toUpperCase()}",
                    style: kCalibriBold.copyWith(color: kBlueMainColor)),
              ),
            ),
            SliverStaggeredGrid.countBuilder(
              itemCount: listItem != null ? listItem.length : 0,
              crossAxisCount: 2,
              staggeredTileBuilder: (index) => StaggeredTile.fit(1),
              itemBuilder: (context, index) {
                return ItemTile(
                  item: listItem[index],
                  size: MediaQuery.of(context).size,
                );
              }
            )
          ],
        )
        );
  }
}

class SellerHeaderDelegate implements SliverPersistentHeaderDelegate {
  //DIGUNAKAN MENYUSUL
  final maxExtent;
  final minExtent;
  final Seller seller;

  SellerHeaderDelegate({this.minExtent,this.seller, @required this.maxExtent});
  
  @override
  Widget build(BuildContext context, double shrinkOffset,bool overlapsContent) {
    var size = MediaQuery.of(context).size;
      return SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Container(
              color: kBlueMainColor,
              height: size.height*0.5,
              width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //Seller Image Belum Ada
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      maxRadius: size.width/6.9,
                      child: CircleAvatar(
                        backgroundColor: kGrayTextColor,
                        maxRadius: size.width/7,
                        backgroundImage: NetworkImage(seller.imageUrl),
                      ),
                    ),
                    SizedBox(
                      height: size.height/50,
                    ),
                    //Seller Name
                    Text(
                      seller.name.toString(),
                      style: kCalibri.copyWith(
                        fontSize: 18,
                        color: Colors.white
                      ),),
                      Text(
                      seller.namaPerusahaan.toString(),
                      style: kCalibri.copyWith(
                        fontSize: 18,
                        color: kOrangeButtonColor,
                      ),),
                    //Rating, jumlah transaksi, ulasan info
                  ],
                ),
    ),
      );
  }

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }

  @override
  // TODO: implement snapConfiguration
  FloatingHeaderSnapConfiguration get snapConfiguration => null;

  @override
  // TODO: implement stretchConfiguration
  OverScrollHeaderStretchConfiguration get stretchConfiguration => null;

  @override
  // TODO: implement showOnScreenConfiguration
  get showOnScreenConfiguration => null;

  @override
  // TODO: implement vsync
  TickerProvider get vsync => null;

}

