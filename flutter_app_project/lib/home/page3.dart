import 'package:flutter/material.dart';
import 'package:flutter_app_project/home/chat.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';


class Page3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    getInfo() async {
      final UserIdResponse user = await fetchUserInfo("user_1", "get_memberlist");
      return user.data;
    }
    return FutureBuilder(
      future: getInfo(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
              itemCount: 2,
              itemBuilder: (BuildContext context, int index) {
                final String memberId = snapshot.data["member_list"][index]["user_id"];
                final String nickname = snapshot.data["member_list"][index]["nickname"];
                return Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey)
                  ),
                  child: ListTile(
                    leading: Icon(Icons.person),
                    title: Text(memberId + '\n' + nickname),
                    // 画面遷移の部分である。引数としてid、name、user_idが渡される。
                    onTap: () async {
                      await Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) {
                                return Chat(id: memberId, name: nickname, myId: snapshot.data["target_user_id"],);
                              }
                          )
                      );
                    },
                    contentPadding: EdgeInsets.only(top: 10, left: 10),
                  ),
                );
              }
          );
        }
        return Container();
      },
    );
  }
}
// userの情報を受け取るために定義している
class UserIdRequest {
  final action;
  final user_id;

  UserIdRequest({this.action,
    this.user_id});

  Map<String, dynamic> toJson() => {
    'action': action,
    'user_id': user_id,
  };
}


class UserIdResponse {
  final data;

  UserIdResponse({
    this.data,
  });

  factory UserIdResponse.fromJson(Map<String, dynamic> json) {
    return UserIdResponse(
        data: json['data']
    );
  }
}

Future<UserIdResponse> fetchUserInfo(String user_id,String action) async {
  final apiUrl = "http://miraidesign.php.xdomain.jp/chat_app/index.php";

  var request = UserIdRequest(action: action, user_id: user_id);
  final response = await http.post(apiUrl,
    body: json.encode(request.toJson()),
    headers: {"Content-Type": "application/json"},
  );


  if (response.statusCode == 200) {
    var user = UserIdResponse.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    return user;
  } else {
    throw Exception('Failed to load album');
  }
}
