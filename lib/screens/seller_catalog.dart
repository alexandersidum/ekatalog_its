import 'package:e_catalog/components/item_tile.dart';
import 'package:e_catalog/constants.dart';
import 'package:e_catalog/models/item.dart';
import 'package:e_catalog/utilities/item_services.dart';
import 'package:flutter/material.dart';
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
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      Provider<ItemService>(
        create: (context) => ItemService(
          uid: Provider.of<Auth>(context, listen: false).getUser.uid,
        ),
      ),
      StreamProvider<List<Item>>(
          create: (context) => ItemService(
                uid: Provider.of<Auth>(context, listen: false).getUser.uid,
              ).getItemsWithStatus([1]))
    ], child: Etalase());
  }
}


class Etalase extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<Item> allItem = Provider.of<List<Item>>(context);
    var seller = ModalRoute.of(context).settings.arguments;
    List<Item> listEtalase() {
      return allItem != null
          ? allItem
              .where((element) =>
                  element.seller.toLowerCase() ==
                  seller.toString().toLowerCase())
              .toList()
          : [];
    }

    return Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              pinned: false,
              floating: true,
              delegate: SellerHeaderDelegate(
                seller : seller,
                maxExtent: 250,
                minExtent: 150,
              ),
            ),
            SliverStaggeredGrid.countBuilder(
              itemCount: listEtalase() != null ? listEtalase().length : 0,
              crossAxisCount: 2,
              staggeredTileBuilder: (index) => StaggeredTile.fit(1),
              itemBuilder: (context, index) {
                return ItemTile(
                  item: listEtalase()[index],
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

  final maxExtent;
  final minExtent;
  final seller;

  SellerHeaderDelegate({this.minExtent,this.seller, @required this.maxExtent});
  
  @override
  Widget build(BuildContext context, double shrinkOffset,bool overlapsContent) {
    var size = MediaQuery.of(context).size;
    return  Container(
          color: kBlueDarkColor,
          height: size.height*0.5,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //Seller Image Belum Ada
              Image(
                height: size.height*0.2,
                image: NetworkImage('https://picsum.photos/300/300'),
              ),
              //Seller Name
              Text(
                seller.toString(),
                style: kLabelStyle.copyWith(
                  fontSize: 18
                ),),
              //Rating, jumlah transaksi, ulasan info
            ],
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

class SellerUI extends StatelessWidget {
  const SellerUI({
    @required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: kBlueDarkColor,
          height: size.height*0.5,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //Seller Image
              Image(
                height: size.height*0.2,
                image: NetworkImage('https://picsum.photos/300/300'),
              ),
              //Seller Name
              Text(
                'Name',
                style: kLabelStyle.copyWith(
                  fontSize: 18
                ),),
              //Rating, jumlah transaksi, ulasan info
            ],
          ),
        ),
        // Expanded(
        //   child: StaggeredGridView.countBuilder(
        //       itemCount: listEtalase() != null ? listEtalase().length : 0,
        //       crossAxisCount: 2,
        //       staggeredTileBuilder: (index) => StaggeredTile.fit(1),
        //       itemBuilder: (context, index) {
        //         return ItemTile(
        //           item: listEtalase()[index],
        //           size: MediaQuery.of(context).size,
        //         );
        //       }),
        // ),
      ],
    );
  }
}
