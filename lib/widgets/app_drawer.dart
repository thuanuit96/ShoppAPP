import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/product.dart';
import 'package:provider/provider.dart';
import '../screens/order_screen.dart';
import '../providers/auth.dart';

class AppDrawer extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text("Hello friend"),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.shop),
              title: Text("Shop"),
              onTap: (){
                Navigator.of(context).pushReplacementNamed("/");
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.payment),
              title: Text("Your orders"),
              onTap: (){
                Navigator.of(context).pushReplacementNamed(OrderScreen.routeName);
                
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text("Logout"),
              onTap: (){
                Provider.of<Auth>(context, listen: false).logout();
              },
            )

        ],),
    );
  }
}