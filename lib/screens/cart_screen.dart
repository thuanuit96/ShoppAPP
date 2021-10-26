import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/cart.dart';
import 'package:flutter_complete_guide/providers/orders.dart';
import 'package:provider/provider.dart';
import '../widgets/cart_item.dart'  as al ;



class CartScreen extends StatelessWidget {

    static const routeName = '/Cart-Screen';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Cart "),
        ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(8),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  Text("Total",style: TextStyle(fontSize: 20),),
                  Spacer(),
                  Chip(
                    label: Text("\$${cart.totalExpense}"),
                    backgroundColor: Theme.of(context).primaryColor
                  ),
                  FlatButton(
                    onPressed: (){
                      Provider.of<Orders>(context, listen: false).addOrder(cart.items.values.toList(), cart.totalAmountItem);
                      cart.clear();

                    }, 
                    child: Text("ORDER NOW"),
                    textColor: Theme.of(context).primaryColor,)
                ],
                ) 
              )
          ),
          SizedBox(height: 10,),
          Expanded(
            child: ListView.builder(
                // shrinkWrap: true,
                itemCount: cart.itemCount,
                itemBuilder: (ctx,index ){
                  final arrItems =  cart.items.values.toList();

                  final arrKeys =  cart.items.keys.toList();
                  return al.CartItem(arrItems[index],arrKeys[index]);
                },
            ),
          )
        ],
        )
    );
  }
}