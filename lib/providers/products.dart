import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './product.dart';

class Products with ChangeNotifier {


  String authToken;
  String userId;

  Products(this.authToken,this.userId,this._items);

  List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];
  // var _showFavoritesOnly = false;

  List<Product> get items {
    // if (_showFavoritesOnly) {
    //   return _items.where((prodItem) => prodItem.isFavorite).toList();
    // }
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  // void showFavoritesOnly() {
  //   _showFavoritesOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavoritesOnly = false;
  //   notifyListeners();
  // }

   Future <void> fetchAndSetProducts()  async {
          final url = Uri.parse('https://shopapp-fb84c-default-rtdb.firebaseio.com/products.json?auth=$authToken&orderBy="creatorId"&equalTo="$userId"');

  print("url:$url");


      try {
        final reponse =  await http.get(url);
        final extractedDate = json.decode(reponse.body) as Map<String,dynamic>;
        final List<Product> loadedProduct = [];
        print("extractedDate :$extractedDate");
        extractedDate?.forEach((productId, productData) {
          var pro = Product(id: productId,
          title: productData["title"].toString(),
          description: productData['description'].toString(),
          price: double.parse(productData['price'].toString()),
          imageUrl: productData['imageUrl'].toString(),
          isFavorite: productData['isFavorite']
          );
          pro.id = productId;
          loadedProduct.insert(0, pro);
         });
         this._items = loadedProduct;
          notifyListeners();
        print(reponse.body);
      } catch (error) {
        throw ("fetchAndSetProducts error:$error");
      }
  }
 


   Future <void> addProduct(Product product) {
    final url = Uri.parse('https://shopapp-fb84c-default-rtdb.firebaseio.com/products.json?auth=$authToken');
    return  http.post(url,body: json.encode({
        "title" :  product.title,
        "description" : product.description,
        "price" : double.parse(product.price.toString()) ,
        'isFavorite' : product.isFavorite,
        'imageUrl' : product.imageUrl,
        'creatorId' : userId
      })).then((reponse) {
        print("Reponse from API: ${json.decode(reponse.body)}");
        product.id =  json.decode(reponse.body)['name'];
        _items.add(product);
          notifyListeners();
      });
    
  }

  Future<void> updateProduct(String id , Product product)  async {
    final index = _items.indexWhere((product) =>  product.id  == id );
    if (index >= 0 ) {
      final url = Uri.parse('https://shopapp-fb84c-default-rtdb.firebaseio.com/products/$id.json');

          // final url = Uri.https('shopapp-fb84c-default-rtdb.firebaseio.com/products', '/$id.json');

       await  http.patch(url,body: json.encode({
        "title" :  product.title,
        "description" : product.description,
        "price" : product.price,
        'isFavorite' : product.isFavorite,
        'imageUrl' : product.imageUrl
      }));
      this._items[index] =  product;
       notifyListeners();
      }
  }

  void deleteProduct(String id ) {
    final url = Uri.parse('https://shopapp-fb84c-default-rtdb.firebaseio.com/products/$id.json');
    http.delete(url).then((reponse){
    final index = _items.indexWhere((product) =>  product.id  == id );
        _items.removeWhere((product) => id == product.id);
        notifyListeners();

    }).catchError((error) {
      throw (error);
    });
    
  }


}
