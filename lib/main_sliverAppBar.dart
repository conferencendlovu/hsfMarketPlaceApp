import 'dart:convert';
import 'package:random_color/random_color.dart';
import 'package:flutter/material.dart';
import 'package:sliverapp/discover.dart';
import 'package:sliverapp/photo.dart';
import 'package:http/http.dart' as http;
import 'package:sliverapp/product_detail.dart';
import 'package:after_layout/after_layout.dart';
import 'package:sliverapp/my_flutter_app_icons.dart';
import 'package:sliverapp/somelist.dart';
import 'categories_model.dart';


void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with AfterLayoutMixin<MyApp> {
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

  _fetchData() async {
    setState(() {
      isLoading = true;
    });
    final response = await http.get(
        "http://hs-marketplace.herokuapp.com/demo/model/get_new_arrivals.php");
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

  fetchCategories() async {
    setState(() {
      isLoading_c = true;
    });
    final response = await http.get(
        "http://hs-marketplace.herokuapp.com/demo/model/get_categories_json.php");
    if (response.statusCode == 200) {
      list_c = (json.decode(response.body) as List)
          .map((data) => new Category.fromJson(data))
          .toList();
      setState(() {
        isLoading_c = false;
      });
    } else {
      throw Exception('Failed to load categories');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.black,
      home: Scaffold(
        backgroundColor: Colors.black,
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 300.0,
                backgroundColor: Colors.black,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text(
                    'Marketplace',
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  ),
                  background: Image.network(
                    "https://i.pinimg.com/originals/2a/41/cd/2a41cdb9ffbd875d38c811b8f789e18a.jpg",
                    fit: BoxFit.cover,
                  ),
                ),
              )
            ];
          },
          body: isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                        ),
                        Text(
                          "New Arrivals",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                        ),
                        Container(
                          height: 350.0,
                          child: listBuild(context),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        ),
                        Text(
                          "Discover",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        Container(
                          child: isLoading_c
                              ? Center(
                                  child: CircularProgressIndicator(),
                                )
                              : categoryList(context),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _fetchData();
          },
          child: Icon(
            Icons.refresh,
            color: Color(0xff3d5afe),
          ),
          backgroundColor: const Color(0xff1a1a1a),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }

 
  @override
  void afterFirstLayout(BuildContext context) {
    _fetchData();
    fetchCategories();
  }

  Widget listBuild(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: list.length,
        itemBuilder: (BuildContext context, int index) {
          return newArrivals(context, index);
        });
  }

  Widget categoryList(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: list_c.length,
      itemBuilder: (BuildContext context, int index) {
        return Column(children: <Widget>[
          ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(2)),
              child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Color(0xff3d5afe))),
                  child: Container(
                    // color: Color(0xff101010),
                    width: double.infinity,
                    color: Color(0xff101010),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return Discover(list_c[index].id);
                        }));
                      },
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Row(
                          children: <Widget>[
                            if (list_c[index].title == 'Clothes')
                              Icon(
                                MyFlutterApp.t_shirt,
                                color: Color(0xff3d5afe),
                              ),
                            if (list_c[index].title == 'Books')
                              Icon(
                                MyFlutterApp.book,
                                color: Color(0xff3d5afe),
                              ),
                            if (list_c[index].title == 'Accessories')
                              Icon(
                                MyFlutterApp.bicycle,
                                color: Color(0xff3d5afe),
                              ),
                            if (list_c[index].title == 'Electronics')
                              Icon(
                                MyFlutterApp.phonelink,
                                color: Color(0xff3d5afe),
                              ),
                            if (list_c[index].title == 'Toys & Games')
                              Icon(
                                MyFlutterApp.toys,
                                color: Color(0xff3d5afe),
                              ),
                            if (list_c[index].title == 'Handmade Products')
                              Icon(
                                MyFlutterApp.pan_tool,
                                color: Color(0xff3d5afe),
                              ),
                            if (list_c[index].title == 'Gift Boxes')
                              Icon(
                                MyFlutterApp.gift,
                                color: Color(0xff3d5afe),
                              ),
                            if (list_c[index].title == 'Homeware')
                              Icon(
                                MyFlutterApp.free_breakfast,
                                color: Color(0xff3d5afe),
                              ),
                            if (list_c[index].title == 'Pets Products')
                              Icon(
                                MyFlutterApp.pets,
                                color: Color(0xff3d5afe),
                              ),
                            if (list_c[index].title == 'Tools & Equipments')
                              Icon(
                                MyFlutterApp.wrench,
                                color: Color(0xff3d5afe),
                              ),
                            if (list_c[index].title == 'Furniture')
                              Icon(
                                MyFlutterApp.event_seat,
                                color: Color(0xff3d5afe),
                              ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(5, 0, 10, 0),
                            ),
                            Expanded(
                                child: Text(
                              list_c[index].title,
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ))
                          ],
                        ),
                      ),
                    ),
                  ))),
          Padding(
            padding: EdgeInsets.all(5),
          )
        ]);
      },
    );
  }

  Widget newArrivals(BuildContext context, int index) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ProductDetail(id: list[index].id);
        }));
      },
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 10, 10, 0),
        child: ClipRRect(
          borderRadius: new BorderRadius.all(Radius.circular(5)),
          child: Stack(
            children: <Widget>[
              Image.network(
                list[index].thumbnailUrl,
                fit: BoxFit.cover,
                height: 350,
                width: 200,
              ),
              Container(
                width: 200,
                height: 350,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: index % 2 == 0
                            ? [
                                Color(0xff000000).withOpacity(0.9),
                                Color(0xff283593).withOpacity(0.9)
                              ]
                            : [
                                Color(0xff283593).withOpacity(0.9),
                                Color(0xff000000).withOpacity(0.9)
                              ])),
              ),
              SizedBox(
                width: 200,
                height: 350,
                child: Center(
                  child: Text(
                    list[index].title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
