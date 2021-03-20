import 'package:e_catalog/constants.dart';
import 'package:e_catalog/models/item.dart';
import 'package:e_catalog/screens/item_detail.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ItemTile extends StatelessWidget {
  final Item item;
  final Size size;

  ItemTile({this.item, this.size});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, ItemDetail.routeId, arguments: item);
      },
      child: Container(
        padding: EdgeInsets.all(2),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 1,
          clipBehavior: Clip.none,
          child: Column(
            children: [
              Container(
                  constraints: BoxConstraints(maxHeight: size.height * 0.3),
                  padding: EdgeInsets.all(1),
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(10)),
                    // child: FadeInImage(
                    //   placeholder:
                    //       AssetImage('assets/item_placeholder_300x300.png'),
                    //   image: NetworkImage(
                    //     item.image[0].toString(),
                    //   ),
                    //   fit: BoxFit.cover,
                    // ),
                    child: CachedNetworkImage(
                      imageUrl: item.image[0].toString(),
                      errorWidget: (context, url, _)=>Image(image : AssetImage('assets/item_placeholder_300x300.png')),
                      placeholder: (context, url)=>CircularProgressIndicator(),
                      fit: BoxFit.cover,
                    ),
                  )),
              Container(
                padding: EdgeInsets.symmetric(horizontal:size.width/50, vertical:size.height/200),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      textAlign: TextAlign.start,
                      style: kCalibriBold.copyWith(
                        color: kBlueMainColor,
                        fontSize: size.height/45
                      ),
                    ),
                    Text(
                      item.seller,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: Colors.black),
                    ),
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    Text(
                      NumberFormat.currency(name: "Rp ", decimalDigits: 0)
                          .format(item.price).replaceAll(",", "."),
                      // 'Rp. ${item.price.toString()}',
                      textAlign: TextAlign.start,
                      style: kCalibriBold.copyWith(
                        fontSize: size.height/38
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
