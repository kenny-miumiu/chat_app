import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  // 相手のID、自分のID、相手の名前を引数で受け取る
  final id;
  final name;
  final myId;
  Chat({
    this.id,
    this.name,
    this.myId
  });
  _Chat createState() => _Chat();
}

class _Chat extends State<Chat> {

  @override
  Widget build(BuildContext context) {

    final ScrollController scrollController = ScrollController();
    final TextEditingController textEditingController = TextEditingController();

    // メッセージの中身の情報を返す
    getInfo() async {
      final MessageIdResponse message = await fetchUserInfo(widget.myId, widget.id);
      return message.data;
    }

    return FutureBuilder(
      future: getInfo(),
      builder: (context, snapshot) {
        // データがあれば分岐を作る
        if(snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              title: Text(widget.name),
            ),
            // 二つの要素を並べるためColumnを使用している
            body: Column(
              children: [
                Expanded(
                  flex: 9,
                  child: ListView.builder(
                    controller: scrollController,
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    // チャットリストに入っている値次第でListViewの子の長さを増やしていく。
                    itemCount: snapshot.data["chat_list"].length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        padding: EdgeInsets.only(top: 10.0, right: 14.0,left: 14.0, bottom: 10.0),
                        child: Align(
                          alignment: snapshot.data["chat_list"][index]["user_id_to"] == widget.id ? Alignment.topRight: Alignment.topLeft,
                          child: snapshot.data["chat_list"][index]["user_id_to"] == widget.id ? Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                  decoration: BoxDecoration (
                                      border: Border.all(color: Colors.blue),
                                      borderRadius: BorderRadius.circular(8.0)
                                  ),
                                  width: 300,
                                  padding: EdgeInsets.all(16.0),
                                  // メッセージ表示
                                  child:  Text(snapshot.data["chat_list"][index]["message"])
                              ),
                              Icon(Icons.person),
                            ],
                          ): Row(
                            children: [
                              Icon(Icons.person),
                              Container(
                                  decoration: BoxDecoration (
                                      border: Border.all(color: Colors.blue),
                                      borderRadius: BorderRadius.circular(8.0)
                                  ),
                                  width: 300,
                                  padding: EdgeInsets.all(16.0),
                                  // メッセージ表示
                                  child:  Text(snapshot.data["chat_list"][index]["message"])
                              ),

                            ],
                          )
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.camera_alt),
                      ),
                      IconButton(
                        icon: Icon(Icons.photo),
                      ),
                      Expanded(
                        child: TextField(
                          controller: textEditingController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder()
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.send),
                        onPressed: () async {
                          final String message = textEditingController.text;

                          // POSTリクエストを行う
                          await sendMessage(widget.id, widget.myId, message);

                          // テキスト表示の中身をクリアする
                          textEditingController.clear();
                          // タッチキーボードの解除
                          FocusScopeNode currentFocus = FocusScope.of(context);
                          if (!currentFocus.hasPrimaryFocus) {
                            currentFocus.unfocus();
                          }

                          // stateの更新を行う。＊これがないとリロードされない
                          setState(() {});
                        },
                      )
                    ],
                  ),
                ),
              ],
            )
          );
        }

        return Container();
      },
    );
  }
}

class MessageIdRequest {
  final user_id_from;
  final user_id_to;

  MessageIdRequest({this.user_id_from,
    this.user_id_to});

  Map<String, dynamic> toJson() => {
    'user_id_from': user_id_from,
    'user_id_to': user_id_to,
  };
}


class MessageIdResponse {
  final data;

  MessageIdResponse({
    this.data,
  });

  factory MessageIdResponse.fromJson(Map<String, dynamic> json) {
    return MessageIdResponse(
        data: json['data']
    );
  }
}

Future<MessageIdResponse> fetchUserInfo(String user_id_to,String user_id_from) async {
  final apiUrl = "http://miraidesign.php.xdomain.jp/chat_app/index.php";

  var request = MessageIdRequest(user_id_from: user_id_from, user_id_to: user_id_to);
  final response = await http.post(apiUrl,
    body: json.encode(request.toJson()),
    headers: {"Content-Type": "application/json"},
  );


  if (response.statusCode == 200) {
    var message = MessageIdResponse.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    return message;
  } else {
    throw Exception('Failed to load album');
  }
}

class MessageRequest {
  final user_id_from;
  final user_id_to;
  final message;

  MessageRequest({this.user_id_from,
    this.user_id_to, this.message});

  Map<String, dynamic> toJson() => {
    'user_id_from': user_id_from,
    'user_id_to': user_id_to,
    'message': message
  };
}

class MessageResponse {
  final data;

  MessageResponse({
    this.data,
  });

  factory MessageResponse.fromJson(Map<String, dynamic> json) {
    return MessageResponse(
        data: json['data']
    );
  }
}

Future<MessageResponse> sendMessage(String user_id_to, String user_id_from, String message) async {
  final apiUrl = "http://miraidesign.php.xdomain.jp/chat_app/index.php";

  var request = MessageRequest(user_id_from: user_id_from, user_id_to: user_id_to, message: message);
  final response = await http.post(apiUrl,
    body: json.encode(request.toJson()),
    headers: {"Content-Type": "application/json"},
  );

  if (response.statusCode == 200) {
    var message = MessageResponse.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    print(message.data);
    return message;
  } else {
    throw Exception('Failed to load album');
  }
}

