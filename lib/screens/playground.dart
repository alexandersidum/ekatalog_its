import 'package:e_catalog/models/account.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../auth.dart';

//CLASS BUAT NGETEST2 TIDAK PENTING

class Tester extends StatefulWidget {
  Tester({Key key}):super(key: key);
  State<Tester> createState()=> TesterState();

}

class TesterState extends State<Tester>  {
  FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void initState() { 
    super.initState();
  }


  var testText = 'Belum';

  @override
  Widget build(BuildContext context) {
    return Center(child: 
    Text(Provider.of<Auth>(context).getUserInfo.name),
    );
    
}}