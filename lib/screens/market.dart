import 'package:e_catalog/components/custom_raised_button.dart';
import 'package:e_catalog/components/custom_text_field.dart';
import 'package:e_catalog/models/item.dart';
import 'package:e_catalog/utilities/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_catalog/auth.dart';

class Market extends StatefulWidget {

  const Market({Key key}) : super(key : key);
  
  @override
  State<StatefulWidget> createState()=>MarketState();

}

class MarketState extends State<Market> {

//Percobaan tanpa image dan isReady
  String name;
  String seller;
  int price;
  String notifText = '';
  String pathText = '';

  @override
  Widget build(BuildContext context) {
    seller = Provider.of<Auth>(context).getUser.email;

    return Container(
      child : Center (
        child: Column(
          children: [
            Text(
              notifText
            ),
            Text(
              pathText
            ),
            CustomTextField(
              hintText: 'name',
              callback: (String value){
                name = value;
              },
            ),
            CustomTextField(
              keyboardType: TextInputType.number,
              hintText: 'price',
              callback: (String value){
                price = int.parse(value);
              },
            ),
            CustomRaisedButton(
              color: Colors.green,
              text: 'Add Item',
              callback: ()async{
                await Provider.of<Database>(context, listen: false).addItem(
                Item(
                  name : name,
                  price : price,
                  seller : seller,
                  //placeholder
                  image: 'https://picsum.photos/300/300',
                )
                , (String status, String coba){
                  setState(() {
                    notifText = status;
                    pathText = coba;
                  });
                });
              }
            )
          ],
        ),)
    );
  }
}