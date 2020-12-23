import 'dart:io';

import 'package:e_catalog/components/custom_raised_button.dart';
import 'package:e_catalog/components/custom_text_field.dart';
import 'package:e_catalog/models/account.dart';
import 'package:e_catalog/models/item.dart';
import 'package:e_catalog/utilities/database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:e_catalog/auth.dart';

import '../constants.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({Key key}) : super(key: key);

  static const routeId = 'AddProduct';

  @override
  State<StatefulWidget> createState() => AddProductScreenState();
}

class AddProductScreenState extends State<AddProductScreen> {
//Percobaan tanpa image dan isReady
  String name;
  int sellerPrice;
  int stock;
  int taxPercentage;
  String selectedCategory;
  String description;
  int status = 0;
  int sold = 0;
  String notifText = '';
  String pathText = '';
  Database db = Database();
  bool isLoading = false;
  ImagePicker imagePicker = ImagePicker();
  List<File> pickedImage = List(3);
  //TODO Dummy Kategori
  List<String> listKategori = [
    "Alat Kantor",
    "AC",
    "Monitor",
    "Smartphone",
    "PC",
    "Laptop",
    "Proyektor"
  ];

  //TODO Validator

  TextEditingController _nameController = TextEditingController();
  TextEditingController _sellerPriceController = TextEditingController();
  TextEditingController _stockController = TextEditingController();
  TextEditingController _taxPercentageController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  void pickImage(int indexImage) async {
    await imagePicker.getImage(source: ImageSource.gallery).then((pickedFile) {
      if (pickedFile != null) {
        pickedImage[indexImage] = (File(pickedFile.path));
      }
    });
    setState(() {});
  }

  Future<void> proposeItem(Seller seller)async{
    try{
      Item item = Item(
      name: _nameController.text,
      sellerPrice: int.parse(_sellerPriceController.text),
      seller: seller.namaPerusahaan,
      sellerUid: seller.uid,
      status: status,
      taxPercentage: int.parse(_taxPercentageController.text),
      category: selectedCategory,
      description: _descriptionController.text,
      stock: int.parse(_stockController.text),
      sold: sold,
    );
    await Database().proposeItem(
      images: pickedImage,
      callback: (bool isSuccess){
        isLoading = false;
        setState(() {
        });
      },
      item: item
    );
    }
    catch(error){
      print(error);
    }
    
  }

  @override
  Widget build(BuildContext context) {
    Seller seller = Provider.of<Auth>(context).getUserInfo;
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: kBackgroundMainColor,
      appBar: AppBar(
        title: Text("Tambah Produk", style: kCalibriBold),
        centerTitle: false,
        backgroundColor: kBlueMainColor,
        elevation: 0,
      ),
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: Container(
          child: ListView(
            children: [
              labelText(leadText: "Nama Produk / Jasa", trailText: "Max 100"),
              Container(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
                child: CustomTextField(
                  maxLength: 100,
                  controller: _nameController,
                  hintText: 'Nama produk..',
                  keyboardType: TextInputType.text,
                  color: Colors.white,
                ),
              ),
              labelText(leadText: "Foto Produk", trailText: "Min 1"),
              //Image Picker
              Container(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    imagePickerBox(index: 0, size: size),
                    imagePickerBox(index: 1, size: size),
                    imagePickerBox(index: 2, size: size),
                  ],
                ),
              ),
              labelText(leadText: "Kategori"),
              Container(
                height: size.height / 15,
                width: size.width / 3,
                margin: EdgeInsets.only(
                    left: size.width * 0.03, right: size.width * 0.5),
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(
                    left: size.width / 20, right: size.width / 50),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white,
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                      isExpanded: true,
                      dropdownColor: Colors.white,
                      value: selectedCategory,
                      items: listKategori
                          .map((kategori) => DropdownMenuItem<String>(
                                child: FittedBox(child: Text(kategori)),
                                value: kategori,
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCategory = value;
                        });
                      }),
                ),
              ),
              labelText(leadText: "Deskripsi", trailText: "Max 1000"),
              Container(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
                child: CustomTextField(
                  maxLength: 1000,
                  controller: _descriptionController,
                  hintText: 'Dekripsi produk..',
                  keyboardType: TextInputType.text,
                  color: Colors.white,
                  maxLine: 20,
                ),
              ),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        labelText(leadText: "Harga Satuan", trailText: "Rupiah"),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: size.width * 0.03),
                          child: CustomTextField(
                            maxLength: 100,
                            controller: _sellerPriceController,
                            hintText: 'Harga',
                            keyboardType: TextInputType.number,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        labelText(leadText: "Pajak(%)"),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: size.width * 0.03),
                          child: CustomTextField(
                            maxLength: 100,
                            controller: _taxPercentageController,
                            hintText: 'Pajak',
                            keyboardType: TextInputType.number,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              labelText(
                leadText: "Jumlah Stok",
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
                child: CustomTextField(
                  maxLength: 10,
                  controller: _stockController,
                  hintText: 'Stok',
                  keyboardType: TextInputType.number,
                  color: Colors.white,
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                    left: size.width * 0.03, right:size.width * 0.05, bottom: size.height * 0.015, top:size.height * 0.05),
                child: Column(
                  children: [
                    Text(
                      '* Jika dianggap sesuai maka produk akan diterima oleh pihak UKPBJ',
                      style: kMaven.copyWith(color: kGrayTextColor),
                    ),
                    SizedBox(
                      height: size.height/40,
                    ),
                    Text(
                      '* Jika harga kurang sesuai maka akan dilakukan proses negosiasi penyesuaian harga',
                      style: kMaven.copyWith(color: kGrayTextColor),
                    ),
                    SizedBox(
                      height: size.height/40,
                    ),
                    Text(
                      '* Hubungi admin jika terdapat masalah atau waktu penerimaan yang terlalu lama',
                      style: kMaven.copyWith(color: kGrayTextColor),
                    ),
                  ],
                ),
              ),
              SizedBox(
                      height: size.height/30,
                    ),
              CustomRaisedButton(
                buttonHeight: size.height/20,
                buttonChild: Text("Submit Produk".toUpperCase(),
                style: kMavenBold,
                textAlign: TextAlign.center,),
                callback: (){
                  //TODO fungsi pengajuan item
                  setState(() {
                    isLoading = true;
                    proposeItem(seller);
                  });
                },
                color: kLightBlueButtonColor,
              ),
              SizedBox(
                      height: size.height/20,
                    ),
            ],
          ),
        ),
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

  Widget imagePickerBox({int index, Size size}) {
    return Builder(
      builder: (BuildContext context) {
        bool isNotPicked = pickedImage[index] == null;
        return InkWell(
            onTap: () {
              pickImage(index);
            },
            child: Container(
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: kGrayConcreteColor,
              ),
              height: size.width / 4,
              width: size.width / 4,
              child: isNotPicked
                  ? Icon(
                      Icons.add_a_photo,
                      color: Colors.white,
                    )
                  : Image.file(
                      pickedImage[index],
                      fit: BoxFit.cover,
                    ),
            ));
      },
    );
  }
}
