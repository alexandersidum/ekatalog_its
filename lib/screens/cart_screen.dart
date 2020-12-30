import 'package:e_catalog/auth.dart';
import 'package:e_catalog/components/custom_raised_button.dart';
import 'package:e_catalog/models/account.dart';
import 'package:e_catalog/models/cart.dart';
import 'package:e_catalog/models/sales_order.dart';
import 'package:e_catalog/screens/cart_confirmation_screen.dart';
import 'package:e_catalog/components/item_counter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:e_catalog/constants.dart';
import 'package:e_catalog/utilities/order_services.dart';
import 'package:grouped_list/grouped_list.dart';

class CartScreen extends StatelessWidget {
  CartScreen({Key key}) : super(key: key);

  //function itemupdate di pass lewat constructor bisa , kalau di function tidak?

  

  Widget cartTile(context, element) {
    Function itemUpdate = Provider.of<Cart>(context).updateCount;
    Function itemDelete = Provider.of<Cart>(context).deleteItemCart;
    Size size = MediaQuery.of(context).size;

    return Container(
      height: size.height * 0.15,
      color: Colors.white,
      margin: EdgeInsets.all(5),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          height: size.height * 0.145,
          width: size.width * 0.3,
          margin: EdgeInsets.only(right: 10),
          child: Image(
            fit: BoxFit.cover,
            image: NetworkImage(element.item.image[0].toString()),
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
                  height: size.height * 0.045,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            itemDelete(element);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                            ),
                            height: size.height * 0.05,
                            width: size.height * 0.05,
                            child: Center(
                              child: FittedBox(
                                  child:
                                      Icon(Icons.delete_forever, color: Colors.red,
                                      size: size.height * 0.05,)),
                            ),
                          ),
                        ),
                        ItemCounterButton(
                          fieldText: element.count.toString(),
                          itemAdd: (){
                            itemUpdate(element, element.count + 1);
                          },
                          itemReduce: (){
                            itemUpdate(element, element.count - 1);
                          },
                          onTextSubmit: (value){
                            print(value);
                            itemUpdate(element, int.parse(value));
                          },
                        )
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
    Cart cart = Provider.of<Cart>(context);
    List<LineItem> itemList = cart.cartList;
    var account = Provider.of<Auth>(context).getUserInfo;
    var size = MediaQuery.of(context).size;

    if (account.role == 1) {
      PejabatPengadaan pp = account as PejabatPengadaan;
      return Container(
        color: kBackgroundMainColor,
        child: Column(
          children: [
            Expanded(
              child: Container(
                  child: itemList.length > 0
                      ? GroupedListView<LineItem, String>(
                          elements: itemList,
                          groupBy: (lineItem) => lineItem.item.seller,
                          groupHeaderBuilder: (lineItem) {
                            return Padding(
                              padding: EdgeInsets.all(2),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.store
                                  ),
                                  Text(
                                    lineItem.item.seller,
                                    style: kCalibriBold,
                                  ),
                                ],
                              ),
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
            itemList.length > 0? 
            Container(
              padding: EdgeInsets.all(size.height / 100),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                      top: Radius.circular(size.height / 60)),
                  color: Colors.white),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: size.width / 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "TOTAL",
                            style: kMavenBold,
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            width: size.width / 3,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                "Rp ${cart.countTotalPrice().toString()}",
                                style: kMavenBold.copyWith(
                                    fontSize: size.height / 33,
                                    color: Colors.orange),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          "Unit Pengajuan".toUpperCase(),
                          style: kMavenBold,
                        ),
                        //PPK
                        Text(
                          pp.getUnit,
                          style: kMavenBold.copyWith(color: kBlueDarkColor),
                        ),
                        Container(
                          padding: EdgeInsets.all(size.height / 60),
                          height: size.height / 12,
                          child: CustomRaisedButton(
                            buttonChild: Text(
                              "SUBMIT",
                              style: kMavenBold,
                              textAlign: TextAlign.center,
                            ),
                            color: kOrangeButtonColor,
                            callback: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context)=>CartConfirmation(),
                                fullscreenDialog: true,
                              ));
                              // await _orderServices.batchCreateSalesOrder(
                              //     itemList: itemList,
                              //     ppName: pp.name,
                              //     ppUid: pp.uid,
                              //     unit: pp.unit,
                              //     onComplete: (isSuccess) {
                              //       isSuccess
                              //           ? Provider.of<Cart>(context,
                              //                   listen: false)
                              //               .clearCart()
                              //           : null;
                              //       //TODO Kalau gagalcreateSalesOrder
                              //     });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ):SizedBox(),
          ],
        ),
      );
    } else {
      return Container(
        padding: EdgeInsets.all(size.width / 20),
        child: Center(
            child: Text(
                'Hanya Akun yang terdaftar Sebagai Pejabat Pengadaan yang diizinkan melakukan Pembelian',
                textAlign: TextAlign.center,
                style: kCalibri)),
      );
    }
  }
}
