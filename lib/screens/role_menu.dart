import 'package:e_catalog/models/account.dart';
import 'package:e_catalog/models/sales_order.dart';
import 'package:e_catalog/models/menu_state.dart';
import 'package:e_catalog/models/cart.dart';
import 'package:e_catalog/screens/add_product_screen.dart';
import 'package:e_catalog/screens/admin_screen/manage_category_screen.dart';
import 'package:e_catalog/screens/admin_screen/manage_user_screen.dart';
import 'package:e_catalog/screens/bpp_screen/pembayaran_screen.dart';
import 'package:e_catalog/screens/penyedia_screen/negotiation_screen_penyedia.dart';
import 'package:e_catalog/screens/penyedia_screen/pembayaran_screen_penyedia.dart';
import 'package:e_catalog/screens/penyedia_screen/product_screen.dart';
import 'package:e_catalog/screens/penyedia_screen/rekening_screen.dart';
import 'package:e_catalog/screens/penyedia_screen/sales_order_penyedia.dart';
import 'package:e_catalog/screens/pp_screen/order_confirmation.dart';
import 'package:e_catalog/screens/ppk_screen/quotation_screen.dart';
import 'package:e_catalog/screens/ppk_screen/sales_order_screen_ppk.dart';
import 'package:e_catalog/screens/ukpbj_screen/laporan_screen.dart';
import 'package:e_catalog/screens/ukpbj_screen/manage_product.dart';
import 'package:e_catalog/screens/ukpbj_screen/negotiation_screen.dart';
import 'package:e_catalog/utilities/order_services.dart';
import 'package:flutter/material.dart';
import 'package:e_catalog/constants.dart';
import 'package:provider/provider.dart';
import '../auth.dart';
import 'admin_screen/user_pending_screen.dart';

class RoleMenu extends StatelessWidget {
  static const routeId = 'RoleMenu';

  @override
  Widget build(BuildContext context) {
    Account account = Provider.of<Auth>(context).getUserInfo;
    int role = Provider.of<Auth>(context).getUserInfo.role;
    String roleDesc = Provider.of<Auth>(context).getUserInfo.getRole;
    return Scaffold(
      backgroundColor: kBackgroundMainColor,
      appBar: AppBar(
        title: Text("Menu $roleDesc", style: kCalibriBold),
        centerTitle: false,
        backgroundColor: kBlueMainColor,
        elevation: 0,
      ),
      body: Container(
        child: roleMenuList(role, context, account),
      ),
    );
  }

  Widget roleMenuList(int role, BuildContext context, Account account) {
    Size size = MediaQuery.of(context).size;
    switch (role) {
      case 0:
        return SizedBox();
        break;
      case 1:
        return OrderConfirmationPP();
        break;
      case 2:
        return MenuPenyedia(size: size, account: account as Seller);
        break;
      case 3:
        return MenuPPK(size: size);
        break;
      case 4:
        return MenuUKPBJ(
          size: size,
        );
        break;
      case 5:
        return Column();
        break;
      case 6:
        return MenuBPP(
          size: size,
        );
        break;
      case 9:
        return MenuAdmin(
          size: size,
        );
        break;
      default:
        return SizedBox();
    }
  }
}

class MenuPenyedia extends StatelessWidget {
  const MenuPenyedia({Key key, @required this.size, this.account})
      : super(key: key);

  final Size size;
  final Seller account;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(
                  top: size.height / 40,
                  left: size.width / 30,
                  bottom: size.height / 100),
              alignment: Alignment.centerLeft,
              child: Text(
                'Produk',
                style: kCalibriBold,
              ),
            ),
            Container(
              color: Colors.white,
              child: Column(
                  children: ListTile.divideTiles(context: context, tiles: [
                ListTile(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ProductScreenPenyedia()));
                  },
                  title: Text(
                    'Produk Saya',
                    style: kCalibri,
                  ),
                  trailing: Icon(Icons.keyboard_arrow_right),
                ),
                ListTile(
                  onTap: () {
                    Navigator.of(context).pushNamed(AddProductScreen.routeId);
                  },
                  title: Text('Tambah Produk', style: kCalibri),
                  trailing: Icon(Icons.keyboard_arrow_right),
                ),
                ListTile(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => NegotationScreenPenyedia()));
                  },
                  title: Text('Negosiasi Produk', style: kCalibri),
                  trailing: Icon(Icons.keyboard_arrow_right),
                ),
              ]).toList()),
            ),
            Container(
              padding: EdgeInsets.only(
                  top: size.height / 40,
                  left: size.width / 30,
                  bottom: size.height / 100),
              alignment: Alignment.centerLeft,
              child: Text(
                'Penjualan',
                style: kCalibriBold,
              ),
            ),
            Container(
              color: Colors.white,
              child: Column(
                  children: ListTile.divideTiles(context: context, tiles: [
                ListTile(
                  title: Text(
                    'Riwayat Penjualan',
                    style: kCalibri,
                  ),
                  trailing: Icon(Icons.keyboard_arrow_right),
                ),
                ListTile(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SalesOrderPenyedia()));
                  },
                  title: Text('Sales Order', style: kCalibri),
                  trailing: Icon(Icons.keyboard_arrow_right),
                ),
              ]).toList()),
            ),
            Container(
              padding: EdgeInsets.only(
                  top: size.height / 40,
                  left: size.width / 30,
                  bottom: size.height / 100),
              alignment: Alignment.centerLeft,
              child: Text(
                'Pembayaran',
                style: kCalibriBold,
              ),
            ),
            Container(
              color: Colors.white,
              child: Column(
                  children: ListTile.divideTiles(context: context, tiles: [
                ListTile(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => StreamProvider<List<SalesOrder>>(
                              create: (context) => OrderServices()
                                  .getSellerSalesOrder(account.uid, [7, 8, 9]),
                              updateShouldNotify: (_, __) => true,
                              child: PembayaranScreenPenyedia(),
                            )));
                  },
                  title: Text(
                    'Pembayaran',
                    style: kCalibri,
                  ),
                  trailing: Icon(Icons.keyboard_arrow_right),
                ),
                ListTile(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => RekeningPenyediaScreen(
                            seller: Provider.of<Auth>(context).getUserInfo)));
                  },
                  title: Text('Atur Rekening Pembayaran', style: kCalibri),
                  trailing: Icon(Icons.keyboard_arrow_right),
                ),
              ]).toList()),
            ),
            Container(
              margin: EdgeInsets.only(
                  top: size.height / 40,
                  left: size.width / 30,
                  bottom: size.height / 100),
              alignment: Alignment.centerLeft,
              child: Text(
                'Bantuan',
                style: kCalibriBold,
              ),
            ),
            Container(
              color: Colors.white,
              child: Column(
                  children: ListTile.divideTiles(context: context, tiles: [
                ListTile(
                  title: Text(
                    'Kontak Bantuan',
                    style: kCalibri,
                  ),
                  trailing: Icon(Icons.keyboard_arrow_right),
                ),
                ListTile(
                  title: Text(
                    'Logout',
                    style: kCalibri,
                  ),
                  onTap: () {
                    Provider.of<Auth>(context, listen: false).signOut(context,
                        () {
                      Provider.of<MenuState>(context, listen: false)
                          .setMenuSelected(0);
                      Provider.of<Cart>(context, listen: false).clearCart();
                    });
                  },
                  trailing: Icon(Icons.keyboard_arrow_right),
                )
              ]).toList()),
            ),
          ],
        ),
      ),
    );
  }
}

class MenuPPK extends StatelessWidget {
  const MenuPPK({
    Key key,
    @required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    var ppk = Provider.of<Auth>(context).getUserInfo as PejabatPembuatKomitmen;
    return Container(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(
                top: size.height / 40,
                left: size.width / 30,
                bottom: size.height / 100),
            alignment: Alignment.centerLeft,
            child: Text(
              'Pengadaan',
              style: kCalibriBold,
            ),
          ),
          Container(
            color: Colors.white,
            child: Column(
                children: ListTile.divideTiles(context: context, tiles: [
              ListTile(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => StreamProvider<List<SalesOrder>>(
                            create: (context) => OrderServices()
                                .getSalesOrder(unit: ppk.unit, status: [0]),
                            updateShouldNotify: (_, __) => true,
                            child: QuotationScreen(),
                          )));
                },
                title: Text(
                  'Quotation',
                  style: kCalibri,
                ),
                trailing: Icon(Icons.keyboard_arrow_right),
              ),
              ListTile(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => StreamProvider<List<SalesOrder>>(
                            create: (context) => OrderServices().getSalesOrder(
                                unit: ppk.unit,
                                status: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
                                //TODO LIMIT DOCUMENT
                                ),
                            updateShouldNotify: (_, __) => true,
                            child: SalesOrderPPK(),
                          )));
                },
                title: Text('Sales Order', style: kCalibri),
                trailing: Icon(Icons.keyboard_arrow_right),
              ),
            ]).toList()),
          ),
          Container(
            margin: EdgeInsets.only(
                top: size.height / 40,
                left: size.width / 30,
                bottom: size.height / 100),
            alignment: Alignment.centerLeft,
            child: Text(
              'Bantuan',
              style: kCalibriBold,
            ),
          ),
          Container(
            color: Colors.white,
            child: Column(
                children: ListTile.divideTiles(context: context, tiles: [
              ListTile(
                title: Text(
                  'Kontak Bantuan',
                  style: kCalibri,
                ),
                trailing: Icon(Icons.keyboard_arrow_right),
              ),
              ListTile(
                  title: Text(
                    'Logout',
                    style: kCalibri,
                  ),
                  onTap: () {
                    Provider.of<Auth>(context, listen: false).signOut(context,
                        () {
                      Provider.of<MenuState>(context, listen: false)
                          .setMenuSelected(0);
                      Provider.of<Cart>(context, listen: false).clearCart();
                    });
                  },
                  trailing: Icon(Icons.exit_to_app),
                )
            ]).toList()),
          ),
        ],
      ),
    );
  }
}

class MenuUKPBJ extends StatelessWidget {
  const MenuUKPBJ({
    Key key,
    @required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(
                top: size.height / 40,
                left: size.width / 30,
                bottom: size.height / 100),
            alignment: Alignment.centerLeft,
            child: Text(
              'Produk',
              style: kCalibriBold,
            ),
          ),
          Container(
            color: Colors.white,
            child: Column(
                children: ListTile.divideTiles(context: context, tiles: [
              ListTile(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ManageProduct(
                            initialTab: 1,
                          )));
                },
                title: Text('Produk Pending', style: kCalibri),
                trailing: Icon(Icons.keyboard_arrow_right),
              ),
              ListTile(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ManageProduct(
                            initialTab: 0,
                          )));
                },
                title: Text('Manage Produk', style: kCalibri),
                trailing: Icon(Icons.keyboard_arrow_right),
              ),
              ListTile(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => NegotationScreenPPK()));
                },
                title: Text('Negosiasi Produk', style: kCalibri),
                trailing: Icon(Icons.keyboard_arrow_right),
              ),
            ]).toList()),
          ),
          Container(
            padding: EdgeInsets.only(
                top: size.height / 40,
                left: size.width / 30,
                bottom: size.height / 100),
            alignment: Alignment.centerLeft,
            child: Text(
              'Analisis',
              style: kCalibriBold,
            ),
          ),
          Container(
            color: Colors.white,
            child: Column(
                children: ListTile.divideTiles(context: context, tiles: [
              ListTile(
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => LaporanScreen()));
                },
                title: Text(
                  'Laporan Pengadaan Ekatalog',
                  style: kCalibri,
                ),
                trailing: Icon(Icons.keyboard_arrow_right),
              ),
            ]).toList()),
          ),
          Container(
            margin: EdgeInsets.only(
                top: size.height / 40,
                left: size.width / 30,
                bottom: size.height / 100),
            alignment: Alignment.centerLeft,
            child: Text(
              'Bantuan',
              style: kCalibriBold,
            ),
          ),
          Container(
            color: Colors.white,
            child: Column(
                children: ListTile.divideTiles(context: context, tiles: [
              ListTile(
                title: Text(
                  'Kontak Bantuan',
                  style: kCalibri,
                ),
                trailing: Icon(Icons.keyboard_arrow_right),
              )
            ]).toList()),
          ),
        ],
      ),
    );
  }
}

class MenuBPP extends StatelessWidget {
  const MenuBPP({
    Key key,
    @required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    var bpp = Provider.of<Auth>(context).getUserInfo as BendaharaPengeluaran;
    return Container(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(
                top: size.height / 40,
                left: size.width / 30,
                bottom: size.height / 100),
            alignment: Alignment.centerLeft,
            child: Text(
              'Pembayaran',
              style: kCalibriBold,
            ),
          ),
          Container(
            color: Colors.white,
            child: Column(
                children: ListTile.divideTiles(context: context, tiles: [
              ListTile(
                onTap: () {
                  //Navigate ke Pembayaran
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => PembayaranScreen()));
                },
                title: Text('Pembayaran', style: kCalibri),
                trailing: Icon(Icons.keyboard_arrow_right),
              ),
              ListTile(
                onTap: () {
                  
                },
                title: Text('Riwayat Pembayaran', style: kCalibri),
                trailing: Icon(Icons.keyboard_arrow_right),
              ),
            ]).toList()),
          ),
          Container(
            padding: EdgeInsets.only(
                top: size.height / 40,
                left: size.width / 30,
                bottom: size.height / 100),
            alignment: Alignment.centerLeft,
            child: Text(
              'Bantuan',
              style: kCalibriBold,
            ),
          ),
          Container(
            color: Colors.white,
            child: Column(
                children: ListTile.divideTiles(context: context, tiles: [
              ListTile(
                title: Text(
                  'Kontak Bantuan',
                  style: kCalibri,
                ),
                trailing: Icon(Icons.keyboard_arrow_right),
              ),
              ListTile(
                  title: Text(
                    'Logout',
                    style: kCalibri,
                  ),
                  onTap: () {
                    Provider.of<Auth>(context, listen: false).signOut(context,
                        () {
                      Provider.of<MenuState>(context, listen: false)
                          .setMenuSelected(0);
                      Provider.of<Cart>(context, listen: false).clearCart();
                    });
                  },
                  trailing: Icon(Icons.exit_to_app),
                )
            ]).toList()),
          ),
        ],
      ),
    );
  }
}

class MenuAdmin extends StatelessWidget {
  const MenuAdmin({
    Key key,
    @required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    var admin = Provider.of<Auth>(context).getUserInfo as Admin;
    return Container(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(
                top: size.height / 40,
                left: size.width / 30,
                bottom: size.height / 100),
            alignment: Alignment.centerLeft,
            child: Text(
              'Kelola User',
              style: kCalibriBold,
            ),
          ),
          Container(
            color: Colors.white,
            child: Column(
                children: ListTile.divideTiles(context: context, tiles: [
              ListTile(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => UserPendingScreen()));
                },
                title: Text(
                  'User Pending',
                  style: kCalibri,
                ),
                trailing: Icon(Icons.keyboard_arrow_right),
              ),
              ListTile(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ManageUserScreen()));
                },
                title: Text('Manage User', style: kCalibri),
                trailing: Icon(Icons.keyboard_arrow_right),
              ),
            ]).toList()),
          ),
          Container(
            margin: EdgeInsets.only(
                top: size.height / 40,
                left: size.width / 30,
                bottom: size.height / 100),
            alignment: Alignment.centerLeft,
            child: Text(
              'Kelola Produk',
              style: kCalibriBold,
            ),
          ),
          Container(
            color: Colors.white,
            child: Column(
                children: ListTile.divideTiles(context: context, tiles: [
              ListTile(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ManageCategoryScreen()));
                },
                title: Text(
                  'Manage Kategori Barang',
                  style: kCalibri,
                ),
                trailing: Icon(Icons.keyboard_arrow_right),
              )
            ]).toList()),
          ),
          Container(
            margin: EdgeInsets.only(
                top: size.height / 40,
                left: size.width / 30,
                bottom: size.height / 100),
            alignment: Alignment.centerLeft,
            child: Text(
              'Other',
              style: kCalibriBold,
            ),
          ),
          Container(
            color: Colors.white,
            child: ListTile(
              title: Text(
                'Logout',
                style: kCalibri,
              ),
              onTap: () {
                Provider.of<Auth>(context, listen: false).signOut(context, () {
                  Provider.of<MenuState>(context, listen: false)
                      .setMenuSelected(0);
                  Provider.of<Cart>(context, listen: false).clearCart();
                });
              },
              trailing: Icon(Icons.exit_to_app),
            ),
          )
        ],
      ),
    );
  }
}
