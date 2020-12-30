import 'package:e_catalog/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final TextInputType keyboardType;
  final IconData iconData;
  final String hintText;
  final Color color;
  final TextEditingController controller;
  final bool isObscure;
  final Function callback;
  final int maxLine;
  final int maxLength;
  final TextInputAction textInputAction;

  CustomTextField({this.textInputAction, this.keyboardType = TextInputType.text, this.iconData, this.color=Colors.white, this.hintText='...', this.controller, this.isObscure = false, this.callback, this.maxLine, this.maxLength});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
        
        textInputAction: textInputAction!=null?textInputAction:TextInputAction.done,
        style: kCalibri,
        maxLines: maxLine!=null?maxLine:1,
        onChanged: callback,
        controller: controller,
        obscureText: isObscure,
        keyboardType: keyboardType,
        autofocus: false,
        inputFormatters: maxLength!=null?[
          LengthLimitingTextInputFormatter(maxLength)
        ]:[],
        decoration: iconData!=null? InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(iconData),
          hintText: hintText,
          contentPadding: EdgeInsets.only(top:15, left: 10),
          filled: true,
          fillColor: color,
        ) : InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),
            borderSide: BorderSide.none
          ),
          hintText: hintText,
          hintStyle: kCalibri,
          contentPadding: EdgeInsets.only(top:15, left : 10),
          filled: true,
          fillColor: color,
        )
      ),
      
    );
  }
}