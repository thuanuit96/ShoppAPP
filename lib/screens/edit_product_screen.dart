import 'dart:math';

import 'package:flutter/material.dart';
import '../providers/product.dart';
import '../providers/products.dart';
import 'package:provider/provider.dart';


class EditProductScreen extends StatefulWidget {
    static const routeName = '/EditProductScreen';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
    final _priceFocusNode = FocusNode();
    final _imageFocusNode = FocusNode();
    final _imageURLController = TextEditingController(text: "https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg");
    final _form =  GlobalKey<FormState>();
    var editProduct = Product(id: null,title: "",description: "",price: 0.0,imageUrl: "",isFavorite: false);
    var data = <String, Object>{};
    var firstInit = true;
    var isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _imageFocusNode.addListener(updateImageURL);
  }
  @override
  void didChangeDependencies() {

    if (firstInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
      this.editProduct = Provider.of<Products>(context,listen: false).findById(productId);
        _imageURLController.text = editProduct.imageUrl;
      }
      firstInit = false;
    }

    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }
  void updateImageURL(){
    if (!_imageFocusNode.hasFocus) {
      setState(() {
        
      });
    }
  }

@override
  void dispose() {
    // TODO: implement dispose

    super.dispose();
    _priceFocusNode.dispose();
    _imageURLController.dispose();
  }

void saveForm() async {
  final isValidate =  _form.currentState.validate();
  if (!isValidate) {
    return;
  }
  _form.currentState.save();
  
  final isAddNew = editProduct.id == null;
  this.editProduct = Product(id: editProduct.id == null ? DateTime.now().toString(): editProduct.id ,
                            title: data["title"].toString(),
                            description: data['description'].toString(),
                            price: double.parse(data['price']),
                            imageUrl: data['imageURL'].toString(),
                            );

  setState(() {
      isLoading = true;
  });
  if (isAddNew){
    Provider.of<Products>(context,listen : false).addProduct(editProduct).then((_) {
        // isLoading = false;
        print("value then");
         Navigator.of(context).pop();
    })
    .catchError((onError){
      return showDialog(context: context, builder: (ctx)=> AlertDialog(
        title: Text("An error accurred"),
        content: Text(onError.toString()),
        actions: [
          FlatButton(onPressed: (){
            Navigator.of(context).pop();
            setState(() {
            isLoading = false;
            });



          }, child: Text("Ok")
          ),  
        ],
      ));
    });
  }else {
       setState(() {
            isLoading = true;
            });
     await  Provider.of<Products>(context,listen : false).updateProduct(editProduct.id, editProduct);
      
      Navigator.pop(context);

  }
  print("editProduct:${editProduct.title}");
  print("editProduct:${editProduct.description}");
  print("editProduct:${editProduct.price}");
  print("editProduct:${editProduct.imageUrl}");

}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit product"),
        actions: [
          IconButton(onPressed: saveForm, icon: Icon(Icons.save))
        ],
      ),
      body: isLoading ? Center(
        child: CircularProgressIndicator(),
      ) : Padding(
        padding: EdgeInsets.all(8),
        child: Form(
          key: _form,
          child: ListView(
          children: [
            TextFormField(
              initialValue: editProduct.title,
              decoration: InputDecoration(
                labelText: "Title",
              ),
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) {
                // FocusScope.of(context).autofocus(_priceFocusNode);
              },
              onSaved: (value){
                data["title"] =  value ;
                  //this.editProduct = 
              },
              validator: (value) {

                  if (value.isEmpty) {
                    return  "Please enter title";
                  }
                  return null;

                // return value.isEmpty ? "Please enter title" : null; 
              },
            ),
             TextFormField(
              initialValue: editProduct.price > 0 ? editProduct.price.toString() : "",
              decoration: InputDecoration(
                labelText: "Price",
              ),
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              focusNode: _priceFocusNode,
              onSaved: (value){
                data["price"] =  value ;
              },
              validator: (value) {
                return value.isEmpty ? "Please enter price" : null; 
              },
            ),
            
             TextFormField(
               initialValue: editProduct.description,
              decoration: InputDecoration(
                labelText: "Description",

              ),
              textInputAction: TextInputAction.next,
              maxLines: 3,
              onFieldSubmitted: (_) {
                // FocusScope.of(context).autofocus(_imageFocusNode);
              },
              onSaved: (value){
                  data["description"] =  value ;

              },
              validator: (value) {
                return value.isEmpty ? "Please enter description" : null; 
              },

              // focusNode: _priceFocusNode,
            ),
            Row(children: [
              Container(
                width: 100,
                height: 100,
                margin: EdgeInsets.only(top: 8,right: 8),
                decoration: BoxDecoration(
                  border: Border.all(width: 1,color: Colors.grey)
                ),
                child: _imageURLController.text.isEmpty ? Padding(padding : EdgeInsets.all(8),child: Text("Please enter a URL ")) : FittedBox(
                  child: Image.network(_imageURLController.text,fit: BoxFit.cover,),

                ),
                
              ),
              Expanded(
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: "Image URL",
                    contentPadding: EdgeInsets.all(5)
                  ),
                  keyboardType: TextInputType.url,
                  controller: _imageURLController,
                  focusNode: _imageFocusNode,
                  onSaved: (value){
                    data["imageURL"] =  value ;
                  },
                  validator: (value) {
                      return value.isEmpty ? "Please enter image" : null; 
                  },
                  onFieldSubmitted: (_){
                        saveForm();
                  },
                ),
              )
            ],)

          ],
        )),
      ),
    );
  }
}