import 'package:e_catalog/auth.dart';
import 'package:e_catalog/models/account.dart';
import 'package:e_catalog/models/cart.dart';
import 'package:e_catalog/models/sales_order.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:e_catalog/constants.dart';
import 'package:e_catalog/utilities/order_services.dart';
import 'package:grouped_list/grouped_list.dart';

class CartScreen extends StatelessWidget {
  CartScreen({Key key}) : super(key: key);

  //function itemupdate di pass lewat constructor bisa , kalau di function tidak?
  //TODO Perbagus UInya Cart Screen

  OrderServices _orderServices = OrderServices();

  Widget cartTile(context, element) {
    Function itemUpdate = Provider.of<Cart>(context).updateCount;
    Function itemDelete = Provider.of<Cart>(context).deleteItemCart;
    Size size = MediaQuery.of(context).size;

    return Container(
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
                  child:
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
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
                          contentPadding: EdgeInsets.only(bottom: 6, left: 3),
                          border: InputBorder.none,
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
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
    );
  }

  @override
  Widget build(BuildContext context) {
    List<LineItem> itemList = Provider.of<Cart>(context).cartList;
    var account = Provider.of<Auth>(context).getUserInfo;
    var size = MediaQuery.of(context).size;

    if (account.role == 1) {
      PejabatPengadaan pp = account as PejabatPengadaan;
      return Column(
        children: [
          Expanded(
            child: Container(
                child: itemList.length > 0
                    ? GroupedListView<LineItem, String>(
                        elements: itemList,
                        groupBy: (lineItem) => lineItem.item.seller,
                        groupHeaderBuilder: (lineItem) {
                          return Text(
                            lineItem.item.seller,
                            style: kCalibriBold,
                          );
                        },
                        itemBuilder: (context, lineItem) {
                          return cartTile(context, lineItem);
                        },
                      )
                    : Container(
                        height: size.height * 0.8,
                        child: Center(
                            child:
                                Text('No item on Cart', style: kCalibriBold)),
                      )),
          ),
          RaisedButton.icon(
              //Function to progress checkout
              //TODO Perbagus
              onPressed: () async {
                await _orderServices.batchCreateSalesOrder(
                    itemList: itemList,
                    ppName: pp.name,
                    ppUid: pp.uid,
                    unit: pp.unit,
                    onComplete: (isSuccess) {
                      isSuccess
                          ? Provider.of<Cart>(context, listen: false)
                              .clearCart()
                          : null;
                      //TODO Kalau gagalcreateSalesOrder
                    });
              },
              icon: Icon(Icons.shopping_cart),
              label: Text('Checkout'))
        ],
      );
    } else {
      return Container(
        padding: EdgeInsets.all(size.width/20),
        child: Center(
            child: Text(
                'Hanya Akun yang terdaftar Sebagai Pejabat Pengadaan yang diizinkan melakukan Pembelian',
                textAlign: TextAlign.center,
                style: kCalibri)),
      );
    }
  }
}
