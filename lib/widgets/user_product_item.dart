
import 'package:flutter/material.dart';
import '../screens/edit_product_screen.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';




class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imgURL;

  UserProductItem(this.id,this.title,this.imgURL);
  @override
  Widget build(BuildContext context) {
     return ListTile(
        leading: CircleAvatar(backgroundImage: NetworkImage(imgURL),),
        title: Text(title),
        trailing: Container(
          width: 100,
          child: Row(children: [
            IconButton(onPressed: (){
              Navigator.of(context).pushNamed(EditProductScreen.routeName,arguments: id);
            }, icon: Icon(Icons.edit,color: Theme.of(context).primaryColor,)),
            IconButton(onPressed: (){
              Provider.of<Products>(context,listen: false).deleteProduct(id);
            }, icon: Icon(Icons.delete,color: Colors.red,))
            
          ],),
        ),
      );
  }
}