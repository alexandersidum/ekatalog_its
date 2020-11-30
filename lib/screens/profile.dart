import 'package:flutter/material.dart';

class Profile extends StatelessWidget {

  const Profile({Key key}) : super(key : key);

  @override
  Widget build(BuildContext context) {
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
              ListTile(
                leading: Icon(
                  Icons.add_shopping_cart
                ),
                title: Text(
                  'Seller Section'
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.group
                ),
                title: Text(
                  'Admin Section'
                ),
              ),
            ]
          ).toList()
        
      )
    );
  }
}