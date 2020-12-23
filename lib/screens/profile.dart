import 'package:e_catalog/constants.dart';
import 'package:e_catalog/models/account.dart';
import 'package:e_catalog/screens/role_menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_catalog/auth.dart';

class Profile extends StatelessWidget {
  const Profile({Key key}) : super(key: key);
  //TODO additional info untuk setiap Role

  Widget additionalInfo(Account accountInfo, Size size) {
    String info = '';
    switch (accountInfo.role) {
      case 0:
        info = "Pengunjung";
        break;
      case 1:
        info = (accountInfo as PejabatPengadaan).getUnit;
        break;
      case 2:
        info = (accountInfo as Seller).namaPerusahaan;
        break;
      case 3:
        info = (accountInfo as PejabatPembuatKomitmen).getUnit;
        break;
      case 4:
        info = "Unit Kerja Pengadaan Barang dan Jasa";
        break;
      case 5:
        info = "Auditor";
        break;
      case 6:
        info = (accountInfo as BendaharaPengeluaran).getUnit;
        break;
      default:
        info = "Pengunjung";
    }
    return Container(
      alignment: Alignment.centerLeft,
      width: size.width/2,
      child: FittedBox(
        fit:BoxFit.scaleDown ,
        child: Text(info,
            style:
                kCalibri.copyWith(fontSize: size.height / 40, color: Colors.white)),
      ),
    );
  }

  Widget roleMenu(int role, Function goRoleMenu) {
    //TODO Navigate ke menunya masing2
    String menuText='';

    switch (role) {
      case 0:
        return SizedBox();
        break;
      case 1:
        menuText='Menu PP';
        break;
      case 2:
        menuText='Menu Penyedia';
        break;
      case 3:
        menuText='Menu PPK';
        break;
      case 4:
        menuText='Menu UKPBJ';
        break;
      case 5:
        menuText='Menu Audit';
        break;
      case 6:
        menuText='Menu BPP';
        break;
      default:
        return SizedBox();
    }
    return ListTile(
          leading: Icon(Icons.menu),
          title: Text(menuText,
                    style: kCalibri),
          trailing: Icon(Icons.keyboard_arrow_right),
          onTap: goRoleMenu
        );
  }

  @override
  Widget build(BuildContext context) {
    var accountInfo = Provider.of<Auth>(context).getUserInfo;
    var size = MediaQuery.of(context).size;
    return Container(
        color: kBlueMainColor,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                  vertical: size.height / 40, horizontal: size.width / 40),
              decoration: BoxDecoration(color: kBlueMainColor),
              height: size.height * 0.2,
              child: Row(
                children: [
                  SizedBox(
                    width: size.width / 15,
                  ),
                  Container(
                    height: size.height / 8,
                    child: CircleAvatar(
                      radius: size.height / 17,
                      backgroundColor: kOrangeButtonColor,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(accountInfo.imageUrl),
                        radius: size.height / 18,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: size.width / 20,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        accountInfo.name,
                        style: kCalibriBold.copyWith(
                            color: Colors.white, fontSize: size.height / 30),
                      ),
                      Text(
                        accountInfo.getRole,
                        style: kCalibriBold.copyWith(
                            color: kOrangeButtonColor,
                            fontSize: size.height / 40),
                      ),
                      additionalInfo(accountInfo, size)
                    ],
                  )
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(top: size.height / 20),
                decoration: BoxDecoration(
                    color: kBackgroundMainColor,
                    borderRadius: BorderRadius.vertical(
                        top: Radius.circular(size.height / 20))),
                child: ListView(
                    children: ListTile.divideTiles(context: context, tiles: [
                  roleMenu(accountInfo.role, (){
                    Navigator.of(context).pushNamed(RoleMenu.routeId);
                  }),
                  ListTile(
                    leading: Icon(Icons.account_circle),
                    title: Text('Pengaturan Akun',
                    style: kCalibri,),
                    trailing: Icon(Icons.keyboard_arrow_right),
                  ),
                  ListTile(
                    leading: Icon(Icons.help),
                    title: Text('Bantuan',
                    style: kCalibri),
                    trailing: Icon(Icons.keyboard_arrow_right),
                  ),
                  ListTile(
                      leading: Icon(Icons.exit_to_app),
                      title: Text('Logout',
                    style: kCalibri),
                      trailing: Icon(Icons.keyboard_arrow_right),
                      onTap: () {
                        Provider.of<Auth>(context, listen: false)
                            .signOut(context);
                      }),
                ]).toList()),
              ),
            ),
          ],
        ));
  }
}
