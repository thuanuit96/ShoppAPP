
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/cart.dart' as ci;
import 'package:provider/provider.dart';



class CartItem extends StatelessWidget {
  final ci.CartItem cartItem;

  final String productId;
  
  CartItem(this.cartItem,this.productId);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(cartItem.id),
      background: Container(
        color: Theme.of(context).primaryColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 25,),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 5
        ),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction){
        return showDialog(
          context: context, 
          builder: (ctx) {
            return AlertDialog(
                title: Text("Are you sure"),
                content: Text(
                  "Do you want to remove the item from  the cart?"
                ),
                actions: [
                  FlatButton(
                    onPressed: (){
                      Navigator.of(context).pop(false);
                    },
                     child: Text("No")
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    } , 
                    child: Text("Yes"))
                ],

            );
          }
          );
      },
      onDismissed: (direction){
        Provider.of<ci.Cart>(context, listen: false).removeItem(this.productId);

      },
      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 5
        ),
        child: Container(
          // color: Colors.red,
          padding: EdgeInsets.all(0),
          child: ListTile(
            hoverColor: Colors.black,
            leading: CircleAvatar(
              child: Padding(
                padding: EdgeInsets.all(5),
                child: FittedBox(
                  child: Text("\$${cartItem.price.toString()}")),
              ),
              ),
            title: Text(cartItem.title),
            subtitle: Text("Total: \$${cartItem.price * cartItem.quantity}"),
            trailing: Text("${cartItem.quantity}x"),
          ),
    
        )
      ),
    );
  }
}