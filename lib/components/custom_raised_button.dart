import 'package:e_catalog/constants.dart';
import 'package:flutter/material.dart';

class CustomRaisedButton extends StatelessWidget {
  
  String text;
  Function callback;
  Color color;
  Widget buttonChild;
  double buttonHeight;
  CustomRaisedButton({this.text, this.callback, this.color, this.buttonChild, this.buttonHeight});
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal:10),
      child: Material(
        color: color,
        elevation: 2,
        borderRadius: BorderRadius.circular(15),
        child: MaterialButton(
          height: this.buttonHeight,
          onPressed: callback,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children : <Widget>[
              Expanded(
                flex: 5,
                child: buttonChild,
              ),
            ],
          ),
        ),
      ),
    );
  }
}