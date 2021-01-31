import 'dart:io';
import 'package:e_catalog/constants.dart';
import 'package:e_catalog/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:e_catalog/components/custom_raised_button.dart';
import 'package:e_catalog/components/custom_text_field.dart';
import 'package:provider/provider.dart';
import 'package:e_catalog/auth.dart';
import 'package:image_picker/image_picker.dart';

//VALIDATOR REGISTRASI BELUM PASSWORD EMAIL DLL
//TODO Fungsi Loading Submit
//TODO Konfirmasi password dibenarkan
class RegistrationScreen extends StatefulWidget {
  static const routeId = 'regisScreen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _namaPerusahaanController = TextEditingController();
  TextEditingController _lokasiPerusahaanController = TextEditingController();
  TextEditingController _teleponController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String validationText = '';
  var roles = ['PP', 'Penyedia', 'PPK', 'UKPBJ', 'Audit', 'BPP'];
  //Unitnya harus diisi dan kodenya
  List<String> units = [
    'Sistem Informasi',
    'Informatika',
    'Pengembangan',
    'Tek.Industri',
    'Tek.Kimia'
  ];
  var selectedRoles ;
  var selectedUnit = 'Sistem Informasi';
  var imagePicker = ImagePicker();
  File pickedImage ;

  void onCompleteRegis(AuthResultStatus status) {
    setState(() {
      validationText = AuthExceptionHandler.generateExceptionMessage(status);
    });
    //Perlu langsung di navigate ke home?
    if(status==AuthResultStatus.successful){
      Navigator.of(context).pushNamedAndRemoveUntil(LoginScreen.routeId,(Route<dynamic> route) => false);
      }
  }


  void signUp() async {
    var email = _emailController.text;
    var password = _passwordController.text;
    var role = roles.indexOf(selectedRoles)+1;
    var namaPerusahaan = _namaPerusahaanController.text;
    var unit = units.indexOf(selectedUnit)+1;
    var alamatPerusahaan = _lokasiPerusahaanController.text;
    var telepon = _teleponController.text;
    var name = _nameController.text.toString();
    Provider.of<Auth>(context, listen: false).signUp(
        email,
        password,
        role,
        unit,
        name,
        namaPerusahaan,
        alamatPerusahaan,
        telepon,
        onCompleteRegis,
        pickedImage);
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

  List<DropdownMenuItem> dropDownMenu(Map input) {
    List<DropdownMenuItem> output = [];
    input.forEach((key, value) {
      output.add(DropdownMenuItem<int>(
        child: Text(value),
        value: key,
      ));
    });
    return output;
  }

  bool isContainNumber(String value){
    var num = ['1','2','3','4','5','6','7','8','9','0'];
    bool output = false;
    num.forEach((e){
      if(value.contains(e)) output=true;
    });
    return output;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          backgroundColor: kBlueMainColor,
          body: Container(
            child: Form(
              key: _formKey,
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    pinned: true,
                    backgroundColor: kBlueMainColor,
                    elevation: 0,
                    title: Text(''),
                    centerTitle: true,
                    actions: [
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Text(
                          'Menu Registrasi',
                          style: kMavenBold.copyWith(
                              color: kOrangeButtonColor,
                              fontSize: size.height / 30),
                        ),
                      )
                    ],
                  ),
                  SliverPersistentHeader(
                      pinned: false,
                      floating: false,
                      delegate:
                          TopContainer(size: size, minExtent: 25, maxExtent: 50)),
                  SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: size.width / 16),
                    sliver: SliverList(
                        delegate: SliverChildListDelegate([
                      Text('Email',
                          style: kCalibriBold.copyWith(
                            color: Colors.white,
                            fontSize: size.height * 0.025,
                          )),
                      CustomTextField(
                        validator: (String value){
                          if(value.isEmpty){
                            return "Email tidak boleh kosong";
                          }
                          else if (!value.contains("@")){
                            return "Masukkan email yang valid";
                          }
                          else{
                            return null;
                          }
                        },
                        controller: _emailController,
                        hintText: 'Email',
                        keyboardType: TextInputType.emailAddress,
                        color: Colors.white,
                      ),
                      SizedBox(
                        height: size.height / 100,
                      ),
                      Text('Password',
                          style: kCalibriBold.copyWith(
                            color: Colors.white,
                            fontSize: size.height * 0.027,
                          )),
                      CustomTextField(
                        validator: (String value){
                          if(value.isEmpty){
                            return "Password tidak boleh kosong";
                          }
                          else if (!isContainNumber(value)||(!value.contains(new RegExp(r'[A-Z]'))&&!value.contains(new RegExp(r'[a-z]')))){
                            return "Password harus merupakan kombinasi dari huruf dan angka";
                          }
                          else{
                            return null;
                          }
                        },
                        controller: _passwordController,
                        hintText: 'Password',
                        keyboardType: TextInputType.visiblePassword,
                        isObscure: true,
                        color: Colors.white,
                      ),
                      SizedBox(
                        height: size.height / 100,
                      ),
                      Text('Konfirmasi Password',
                          style: kCalibriBold.copyWith(
                            color: Colors.white,
                            fontSize: size.height * 0.027,
                          )),
                      CustomTextField(
                        validator: (String value){
                          if(value!=_passwordController.text){
                            return "Password tidak sesuai";
                          }
                          else{
                            return null;
                          }
                        },
                        hintText: 'Masukkan ulang password',
                        keyboardType: TextInputType.visiblePassword,
                        isObscure: true,
                        color: Colors.white,
                        // callback: ,
                      ),
                      SizedBox(
                        height: size.height / 100,
                      ),
                      Text('Nama',
                          style: kCalibriBold.copyWith(
                            color: Colors.white,
                            fontSize: size.height * 0.025,
                          )),
                      CustomTextField(
                        validator: (String value){
                          if(value.isEmpty){
                            return "Nama tidak boleh kosong";
                          }
                          else{
                            return null;
                          }
                        },
                        controller: _nameController,
                        hintText: 'Nama',
                        keyboardType: TextInputType.text,
                        color: Colors.white,
                      ),
                      SizedBox(
                        height: size.height / 100,
                      ),
                      Text('Mendaftar Sebagai',
                          style: kCalibriBold.copyWith(
                            color: Colors.white,
                            fontSize: size.height * 0.025,
                          )),
                      Container(
                        margin: EdgeInsets.only(right: size.width / 2.5),
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(
                            left: size.width / 30, right: size.width / 50),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white,
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                              hint: Text("Pilih peran"),
                              isExpanded: true,
                              dropdownColor: Colors.white,
                              value: selectedRoles,
                              items: roles
                                  .map((e) => DropdownMenuItem<String>(
                                        child: Text(e, style: kCalibri,),
                                        value: e,
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedRoles = value;
                                });
                              }),
                        ),
                      ),
                      Text(selectedRoles!=null?"":"Wajib memilih peran", style: kCalibri.copyWith(color: Colors.orange),),
                      SizedBox(
                        height: size.height / 100,
                      ),
                      selectedRoles == 'PP' || selectedRoles == 'PPK'|| selectedRoles == 'BPP'
                          ? Text('Unit',
                              style: kCalibriBold.copyWith(
                                color: Colors.white,
                                fontSize: size.height * 0.025,
                              ))
                          : SizedBox(),
                      selectedRoles == 'PP' || selectedRoles == 'PPK' || selectedRoles == 'BPP'
                          ? Container(
                              margin: EdgeInsets.only(right: size.width / 3),
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
                                    value: selectedUnit,
                                    items: units
                                        .map((e) => DropdownMenuItem<String>(
                                              child: Text(e),
                                              value: e,
                                            ))
                                        .toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        selectedUnit = value;
                                      });
                                    }),
                              ),
                            )
                          : SizedBox(),
                      selectedRoles == 'PP' || selectedRoles == 'PPK'
                          ? SizedBox(
                              height: size.height / 100,
                            )
                          : SizedBox(),
                      Text('No. Telepon',
                          style: kCalibriBold.copyWith(
                            color: Colors.white,
                            fontSize: size.height * 0.025,
                          )),
                      CustomTextField(
                        validator: (String value){
                          if(value.contains(new RegExp(r'[A-Z]'))||value.contains(new RegExp(r'[a-z]'))){
                            return "Mohon masukkan nomor yang valid";
                          }
                          else{
                            return null;
                          }
                        },
                        controller: _teleponController,
                        hintText: 'No.Telepon (08123456789)',
                        keyboardType: TextInputType.phone,
                        color: Colors.white,
                      ),
                      SizedBox(
                        height: size.height / 100,
                      ),
                      Text('Upload Foto',
                          style: kCalibriBold.copyWith(
                            color: Colors.white,
                            fontSize: size.height * 0.025,
                          )),
                      Container(
                        margin: EdgeInsets.only(right: size.width / 2),
                        child: RaisedButton(
                            child: Text('Browse Image'),
                            onPressed: () {
                              pickImage();
                            }),
                      ),
                      GestureDetector(
                        onTap: () {
                              pickImage();
                            },
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: pickedImage != null? Image.file(
                            pickedImage,
                            fit: BoxFit.cover,
                            height: size.height / 5,
                            width: size.height / 5,
                          ):GestureDetector(
                            onTap: () {
                                pickImage();
                              },
                            child: Container(
                            decoration: BoxDecoration(
                              color: kLightGrayTextColor,
                            ),
                            height: size.height / 5,
                            width: size.height / 5,
                            child: Icon(
                                    Icons.add_a_photo,
                                    color: Colors.white,
                                  )
                        ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: size.height / 100,
                      ),
                      selectedRoles == 'Penyedia'
                          ? Text('Nama Perusahaan',
                              style: kCalibriBold.copyWith(
                                color: Colors.white,
                                fontSize: size.height * 0.025,
                              ))
                          : SizedBox(),
                      selectedRoles == 'Penyedia'
                          ? CustomTextField(
                              controller: _namaPerusahaanController,
                              hintText: 'Nama Perusahaan',
                              keyboardType: TextInputType.text,
                              color: Colors.white,
                            )
                          : SizedBox(),
                      selectedRoles == 'Penyedia'
                          ? SizedBox(
                              height: size.height / 100,
                            )
                          : SizedBox(),
                      selectedRoles == 'Penyedia'
                          ? Text('Alamat',
                              style: kCalibriBold.copyWith(
                                color: Colors.white,
                                fontSize: size.height * 0.025,
                              ))
                          : SizedBox(),
                      selectedRoles == 'Penyedia'
                          ? CustomTextField(
                              maxLine: 4,
                              controller: _lokasiPerusahaanController,
                              hintText: 'Alamat Perusahaan',
                              keyboardType: TextInputType.text,
                              color: Colors.white,
                            )
                          : SizedBox(),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: size.height / 30),
                        child: Text(
                          '*Akun akan memiliki status sebagai pengunjung selama admin belum memverifikasi data registrasi',
                          style: kMaven.copyWith(color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: size.height / 100),
                        child: Text(
                          '*Hubungi admin jika terdapat masalah atau waktu verifikasi yang terlalu lama',
                          style: kMaven.copyWith(color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: size.height / 100),
                        child: Text(
                          validationText,
                          style: kMavenBold.copyWith(
                            color: Colors.red,
                          fontSize: size.height/40,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: size.width / 100,
                            vertical: size.height / 100),
                        child: CustomRaisedButton(
                          buttonHeight: size.height / 10,
                          callback: () {
                            _formKey.currentState.validate()?print("Sukses"):print("Validator ngak valed");
                            // signUp();
                          },
                          color: kOrangeButtonColor,
                          buttonChild: Text("Submit Registrasi",
                              textAlign: TextAlign.center,
                              style: kMavenBold.copyWith(
                                  fontSize: size.height * 0.028)),
                        ),
                      ),
                    ])),
                  )
                ],
              ),
            ),
          )),
    );
  }
}


class TopContainer extends SliverPersistentHeaderDelegate {
  double maxExtent;
  double minExtent;
  Size size;

  TopContainer({this.maxExtent, this.minExtent, this.size});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
      height: size.height / 10,
      child: Text(
        'Masukkan data sesuai dengan identitas asli anda, dan hubungi admin jika memiliki kendala',
        style: kMaven.copyWith(
          color: Colors.white,
        ),
        textAlign: TextAlign.right,
      ),
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}

