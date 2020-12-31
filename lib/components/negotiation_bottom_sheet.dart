import 'package:e_catalog/components/custom_text_field.dart';
import 'package:e_catalog/utilities/item_services.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import 'custom_raised_button.dart';

class NegosiasiBottomSheet extends StatefulWidget {
  String id, sellerPrice, docId;

  NegosiasiBottomSheet({this.id, this.sellerPrice, this.docId});

  @override
  _NegosiasiBottomSheetState createState() => _NegosiasiBottomSheetState();
}

class _NegosiasiBottomSheetState extends State<NegosiasiBottomSheet> {
  ItemService itemService = ItemService();
  int ukpbjPrice;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height / 2,
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
            color: kBackgroundMainColor,
            borderRadius:
                BorderRadius.vertical(top: Radius.circular(size.height / 30))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(size.width / 100),
              child: Text(
                "Negosiasi ${widget.id}",
                textAlign: TextAlign.center,
                style: kMavenBold,
              ),
            ),
            Container(
              padding: EdgeInsets.all(size.width / 100),
              child: Text(
                "Harga awal ${widget.sellerPrice}",
                textAlign: TextAlign.center,
                style: kMavenBold.copyWith(color: Colors.orange),
              ),
            ),
            SizedBox(
              height: size.height / 20,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.03, vertical: size.height * 0.015),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Penawaran",
                      style: kCalibriBold.copyWith(
                        color: kGrayTextColor,
                        fontSize: size.height * 0.025,
                      )),
                ],
              ),
            ),
            Container(
                padding: EdgeInsets.symmetric(horizontal: size.width / 20),
                height: size.height / 6,
                child: CustomTextField(
                  keyboardType: TextInputType.number,
                  callback: (value) {
                    ukpbjPrice = int.parse(value);
                    print(ukpbjPrice);
                  },
                  hintText: "Harga Penawaran",
                  maxLength: 100,
                )),
            SizedBox(
              height: size.height / 100,
            ),
            Container(
              height: size.height / 20,
              width: size.width / 3,
              child: CustomRaisedButton(
                color: kRedButtonColor,
                callback: () async {
                  print(ukpbjPrice);
                  if (ukpbjPrice != null) {
                    print(await itemService.negotiateItem(
                        widget.docId, ukpbjPrice));
                    Navigator.of(context).pop();
                  } else {
                    //Jika tidak valid ukpbjprice
                  }
                },
                buttonChild: Text("Submit",
                    style: kCalibriBold.copyWith(color: Colors.white)),
              ),
            )
          ],
        ),
      ),
    );
  }
}