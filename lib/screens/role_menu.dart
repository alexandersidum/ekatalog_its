import 'package:e_catalog/models/account.dart';
import 'package:e_catalog/models/sales_order.dart';
import 'package:e_catalog/screens/add_product_screen.dart';
import 'package:e_catalog/screens/ppk_screen/quotation_screen.dart';
import 'package:e_catalog/screens/ppk_screen/sales_order_screen_ppk.dart';
import 'package:e_catalog/utilities/order_services.dart';
import 'package:flutter/material.dart';
import 'package:e_catalog/constants.dart';
import 'package:provider/provider.dart';
import '';
import '../auth.dart';

class RoleMenu extends StatelessWidget {
  static const routeId = 'RoleMenu';

  @override
  Widget build(BuildContext context) {
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
        child: roleMenuList(role, context),
      ),
    );
  }

  Widget roleMenuList(int role, BuildContext context) {
    Size size = MediaQuery.of(context).size;
    switch (role) {
      case 0:
        return SizedBox();
        break;
      case 1:
        return Column();
        break;
      case 2:
        return MenuPenyedia(size: size);
        break;
      case 3:
        return MenuPPK(size: size);
        break;
      case 4:
        return Column();
        break;
      case 5:
        return Column();
        break;
      case 5:
        return Column();
        break;
      default:
        return SizedBox();
    }
  }
}

class MenuPenyedia extends StatelessWidget {
  const MenuPenyedia({
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
                title: Text('Sales Order', style: kCalibri),
                trailing: Icon(Icons.keyboard_arrow_right),
              ),
              ListTile(
                title: Text('Pembayaran', style: kCalibri),
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

class MenuPPK extends StatelessWidget {
  const MenuPPK({
    Key key,
    @required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    var ppk = Provider.of<Auth>(context).getUserInfo as PejabatPembuatKomitmen;
    return StreamProvider<List<SalesOrder>>(
      //Unit dari ppk seharusnya list
      create: (context) => OrderServices().getSalesOrder(ppk.unit),
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
                      builder: (context)=>StreamProvider<List<SalesOrder>>(
                        create: (context) => OrderServices().getSalesOrder(ppk.unit),
                        updateShouldNotify: (_,__)=>true,
                        child: QuotationScreen(),)));
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
                      builder: (context)=>StreamProvider<List<SalesOrder>>(
                        create: (context) => OrderServices().getSalesOrder(ppk.unit),
                        updateShouldNotify: (_,__)=>true,
                        child: SalesOrderPPK(),)));
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
                )
              ]).toList()),
            ),
          ],
        ),
      ),
    );
  }
}
