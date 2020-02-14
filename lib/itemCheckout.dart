import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sliverapp/my_friends_items_widgets/my_friends_item_list.dart';
import 'package:sliverapp/photo.dart';
import 'package:sliverapp/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

class ItemCheckout extends StatefulWidget {
  String id;
  String reciever;
  ItemCheckout({Key key, this.id, this.reciever}) : super(key: key);
  @override
  _ItemCheckoutState createState() => _ItemCheckoutState();
}

class _ItemCheckoutState extends State<ItemCheckout> {
  List<Photo> list = List();
  var isLoading = true;
 
  @override
  Widget build(BuildContext context) {
    _fetchData();
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: <Widget>[
                  Expanded(
                    flex: 5,
                    child: Image.network(list[0].image),
                  ),
                  Expanded(
                    flex: 5,
                    child: Text(
                      list[0].description,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){
          _checkOut();
          print("press");
        },
        label: Text("Checkout"),
        backgroundColor: Color(0xff283593),
        icon: Icon(Icons.shopping_basket),
      ),
    );
  }

  _fetchData() async {
    final response = await http.get(
        "http://hs-marketplace.herokuapp.com/demo/model/product_detail.php?id=" +
            widget.id);
    if (response.statusCode == 200) {
      list = (json.decode(response.body) as List)
          .map((data) => new Photo.fromJson(data))
          .toList();
      setState(() {
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load photos');
    }
  }

  _checkOut() async {

    Map<String, String> headers = {"Content-type": "application/json"};
    String send =
        '{"uid":"${globals.id}","rid":"${widget.reciever}","pid":"${widget.id}"}';
        print(send);
    final response = await http.post(
        "http://hs-marketplace.herokuapp.com/demo/model/gift_json.php",
        headers: headers,
        body: send);
   
    if (response.statusCode == 200) {
      
      setState(() {
        Toast.show("Your friend has recieved the Gift", context, duration: Toast.LENGTH_LONG, gravity:  Toast.CENTER);
        Navigator.pop(context);
      });
    } else {
      throw Exception('Failed to load users');
    }
  }
}
