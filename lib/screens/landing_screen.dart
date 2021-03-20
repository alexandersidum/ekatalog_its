import 'package:e_catalog/auth.dart';
import 'package:e_catalog/screens/catalog_home.dart';
import 'package:e_catalog/screens/login_screen.dart';
import 'package:e_catalog/screens/role_menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LandingScreen extends StatefulWidget {
  static const routeId = 'landing';
  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  @override
  void initState() {
    super.initState();
    Auth().streamAccount.listen((user){
      if(user!=null){
        navigateLogin(user.role);
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    checkLogin();
  }

  void checkLogin() async {
    await Provider.of<Auth>(context, listen: false).checkAuth().then((value) {
      if (value) {
        print("Valued");
        WidgetsBinding.instance.addPostFrameCallback((_) {
          navigateLogin(
              Provider.of<Auth>(context, listen: false).getUserInfo.role);
        });
      }
      else{
        print("Not Valued");
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacementNamed(context, LoginScreen.routeId);
        });
        
      }
    });
  }

  void navigateLogin(int role) async {
    if (role == 0 || role == 1) {
      Navigator.pushReplacementNamed(context, CatalogHome.routeId);
    } else {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => RoleMenu()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width/1.5,
          decoration: BoxDecoration( 
            image: DecorationImage(
              fit: BoxFit.contain,
              image: AssetImage("assets/logo_its.png")
            )
          ),
        ),
      ),
    );
  }
}
