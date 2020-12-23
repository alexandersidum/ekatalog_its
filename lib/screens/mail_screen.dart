import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_catalog/auth.dart';
import 'package:e_catalog/constants.dart';

class MailScreen extends StatelessWidget {
  MailScreen({Key key}) : super(key: key);

  static const routeId = 'Mail';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top:MediaQuery.of(context).size.height/50),
      child: ListView(
            children: ListTile.divideTiles(context: context, tiles: [
      ListTile(
        leading: Icon(Icons.message),
        title: Text('Pesan', style: kCalibri),
        trailing: Icon(Icons.keyboard_arrow_right),
      ),
      ListTile(
        leading: Icon(Icons.notifications),
        title: Text('Notifikasi', style: kCalibri),
        trailing: Icon(Icons.keyboard_arrow_right),
      ),
    ]).toList()));
  }
}
