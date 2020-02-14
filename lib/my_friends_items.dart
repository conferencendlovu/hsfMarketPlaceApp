import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sliverapp/basket.dart';
import 'package:http/http.dart' as http;

import 'my_friends_items_widgets/my_friends_item_list.dart';

class MyFriendsItems extends StatefulWidget {
  String id;
  MyFriendsItems({Key key, this.id}) : super(key: key);
  @override
  _MyFriendsItemsState createState() => _MyFriendsItemsState();
}

class _MyFriendsItemsState extends State<MyFriendsItems> {
  List<Basket> list = new List<Basket>();
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
            : MyFriendsListItem(list: list,user_id: widget.id),
      ),
    );
  }

  _fetchData() async {
    Map<String, String> headers = {"Content-type": "application/json"};
    String send = '{"uid":"${widget.id}"}';
    final response = await http.post(
        "http://hs-marketplace.herokuapp.com/demo/model/get_wishlist_api.php",
        headers: headers,
        body: send);

    if (response.statusCode == 200) {
      list = (json.decode(response.body) as List)
          .map((data) => new Basket.fromJson(data))
          .toList();
      setState(() {
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load users');
    }
  }
}
