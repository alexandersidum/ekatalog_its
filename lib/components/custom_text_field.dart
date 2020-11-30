import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextInputType keyboardType;
  final IconData iconData;
  final String hintText;
  final Color color;
  final TextEditingController controller;
  final bool isObscure;
  final Function callback;

  CustomTextField({this.keyboardType = TextInputType.text, this.iconData, this.color=Colors.white, this.hintText='...', this.controller, this.isObscure = false, this.callback});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      child: TextField(
        onChanged: callback,
        controller: controller,
        obscureText: isObscure,
        keyboardType: keyboardType,
        autofocus: false,
        decoration: iconData!=null? InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(iconData),
          hintText: hintText,
          contentPadding: EdgeInsets.only(top:15, left: 10),
          filled: true,
          fillColor: color,
        ) : InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          contentPadding: EdgeInsets.only(top:15, left : 10),
          filled: true,
          fillColor: color,
        )
      ),
      
    );
  }
}