import 'package:e_catalog/models/item.dart';
import 'package:flutter/cupertino.dart';

class Cart with ChangeNotifier {
  List<LineItem> cartList = [];

  void addToCart(Item item, int count) {
    if(count<=0) { 
      return;
    }
    var existingItem = cartList.singleWhere((element) => element.item == item,
        orElse: () => null);
    if (existingItem != null) {
      existingItem.count += count;
    } else {
      var cartItem = LineItem(item, count);
      cartList.add(cartItem);
    }
    notifyListeners();
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

  void addCount() => count++;
  void minCount() => count > 1 ? count-- : null;
}
