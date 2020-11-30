import 'package:e_catalog/models/item.dart';
import 'package:e_catalog/screens/item_detail.dart';
import 'package:flutter/material.dart';


class ItemTile extends StatelessWidget {
  final Item item;
  final Size size;

  ItemTile({this.item, this.size});

  @override
  Widget build(BuildContext context) {
     return GestureDetector(
      onTap: (){
        Navigator.pushNamed(context, ItemDetail.routeId, arguments: item);
      },
      child: Container(
        child: Card(
          elevation: 0.4,
          child: Column(
            children: [
              Container(
                constraints: BoxConstraints(
                  maxHeight: size.height*0.3
                ),
                padding: EdgeInsets.all(1),
                width: double.infinity,
                child: FadeInImage(
                  placeholder: AssetImage('assets/item_placeholder_300x300.png'), 
                  image: NetworkImage(
                    item.image,),
                  fit: BoxFit.cover,
                  )
              ),
              Container(
                padding: EdgeInsets.all(5),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.black
                      ),
                    ),
                    Text(
                      item.seller,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        color: Colors.black
                      ),
                    ),
                    SizedBox(
                      height: size.height*0.01,
                    ),
                    Text(
                      'Rp. ${item.price.toString()}',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Colors.black
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