import 'package:flutter/material.dart';
import 'package:e_catalog/constants.dart';

class CustomAlertDialog extends StatelessWidget {
  String title;
  String content;
  Function yesFunction;
  Function noFunction;
  CustomAlertDialog({this.title, this.content, this.yesFunction, this.noFunction});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title, style: kCalibriBold,),
      content: Text(content, style: kCalibri),
      actions: [
        
        TextButton(onPressed: (){
          noFunction();
        }, child: Text("Cancel")),
        TextButton(onPressed: (){
          yesFunction();
        }, child: Text("Konfirmasi")),
      ],
      
    );
  }
}