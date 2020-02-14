import 'dart:convert';
import 'package:intro_views_flutter/Models/page_view_model.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';
import 'package:random_color/random_color.dart';
import 'package:flutter/material.dart';
import 'package:sliverapp/photo.dart';
import 'package:http/http.dart' as http;
import 'package:sliverapp/product_detail.dart';
import 'package:after_layout/after_layout.dart';
import 'categories_model.dart';

class Discover extends StatefulWidget {
  String id;
  Discover(this.id);
  @override
  _DiscoverState createState() => _DiscoverState();
}

class _DiscoverState extends State<Discover> with AfterLayoutMixin<Discover> {
  RandomColor randomColor = RandomColor();
  final List<ColorHue> _hueType = <ColorHue>[
    ColorHue.red,
    ColorHue.green,
    ColorHue.blue,
  ];

  List<Photo> list = List();
  var isLoading = false;

  List<Category> list_c = List();
  var isLoading_c = false;

  _fetchData(id) async {
    setState(() {
      isLoading = true;
    });
    final response = await http.get(
        "http://hs-marketplace.herokuapp.com/demo/model/searched_product.php?s=&f=&c=" +
            id);
    if (response.statusCode == 200) {
      list = (json.decode(response.body) as List)
          .map((data) => new Photo.fromJson(data))
          .toList();
      setState(() {
        isLoading = false;
        someList();
      });
      
    } else {
      throw Exception('Failed to load photos');
    }
  }

  List<PageViewModel> pages = [];
  someList() {
    pages = [
      PageViewModel(
        pageColor: Colors.black,
        bubble: Icon(Icons.check_circle),
        body: Text(
          'Swipe right to see more',
          style: TextStyle(fontSize: 10),
        ),
        title: Text(
          '',
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        mainImage: Image.network(
          list[0].image,
          width: double.infinity,
          fit: BoxFit.cover,
          alignment: Alignment.center,
        ),
        textStyle: TextStyle(
          color: Colors.white,
        ),
      ),
    ];
    for (var i = 0; i < list.length; i++) {
      pages.add(new PageViewModel(
        pageColor: i % 2 == 0
            ? Color(0xff101010)
            : Colors.black, // To Define page background color
        bubble: Icon(Icons.check_circle), // to define page indicator at bottom
        body: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(2)),
            child: Container(
                decoration:
                    BoxDecoration(border: Border.all(color: Color(0xff3d5afe))),
                child: Container(
                  // color: Color(0xff101010),
                  width: double.infinity,
                  color: Color(0xff101010),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return ProductDetail(id: list[i].id);
                      }));
                    },
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Icon(
                        Icons.info,
                        color: Color(0xff3d5afe),
                      ),
                    ),
                  ),
                ))),
        /*RaisedButton(
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ProductDetail(id: list[i].id);
        }));
          }*/
        // compulsory to define body and it will be shown at bottom
        title: Text(
          list[i].title,
          style: TextStyle(fontSize: 18.0, color: Colors.white),
        ), // it will be shown at page header
        textStyle: TextStyle(
          color: Colors.white,
        ), // generic text style define for whole page
        mainImage: Image.network(
          list[i].image,
          width: double.infinity,
          fit: BoxFit.cover,
          alignment: Alignment.center,
        ), // to define image for the introduction
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.black,
      home: Scaffold(
        backgroundColor: Colors.black,
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : IntroViewsFlutter(
                pages,
                skipText: Text(""),
                // Customize skip button
                doneText: Text(
                  '',
                  style: TextStyle(color: Colors.white),
                ), // Customize done button
                onTapDoneButton: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ProductDetail(id: list[0].id);
                  })); // after introduction where to navigate
                },
                pageButtonTextStyles: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                ),
              ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    _fetchData(widget.id);
  }
}
