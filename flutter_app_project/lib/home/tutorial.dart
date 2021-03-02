import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_project/home/home.dart';
import 'package:webview_flutter/webview_flutter.dart';

WebViewController _webViewController;

class Tutorial extends StatelessWidget {
  Tutorial({this.showTutorial});
  final void showTutorial;

  @override
  Widget build(BuildContext context) {
    // 最初にテキストとしておいているhtmlを持ってきて、コントローラーの中に情報を格納する
    // 初回のみの実行
    Future loadHtmlFromAssets() async {
      String fileText = await rootBundle.loadString('assets/tutorial.html');
      _webViewController.loadUrl(Uri.dataFromString(fileText, mimeType: 'text/html', encoding: Encoding.getByName('utf-8')).toString());
    }

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
                  child: WebView(
                    initialUrl: 'about:blank',
                    onWebViewCreated: (WebViewController webViewController) async {
                      _webViewController = webViewController;
                      await loadHtmlFromAssets();
                    },
                    javascriptMode: JavascriptMode.unrestricted,
                  )
                )
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.circle, size: 15),
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
                  showTutorial;
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