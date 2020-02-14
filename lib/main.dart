import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:random_color/random_color.dart';
import 'package:flutter/material.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliverapp/discover.dart';
import 'package:sliverapp/login_qr.dart';
import 'package:sliverapp/my_notes.dart';
import 'package:sliverapp/myfriends.dart';
import 'package:sliverapp/photo.dart';
import 'package:http/http.dart' as http;
import 'package:sliverapp/product_detail.dart';
import 'package:after_layout/after_layout.dart';
import 'package:sliverapp/my_flutter_app_icons.dart';
import 'package:toast/toast.dart';
import 'categories_model.dart';
import 'package:flutter/services.dart';
import 'globals.dart' as globals;
//import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyHomePage());
//void main() => runApp(MyFriends());
//void main() => runApp(Logg());

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: Get.key,
      title: 'HSF-Marketplace',
      theme:
          ThemeData(primaryColor: Colors.black, backgroundColor: Colors.black),
      home: MyApp(title: 'HSF-Marketplace'),
    );
  }
}

class MyApp extends StatefulWidget {
  MyApp({Key key, this.title}) : super(key: key);

  final String title;

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

  bool globalsCheck() {
    if (globals.id == 0 && globals.email == "") {
      return true;
    } else {
      return false;
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
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                        Colors.black,
                        Color(0xff101010).withOpacity(0.9)
                      ])),
                  child: Container(
                    // color: Color(0xff101010),
                    width: double.infinity,

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

  Widget surpriseButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: OutlineButton(
        onPressed: () {
          if (globalsCheck()) {
            Get.to(Login_QR());
            //Toast.show("email"+globals.email, context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
          } else {
            Get.to(MyFriends());
            //Toast.show("email ELSE"+globals.email, context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
          }
        },
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(1000.0),
        ),
        color: Color(0xff283593),
        child: Text(
          "Surprise Someone",
          style: TextStyle(
            color: Color(0xff283593),
          ),
        ),
        borderSide: BorderSide(
            color: Color(0xff283593), style: BorderStyle.solid, width: 1),
      ),
    );
  }

  Widget myNotesButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: OutlineButton(
        onPressed: () {
         Get.to(MyNotes());
        },
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(1000.0),
        ),
        color: Color(0xff283593),
        child: Text(
          "My Notes",
          style: TextStyle(
            color: Color(0xff283593),
          ),
        ),
        borderSide: BorderSide(
            color: Color(0xff283593), style: BorderStyle.solid, width: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.title),
      ),
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
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
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
                    Row(
                      children: <Widget>[
                        Expanded(child: surpriseButton(context)),
                        Expanded(child: myNotesButton(context))
                      ],
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
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
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
    );
  }

  /*void _scanQR() async {
    String result;
    try {
      result = await QrUtils.scanQR;
    } on PlatformException {
      result = 'Process Failed!';
    }

    /*setState(() {
      _makePostRequest(result);
    });*/
  }
*/
  _makePostRequest(String verifier) async {
    String url =
        'https://hs-marketplace.herokuapp.com/demo/model/auth_over_json.php';
    Map<String, String> headers = {"Content-type": "application/json"};
    String json = '{"verify": "$verifier"}'; // make POST request
    Response response = await post(url,
        headers: headers, body: json); // check the status code for the result
    int statusCode = response
        .statusCode; // this API passes back the id of the new item added to the body
    String body = response.body;
    //print(body);
    //qrText = body;
    if (body.split(" ").length == 4) {
      // addStringToSF(body.split(" ")[2], body.split(" ")[3]);

      //qrText = 'id =  ${body.split(" ")[2]} email= ${body.split(" ")[3]}';
      Get.to(MyFriends());
    }
  }

  /* addStringToSF(String email, String id) async {
    /*SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email', "$email");
    prefs.setString('id', "$id");*/
  }*/
}
