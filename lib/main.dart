import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/auth.dart';
import 'package:flutter_complete_guide/providers/cart.dart';
import 'package:flutter_complete_guide/providers/orders.dart';
import 'package:flutter_complete_guide/providers/product.dart';
import 'package:flutter_complete_guide/screens/cart_screen.dart';
import 'package:flutter_complete_guide/screens/edit_product_screen.dart';
import 'package:flutter_complete_guide/screens/login_screen.dart';
import 'package:flutter_complete_guide/screens/auth_screen.dart';

import 'package:flutter_complete_guide/screens/order_screen.dart';
import 'package:flutter_complete_guide/screens/splash_screen.dart';
import 'package:flutter_complete_guide/screens/user_product_screen.dart';
import 'package:provider/provider.dart';

import './screens/products_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/cart_screen.dart';
import './providers/products.dart';
import './providers/cart.dart';
import './providers/orders.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          // ChangeNotifierProvider.value(value: Products()),
          ChangeNotifierProvider.value(
            value: Auth(),
          ),
           ChangeNotifierProvider.value(
            value: Cart(),
          ),
          ChangeNotifierProxyProvider<Auth, Products>(
            // create: (ctx) => Products("", []),
            update: (ctx, auth, previousProducts) => Products(auth.token,auth.userId,
                previousProducts == null ? [] : previousProducts.items),
          ),
        ChangeNotifierProxyProvider<Auth, Orders>(
            // create: (ctx) => Products("", []),
            update: (ctx, auth, orders) => Orders(auth.token,auth.userId,
                orders == null ? [] : orders.orders),
          ),
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, child) {
            print('_____________');
            print(ctx);
            // print(a);
            print(child);
            print('_____________');
            return MaterialApp(
                title: 'MyShop',
                theme: ThemeData(
                  primarySwatch: Colors.purple,
                  accentColor: Colors.deepOrange,
                  fontFamily: 'Lato',
                ),
                home: auth.isAuth ? ProductsOverviewScreen() :
                FutureBuilder(future: auth.autologin()
                ,builder: (ctx, authResultSnapshot) => authResultSnapshot.connectionState == ConnectionState.waiting ? SplashScreen() : AuthScreen(),
                ),
                routes: {
                  ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
                  CartScreen.routeName: (ctx) => CartScreen(),
                  OrderScreen.routeName: (ctx) => OrderScreen(),
                  UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
                  EditProductScreen.routeName: (ctx) => EditProductScreen(),
                  LoginScreen.routeName: (ctx) => LoginScreen(),
                  AuthScreen.routeName: (ctx) => AuthScreen(),
                });
          },
        ));
  }
}
