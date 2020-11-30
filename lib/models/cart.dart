import 'package:e_catalog/models/item.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class Cart with ChangeNotifier {
  List<CartItem> cartList = [];

  void addToCart(Item item, int count) {
    if(count<=0) { 
      return;
    }
    var existingItem = cartList.singleWhere((element) => element.item == item,
        orElse: () => null);
    if (existingItem != null) {
      existingItem.count += count;
    } else {
      var cartItem = CartItem(item, count);
      cartList.add(cartItem);
    }
    notifyListeners();
  }

  void deleteItemCart(CartItem item) {
    cartList.remove(item);
    notifyListeners();
  }

  void updateCount(CartItem selectedItem, int count) {
    if (count <= 0) {
    } else {
      var selected = cartList.singleWhere((element) => element == selectedItem);
      selected.count = count;
    }
    notifyListeners();
  }
}

class CartItem {
  Item item;
  int count;

  CartItem(this.item, this.count);

  void addCount() => count++;
  void minCount() => count > 1 ? count-- : null;
}
