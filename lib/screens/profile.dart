import 'package:e_catalog/models/account.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_catalog/auth.dart';

class Profile extends StatelessWidget {

  const Profile({Key key}) : super(key : key);

  @override
  Widget build(BuildContext context) {
    var accountInfo = Provider.of<Account>(context);
    return Container(
      child: ListView(
        children: ListTile.divideTiles(
            context: context,
            tiles: [
              ListTile(
                leading: Icon(
                  Icons.account_circle,
                ),
                title: Text(
                  'Account'
                ),
              ),
              accountInfo.role==1?
              ListTile(
                leading: Icon(
                  Icons.add_shopping_cart
                ),
                title: Text(
                  'Seller Section'
                ),
              ):accountInfo.role==2?
              ListTile(
                leading: Icon(
                  Icons.group
                ),
                title: Text(
                  'PP Section'
                ),
              ):null,
              ListTile(
                leading: Icon(
                  Icons.exit_to_app
                ),
                title: Text(
                  'Signout'
                ),
                onTap: (){
                  Provider.of<Auth>(context, listen: false).signOut(context);
                }
              ),
            ]
          ).toList()
        
      )
    );
  }
}