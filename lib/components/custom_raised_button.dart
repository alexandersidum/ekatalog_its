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
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal:size.width/200),
      child: Material(
        color: color,
        elevation: 2,
        borderRadius: BorderRadius.circular(size.width/100),
        child: MaterialButton(
          height: this.buttonHeight,
          onPressed: callback,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children : <Widget>[
              Expanded(
                flex: 5,
                child: Center(
                  child: buttonChild,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}