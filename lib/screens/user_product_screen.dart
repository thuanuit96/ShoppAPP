

import 'package:flutter/material.dart';
import '../providers/product.dart';
import '../providers/products.dart';
import '../widgets/app_drawer.dart';
import '../widgets/user_product_item.dart';
import 'package:provider/provider.dart';
import '../screens/edit_product_screen.dart';



class UserProductsScreen extends StatelessWidget {
  static String routeName = "/UserProduct";

  @override
  Widget build(BuildContext context) {

Future<void> refeshProducts(BuildContext contex)  async {
  print("refeshProducts:");
  await Provider.of<Products>(context,listen: false).fetchAndSetProducts();

}


  final productData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your products "),
        actions: [
          IconButton(
            onPressed: (){
                Navigator.of(context).pushNamed(EditProductScreen.routeName);
            }, 
            icon: Icon(Icons.add))
        ],
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => refeshProducts(context),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListView.builder(
           itemCount: productData.items.length,
           itemBuilder: (ctx,index) => Column(children: [
             UserProductItem(productData.items[index].id,productData.items[index].title,productData.items[index].imageUrl),
             Divider()
           ] 
           ),
          ),
        ),
      )
    );
  }
}