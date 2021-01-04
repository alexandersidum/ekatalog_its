import 'package:e_catalog/constants.dart';
import 'package:e_catalog/models/account.dart';
import 'package:e_catalog/models/menu_state.dart';
import 'package:e_catalog/screens/add_product_screen.dart';
import 'package:e_catalog/screens/item_detail.dart';
import 'package:e_catalog/screens/ppk_screen/quotation_screen.dart';
import 'package:e_catalog/screens/role_menu.dart';
import 'package:e_catalog/screens/seller_catalog.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/catalog_home.dart';
import 'auth.dart';
import 'models/cart.dart';
import 'package:flutter/services.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
       statusBarColor: kBlueMainColor,
    ));
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context)=>MenuState(menuSelected: 0)),
        ChangeNotifierProvider(create: (context)=>Cart()),
        Provider(create: (context)=>Auth()),
        StreamProvider<Account>(
          updateShouldNotify: (_,__)=>true,
          create: (context)=>Provider.of<Auth>(
          context,listen: false).streamUserInfo(Provider.of<Auth>(context,listen: false).getUserInfo.uid))
      ],
      child: MaterialApp(
        theme: ThemeData.light().copyWith(
          canvasColor: Colors.transparent,
        ),
        initialRoute: LoginScreen.routeId,
        routes: {
          LoginScreen.routeId : (context)=>LoginScreen(),
          RegistrationScreen.routeId : (context)=>RegistrationScreen(),
          CatalogHome.routeId : (context)=>CatalogHome(),
          ItemDetail.routeId : (context)=>ItemDetail(),
          SellerCatalog.routeId : (context)=>SellerCatalog(),
          RoleMenu.routeId : (context)=>RoleMenu(),
          AddProductScreen.routeId : (context)=>AddProductScreen(),
          QuotationScreen.routeId : (context)=>QuotationScreen(),
        },
      ),
    );
  }
}
