import 'package:flutter/material.dart';

class MenuState with ChangeNotifier{

  int menuSelected;

  MenuState({this.menuSelected});

  void setMenuSelected(int newMenuSelected){
    menuSelected = newMenuSelected;
    notifyListeners();
  }

}