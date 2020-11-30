import 'package:e_catalog/screens/catalog_home.dart';
import 'package:e_catalog/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import '../components/custom_raised_button.dart';
import 'package:e_catalog/components/custom_text_field.dart';
import 'package:e_catalog/constants.dart';

//Login sebagai seller metodenya belum

class LoginScreen extends StatefulWidget {

  static const routeId = 'loginScreen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

//Perlu fungsi validasi

class _LoginScreenState extends State<LoginScreen> {


  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  String validationText = '';

  @override
  void initState() { 
    super.initState();
    checkLogin();
  }

  void loginCallback()async{
    setState(() {
      isLoading = true;
    });
    try{
      await Provider.of<Auth>(context, listen: false).signIn(emailController.text, passwordController.text, (){
      // print("tried");
      if(Provider.of<Auth>(context, listen: false).getUser!=null){
        Navigator.pushReplacementNamed(context, CatalogHome.routeId);
      }else{
        validationText = 'Login Gagal';
      }
    });
    }catch(e){
      validationText = 'Login Gagal';
    }
    setState(() {
      isLoading = false;
    });
  }

  void checkLogin() async{
    await Provider.of<Auth>(context, listen: false).checkAuth().then((value) {
      value!=null?Navigator.pushReplacementNamed(context, CatalogHome.routeId):null;
    });
  }

  @override
  Widget build(BuildContext context) {    
  return Scaffold(
    body: ModalProgressHUD(
      inAsyncCall: isLoading,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Image(
                  image: AssetImage('assets/logo_its.png'),
                  height: MediaQuery.of(context).size.height/4,
                ),
              ),
              Flexible(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height/17,
                ),
              ),
              Text('Email',
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              CustomTextField(
                controller: emailController,
                hintText: 'Email',
                iconData: Icons.email,
                keyboardType: TextInputType.emailAddress,
                color: Colors.white,
              ),
              Text('Password',
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              CustomTextField(
                controller: passwordController,
                hintText: 'Password',
                iconData: Icons.lock,
                keyboardType: TextInputType.visiblePassword,
                isObscure: true,
                color: Colors.white,
              ),
              Text(
                validationText,
                style: TextStyle(
                  color: Colors.black)
                ),

              CustomRaisedButton(
                color: Colors.blue[500],
                text: 'Masuk',
                callback: (){loginCallback();},
              ),

              CustomRaisedButton(
                color: Colors.green[500],
                text: 'Registrasi',
                callback: (){
                  Navigator.pushNamed(context, RegistrationScreen.routeId);
                }
              ),

            ],
          ),
        )
        ),
    ),
  );
  
  }
}