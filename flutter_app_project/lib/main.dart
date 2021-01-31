import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app_project/home/home.dart';
import 'package:splashscreen/splashscreen.dart';


void main() {
  runApp(
    MaterialApp(
      home: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 10,
      navigateAfterSeconds: MyHomePage(),
      title: Text("Chat App"),
      loaderColor: Colors.red,
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SingleChildScrollView(
                child: Container(
                  height: 400,
                  width: 300,
                  margin: EdgeInsets.only(bottom: 30),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue)
                  ),
                  child: Text("このアプリは..."),
                )
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.circle),
                Icon(Icons.circle),
                Icon(Icons.circle),
              ],
            ),
            Container(
              width: MediaQuery.of(context).size.width / 1.3,
              height: MediaQuery.of(context).size.height / 12,
              margin: EdgeInsets.only(top: 15),
              child: RaisedButton(
                color: Colors.red,
                textColor: Colors.white,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return Home();
                      }
                    )
                  );
                },
                child: Text("チャットを始める"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

