import 'package:flutter/material.dart';
import 'package:intro_views_flutter/Models/page_view_model.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final pages = [
    PageViewModel(
      pageColor: const Color.fromRGBO(
          0, 157, 204, 1), // To Define page background color
      bubble: Icon(Icons.check_circle), // to define page indicator at bottom
      body: Text(
        'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
      ), // compulsory to define body and it will be shown at bottom
      title: Text(
        'Super Sale',
        style: TextStyle(fontSize: 32.0),
      ), // it will be shown at page header
      textStyle: TextStyle(
        fontFamily: 'Pacifico',
        color: Colors.black,
      ), // generic text style define for whole page
      mainImage: Image.asset(
        'images/market.png',
        width: 300.0,
        alignment: Alignment.center,
      ), // to define image for the introduction
    ),
    PageViewModel(
      pageColor: const Color.fromRGBO(255, 245, 2, 1),
      bubble: Icon(Icons.check_circle),
      body: Text(
        'There are many variations of passages of Lorem Ipsum available',
      ),
      title: Text(
        'Mega Sale',
        style: TextStyle(fontSize: 32.0),
      ),
      mainImage: Image.asset(
        'images/market.png',
        width: 300.0,
        alignment: Alignment.center,
      ),
      textStyle: TextStyle(
        fontFamily: 'Pacifico',
        color: Colors.black,
      ),
    ),
    PageViewModel(
      pageColor: const Color.fromRGBO(0, 54, 128, 1),
      bubble: Icon(Icons.check_circle),
      body: Text(
        'Sed ut perspiciatis unde omnis iste natus error sit voluptatem',
      ),
      title: Text(
        'Super Sale',
        style: TextStyle(fontSize: 32.0),
      ),
      mainImage: Image.asset(
       'images/market.png',
        width: 300.0,
        alignment: Alignment.center,
      ),
      textStyle: TextStyle(
        fontFamily: 'Pacifico',
        color: Colors.white,
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Intro View',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Builder(
        builder: (context) => IntroViewsFlutter(
          pages,
          skipText: Text(
            'SKIP',
            style: TextStyle(color: Colors.black),
          ), // Customize skip button
          doneText: Text(
            'GO TO APP',
            style: TextStyle(color: Colors.white),
          ), // Customize done button
          onTapDoneButton: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MyHomePage(),
              ),
            ); // after introduction where to navigate
          },
          pageButtonTextStyles: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
          ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
