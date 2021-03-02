import 'package:flutter/material.dart';
import 'package:flutter_app_project/home/home.dart';
import 'package:flutter_app_project/home/tutorial.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splashscreen/splashscreen.dart';


void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 5,
      navigateAfterSeconds: MyHomePage(),
      title: Text("Chat App"),
      loaderColor: Colors.red,
    );
  }
}

class MyHomePage extends StatefulWidget{
  MyHomePage({Key key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>{
  @override
  Widget build(BuildContext context) {
    // チュートリアルが表示される仕組み
    // まず最初にshared_preferencesを使って、'done'にtrueを格納しておく
    // shared_preferencesは、デバイス上に情報を保存する仕組みを持っている
    void showTutorial() async {
      final preference = await SharedPreferences.getInstance();
      preference.setBool('done', true);
    }

    // もし、trueじゃなければチュートリアルを表示する
    // trueならそのまま処理を実行する
    void hideTutorial() async {
      final preference = await SharedPreferences.getInstance();

      if (preference.getBool('done') != true) {
        Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) {
                  return Tutorial(
                    showTutorial: showTutorial,
                  );
                }
            )
        );
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      hideTutorial();
    });

    return Home();
  }
}

