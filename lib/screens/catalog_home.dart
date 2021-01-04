import 'package:e_catalog/models/item.dart';
import 'package:e_catalog/models/account.dart';
import 'package:e_catalog/models/menu_state.dart';
import 'package:e_catalog/screens/cart_screen.dart';
import 'package:e_catalog/screens/item_catalog.dart';
import 'package:e_catalog/screens/mail_screen.dart';
import 'package:e_catalog/screens/profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_catalog/auth.dart';
import 'package:e_catalog/utilities/item_services.dart';
import 'package:e_catalog/constants.dart';
import 'playground.dart';
import 'package:e_catalog/models/menu_state.dart';

//BottomNavbar belum diimplementasikan
//Single item atau detail item page belum
//Belum menyediakan appbar untuk page selain katalog item
//filter bottomsheet belum

class CatalogHome extends StatefulWidget {
  static const routeId = 'CatalogHome';

  @override
  State<StatefulWidget> createState() => CatalogHomeState();
}

class CatalogHomeState extends State<CatalogHome> {
  List<BottomNavigationBarItem> _bottomNavBarItem = [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
    BottomNavigationBarItem(
        icon: Icon(Icons.shopping_cart), label: 'Keranjang'),
    BottomNavigationBarItem(icon: Icon(Icons.mail), label: 'Mail'),
    BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Account'),
  ];

  List<Widget> _listPage = [
    ItemCatalog(
      key: PageStorageKey('catalog'),
    ),
    CartScreen(key: PageStorageKey('cart')),
    MailScreen(key:PageStorageKey('mail')),
    // AddProductScreen(key: PageStorageKey('add_product')),
    Profile(key: PageStorageKey('profile')),
  ];

  List<Widget> _listAppbar = [
    AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      toolbarHeight: 0,
      backgroundColor: kBlueMainColor,
    ),
    AppBar(
      title: Text("Keranjang",
      style: kCalibriBold),
      centerTitle: true,
      backgroundColor: kBlueMainColor,
      elevation: 0,
    ),
    AppBar(
      title: Text("Mail",
      style: kCalibriBold,),
      centerTitle: true,
      backgroundColor: kBlueMainColor,
      elevation: 0,
    ),
    AppBar(
      elevation: 0,
      toolbarHeight: 0,
      backgroundColor: kBlueMainColor,
    ),
  ];

  //Placeholder sementara
  List<String> listDrawer = ['Home', 'Profile', 'Produk Saya', 'Logout'];
  String searchQuery = '';
  bool onSearch = false;
  Widget appBarTitle = Text('Home');
  IconData actionIcon = Icons.search;
  int selectedIndex;

  //For saving the page key and state
  final PageStorageBucket bucket = PageStorageBucket();

  //Customizeable appbar untuk merebuild page jika icon ditekan
  //Tidak digunakan kalau searchnya di body
  AppBar appBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.blueAccent,
      leading: FlatButton(
        onPressed: () {
          // Provider.of<Auth>(context, listen: false).signOut(context, );
        },
        child: Icon(Icons.exit_to_app),
      ),
      title: appBarTitle,
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(actionIcon),
          onPressed: () {
            appBarStateChange();
          },
        ),
      ],
    );
  }

  void appBarStateChange() {
    //Memulai search
    setState(() {
      onSearch = true;
      if (actionIcon == Icons.search) {
        actionIcon = Icons.close;
        appBarTitle = Padding(
          padding: const EdgeInsets.all(3),
          child: Container(
            width: double.infinity,
            child: TextField(
              onChanged: (searchText) {
                setState(() {
                  searchQuery = searchText;
                });
              },
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.blueAccent[100],
                  contentPadding: EdgeInsets.fromLTRB(10, 0, 5, 0),
                  hintText: 'Search'),
            ),
          ),
        );
      } else {
        //Mengakhiri search
        onSearch = false;
        actionIcon = Icons.search;
        appBarTitle = Text('Home');
        searchQuery = '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var _auth = Provider.of<Auth>(context, listen: false);
    selectedIndex = Provider.of<MenuState>(context).menuSelected;
    return MultiProvider(
      providers: [
        Provider<ItemService>(
            create: (context) => ItemService(
                  uid: _auth.getUser.uid,
                )),
        // ProxyProvider<Auth, Account>(
        //   //Provider for user information
        //   create: (context) => _auth.getUserInfo,
        //   update: (context, auth, account) => auth.getUserInfo,
        // ),
        StreamProvider<List<Item>>(
          create: (context) => ItemService(
            uid: _auth.getUser.uid,
          ).getItemsWithStatus([1]),
          updateShouldNotify: (_, __) => true,
        ),
        
      ],
      child: Scaffold(
          //Appbar sementara
          appBar: _listAppbar[selectedIndex],
          body: PageStorage(bucket: bucket, child: _listPage[selectedIndex]),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.grey,
            backgroundColor: kBlueMainColor,
            items: _bottomNavBarItem,
            currentIndex: selectedIndex,
            onTap: (index) {
              setState(() {
                Provider.of<MenuState>(context, listen: false).menuSelected =
                    index;
              });
            },
          )),
    );
  }
}
