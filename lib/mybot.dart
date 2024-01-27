import 'dart:convert';

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ourUrl =
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=AIzaSyCZpXFRgBMJ_2J7pk-E810v9eFrkavPgPM";

  ChatUser currentUser = ChatUser(
    id: "1",
    firstName: "Muhammad",
    lastName: "Suhaib",
  );
  ChatUser bot = ChatUser(
    id: "2",
    firstName: "Gemini",
    lastName: "Ai",
  );

  List<ChatMessage> allMessages = [];
  List<ChatUser> typing = [];
  final header = {"Content-Type": "application/json"};
  getData(ChatMessage message) async {
    typing.add(bot);
    allMessages.insert(0, message);
    setState(() {});

    var data = {
      "contents": [
        {
          "parts": [
            {"text": message.text}
          ]
        }
      ]
    };

    try {
      var response = await http.post(Uri.parse(ourUrl),
          headers: header, body: jsonEncode(data));

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);

        setState(() {
          ChatMessage message2 = ChatMessage(
            user: bot,
            text: responseData['candidates'][0]['content']['parts'][0]['text'],
            createdAt: DateTime.now(),
          );

          allMessages.insert(0, message2);
        });
      } else {
        showAboutDialog(context: context, children: [Text(response.body)]);
      }
    } catch (e) {
      showAboutDialog(context: context, children: [Text(e.toString())]);
    }

    typing.remove(bot);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(onPressed: () {}, icon: Icon(Icons.menu)),
          title: const Text(
            'Gemini AI',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          backgroundColor: const Color.fromRGBO(
            0,
            166,
            126,
            1,
          ),
        ),
        body: DashChat(
          typingUsers: typing,
          currentUser: currentUser,
          onSend: (ChatMessage message) {
            getData(message);
          },
          messages: allMessages,
          inputOptions: const InputOptions(
              cursorStyle: CursorStyle(
            color: Color.fromRGBO(
              0,
              166,
              126,
              1,
            ),
          )),
          messageOptions: const MessageOptions(
            currentUserContainerColor: Color.fromRGBO(
              0,
              166,
              126,
              1,
            ),
          ),
        ));
  }
}
