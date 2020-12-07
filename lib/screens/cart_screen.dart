import 'package:e_catalog/models/cart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:e_catalog/constants.dart';

class CartScreen extends StatelessWidget {
  CartScreen({Key key}) : super(key: key);

  //function itemupdate di pass lewat constructor bisa , kalau di function tidak?

  List<Widget> itemListBuilder(List<CartItem> item, BuildContext context,
    Function itemUpdate, Function itemDelete) {
    var output = <Widget>[];
    Size size = MediaQuery.of(context).size;

    item.forEach((element) {
      //size belum sesuai layar
      output.add(Container(
        height: size.height * 0.15,
        margin: EdgeInsets.all(5),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            height: size.height * 0.145,
            width: size.width * 0.3,
            margin: EdgeInsets.only(right: 10),
            child: Image(
              fit: BoxFit.cover,
              image: NetworkImage(element.item.image),
            ),
          ),
          Expanded(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    element.item.name,
                    style: kItemNameTextStyle.copyWith(
                        fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    'Rp ${element.item.price * element.count}',
                    style: kPriceTextStyle.copyWith(
                        fontSize: 16, color: Colors.orange),
                  ),
                  Text(
                    '${element.item.seller}',
                    style: kItemNameTextStyle.copyWith(
                      fontSize: 13,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: size.height * 0.001),
                    height: size.height * 0.03,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            height: size.height * 0.07,
                            child: IconButton(
                              onPressed: () {
                                itemDelete(element);
                              },
                              icon: Icon(Icons.delete),
                            ),
                          ),
                          Container(
                            height: size.height * 0.07,
                            child: IconButton(
                              onPressed: () {
                                itemUpdate(element, element.count + 1);
                              },
                              icon: Icon(Icons.add_circle),
                            ),
                          ),
                          Container(
                            width: size.width * 0.07,
                            height: size.height * 0.07,
                            child: TextField(
                              style: TextStyle(fontWeight: FontWeight.w700),
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.only(bottom: 6, left: 3),
                                border: InputBorder.none,
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                WhitelistingTextInputFormatter.digitsOnly
                              ],
                              onChanged: (value) {
                                itemUpdate(element, int.parse(value));
                              },
                              controller: TextEditingController(
                                  text: element.count.toString()),
                            ),
                          ),
                          Container(
                            height: size.height * 0.07,
                            child: IconButton(
                                onPressed: () {
                                  itemUpdate(element, element.count - 1);
                                },
                                icon: Icon(
                                  Icons.remove_circle,
                                )),
                          ),
                        ]),
                  )
                ],
              ),
            ),
          ),
        ]),
      ));
    });
    output.add(
        //Checkout Button
        RaisedButton.icon(
            //Function to progress checkout
            onPressed: () {

            },
            icon: Icon(Icons.shopping_cart),
            label: Text('Checkout')
            ));

    return output;
  }

  @override
  Widget build(BuildContext context) {
    List<CartItem> itemList = Provider.of<Cart>(context).cartList;
    Function itemUpdate = Provider.of<Cart>(context).updateCount;
    Function itemDelete = Provider.of<Cart>(context).deleteItemCart;

    return Container(
      child: ListView(
        children: itemList.length > 0
            ? itemListBuilder(itemList, context, itemUpdate, itemDelete)
            : [
                Container(
                  height: MediaQuery.of(context).size.height*0.8,
                  child: Center(
                      child: Text('No item on Cart',
                          style: TextStyle(color: Colors.black))),
                )
              ],
      ),
    );
  }
}
