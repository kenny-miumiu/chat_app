import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_project/home/home.dart';
import 'package:webview_flutter/webview_flutter.dart';

WebViewController _webViewController;

class Tutorial extends StatefulWidget {
  Tutorial({this.showTutorial});
  final void showTutorial;
  _TutorialState createState() => _TutorialState();
}

class _TutorialState extends State<Tutorial> {
  int transitionViewer;
  WebView webView;

  @override
  void initState() {
    super.initState();
    transitionViewer = 0;
  }

  @override
  void dispose() {
    super.dispose();
    _webViewController.clearCache();
  }

  @override
  Widget build(BuildContext context) {
    // 最初にテキストとしておいているhtmlを持ってきて、コントローラーの中に情報を格納する
    // 初回のみの実行
    // rootBundle.loadStringからは、assetsのhtmlを得ることはできないので、個別に作るしかない。
    // 冗長化を防ぐためには、ページ数をできるだけ減らした方が良い
    Future<void> loadHtmlFromAssets() async {
      String fileText = await rootBundle.loadString('assets/tutorial1.html');

      _webViewController.loadUrl(Uri.dataFromString(fileText,
              mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
          .toString());
    }

    Future<void> loadHtmlFromAssets2() async {
      String fileText = await rootBundle.loadString('assets/tutorial2.html');
      _webViewController.loadUrl(Uri.dataFromString(fileText,
              mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
          .toString());
    }

    Future<void> loadHtmlFromAssets3() async {
      String fileText = await rootBundle.loadString('assets/tutorial3.html');
      _webViewController.loadUrl(Uri.dataFromString(fileText,
              mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
          .toString());
    }

    // 押したボタンで場合分けを行う
    Future<void> webViewCreating(WebViewController webViewController) async {
      _webViewController = webViewController;
      if (transitionViewer == 0) {
        await loadHtmlFromAssets();
      } else if (transitionViewer == 1) {
        await loadHtmlFromAssets2();
      } else {
        loadHtmlFromAssets3();
      }
    }

    // IconButtonのリストをfor文で作っている
    // 冗長化を防ぐため、リスト形式で格納している
    List<IconButton> createIconButton() {
      const assetsNumber = 3;
      List<IconButton> crtIconButton = [];
      for (var i = 0; i < assetsNumber; i++) {
        crtIconButton.add(
          IconButton(
            icon: Icon(Icons.circle),
            onPressed: () {
              setState(() {
                transitionViewer = i;
                webViewCreating(_webViewController);
              });
            },
          ),
        );
      }
      return crtIconButton;
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SingleChildScrollView(
              child: Container(
                height: 400,
                width: 300,
                margin: const EdgeInsets.only(bottom: 30),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue),
                ),
                child: WebView(
                  initialUrl: 'about:blank',
                  onWebViewCreated: webViewCreating,
                  javascriptMode: JavascriptMode.unrestricted,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: createIconButton(),
            ),
            Container(
              width: MediaQuery.of(context).size.width / 1.3,
              height: MediaQuery.of(context).size.height / 12,
              margin: const EdgeInsets.only(top: 15),
              child: Container(
                color: Colors.red,
                child: TextButton(
                  style: TextButton.styleFrom(primary: Colors.white),
                  onPressed: () {
                    // ignore: unnecessary_statements
                    widget.showTutorial;
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) {
                        return Home();
                      }),
                    );
                  },
                  child: Text("チャットを始める"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
