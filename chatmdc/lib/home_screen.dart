import 'dart:convert';

import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  List<String> _data = [];
  static const String BOT_URL = "https://be31-34-143-167-136.ngrok-free.app";

  TextEditingController queryController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 219, 230, 243),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 255, 211, 79),
        title: Text("MDC Chatbot"),
      ),
      body: Stack(
        children: <Widget>[
          AnimatedList(
            key: _listKey,
            initialItemCount: _data.length,
            itemBuilder:
                (BuildContext context, int index, Animation<double> animation) {
              return buildItem(_data[index], animation, index);
            },
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: ColorFiltered(
                colorFilter: ColorFilter.linearToSrgbGamma(),
                child: Container(
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: TextField(
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          icon: Icon(
                            Icons.message,
                            color: Colors.blue,
                          ),
                          hintText:
                              "Hãy nhập câu hỏi, chúng tôi luôn sẵn sàng giải quyết",
                          fillColor: Colors.white12,
                        ),
                        controller: queryController,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (msg) {
                          this.getResponse();
                        },
                      ),
                    )),
              )),
        ],
      ),
    );
  }

  void getResponse() async {
    final dio = Dio(BaseOptions(
      responseType: ResponseType.json,
    ));
    // dio.options.headers['Access-Control-Allow-Origin'] = '*'; // Điều này cho phép truy cập từ tất cả các nguồn
    // dio.options.headers['Access-Control-Allow-Methods'] = 'POST';
    // dio.options.headers['Access-Control-Allow-Headers'] = 'Content-Type';
    if (queryController.text.length > 0) {
      this.insertSingleItem(queryController.text);
      //var client = getClient();

      try {
        Response response =
            await dio.post(BOT_URL, data: {"query": queryController.text});
        if (response.statusCode == 200) {
          // Process the response data here
          print(response.data);
          insertSingleItem(response.data['ans']);
        } else {
          // Handle HTTP error
          print('HTTP Error: ${response.statusCode}');
        }
      } catch (e) {
        print('An error occurred: $e');
      }
      // finally {
      //   //client.close();
      //   queryController.clear();
      // }
    }
  }

  void insertSingleItem(String message) {
    _data.add(message);
    _listKey.currentState!.insertItem(_data.length - 1);
  }

  http.Client getClient() {
    return http.Client();
  }
}

Widget buildItem(String item, Animation<double> animation, int index) {
  bool mine = item.endsWith("<bot>");
  return SizeTransition(
    sizeFactor: animation,
    child: Padding(
      padding: EdgeInsets.only(top: 10),
      child: Container(
        alignment: mine ? Alignment.topLeft : Alignment.topRight,
        child: Bubble(
          child: Text(
            item.replaceAll("<bot>", ""),
            style: TextStyle(color: mine ? Colors.white : Colors.black),
          ),
          color: mine ? Colors.blue : Colors.grey[200],
          padding: BubbleEdges.all(10),
        ),
      ),
    ),
  );
}
