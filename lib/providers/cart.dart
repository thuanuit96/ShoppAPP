import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;
  CartItem({
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.price
  });

}
class Cart with ChangeNotifier {
  Map<String,CartItem> _items = {}; 

  Map<String,CartItem> get items {
      return {..._items};
   }

  int get itemCount{
    return  _items != null ? _items.length : 0;
  }

  double get totalAmountItem {
    var total = 0.0;
     this._items.forEach((key, item ) {
       total +=  item.quantity;
     });

    return total;
  }
  double get totalExpense {
    var total = 0.0;
     this._items.forEach((key, item ) {
       total +=  item.quantity * item.price ;
     });

    return total;
  }
  double  totalExpenseByItem (String  itemId) {
    var item = _items.values.toList().firstWhere((element){
      return  element.id == itemId;
    },orElse: () => null
    );

    return item.quantity * item.price;
  }



   void addItem(String productId, double price , String title) {


     if (_items != null && _items.containsKey(productId)){
       //Change quantity
       _items.update(productId, (existingCartItem) {
            return CartItem(id: existingCartItem.id,
                        title: existingCartItem.title,
                        price: existingCartItem.price,
                        quantity: existingCartItem.quantity + 1
                        );

       });
     }else {
       this._items.putIfAbsent(
         productId, 
         () => CartItem(id: DateTime.now().toString(),
                        title: title,
                        price: price,
                        quantity: 1
                        ));
     }
         notifyListeners();

   }
  void removeItem(String productId){
    this._items.remove(productId);
    notifyListeners();
  }

  void removeSigleItem(String productId){

    if (!_items.containsKey(productId)) {
      return;
    }


    if  (_items[productId].quantity > 1) {
      _items.update(productId, (existingCart) =>  CartItem(id: existingCart.id, 
                                                          title: existingCart.title,
                                                          quantity: existingCart.quantity - 1, 
                                                          price: existingCart. price));

    }else {
    this._items.remove(productId);
    }
    notifyListeners();
  }
  void clear () {
    this._items = {};
    notifyListeners();
  }
}

