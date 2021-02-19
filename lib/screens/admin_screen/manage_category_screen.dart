import 'dart:io';
import 'package:e_catalog/components/custom_raised_button.dart';
import 'package:e_catalog/components/custom_text_field.dart';
import 'package:e_catalog/components/modal_bottom_sheet_app.dart';
import 'package:e_catalog/constants.dart';
import 'package:e_catalog/models/item.dart';
import 'package:e_catalog/utilities/item_services.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class ManageCategoryScreen extends StatefulWidget {
  @override
  _ManageCategoryScreenState createState() => _ManageCategoryScreenState();
}

class _ManageCategoryScreenState extends State<ManageCategoryScreen> {
  List<Category> categoryList = [];
  bool isLoading = false;
  ItemService _service = ItemService();
  ImagePicker _imagePicker = ImagePicker();
  Stream<List<Category>> streamCategory;
  File pickedImage;
  TextEditingController categoryName = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // getCategory();
    streamCategory = _service.getStreamCategory();
    super.initState();
  }

  void getCategory() async {
    categoryList = await _service.getCategory();
    isLoading = false;
    setState(() {});
  }

  Future<void> pickImage() async {
    await _imagePicker.getImage(source: ImageSource.gallery).then((pickedFile) {
      if (pickedFile != null) {
        pickedImage = File(pickedFile.path);
      } 
    });
    setState(() {});
    return;
  }

  Widget addCategorySheet(Size size) {
    return StatefulBuilder(
      builder: (context, setStater) {
        return Container(
          width: size.width,
          height: size.height / 2,
          decoration: BoxDecoration(color: kBlueMainColor,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                child: GestureDetector(
                  onTap: () async{
                    await pickImage();
                    setStater((){});
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical : size.height/30),
                    height: size.height / 5,
                    width: size.height / 5,
                    color: Colors.white,
                    alignment: Alignment.centerLeft,
                    child: pickedImage != null
                        ? Image.file(
                            pickedImage,
                            fit: BoxFit.cover,
                            height: size.height / 5,
                            width: size.height / 5,
                          )
                        : Align(
                          alignment: Alignment.center,
                          child: Icon(Icons.add_a_photo)),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical : size.height/100, horizontal:size.width/10),
                child: CustomTextField(
                  hintText: "Nama Kategori",
                  controller: categoryName,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical : size.height/100, horizontal:size.width/10),
                child: CustomRaisedButton(
                color: kOrangeButtonColor,
                callback: ()async{
                  await _service.addCategory(categoryName.text, pickedImage).then((isSuccess){
                      // Kalau sukses tambah kategori
                  });
                },
                buttonChild: Text("TAMBAH KATEGORI", style: kCalibriBold.copyWith(color: Colors.black)),
              ),)
            ],
          ),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        key : _scaffoldKey,
        appBar: AppBar(
          backgroundColor: kBlueMainColor,
          title: Text("Manage Category", style: kCalibriBold),
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: kBlueMainColor,
          label: Text("Add Category"),
          onPressed: () {
            showModalBottomSheetApp(
                context: context, builder: (context) => addCategorySheet(size)).whenComplete((){
                  pickedImage = null;
                });
          },
          icon: Icon(Icons.add),
        ),
        body: StreamBuilder<List<Category>>(
          stream: streamCategory,
          builder: (context, categoryList) {
            if(categoryList.connectionState==ConnectionState.waiting){
              return Center(child: CircularProgressIndicator(),);
            }
            if(categoryList.hasData){
              return Container(
              child: GridView.builder(
                itemCount: categoryList.data.length,
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, childAspectRatio: 3 / 2),
                itemBuilder: (context, index) {
                  Category currentCategory = categoryList.data[index];
                  return Container(
                    child: Card(
                      child: Row(children: [
                        Expanded(
                          flex: 2,
                          child: Container(
                            padding: EdgeInsets.all(4.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                    child: Image.network(
                                  currentCategory.thumbnailUrl,
                                  height: size.height / 5,
                                  fit: BoxFit.contain,
                                )),
                                Text(currentCategory.name, style: kMavenBold)
                              ],
                            ),
                          ),
                        ),
                        // Expanded(
                        //   flex: 1,
                        //   child: Column(
                        //     mainAxisAlignment: MainAxisAlignment.center,
                        //     children: [
                        //       Container(
                        //         child: InkWell(
                        //           child: Text(
                        //             "HAPUS",
                        //             style:
                        //                 kMavenBold.copyWith(color: kRedButtonColor),
                        //           ),
                        //         ),
                        //       ),
                        //       SizedBox(
                        //         height: size.height / 40,
                        //       ),
                        //       Container(
                        //         child: InkWell(
                        //           child: Text(
                        //             "UBAH",
                        //             style:
                        //                 kMavenBold.copyWith(color: kBlueMainColor),
                        //           ),
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                      ]),
                    ),
                  );
                },
              ),
            );
            }
            else{
              return Center(child : Text("Kesalahan dalam mengambil data"));
            }
            
            
          }
        ),
      ),
    );
  }
}
