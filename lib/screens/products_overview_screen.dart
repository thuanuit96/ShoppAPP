import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/cart.dart';
import 'package:flutter_complete_guide/screens/cart_screen.dart';
import 'package:flutter_complete_guide/widgets/badge.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../widgets/app_drawer.dart';
import '../widgets/products_grid.dart';


enum FilterOptions {
  Favorites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavorites = false;
  var isInit = true;

@override
  void initState() {
    // TODO: implement initState
    super.initState();
  
    }

    @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
        print("didChangeDependencies product overview screen ");
    super.didChangeDependencies();
    if (isInit) {
      isInit = false;
      Provider.of<Products>(context).fetchAndSetProducts().then((_){
       setState(() {
       });
     });
    }
        // Future.delayed(Duration.zero).then((_){
        //   Provider.of<Products>(context).fetchAndSetProducts();
        // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Favorites) {
                  _showOnlyFavorites = true;
                } else {
                  _showOnlyFavorites = false;
                }
              });
            },
            icon: Icon(
              Icons.more_vert,
            ),
            itemBuilder: (_) => [
                  PopupMenuItem(
                    child: Text('Only Favorites'),
                    value: FilterOptions.Favorites,
                  ),
                  PopupMenuItem(
                    child: Text('Show All'),
                    value: FilterOptions.All,
                  ),
                ],
          ),

          Consumer<Cart>(
            builder: (_,cart,child) => Badge(
              child: child, 
              value: cart.itemCount.toString()),
            child: IconButton(
                  icon: Icon(
                    Icons.shopping_cart
                  ),
                  onPressed: (){
                    Navigator.of(context).pushNamed(CartScreen.routeName);
                  },
              ), 

            )
         ,
        ],
      ),
      drawer: AppDrawer(),
      body: ProductsGrid(_showOnlyFavorites),
    );
  }
}
