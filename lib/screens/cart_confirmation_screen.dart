import 'package:e_catalog/auth.dart';
import 'package:e_catalog/components/custom_raised_button.dart';
import 'package:e_catalog/components/custom_text_field.dart';
import 'package:e_catalog/components/modal_bottom_sheet_app.dart';
import 'package:e_catalog/models/account.dart';
import 'package:e_catalog/models/cart.dart';
import 'package:e_catalog/models/shipping_address.dart';
import 'package:e_catalog/utilities/order_services.dart';
import 'package:flutter/material.dart';
import 'package:e_catalog/constants.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class CartConfirmation extends StatefulWidget {
  @override
  _CartConfirmationState createState() => _CartConfirmationState();
}

class _CartConfirmationState extends State<CartConfirmation> {
  OrderServices _orderServices = OrderServices();
  ShippingAddress finalShippingAddress;

  void createSalesOrder() {}

  @override
  Widget build(BuildContext context) {
    Cart cart = Provider.of<Cart>(context);
    PejabatPengadaan account = Provider.of<Auth>(context).getUserInfo;
    List<LineItem> listItem = cart.cartList;
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("Konfirmasi", style: kCalibriBold),
        centerTitle: false,
        backgroundColor: kBlueMainColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(
                top: size.height / 40,
                left: size.width / 30,
              ),
              alignment: Alignment.centerLeft,
              child: Text(
                'Rincian Pembelian'.toUpperCase(),
                style: kCalibriBold,
              ),
            ),
            Container(
              margin: EdgeInsets.all(size.width / 50),
              padding: EdgeInsets.all(size.height / 100),
              decoration: BoxDecoration(color: Colors.white),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Produk",
                      style: kCalibriBold.copyWith(color: kBlueDarkColor),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: size.width / 20),
                        child: Column(
                          children: listItem.map((LineItem e) {
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              children: [
                                Expanded(
                                    child: Text(e.item.name + " ${e.count} x",
                                        style: kCalibriBold)),
                                Expanded(
                                    child: Text(
                                        NumberFormat.currency(
                                                name: "Rp ", decimalDigits: 0)
                                            .format((e.item.price * e.count) *
                                                (1 +
                                                    e.item.taxPercentage /
                                                        100)),
                                        style: kCalibriBold)),
                              ],
                            );
                          }).toList(),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: size.height / 25),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Total Biaya",
                      style: kCalibriBold.copyWith(color: kBlueDarkColor),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: size.width / 20),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      NumberFormat.currency(name: "Rp ", decimalDigits: 0)
                          .format(cart.countTotalPrice()),
                      style: kCalibriBold.copyWith(
                          color: Colors.orange, fontSize: size.width / 20),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                top: size.height / 40,
                left: size.width / 30,
              ),
              alignment: Alignment.centerLeft,
              child: Row(
                textBaseline: TextBaseline.alphabetic,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    child: Icon(Icons.home),
                  ),
                  Text(
                    'Alamat Pengiriman',
                    style: kCalibriBold,
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(size.width / 50),
              padding: EdgeInsets.all(size.height / 100),
              decoration: BoxDecoration(color: Colors.white),
              child: StreamBuilder(
                  stream: _orderServices.getShippingAddress(account.uid),
                  builder:
                      (context, AsyncSnapshot<List<ShippingAddress>> snapshot) {
                    if (snapshot.hasError) {
                      return Container(
                        decoration: BoxDecoration(color: kBackgroundMainColor),
                        child: Text("Error Mengambil alamat"),
                      );
                    }
                    if (snapshot == null || snapshot.data == null) {
                      return tambahkanAlamatBox(size, context, account);
                    } 
                    else if(snapshot.data.length <= 0){
                      return tambahkanAlamatBox(size, context, account);
                    }
                    else {
                      finalShippingAddress = snapshot.data[0];
                      return Container(
                        child: Column(
                          children: snapshot.data.map((shippingAddress) {
                            return Stack(children: [
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(size.width / 30),
                                decoration:
                                    BoxDecoration(color: kBackgroundMainColor),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      shippingAddress.namaAlamat,
                                      style: kCalibriBold,
                                    ),
                                    Container(
                                        padding: EdgeInsets.only(
                                            left: size.width / 20),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(shippingAddress.namaPenerima,
                                                style: kCalibri),
                                            Text(
                                                shippingAddress.teleponPenerima,
                                                style: kCalibri),
                                            Text(shippingAddress.address,
                                                style: kCalibri),
                                          ],
                                        ))
                                  ],
                                ),
                              ),
                              Positioned(
                                  right: 1,
                                  top: 1,
                                  child: TextButton(
                                      onPressed: () {
                                        showModalBottomSheetApp(
                                            context: context,
                                            builder: (context) =>
                                                ShippingBottomSheet(
                                                  shipAddress: shippingAddress,
                                                  isEdit: true,
                                                  uid: account.uid,
                                                ));
                                      },
                                      child: Text(
                                        "Edit",
                                        style: kCalibriBold,
                                      ))),
                            ]);
                          }).toList(),
                        ),
                      );
                    }
                  }),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: size.height / 10),
              height: size.height / 15,
              child: CustomRaisedButton(
                callback: () {
                  //TODO Validator Kalau ada data yang kosong atau salah
                  _orderServices.batchCreateSalesOrder(
                      itemList: listItem,
                      shippingAddress: finalShippingAddress,
                      ppName: account.name,
                      ppUid: account.uid,
                      unit: account.unit,
                      onComplete: (isSuccess) {
                        if(isSuccess){
                          cart.clearCart();
                          Navigator.of(context).pop();
                          print("Create SO $isSuccess");
                        }
                        else{
                          print("Create SO $isSuccess");
                        }
                      });
                },
                color: kOrangeButtonColor,
                buttonChild: Text(
                  "Konfirmasi Pengajuan",
                  style: kMavenBold.copyWith(color: Colors.black),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Container tambahkanAlamatBox(Size size, BuildContext context, PejabatPengadaan account) {
    return Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(size.width / 30),
                        decoration:
                            BoxDecoration(color: kBackgroundMainColor),
                        child: Center(
                            child: TextButton(
                          child: Text("Belum ada alamat Tambahkan Alamat"),
                          onPressed: () {
                            showModalBottomSheetApp(
                                context: context,
                                builder: (context) => ShippingBottomSheet(
                                      isEdit: false,
                                      uid: account.uid,
                                    ));
                          },
                        )));
  }
}

class ShippingBottomSheet extends StatefulWidget {
  ShippingAddress shipAddress;
  bool isEdit;
  String uid;
  ShippingBottomSheet({this.shipAddress, this.isEdit, this.uid});
  @override
  _ShippingBottomSheetState createState() => _ShippingBottomSheetState();
}

class _ShippingBottomSheetState extends State<ShippingBottomSheet> {
  OrderServices _orderServices = OrderServices();
  bool isLoading = true;

  Widget labelText({String leadText, String trailText}) {
    return Builder(
      builder: (BuildContext context) {
        Size size = MediaQuery.of(context).size;
        return Padding(
          padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.03, vertical: size.height * 0.01),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(leadText,
                  style: kCalibriBold.copyWith(
                    color: kGrayTextColor,
                    fontSize: size.height * 0.023,
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

  Future<bool> editExistingAddress(
      String uid, ShippingAddress newAddress) async {
    isLoading = true;
    print("SAMPAI DI EDITEXISTING ${newAddress.namaPenerima}");
    await _orderServices.setShippingAddress(uid, newAddress).then((value) {
      if (value) {
        Navigator.of(context).pop();
      }
    });
  }

  Future<bool> addAddress(String uid, ShippingAddress newAddress) async {
    isLoading = true;
    print("SAMPAI DI ADDADDRESS ${newAddress.namaPenerima}");
    await _orderServices.createShippingAddress(uid, newAddress).then((value) {
      if (value) {
        Navigator.of(context).pop();
      }
    });
  }

  var _namaAlamatController = TextEditingController();
  var _namaPenerimaController = TextEditingController();
  var _teleponPenerimaController = TextEditingController();
  var _alamatController = TextEditingController();

  @override
  void initState() {
    bool isEdit = widget.isEdit;
    ShippingAddress shipAddress = widget.shipAddress;
    _namaAlamatController.text = isEdit ? shipAddress.namaAlamat : "";
    _namaPenerimaController.text = isEdit ? shipAddress.namaPenerima : "";
    _teleponPenerimaController.text = isEdit ? shipAddress.teleponPenerima : "";
    _alamatController.text = isEdit ? shipAddress.address : "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var shipAddress = widget.shipAddress;
    var uid = widget.uid;
    var isEdit = widget.isEdit;
    var size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Container(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.only(top: size.height / 40),
            decoration: BoxDecoration(
                color: kBackgroundMainColor,
                borderRadius: BorderRadius.vertical(
                    top: Radius.circular(size.height / 30))),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              Text(
                isEdit ? "UBAH ALAMAT" : "TAMBAH ALAMAT",
                style: kCalibriBold.copyWith(fontSize: size.height / 40),
              ),
              SizedBox(height: size.height / 50),
              labelText(leadText: "Nama Alamat", trailText: "Max 50"),
              Container(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
                child: CustomTextField(
                  maxLength: 50,
                  controller: _namaAlamatController,
                  hintText: 'Rumah / Toko / Kantor',
                  keyboardType: TextInputType.text,
                  color: Colors.white,
                ),
              ),
              labelText(leadText: "Nama Penerima", trailText: "Max 50"),
              Container(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
                child: CustomTextField(
                  maxLength: 50,
                  controller: _namaPenerimaController,
                  hintText: 'Nama penerima..',
                  keyboardType: TextInputType.name,
                  color: Colors.white,
                ),
              ),
              labelText(leadText: "No.Telpon Penerima"),
              Container(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
                child: CustomTextField(
                  maxLength: 50,
                  controller: _teleponPenerimaController,
                  hintText: 'Nomor telepon penerima..',
                  keyboardType: TextInputType.number,
                  color: Colors.white,
                ),
              ),
              labelText(leadText: "Alamat", trailText: "Max 300"),
              Container(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
                child: CustomTextField(
                  maxLine: 3,
                  maxLength: 100,
                  controller: _alamatController,
                  hintText: 'Alamat dan Informasi lokasi..',
                  keyboardType: TextInputType.text,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: size.height / 50),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: size.height / 20,
                      child: CustomRaisedButton(
                        callback: () {
                          Navigator.of(context).pop();
                        },
                        color: kRedButtonColor,
                        buttonChild: Text("Batal",
                            style: kMavenBold.copyWith(color: Colors.white)),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: size.height / 20,
                      child: CustomRaisedButton(
                        color: kBlueMainColor,
                        callback: () async {
                          if (isEdit) {
                            shipAddress.namaAlamat = _namaAlamatController.text;
                            shipAddress.namaPenerima =
                                _namaPenerimaController.text;
                            shipAddress.teleponPenerima =
                                _teleponPenerimaController.text;
                            shipAddress.address = _alamatController.text;
                            await editExistingAddress(uid, shipAddress);
                          } else {
                            var shipAddress = ShippingAddress(
                              namaAlamat: _namaAlamatController.text,
                              namaPenerima: _namaPenerimaController.text,
                              teleponPenerima: _teleponPenerimaController.text,
                              address: _alamatController.text,
                            );
                            await addAddress(uid, shipAddress);
                          }
                        },
                        buttonChild: Text("Simpan",
                            style: kMavenBold.copyWith(color: Colors.white)),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.height / 50),
            ]),
          )),
    );
  }
}
