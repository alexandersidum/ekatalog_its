import 'package:e_catalog/components/custom_text_field.dart';
import 'package:e_catalog/models/item.dart';
import 'package:e_catalog/utilities/item_services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../constants.dart';
import 'custom_raised_button.dart';

class NegosiasiBottomSheet extends StatefulWidget {
  String id, sellerPrice, docId;
  bool isChangePrice = false;
  Item item;

  NegosiasiBottomSheet(
      {this.id, this.sellerPrice, this.docId, this.isChangePrice, this.item});

  @override
  _NegosiasiBottomSheetState createState() => _NegosiasiBottomSheetState();
}

class _NegosiasiBottomSheetState extends State<NegosiasiBottomSheet> {
  ItemService itemService = ItemService();
  int newPrice;
  Item item;
  bool isChangePrice = false;
  String lastPrice;

  @override
  void initState() {
    isChangePrice = widget.isChangePrice??isChangePrice;
    item = widget.item;
    if (item != null) {
      lastPrice = NumberFormat.currency(name: "Rp ", decimalDigits: 0)
          .format(item.price);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height / 2,
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
            color: kBackgroundMainColor,
            borderRadius: BorderRadius.vertical(
                top: Radius.circular(size.height / 30))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(size.width / 100),
              child: Text(
                isChangePrice ? "${item.name}" : "Negosiasi ${widget.id}",
                textAlign: TextAlign.center,
                style: kCalibriBold,
              ),
            ),
            Container(
              padding: EdgeInsets.all(size.width / 100),
              child: Text(
                isChangePrice
                    ? "Harga sebelumnya $lastPrice"
                    : "Harga awal ${widget.sellerPrice}",
                textAlign: TextAlign.center,
                style: kCalibriBold.copyWith(color: Colors.orange),
              ),
            ),
            SizedBox(
              height: size.height / 20,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.03,
                  vertical: size.height * 0.015),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(isChangePrice ? "Harga Baru" : "Penawaran",
                      style: kCalibriBold.copyWith(
                        color: kGrayTextColor,
                        fontSize: size.height * 0.025,
                      )),
                ],
              ),
            ),
            Container(
                padding: EdgeInsets.symmetric(horizontal: size.width / 20),
                height: size.height / 9,
                child: CustomTextField(
                  keyboardType: TextInputType.number,
                  callback: (value) {
                    newPrice = int.parse(value);
                    print(newPrice);
                  },
                  hintText: isChangePrice
                      ? "Masukkan harga baru"
                      : "Harga Penawaran",
                  maxLength: 100,
                )),
            isChangePrice?Container(
              padding: EdgeInsets.symmetric(horizontal: size.width/20),
              child: Text("Penggantian harga perlu persetujuan, jika haga telah disetujui maka harga akan diubah",
                        style: kCalibriBold.copyWith(
                          color: kRedButtonColor,
                          fontSize: size.height * 0.022,
                        )),
            ):SizedBox(),
            SizedBox(
              height: size.height / 20,
            ),
            Container(
              height: size.height / 15,
              width: size.width/1.5 ,
              child: CustomRaisedButton(
                color: kBlueMainColor,
                callback: () async {
                  if (newPrice != null) {
                    if (isChangePrice) {
                      await itemService.proposeItemPriceChange(
                          itemId: item.id,
                          newSellerPrice: newPrice,
                          callback: (bool isSuccess) {
                            //Snackbar jika sukses dan gagal
                            Navigator.of(context).pop();
                          });
                    }else{
                      await itemService.negotiateItem(widget.docId, newPrice);
                      Navigator.of(context).pop();
                    }
                    
                  } else {
                    //Jika kosong valuenya
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
