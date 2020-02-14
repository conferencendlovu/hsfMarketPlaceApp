import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'globals.dart' as globals;
import 'package:sliverapp/myfriends.dart';

class Logg extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: Get.key,
      home: Login_QR(),
    );
  }
}

class Login_QR extends StatefulWidget {
  @override
  _Login_QRState createState() => _Login_QRState();
}

class _Login_QRState extends State<Login_QR> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  var qrText = "";
  var isLoading = true;
  QRViewController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Text('Scan the QR code on your HS-Marketplace Profile to Login'),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(onPressed: (){
        controller.resumeCamera();
      }, label: Text("Start Scanner"),icon: Icon(Icons.camera),),
    );
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
        globals.id = int.parse(body.split(" ")[2]);
        globals.email = body.split(" ")[3];
      });
    } else {
      qrText = "invalid qr code";
    }
  }


  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
