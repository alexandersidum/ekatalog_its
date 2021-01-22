
import 'package:flutter/cupertino.dart';

class ItemSearch with ChangeNotifier{
  //Mode 0 = Kategori , 1 = Search
  int mode;
  String keyword;
  ItemSearch({this.keyword, this.mode});

  void setKeyword(String newKeyword){
    keyword = newKeyword;
    notifyListeners();
  }

  void setMode(int newMode){
    mode = newMode;
    notifyListeners();
  }

  String getInfo(){
    return 
    this.mode == 1? "Hasil Pencarian dari '${this.keyword}'"
    : "Produk dalam kategori ${this.keyword}";

  }

}

