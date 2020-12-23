import 'package:e_catalog/screens/add_product_screen.dart';
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
        return Column(
        );
        break;
      case 2:
        return Container(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: size.height/40, left: size.width/30, bottom: size.height/100),
                alignment: Alignment.centerLeft,
                child: Text('Produk',
                style: kCalibriBold,),
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
                    onTap: (){
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
                padding: EdgeInsets.only(top: size.height/40, left: size.width/30, bottom: size.height/100),
                alignment: Alignment.centerLeft,
                child: Text('Penjualan',
                style: kCalibriBold,),
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
                margin: EdgeInsets.only(top: size.height/40, left: size.width/30, bottom: size.height/100),
                alignment: Alignment.centerLeft,
                child: Text('Bantuan',
                style: kCalibriBold,),
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
        break;
      case 3:
        return Column(
        );
        break;
      case 4:
        return Column(
        );
        break;
      case 5:
        return Column(
        );
        break;
      case 5:
        return Column(
        );
        break;
      default:
        return SizedBox();
    }
  }
}
