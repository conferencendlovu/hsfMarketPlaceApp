import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:sliverapp/my_friends_widgets/my_friends_list.dart';
import 'package:sliverapp/users.dart';

class MyFriends extends StatefulWidget {
  @override
  _MyFriendsState createState() => _MyFriendsState();
}

class _MyFriendsState extends State<MyFriends> {
  List<Users> list = List();
  var isLoading = true;
  String qrText = "text";

  @override
  Widget build(BuildContext context) {
    _fetchData();
    return Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Container(
            child: isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : MyFriendsList(list: list),
          ),
        ),
    );
  }

  _fetchData() async {
    Map<String, String> headers = {"Content-type": "application/json"};
    String send = '{"croma": "x1x2x3x4x5x6x7x8x9"}';
    final response = await http.post(
        "http://hs-marketplace.herokuapp.com/demo/model/listUsers.php",
        headers: headers,
        body: send);
    if (response.statusCode == 200) {
      list = (json.decode(response.body) as List)
          .map((data) => new Users.fromJson(data))
          .toList();
      setState(() {
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load users');
    }
  }
}
