import 'package:e_catalog/models/item.dart';
import 'package:flutter/cupertino.dart';

class Cart with ChangeNotifier {
  List<LineItem> cartList = [];

  void addToCart(Item item, int count) {
    if(count<=0) { 
      return;
    }
    var existingItem = cartList.singleWhere((element) => element.item.id == item.id,
        orElse: () => null);
    if (existingItem != null) {
      existingItem.changeCount(existingItem.count+=count);
    } else {
      var cartItem = LineItem(item, count);
      cartList.add(cartItem);
    }
    notifyListeners();
  }

  int countTotalPrice(){
    if(cartList.isEmpty){
      return 0;
    }
    else{
      double output = 0;
      cartList.forEach((e) { 
        output += (e.item.price*e.count)*(1+e.item.taxPercentage/100);
      });
      return output.round();
    }
  }

  void deleteItemCart(LineItem item) {
    cartList.remove(item);
    notifyListeners();
  }

  void clearCart(){
    cartList.clear();
    notifyListeners();
  }

  void updateCount(LineItem selectedItem, int count) {
    if (count <= 0) {
    } else {
      var selected = cartList.singleWhere((element) => element == selectedItem);
      selected.count = count;
    }
    notifyListeners();
  }
}

class LineItem {
  Item item;
  int count;

  LineItem(this.item, this.count);

  void changeCount(int count) => this.count = count;
  void addCount() => count++;
  void minCount() => count > 1 ? count-- : null;
}
