import 'dart:io';
import 'package:e_catalog/constants.dart';
import 'package:e_catalog/models/account.dart';
import 'package:e_catalog/models/unit.dart';
import 'package:e_catalog/screens/login_screen.dart';
import 'package:e_catalog/utilities/account_services.dart';
import 'package:flutter/material.dart';
import 'package:e_catalog/components/custom_raised_button.dart';
import 'package:e_catalog/components/custom_text_field.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
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
  bool isLoading = true;
  AccountService _services = AccountService();
  List<int> unitRole = Account.unitRole;
  Map<int, String> mapRole = Account.mapRole;
  List<Unit> listUnit = [];
  List<DivisiPPK> listDivisi = [];
  int selectedRoles;
  Unit selectedUnit;
  DivisiPPK selectedDivisi;
  var imagePicker = ImagePicker();
  File pickedImage;
  int counter = 0;

  getUnitInfo() async {
    setState(() {
      isLoading = true;
    });
    listUnit = await _services.getUnit();
    listDivisi = await _services.getDivisiPPK();
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getUnitInfo();
  }

  void onCompleteRegis(AuthResultStatus status) {
    setState(() {
      validationText = status==AuthResultStatus.successful? "":AuthExceptionHandler.generateExceptionMessage(status);
      isLoading = false;
    });
    if (status == AuthResultStatus.successful) {
      Navigator.of(context).pushNamedAndRemoveUntil(
          LoginScreen.routeId, (Route<dynamic> route) => false);
    }
  }

  void signUp() async {
    setState(() {
          isLoading = true;
        });
    var email = _emailController.text;
    var password = _passwordController.text;
    var role = selectedRoles;
    var namaPerusahaan = _namaPerusahaanController.text;
    var unit = selectedUnit;
    var alamatPerusahaan = _lokasiPerusahaanController.text;
    var telepon = _teleponController.text;
    var name = _nameController.text.toString();
    Provider.of<Auth>(context, listen: false).signUp(
        email,
        password,
        role,
        unit != null ? int.parse(unit.unitId) : 1,
        name,
        namaPerusahaan,
        unit != null ? unit.namaUnit : "",
        selectedDivisi != null ? selectedDivisi.namaDivisi : "",
        alamatPerusahaan,
        telepon,
        onCompleteRegis,
        selectedRoles == 3 ? selectedDivisi.ppkCode : unitRole.contains(selectedRoles)? selectedUnit.ppkCode:"",
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

  bool isContainNumber(String value) {
    var num = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0'];
    bool output = false;
    num.forEach((e) {
      if (value.contains(e)) output = true;
    });
    return output;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          backgroundColor: kBlueMainColor,
          body: ModalProgressHUD(
            inAsyncCall: isLoading,
            child: Container(
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
                        delegate: TopContainer(
                            size: size, minExtent: 25, maxExtent: 50)),
                    SliverPadding(
                      padding:
                          EdgeInsets.symmetric(horizontal: size.width / 16),
                      sliver: SliverList(
                          delegate: SliverChildListDelegate([
                        Text('Email',
                            style: kCalibriBold.copyWith(
                              color: Colors.white,
                              fontSize: size.height * 0.025,
                            )),
                        CustomTextField(
                          validator: (String value) {
                            if (value.isEmpty) {
                              return "Email tidak boleh kosong";
                            } else if (!value.contains("@")) {
                              return "Masukkan email yang valid";
                            } else {
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
                          validator: (String value) {
                            if (value.isEmpty) {
                              return "Password tidak boleh kosong";
                            } else if (!isContainNumber(value) ||
                                (!value.contains(new RegExp(r'[A-Z]')) &&
                                    !value.contains(new RegExp(r'[a-z]')))) {
                              return "Password harus merupakan kombinasi dari huruf dan angka";
                            } else {
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
                          validator: (String value) {
                            if (value != _passwordController.text) {
                              return "Password tidak sesuai";
                            } else {
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
                          validator: (String value) {
                            if (value.isEmpty) {
                              return "Nama tidak boleh kosong";
                            } else {
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
                                items: mapRole.entries
                                    .map((entry) => DropdownMenuItem<int>(
                                          child: Text(
                                            entry.value,
                                            style: kCalibri,
                                          ),
                                          value: entry.key,
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedRoles = value;
                                  });
                                }),
                          ),
                        ),
                        Text(
                          selectedRoles != null ? "" : "Wajib memilih peran",
                          style: kCalibri.copyWith(color: Colors.orange),
                        ),
                        unitRole.contains(selectedRoles)
                            ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Unit',
                                      style: kCalibriBold.copyWith(
                                        color: Colors.white,
                                        fontSize: size.height * 0.025,
                                      )),
                                  Container(
                                    margin:
                                        EdgeInsets.only(right: size.width / 3),
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.only(
                                        left: size.width / 20,
                                        right: size.width / 50),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.white,
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton(
                                          hint: Text("Pilih Unit"),
                                          isExpanded: true,
                                          dropdownColor: Colors.white,
                                          value: selectedUnit,
                                          items: listUnit
                                              .map(
                                                  (e) => DropdownMenuItem<Unit>(
                                                        child: Text(e.namaUnit),
                                                        value: e,
                                                      ))
                                              .toList(),
                                          onChanged: (value) {
                                            setState(() {
                                              selectedUnit = value;
                                            });
                                          }),
                                    ),
                                  ),
                                  SizedBox(
                                    height: size.height / 100,
                                  )
                                ],
                              )
                            : SizedBox(),
                        selectedRoles == 3
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Divisi PPK',
                                      style: kCalibriBold.copyWith(
                                        color: Colors.white,
                                        fontSize: size.height * 0.025,
                                      )),
                                  Container(
                                    margin:
                                        EdgeInsets.only(right: size.width / 10),
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.only(
                                        left: size.width / 20,
                                        right: size.width / 50),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.white,
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton(
                                          hint: Text("Pilih Divisi"),
                                          isExpanded: true,
                                          dropdownColor: Colors.white,
                                          value: selectedDivisi,
                                          items: listDivisi.map((e) {
                                            return DropdownMenuItem<DivisiPPK>(
                                              child: Text(e.namaDivisi),
                                              value: e,
                                            );
                                          }).toList(),
                                          onChanged: (value) {
                                            setState(() {
                                              selectedDivisi = value;
                                            });
                                          }),
                                    ),
                                  ),
                                  SizedBox(
                                    height: size.height / 100,
                                  )
                                ],
                              )
                            : SizedBox(),
                        Text('No. Telepon',
                            style: kCalibriBold.copyWith(
                              color: Colors.white,
                              fontSize: size.height * 0.025,
                            )),
                        CustomTextField(
                          validator: (String value) {
                            if (value.contains(new RegExp(r'[A-Z]')) ||
                                value.contains(new RegExp(r'[a-z]'))) {
                              return "Mohon masukkan nomor yang valid";
                            } else {
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
                            child: pickedImage != null
                                ? Image.file(
                                    pickedImage,
                                    fit: BoxFit.cover,
                                    height: size.height / 5,
                                    width: size.height / 5,
                                  )
                                : GestureDetector(
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
                                        )),
                                  ),
                          ),
                        ),
                        SizedBox(
                          height: size.height / 100,
                        ),
                        selectedRoles == 2
                            ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Nama Perusahaan',
                                      style: kCalibriBold.copyWith(
                                        color: Colors.white,
                                        fontSize: size.height * 0.025,
                                      )),
                                  CustomTextField(
                                    controller: _namaPerusahaanController,
                                    hintText: 'Nama Perusahaan',
                                    keyboardType: TextInputType.text,
                                    color: Colors.white,
                                  ),
                                  Text('Alamat',
                                      style: kCalibriBold.copyWith(
                                        color: Colors.white,
                                        fontSize: size.height * 0.025,
                                      )),
                                  CustomTextField(
                                    maxLine: 4,
                                    controller: _lokasiPerusahaanController,
                                    hintText: 'Alamat Perusahaan',
                                    keyboardType: TextInputType.text,
                                    color: Colors.white,
                                  )
                                ],
                              )
                            : SizedBox(),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: size.height / 30),
                          child: Text(
                            '*Akun akan memiliki status sebagai pengunjung selama admin belum memverifikasi data registrasi',
                            style: kMaven.copyWith(color: Colors.white),
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: size.height / 100),
                          child: Text(
                            '*Hubungi admin jika terdapat masalah atau waktu verifikasi yang terlalu lama',
                            style: kMaven.copyWith(color: Colors.white),
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: size.height / 100),
                          child: Text(
                            validationText.isNotEmpty ? validationText : "",
                            style: kMavenBold.copyWith(
                                color: Colors.red, fontSize: 15),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: size.width / 100,
                              vertical: size.height / 100),
                          child: CustomRaisedButton(
                            buttonHeight: size.height / 10,
                            callback: () {
                              if (_formKey.currentState.validate()) {
                                validationText =
                                    "";
                                signUp();
                              } else {
                                validationText =
                                    "Mohon periksa kelengkapan data kembali";
                              }
                              setState(() {});
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
