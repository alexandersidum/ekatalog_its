import 'dart:io';
import 'dart:math';
import 'package:e_catalog/components/custom_raised_button.dart';
import 'package:e_catalog/components/custom_text_field.dart';
import 'package:e_catalog/models/account.dart';
import 'package:e_catalog/models/item.dart';
import 'package:e_catalog/utilities/item_services.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:e_catalog/auth.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import '../constants.dart';

class AddProductScreen extends StatefulWidget {
  Item item;
  bool isEdit;
  AddProductScreen({Key key, this.item, this.isEdit=false}) : super(key: key);

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
  ItemService db = ItemService();
  bool isLoading = false;
  ImagePicker imagePicker = ImagePicker();
  List<File> pickedImage = List(3);
  List<ImageEditInfo> pickedImageInfo = [ImageEditInfo(), ImageEditInfo(), ImageEditInfo()];
  //TODO Dummy Kategori
  List<String> listKategori = [
  ];
  // List<String> listKategori = [
  //   "Alat Kantor",
  //   "AC",
  //   "Monitor",
  //   "Smartphone",
  //   "PC",
  //   "Laptop",
  //   "Proyektor",
  //   "Elektronik"
  // ];
  //TODO Validator
  TextEditingController _nameController = TextEditingController();
  TextEditingController _sellerPriceController = TextEditingController();
  TextEditingController _stockController = TextEditingController();
  TextEditingController _taxPercentageController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  Future<File> urlToFile(String imageUrl) async {
    var rng = Random(); 
    Directory tempDir =
        await getTemporaryDirectory();
    String tempPath = tempDir.path; 
    File file = File('$tempPath' +
        (rng.nextInt(100)).toString() +'.png'); 
    http.Response response = await http.get(imageUrl); 
    return await file.writeAsBytes(response.bodyBytes);
  }

  void getNetworkImage(List<String> imageUrls)async{
    setState(() {
      isLoading = true;
    });
    int index = 0;
    await Future.forEach(imageUrls, (element) async{
        if(element!=null) {
          pickedImage[index] = await urlToFile(element);
          pickedImageInfo[index] = ImageEditInfo(
            imageFile: pickedImage[index],
            existingUrl: imageUrls[index],
          );
        }
      index++;
    });
    await getCategory();
    setState(() {
      isLoading = false;
    });
  }

  Future<void> getCategory()async{
    setState(() {
      isLoading = true;
    });
    listKategori = await db.getCategory().then((listCategory)=>listCategory.map((e)=>e.name).toList());
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    print("initstate");
    print(widget.isEdit);
    if (widget.item != null && widget.isEdit) {
      print("widget tidak null");
      var item = widget.item;
      _nameController.text = item.name;
      _descriptionController.text = item.description;
      _stockController.text = item.stock.toString();
      _taxPercentageController.text = item.taxPercentage.toString();
      _sellerPriceController.text = item.price.toString();
      selectedCategory = item.category;
      getNetworkImage(item.image);
    }
    else{
      getCategory();
      print("widget  null");
    }
    super.initState();
  }

  void pickImage(int indexImage) async {
    await imagePicker.getImage(source: ImageSource.gallery).then((pickedFile) {
      if (pickedFile != null) {
        pickedImage[indexImage] = (File(pickedFile.path));
        pickedImageInfo[indexImage].imageFile = pickedImage[indexImage];
        pickedImageInfo[indexImage].changeStatus(true);
      }
    });
    setState(() {});
  }

  Future<void> proposeItem(Seller seller) async {
    try {
      Item item = Item(
        name: _nameController.text,
        sellerPrice: int.parse(_sellerPriceController.text),
        seller: seller.namaPerusahaan,
        sellerUid: seller.uid,
        status: status,
        taxPercentage: _taxPercentageController.text.isNotEmpty
            ? int.parse(_taxPercentageController.text)
            : 0,
        category: selectedCategory,
        description: _descriptionController.text,
        stock: int.parse(_stockController.text),
        sold: sold,
      );
      await db.proposeItem(
          images: pickedImage,
          callback: (bool isSuccess) {
            isLoading = false;
            setState(() {});
          },
          item: item);
    } catch (error) {
      print(error);
    }
  }

  Future<void> editItem(Seller seller, Item currentItem) async {
    try {
      Item item = currentItem;
      item.name = _nameController.text;
      item.category = selectedCategory;
      item.description = _descriptionController.text;
      item.stock = int.parse(_stockController.text);
      
      await db.editItem(
          images: pickedImageInfo,
          callback: (bool isSuccess) {
            isLoading = false;
            setState(() {});
          },
          item: item);
    } catch (error) {
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
        title: Text(widget.isEdit?"Ubah Produk":"Tambah Produk", style: kCalibriBold),
        centerTitle: false,
        backgroundColor: kBlueMainColor,
        elevation: 0,
      ),
      body: seller.nomorRekening == null
          ? Center(
              child: Padding(
              padding: EdgeInsets.all(size.width / 5),
              child: Text(
                  "Tidak dapat menambahkan Produk sebelum mengatur Nomor Rekening",
                  style: kCalibriBold.copyWith(color: kRedButtonColor)),
            ))
          : ModalProgressHUD(
              inAsyncCall: isLoading,
              child: Container(
                child: ListView(
                  children: [
                    labelText(
                        leadText: "Nama Produk / Jasa", trailText: "Max 100"),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: size.width * 0.03),
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
                      padding:
                          EdgeInsets.symmetric(horizontal: size.width * 0.03),
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
                            hint: Text("Pilih Kategori", style:kCalibri),
                            isExpanded: true,
                            dropdownColor: Colors.white,
                            value: listKategori.contains(selectedCategory)?selectedCategory:null,
                            items: listKategori
                                .map((kategori) => DropdownMenuItem<String>(
                                      child: FittedBox(child: Text(kategori, style: kCalibri)),
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
                      padding:
                          EdgeInsets.symmetric(horizontal: size.width * 0.03),
                      child: CustomTextField(
                        textInputAction: TextInputAction.newline,
                        maxLength: 1000,
                        controller: _descriptionController,
                        hintText: 'Dekripsi produk..',
                        keyboardType: TextInputType.multiline,
                        color: Colors.white,
                        maxLine: 8,
                      ),
                    ),
                    widget.isEdit? SizedBox()
                    :Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Column(
                            children: [
                              labelText(
                                  leadText: "Harga Satuan",
                                  trailText: "Rupiah"),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: size.width * 0.03),
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
                                padding: EdgeInsets.symmetric(
                                    horizontal: size.width * 0.03),
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
                      padding:
                          EdgeInsets.symmetric(horizontal: size.width * 0.03),
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
                          left: size.width * 0.03,
                          right: size.width * 0.05,
                          bottom: size.height * 0.015,
                          top: size.height * 0.05),
                      child: Column(
                        children: [
                          Text(
                            '* Jika dianggap sesuai maka produk akan diterima oleh pihak UKPBJ',
                            style: kMaven.copyWith(color: kGrayTextColor),
                          ),
                          SizedBox(
                            height: size.height / 40,
                          ),
                          Text(
                            '* Jika harga kurang sesuai maka akan dilakukan proses negosiasi penyesuaian harga',
                            style: kMaven.copyWith(color: kGrayTextColor),
                          ),
                          SizedBox(
                            height: size.height / 40,
                          ),
                          Text(
                            '* Hubungi admin jika terdapat masalah atau waktu penerimaan yang terlalu lama',
                            style: kMaven.copyWith(color: kGrayTextColor),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: size.height / 30,
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: size.width / 10),
                      child: CustomRaisedButton(
                        buttonHeight: size.height / 20,
                        buttonChild: Text(
                          "Submit Produk".toUpperCase(),
                          style: kMavenBold,
                          textAlign: TextAlign.center,
                        ),
                        callback: () {
                          //TODO fungsi pengajuan item
                          setState(() {
                            isLoading = true;
                            widget.isEdit?editItem(seller, widget.item):
                            proposeItem(seller);
                          });
                        },
                        color: kOrangeButtonColor,
                      ),
                    ),
                    SizedBox(
                      height: size.height / 20,
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
        return Column(
          children: [
            Stack(children: [
              Container(
                height: size.width / 3.5,
                width: size.width / 3.5,
              ),
              Positioned(
                left: 5,
                right: 5,
                bottom: 5,
                top: 5,
                child: InkWell(
                    onTap: () {
                      pickImage(index);
                    },
                    child: Container(
                      padding: EdgeInsets.all(1),
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
                    )),
              ),
              !isNotPicked
                  ? Positioned(
                      right: 0,
                      top: 0,
                      child: GestureDetector(
                        onTap: () {
                          pickedImage[index] = null;
                          pickedImageInfo[index].imageFile = null;
                          pickedImageInfo[index].changeStatus(true);
                          setState(() {});
                        },
                        child: Icon(
                          Icons.highlight_off,
                          color: Colors.red,
                        ),
                      ),
                    )
                  : SizedBox(),
            ]),
            Text(
              index == 0 ? "Foto Utama" : " ",
              style: kCalibriBold.copyWith(color: kBlueMainColor),
            )
          ],
        );
      },
    );
  }
}
