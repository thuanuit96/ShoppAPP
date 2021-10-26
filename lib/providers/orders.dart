import 'dart:convert';

import 'package:flutter/foundation.dart';
import './cart.dart';
import 'package:http/http.dart' as http;


class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;
  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime
  });

}
class Orders with ChangeNotifier {
   String authToken;
  String userId;

  Orders(this.authToken,this.userId,this._orders);
  List<OrderItem>  _orders = [];


  List<OrderItem> get orders {
      return [... _orders];
   }


Future<void> fetchAndSetOrders()  async {
    final url = Uri.parse('https://shopapp-fb84c-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken');
    final rp =  await http.get(url);
    final extractedData = json.decode(rp.body) as Map<String,dynamic>;

    final List<OrderItem> loadedOrders = [];
    print("extractedData :$extractedData");
        extractedData?.forEach((orderId, orderData) {
          loadedOrders.add(OrderItem(
            id: orderId,
            amount: orderData['amount'],
            dateTime: DateTime.parse(orderData['datetime']),
            products: (orderData['products'] as List<dynamic>).map((item) => CartItem(id: item["id"],
                                                                                      title: item["title"], 
                                                                                      quantity: item['quantity'], 
                                                                                      price: item['price'])
                                                                                      ).toList()
                                                                                      
          ));

         });
         this._orders = loadedOrders.reversed.toList();
          notifyListeners();

}

   void addOrder(List <CartItem>  products , double total )  async {
      final url = Uri.parse('https://shopapp-fb84c-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken');
      final timeStamp = DateTime.now();

      final value = {
         'amount' : total,
          'datetime' : timeStamp.toIso8601String(),
          "products" : products.map((cp) => 
            {
                "id" : cp.id,
                "title": cp.title,
                "quantity" : cp.quantity,
                "price" : cp.price
            }).toList()
      };
      final rp =  await http.post(url,
                            body: json.encode(value ));
      print(json.decode(rp.body)['name']);
     _orders.insert(
       0, 
       OrderItem(
         id: json.decode(rp.body)['name'],
         amount: total,
         products: products,
         dateTime: timeStamp
         )
      );
     notifyListeners();
   }
}

