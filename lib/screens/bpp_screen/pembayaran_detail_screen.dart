import 'dart:io';

import 'package:e_catalog/components/custom_raised_button.dart';
import 'package:e_catalog/components/custom_text_field.dart';
import 'package:e_catalog/constants.dart';
import 'package:e_catalog/models/account.dart';
import 'package:e_catalog/models/sales_order.dart';
import 'package:e_catalog/utilities/account_services.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class PembayaranDetailScreen extends StatefulWidget {

  SalesOrder order;
  PembayaranDetailScreen({this.order});

  @override
  _PembayaranDetailScreenState createState() => _PembayaranDetailScreenState();
}

class _PembayaranDetailScreenState extends State<PembayaranDetailScreen> {
  Seller sellerBilling;
  bool isLoading = true;
  TextEditingController _descriptionController = TextEditingController();
  AccountService accountService = AccountService();
  ImagePicker imagePicker = ImagePicker();
  File pickedImage;

  @override
  void initState() {
    getSellerInfo();
    super.initState();
  }


  void getSellerInfo() async{
    sellerBilling = await accountService.getSellerInfo(widget.order.sellerUid);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ModalProgressHUD(
      inAsyncCall: isLoading,
          child: Scaffold(
        appBar: AppBar(
          title: Text("Detail Pembayran", style: kCalibriBold),
          centerTitle: false,
          backgroundColor: kBlueMainColor,
          elevation: 0,
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal:size.width/12),
          child: SingleChildScrollView(
                      child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical:size.height/50),
                  child:Text("Total Tagihan", style: kCalibriBold,)
                ),
                Container(
                  width: size.width,
                  height: size.height/10,
                  decoration: BoxDecoration(
                    border : Border.all()
                  ),
                  child: Center(child: FittedBox(
                                  child: Text(NumberFormat.currency(
                                                  name: "Rp ", decimalDigits: 0)
                                              .format(widget.order.totalPrice), style: kCalibriBold.copyWith(
                                                fontSize: size.height/30
                                              )),
                  )),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical:size.height/30),
                  child:Text("Pembayaran dapat dilakukan melalui rekening berikut :", style: kCalibriBold,)
                ),
              rowText(size: size, leftText: "Bank Tujuan :", rightText: sellerBilling.namaBank.toUpperCase()),
              rowText(size: size, leftText: "No. Rekening :", rightText: sellerBilling.nomorRekening),
              rowText(size: size, leftText: "Atas Nama:", rightText: sellerBilling.atasNamaRekening),
              SizedBox(height:size.height/30),
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Upload Bukti Pembayaran", style: kCalibriBold)),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RaisedButton(
                    color: kBlueMainColor,
                    child: Text("Browse", style: kCalibriBold.copyWith(color:Colors.white),),
                    onPressed: (){
                      pickImage();
                    },
                  ),
                  SizedBox(width: size.width/20),
                  pickedImage != null? Container(
                      alignment: Alignment.centerLeft,
                      child: Image.file(
                        pickedImage,
                        fit: BoxFit.cover,
                        height: size.height / 5,
                        width: size.height / 5,
                      ),
                    ):SizedBox()
                ],
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Keterangan Tambahan", style: kCalibriBold)),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
                  child: CustomTextField(
                    textInputAction: TextInputAction.newline,
                    maxLength: 1000,
                    controller: _descriptionController,
                    hintText: 'Keterangan Tambahan...',
                    keyboardType: TextInputType.multiline,
                    color: Colors.white,
                    maxLine: 3,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: size.height * 0.03),
                child: CustomRaisedButton(
                  buttonHeight: size.height / 20,
                  buttonChild: Text(
                    "Konfirmasi Pembayaran".toUpperCase(),
                    style: kMavenBold.copyWith(color:Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  callback: () {
                    //TODO fungsi pembayaran
                    
                  },
                  color: kBlueMainColor,
                ),
              ),
              ],
              

            ),
          ),
        ),
        
      ),
    );
  }

  void pickImage() async {
    await imagePicker.getImage(source: ImageSource.gallery).then((pickedFile) {
      if (pickedFile != null) {
        pickedImage = File(pickedFile.path);
      } else {
        pickedImage = null;
      }
    });
    setState(() {});
  }

  Container rowText({Size size, String leftText, String rightText}) {
    return Container(
          padding: EdgeInsets.symmetric(vertical:size.height/80),
          child: Row(
            textBaseline: TextBaseline.alphabetic,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            children: [
              Expanded(flex: 1, child: Text(leftText, style: kCalibri)),
              Expanded(flex: 2, child: Text(rightText, style: kCalibriBold)),
            ],
          ),
        );
  }
}