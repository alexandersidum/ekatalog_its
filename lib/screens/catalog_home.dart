import 'package:e_catalog/models/item.dart';
import 'package:e_catalog/models/account.dart';
import 'package:e_catalog/screens/cart_screen.dart';
import 'package:e_catalog/screens/item_catalog.dart';
import 'package:e_catalog/screens/market.dart';
import 'package:e_catalog/screens/profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_catalog/auth.dart';
import 'package:e_catalog/utilities/database.dart';
import 'package:e_catalog/constants.dart';
import 'playground.dart';

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
    BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('Home')),
    BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), title: Text('Cart')),
    BottomNavigationBarItem(icon: Icon(Icons.shopping_basket), title: Text('Market')),
    BottomNavigationBarItem(icon: Icon(Icons.account_circle), title: Text('Profile')),
  ];

  List<Widget> _listPage = [
    ItemCatalog(
      key: PageStorageKey('catalog'),
    ),
    CartScreen(
      key: PageStorageKey('cart')),
    // Market(
    //   key: PageStorageKey('market')),
    Tester(
      key: PageStorageKey('tester')),
    Profile(
      key: PageStorageKey('profile')),
    // ProposalScreen(
    //   key: PageStorageKey('Proposal'))
  ];

  //Placeholder sementara
  List<String> listDrawer = ['Home', 'Profile', 'Produk Saya', 'Logout'];

  String searchQuery = '';
  bool onSearch = false;
  Widget appBarTitle = Text('Home');
  IconData actionIcon = Icons.search;

  int selectedIndex = 0;

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
          Provider.of<Auth>(context, listen: false).signOut(context);
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
    return MultiProvider(
      providers: [
        Provider<Database>(
            create: (context) => Database(
                  uid: _auth.getUser.uid,
                )),
        ProxyProvider<Auth,Account>(
          //Provider for user information
          create: (context) => _auth.getUserInfo,
          update: (context, auth, account)=>auth.getUserInfo,
        ),
        StreamProvider<List<Item>>(
          create: (context) => Database(
            uid: _auth.getUser.uid,
          ).getItems(),
          updateShouldNotify: (_,__)=>true,
        ),
      ],
      child: Scaffold(
          //Appbar sementara
          appBar: selectedIndex!=0? AppBar(
            // leading: Builder(builder: (context) {
            //   return IconButton(
            //       icon: Icon(Icons.menu),
            //       onPressed: () {
            //         Scaffold.of(context).openDrawer();
            //       });
            // }),
            title: Text("eKatalog ITS"),
            centerTitle: true,
            backgroundColor: kBlueMainColor,
            elevation: 0,
          ):AppBar(
            toolbarHeight: 0,
            backgroundColor: kBlueMainColor,
          ),
          // drawer: NavDrawer(listDrawer: listDrawer),
          body: PageStorage(bucket: bucket, child: _listPage[selectedIndex]),

          //Masih coba2
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.grey,
            backgroundColor: kBlueMainColor,
            items: _bottomNavBarItem,
            currentIndex: selectedIndex,
            onTap: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
          )
          ),
    );
  }
}

class NavDrawer extends StatelessWidget {
  const NavDrawer({
    Key key,
    @required this.listDrawer,
  }) : super(key: key);

  final List<String> listDrawer;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
          child: Column(
        children: [
          UserAccountsDrawerHeader(
              arrowColor: Colors.white,
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
              ),
              accountName: Text(Provider.of<Auth>(context).getUser.email),
              accountEmail: Text('placeholder@email.com')),
          Expanded(
            child: ListView.builder(
                itemCount: listDrawer.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(listDrawer[index]),
                    trailing: Icon(Icons.arrow_right),
                  );
                }),
          ),
        ],
      )),
    );
  }
}
