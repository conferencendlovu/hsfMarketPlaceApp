/*import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_code_scanner/qr_scanner_overlay_shape.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliverapp/myfriends.dart';

class Li extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: Get.key,
      home: Login(),
    );
  }
}

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with AfterLayoutMixin<Login> {
  var isLoading = true;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  var qrText =
      "Login to https://hs-marketplace.herokuapp.com/demo/login.php from you PC and scan the QR Code in your profile page";
  QRViewController controller;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          Expanded(
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: Colors.blue,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: 300,
              ),
            ),
          ),
          /* Expanded(
              flex: 5,
              child: Center(
                child: isLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : RaisedButton(
                        child: Text("Token Verified,Click to Login"),
                        onPressed: () {
                          Get.to(MyFriends());
                        },
                      ),
              ),
            )*/
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Get.to(MyFriends());
          },
          label: Text("data")),
    );
  }

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
    qrText = body;
    if (body.split(" ").length == 4) {
      //addStringToSF(body.split(" ")[2], body.split(" ")[3]);

      qrText = 'id =  ${body.split(" ")[2]} email= ${body.split(" ")[3]}';
      Get.to(MyFriends());
      setState(() {
        isLoading = false;
      });
    } else {
      qrText = "invalid qr code";
    }
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        //qrText = scanData;
        controller.pauseCamera();
        Timer(Duration(milliseconds: 300), () {
          _makePostRequest(scanData);
        });
      });
    });
  }

  /*addStringToSF(String email, String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email', "$email");
    prefs.setString('id', "$id");
  }*/

  @override
  void afterFirstLayout(BuildContext context) {
    // Calling the same function "after layout" to resolve the issue.
  }
}
*/
