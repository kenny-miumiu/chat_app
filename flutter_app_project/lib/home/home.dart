import 'package:flutter/material.dart';
import 'package:flutter_app_project/home/page1.dart';
import 'package:flutter_app_project/home/page2.dart';
import 'package:flutter_app_project/home/page3.dart';
import 'package:flutter_app_project/home/page4.dart';


class Home extends StatefulWidget {
  Home({Key key}): super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var currentIndex = 2;

  @override
  Widget build(BuildContext context) {
    print(currentIndex);
    return Scaffold(
      body: currentIndex == 0?
          Page1(): currentIndex == 1?
          Page2(): currentIndex == 2?
          Page3(): Page4(),
      // 下にあるRoute部分
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: IconButton(
                icon: Icon(Icons.star),
                onPressed: () {
                  currentIndex = 0;
                  setState(() {});
                },
            ),
            label: ''
          ),
          BottomNavigationBarItem(
            icon: IconButton(
                icon: Icon(Icons.star),
                onPressed: () {
                  setState(() {
                    currentIndex = 1;
                  });
                }
            ),
            label: ''
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              icon: Icon(Icons.mail_outline_outlined),
              onPressed: () {
                setState(() {
                  currentIndex = 2;
                });
              }
            ),
            label: ''
          ),
          BottomNavigationBarItem(
            icon: IconButton(
                icon: Icon(Icons.star),
                onPressed: () {
                  currentIndex = 3;
                  setState(() {});
                }
            ),
            label: ''
          ),
        ],
        currentIndex: currentIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.blueAccent,
      ),
    );
  }
}


