import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:sliverapp/photo.dart';
import 'package:http/http.dart' as http;
import 'package:after_layout/after_layout.dart';
import 'package:sliverapp/db.dart';
import 'package:sliverapp/wishnote_model.dart';

class WishNoteMaker extends StatefulWidget {
  final String id;
  WishNoteMaker({@required this.id});
  @override
  _WishNoteMakerState createState() => _WishNoteMakerState();
}

class _WishNoteMakerState extends State<WishNoteMaker>
    with AfterLayoutMixin<WishNoteMaker> {
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();
  Future<List<WishNote>> notes;
  String note;
  DBHelper dbHelper;
  final noteController = TextEditingController();
  final reminderController = TextEditingController();
  var now = new DateTime.now();
  String reminder;
  FocusNode focus = new FocusNode();
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
  }

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  List<Photo> list = List();
  var isLoading = false;
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  fetchData(id) async {
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

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  Widget imageSection(BuildContext context) {
    return Image.network(list[0].image, fit: BoxFit.cover);
  }

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  Widget noteForm(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (value.trim() == "") return "Only Space is Not Valid!!!";
        return null;
      },
      onSaved: (value) {
        note = value;
      },
      controller: noteController,
      decoration: InputDecoration(
          focusedBorder: new UnderlineInputBorder(
              borderSide: new BorderSide(
                  color: Colors.blue, width: 1, style: BorderStyle.solid)),
          // hintText: "Student Name",
          labelText: "Note",
          icon: Icon(
            Icons.note,
            color: Colors.blue,
          ),
          fillColor: Colors.white,
          labelStyle: TextStyle(
            color: Colors.blue,
          )),
    );
  }

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  Widget reminderForm(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (value.trim() == "") return "Only Space is Not Valid!!!";
        if (value.isEmpty) return "add a reminder";
        return null;
      },
      onSaved: (value) {
        reminder = value;
      },
      enabled: false,
      controller: reminderController,
      decoration: InputDecoration(
          focusedBorder: new UnderlineInputBorder(
              borderSide: new BorderSide(
                  color: Colors.blue, width: 1, style: BorderStyle.solid)),
          // hintText: "Student Name",
          labelText: "Reminder",
          icon: Icon(
            Icons.access_alarm,
            color: Colors.blue,
          ),
          fillColor: Colors.white,
          labelStyle: TextStyle(
            color: Colors.blue,
          )),
    );
  }

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  fetchDate() {
    DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: now,
        maxTime: DateTime(2075, 12, 31), onChanged: (date) {
      reminder = "$date";
      reminderController.text = reminder;
    }, onConfirm: (date) {
      print('confirm $date');
    }, currentTime: DateTime.now(), locale: LocaleType.en);
  }

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  Widget wishlistForm(BuildContext context) {
    return Form(
      key: _formStateKey,
      autovalidate: true,
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
            child: noteForm(context),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
            child: InkWell(
                onTap: () {
                  fetchDate();
                },
                child: reminderForm(context)),
          ),
        ],
      ),
    );
  }

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  saveData() {
    if (_formStateKey.currentState.validate()) {
      _formStateKey.currentState.save();
      dbHelper.add(WishNote(null, note, int.parse(widget.id), reminder));
    }
  }

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Note"),
          backgroundColor: Colors.black,
        ),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    imageSection(context),
                    wishlistForm(context),
                  ],
                ),
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            saveData();
            Navigator.pop(context);
          },
          backgroundColor: Colors.black,
          child: Icon(Icons.save),
        ),
      ),
    );
  }

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  @override
  void afterFirstLayout(BuildContext context) {
    reminder = now.toString();
    fetchData(widget.id);
  }
}
