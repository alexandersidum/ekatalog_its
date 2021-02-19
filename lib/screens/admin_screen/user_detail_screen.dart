import 'package:e_catalog/components/photo_detail.dart';
import 'package:e_catalog/constants.dart';
import 'package:e_catalog/models/account.dart';
import "package:flutter/material.dart";
import 'package:cached_network_image/cached_network_image.dart';

class UserDetailScreen extends StatelessWidget {
  Account user;
  UserDetailScreen({this.user});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: kBackgroundMainColor,
      appBar: AppBar(
        title: Text("User Detail", style: kCalibriBold),
        centerTitle: false,
        backgroundColor: kBlueMainColor,
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: size.width / 10),
        child: ListView(
          children: [
            Row(
              children: [
                 Text("Foto :", style: kCalibriBold),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => PhotoDetail(
                              heroTag: "accountImage",
                              imageUrl: user.imageUrl,
                            )));
                  },
                  child: Hero(
                    tag: "accountImage",
                    child: Container(
                      width: size.width / 4,
                      height: size.width / 4,
                      child: CachedNetworkImage(
                        placeholder: (context, url) => Icon(Icons.photo),
                        imageUrl: user.imageUrl,
                        errorWidget: (context, url, err) => Icon(Icons.error),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              children: [
                Expanded(flex: 2, child: Text("Name :", style: kCalibriBold)),
                Expanded(flex: 5, child: Text(user.name, style: kCalibriBold)),
              ],
            ),
            SizedBox(height: size.height / 100),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              children: [
                Expanded(flex: 2, child: Text("Email :", style: kCalibriBold)),
                Expanded(flex: 5, child: Text(user.email, style: kCalibriBold)),
              ],
            ),
            SizedBox(height: size.height / 100),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              children: [
                Expanded(flex: 2, child: Text("No.Telepon :", style: kCalibriBold)),
                Expanded(flex: 5, child: Text(user.telepon, style: kCalibriBold)),
              ],
            ),
            SizedBox(height: size.height / 100),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              children: [
                Expanded(flex: 2, child: Text("Role :", style: kCalibriBold)),
                Expanded(flex: 5, child: Text(user.getRole, style: kCalibriBold)),
              ],
            ),
            SizedBox(height: size.height / 100),
            (user.role==1||user.role==3||user.role==6)?Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              children: [
                Expanded(flex: 2, child: Text(user.role==3?"Divisi :":"Unit :", style: kCalibriBold)),
                Expanded(flex: 5, child: Text(
                  user.role==1?(user as PejabatPengadaan).namaUnit
                  :user.role==3?(user as PejabatPembuatKomitmen).namaDivisi
                  :user.role==7?(user as PejabatPenerima).namaUnit
                  :(user as BendaharaPengeluaran).namaUnit
                  , style: kCalibriBold)),
              ],
            ):
            user.role==2?
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              children: [
                Expanded(flex: 2, child: Text("Nama Perusahaan :", style: kCalibriBold)),
                Expanded(flex: 5, child: Text((user as Seller).namaPerusahaan, style: kCalibriBold)),
              ],
            )
            :SizedBox(),
            user.role==2?
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              children: [
                Expanded(flex: 2, child: Text("Alamat Perusahaan :", style: kCalibriBold)),
                Expanded(flex: 5, child: Text((user as Seller).location, style: kCalibriBold)),
              ],
            )
            :SizedBox(),
          ],
        ),
      ),
    );
  }
}
