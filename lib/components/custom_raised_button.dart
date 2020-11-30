import 'package:flutter/material.dart';

class CustomRaisedButton extends StatelessWidget {
  
  String text;
  Function callback;
  Color color;
  CustomRaisedButton({this.text, this.callback, this.color});
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal:20, vertical: 8),
      child: Material(
        color: color,
        elevation: 2,
        borderRadius: BorderRadius.circular(5),
        child: MaterialButton(
          height: MediaQuery.of(context).size.height/15,
          onPressed: callback,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children : <Widget>[
              Expanded(
                flex: 5,
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    letterSpacing: 2,
                    fontSize: 15,
                    color: Colors.white
                  ),
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}