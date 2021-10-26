
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/widgets/app_drawer.dart';
import 'package:provider/provider.dart';
import '../providers/orders.dart' show Orders;
import '../widgets/order_item.dart';



class OrderScreen extends StatefulWidget {
  static String routeName = "/orderScreen";

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  var isInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (isInit) {
        Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
      isInit = false ;
    }
    
  }

Future<void> refesh(BuildContext contex)  async {
  print("refeshProducts:");
  Provider.of<Orders>(context,listen: false).fetchAndSetOrders();

}
  @override
  Widget build(BuildContext context) {
      // final orderData = Provider.of<Orders>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Orders"),
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: ()=> refesh(context),
        child: FutureBuilder(future : Provider.of<Orders>(context,listen: false).fetchAndSetOrders(), builder: (ctx,dataSnapshot){
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(),);
          }else {
            if (dataSnapshot.error != null)  {
             return Center(child: Text("An error accur"), );
            }else {
              return Consumer<Orders>(
                builder: (ctx,orderData,child) => ListView.builder(
                          itemCount: orderData.orders.length,
                          itemBuilder: (ctx,index) => OrderItem(orderData.orders[index]),
                        ),
              );
            }
          }
        }),)
      );
  }
}