import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sliverapp/photo.dart';
import 'package:http/http.dart' as http;
import 'package:after_layout/after_layout.dart';
import 'package:sliverapp/wishnote.dart';

class ProductDetail extends StatefulWidget {
  final String id;
  ProductDetail({@required this.id});
  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail>
    with AfterLayoutMixin<ProductDetail> {
  List<Photo> list = List();
  var isLoading = false;

  _fetchData(id) async {
    setState(() {
      isLoading = true;
    });
    final response = await http.get(
        "http://hs-marketplace.herokuapp.com/demo/model/product_detail.php?id=" +
            id);
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product detail',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Details'),
          backgroundColor: Colors.black,
        ),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: <Widget>[
                  Image.network(list[0].image),
                  titleSection(context),
                  textSection(context)
                ],
              ),
        floatingActionButton: new FloatingActionButton(
          onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return WishNoteMaker(id: list[0].id);
              }));
            },
          child: Icon(Icons.note_add),
          backgroundColor: Colors.black,
        ),
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    // Calling the same function "after layout" to resolve the issue.
    _fetchData(widget.id);
  }

  Widget textSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Text(
        list[0].description,
        softWrap: true,
      ),
    );
  }

  Widget titleSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Text(
        list[0].title,
        softWrap: true,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
    );
  }
}
