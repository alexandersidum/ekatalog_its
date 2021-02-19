import 'package:e_catalog/auth.dart';
import 'package:e_catalog/components/custom_raised_button.dart';
import 'package:e_catalog/components/custom_text_field.dart';
import 'package:e_catalog/models/account.dart';
import 'package:e_catalog/utilities/account_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';

class RekeningPenyediaScreen extends StatefulWidget {
  Seller seller;
  RekeningPenyediaScreen({this.seller});
  State<RekeningPenyediaScreen> createState() => RekeningPenyediaState();
}

class RekeningPenyediaState extends State<RekeningPenyediaScreen> {
  AccountService service = AccountService();
  List<String> bankList = Seller.bankNames;
  String validationText = '';
  Seller seller;
  bool isEditing = false;
  TextEditingController _namaPemilikController = TextEditingController();
  TextEditingController _nomorRekeningController = TextEditingController();
  String selectedBank;
  bool isLoading = false;
  bool isRekeningExist;


  @override
  Widget build(BuildContext context) {
    seller = Provider.of<Account>(context);
    isRekeningExist = seller.nomorRekening != null;
    print(seller.nomorRekening);

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kBackgroundMainColor,
      appBar: AppBar(
        title: Text("Atur Rekening", style: kCalibriBold),
        centerTitle: false,
        backgroundColor: kBlueMainColor,
        elevation: 0,
      ),
      body: isRekeningExist && !isEditing
          ? existingRekening(size, seller)
          : formSetRekening(size, seller),
    );
  }

  Widget existingRekening(Size size, Seller seller) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: size.width / 100, vertical: size.height / 100),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      padding: EdgeInsets.all(size.width / 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Text(
              "Rekening Terdaftar",
              style: kCalibriBold.copyWith(
                  fontSize: size.height / 30, color: kBlueMainColor),
            ),
          ),
          SizedBox(
            height: size.height / 30,
          ),
          Container(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                        child: Text("Nama Bank :",
                            style: kCalibriBold.copyWith(
                                fontSize: size.height / 40))),
                    Expanded(
                        child: Text(seller.namaBank,
                            style:
                                kCalibri.copyWith(fontSize: size.height / 40))),
                  ],
                ),
                SizedBox(
                  height: size.height / 100,
                ),
                Row(
                  children: [
                    Expanded(
                        child: Text("Nama Pemilik :",
                            style: kCalibriBold.copyWith(
                                fontSize: size.height / 40))),
                    Expanded(
                        child: Text(seller.atasNamaRekening,
                            style:
                                kCalibri.copyWith(fontSize: size.height / 40))),
                  ],
                ),
                SizedBox(
                  height: size.height / 100,
                ),
                Row(
                  children: [
                    Expanded(
                        child: Text("Nomor Rekening :",
                            style: kCalibriBold.copyWith(
                                fontSize: size.height / 40))),
                    Expanded(
                        child: Text(seller.nomorRekening,
                            style:
                                kCalibri.copyWith(fontSize: size.height / 40))),
                  ],
                ),
                SizedBox(
                  height: size.height / 30,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    width: size.width / 2,
                    height: size.height / 20,
                    child: CustomRaisedButton(
                      buttonChild: Text("Ubah Rekening",
                          style: kCalibriBold.copyWith(color: Colors.white)),
                      color: kBlueMainColor,
                      callback: () {
                        setState(() {
                          isEditing = true;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget labelText({String leadText, String trailText}) {
    return Builder(
      builder: (BuildContext context) {
        Size size = MediaQuery.of(context).size;
        return Padding(
          padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.03, vertical: size.height * 0.015),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(leadText,
                  style: kCalibriBold.copyWith(
                    color: kGrayTextColor,
                    fontSize: size.height * 0.025,
                  )),
              Text(trailText != null ? trailText : "",
                  style: kCalibriBold.copyWith(
                    color: kLightGrayTextColor,
                    fontSize: size.height * 0.02,
                  )),
            ],
          ),
        );
      },
    );
  }

  Widget formSetRekening(Size size, Seller seller) {
    return Container(
      child: ListView(
        children: [
          labelText(leadText: "Nama Pemilik Rekening", trailText: "Max 100"),
          Container(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
            child: CustomTextField(
              controller: _namaPemilikController,
              maxLength: 100,
              hintText: 'Atas nama Rekening',
              keyboardType: TextInputType.text,
              color: Colors.white,
            ),
          ),
          labelText(leadText: "Nama Bank"),
          Container(
            height: size.height / 15,
            width: size.width / 3,
            margin: EdgeInsets.only(
                left: size.width * 0.03, right: size.width * 0.5),
            alignment: Alignment.centerLeft,
            padding:
                EdgeInsets.only(left: size.width / 20, right: size.width / 50),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                  isExpanded: true,
                  hint: Text("Pilih bank"),
                  dropdownColor: Colors.white,
                  value: selectedBank,
                  items: bankList
                      .map((kategori) => DropdownMenuItem<String>(
                            child: FittedBox(
                                child: Text(
                              kategori,
                              style: kCalibri,
                            )),
                            value: kategori,
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedBank = value;
                    });
                  }),
            ),
          ),
          labelText(leadText: "Nomor Rekening", trailText: "Max 100"),
          Container(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
            child: CustomTextField(
              controller: _nomorRekeningController,
              maxLength: 100,
              hintText: 'Isikan Nomor Rekening',
              keyboardType: TextInputType.number,
              color: Colors.white,
            ),
          ),
          Container(
            padding: EdgeInsets.only(
                left: size.width * 0.03,
                right: size.width * 0.05,
                bottom: size.height * 0.015,
                top: size.height * 0.05),
            child: Column(
              children: [
                Text(
                  '* Rekening akan digunakan untuk pembayaran setiap transaksi, harap diisi seakurat mungkin',
                  style: kMaven.copyWith(color: kGrayTextColor),
                ),
                SizedBox(
                  height: size.height / 40,
                ),
              ],
            ),
          ),
          Text(
            validationText,
            style: kMavenBold.copyWith(color: kGrayTextColor),
          ),
          SizedBox(
            height: size.height / 30,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: size.width / 10),
            child: CustomRaisedButton(
              buttonHeight: size.height / 20,
              buttonChild: Text(
                "Tambah Rekening".toUpperCase(),
                style: kMavenBold,
                textAlign: TextAlign.center,
              ),
              callback: () async {
                setState(() {
                  isLoading = true;
                });
                await service
                    .setRekeningPembayaran(
                        seller.uid,
                        selectedBank,
                        _namaPemilikController.text.trim(),
                        _nomorRekeningController.text.trim())
                    .then((value) {
                  value ? validationText = "SUKSES" : validationText = "GAGAL";
                }).whenComplete(() => setState(() {
                          isLoading = false;
                          isEditing = false;
                        }));
              },
              color: kOrangeButtonColor,
            ),
          ),
          SizedBox(
            height: size.height / 20,
          ),
        ],
      ),
    );
  }
}
