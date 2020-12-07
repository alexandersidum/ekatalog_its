import 'package:e_catalog/constants.dart';
import 'package:e_catalog/screens/item_detail.dart';
import 'package:e_catalog/screens/seller_catalog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/catalog_home.dart';
import 'screens/login_screen.dart';
import 'auth.dart';
import 'models/cart.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context)=>Cart()),
        ChangeNotifierProvider(create: (context)=>Auth())
      ],
      child: MaterialApp(
        theme: ThemeData.light(),
        initialRoute: LoginScreen.routeId,
        routes: {
          LoginScreen.routeId : (context)=>LoginScreen(),
          RegistrationScreen.routeId : (context)=>RegistrationScreen(),
          CatalogHome.routeId : (context)=>CatalogHome(),
          ItemDetail.routeId : (context)=>ItemDetail(),
          SellerCatalog.routeId : (context)=>SellerCatalog(),
        },
      ),
    );
  }
}
