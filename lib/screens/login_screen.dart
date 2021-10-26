import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/_LoginScreenState';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    // Full screen width and height
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    // Height (without SafeArea)
    var padding = MediaQuery.of(context).padding;
    double heightWithoutSafeArea = height - padding.top - padding.bottom;

    // Height (without status bar)
    double height2 = height - padding.top;

    // Height (without status and toolbar)
    double height3 = height - padding.top - kToolbarHeight;

    return Scaffold(
      backgroundColor: Colors.red,
      body: Stack(
        children : [ 
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
                  Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0, 1],
              ),
            ),
          ),
          Container(
              alignment: Alignment.center,
              height: heightWithoutSafeArea,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Container(
                  child: Text("IMG"),
                  alignment: Alignment.center,
                ),
                Container(
                  width: 300,
                  alignment: Alignment.center,
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Form(
                        child: ListView(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          children: [
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: "E-Mail",
                              ),
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) {
                                // FocusScope.of(context).autofocus(_priceFocusNode);
                              },
                              onSaved: (value) {},
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Please enter E-Mail";
                                }
                                return null;
          
                                // return value.isEmpty ? "Please enter title" : null;
                              },
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: "Password",
                              ),
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.number,
                              onSaved: (value) {},
                              validator: (value) {
                                return value.isEmpty ? "Please enter price" : null;
                              },
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                
                                    
                                      onPressed: () {},
                                      child: Padding(child: Text("LOGIN"),padding: EdgeInsets.only(top: 10,bottom: 10,left: 20,right: 20)),
                                      style: ButtonStyle(
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(18.0),
                                                  side: BorderSide(
                                                      color: Colors.purple))))),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "SIGNUP INSTEAD",
                                    style: TextStyle(color: Colors.purple),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ]),
            ),
        ]),
    );
  }
}
