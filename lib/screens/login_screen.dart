import 'package:e_catalog/screens/catalog_home.dart';
import 'package:e_catalog/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import '../components/custom_raised_button.dart';
import 'package:e_catalog/components/custom_text_field.dart';
import 'package:e_catalog/constants.dart';

//Setelah registrasi apa perlu login lagi?
//Perlu fungsi validasi dan Exception Handling
// The method 'findAncestorStateOfType' was called on null.
// Receiver: null
// Tried calling: findAncestorStateOfType<NavigatorState>()



class LoginScreen extends StatefulWidget {
  static const routeId = 'loginScreen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  String validationText = '';

  @override
  void initState() {
    super.initState();
  }

  void loginCallback() async {
    setState(() {
      isLoading = true;
    });
      await Provider.of<Auth>(context, listen: false)
        .signIn(emailController.text, passwordController.text, (AuthResultStatus status) {
        if(status==AuthResultStatus.successful){
          Navigator.pushReplacementNamed(context, CatalogHome.routeId);
        }
        else{
          validationText = AuthExceptionHandler.generateExceptionMessage(status);
          isLoading = false;
        setState(() {
        });
        } 
        
    });
    
    
  }

  void checkLogin()  async{
    await Provider.of<Auth>(context, listen: false).checkAuth().then((value) {
      if(value){
        WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, CatalogHome.routeId);
      });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    checkLogin();
    var size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: kBackgroundMainColor,
      body: ModalProgressHUD(
          inAsyncCall: isLoading,
          child: SafeArea(
            child: SingleChildScrollView(
              physics: ClampingScrollPhysics(),
                          child: Container(
                            height: size.height,
                            width: size.width,
                                                      child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: size.height * 0.06,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: size.width * 0.05),
                    child: Text('Welcome to Login',
                        style: kMavenBold.copyWith(
                            color: kBlueDarkColor,
                            fontSize: size.height * 0.035,
                        )),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: size.width * 0.05,
                        top: size.height * 0.01,
                        right: size.width * 0.2),
                    child: Text(
                      'Silahkan Masuk dengan menggunakan E-mail dan Password yang sesuai',
                      style: TextStyle(
                            color: kBlueDarkColor, fontFamily: 'MavenPro'),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.05,
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(40)),
                            color: kBlueMainColor),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: size.height * 0.02,
                                  horizontal: size.width * 0.08),
                              child: Text('LOGIN FORM',
                                  style: kMavenBold.copyWith(
                                    color: Colors.white,
                                    fontSize: size.height * 0.03,
                                  )),
                            ),
                            SizedBox(
                              height: size.height * 0.05,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: size.width * 0.1),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text('Email',
                                      style: kCalibriBold.copyWith(
                                        color: Colors.white,
                                        fontSize: size.height * 0.027,
                                      )),
                                  CustomTextField(
                                    controller: emailController,
                                    hintText: 'Email',
                                    keyboardType: TextInputType.emailAddress,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    height: size.height * 0.02,
                                  ),
                                  Text('Password',
                                      style: kCalibriBold.copyWith(
                                        color: Colors.white,
                                        fontSize: size.height * 0.027,
                                      )),
                                  CustomTextField(
                                    controller: passwordController,
                                    hintText: 'Password',
                                    keyboardType: TextInputType.visiblePassword,
                                    isObscure: true,
                                    color: Colors.white,
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(size.height/100),
                                    child: Text(
                                      validationText,
                                      style: kCalibriBold.copyWith(
                                        color : kRedButtonColor,
                                        fontSize: size.height/40,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: size.height * 0.06,
                                  ),
                                  CustomRaisedButton(
                                    buttonHeight: size.height/12,
                                    callback: (){
                                      loginCallback();
                                    },
                                    color: kOrangeButtonColor,
                                    buttonChild: Text(
                                      "Login Now",
                                      textAlign: TextAlign.center,
                                      style : kMavenBold.copyWith(
                                        fontSize: size.height*0.028
                                      )
                                    ),
                                  ),
                                  SizedBox(
                                    height: size.height * 0.02,
                                  ),
                                  CustomRaisedButton(
                                    buttonHeight: size.height/18,
                                    callback: (){
                                      Navigator.pushNamed(context, RegistrationScreen.routeId);
                                      },
                                    color: kLightBlueButtonColor,
                                    buttonChild: Text(
                                      "Register",
                                      textAlign: TextAlign.center,
                                      style : kMavenBold.copyWith(
                                        fontSize: size.height*0.028
                                      )
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
                          ),
            ),
          )),
    );
  }
}
