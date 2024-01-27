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
    http
        .post(Uri.parse(ourUrl), headers: header, body: jsonEncode(data))
        .then((value) {
      if (value.statusCode == 200) {
        var response = jsonDecode(value.body);
        // ignore: avoid_print
        print(response['candidates'][0]['content']['parts'][0]['text']);

        setState(() {
          ChatMessage message2 = ChatMessage(
            user: bot,
            text: response['candidates'][0]['content']['parts'][0]['text'],
            createdAt: DateTime.now(),
          );

          allMessages.insert(0, message2);
        });
      } else {
        showAboutDialog(context: context, children: [Text(value.body)]);
      }
    }).catchError((e) {
      showAboutDialog(context: context, children: [Text(e.toString())]);
    });
    typing.remove(bot);
    setState(() {});
  }

  //   AIzaSyCZpXFRgBMJ_2J7pk-E810v9eFrkavPgPM

  //   curl \
  // -H 'Content-Type: application/json' \
  // -d '{"contents":[{"parts":[{"text":"Write a story about a magic backpack"}]}]}' \
  // -X POST https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=AIzaSyCZpXFRgBMJ_2J7pk-E810v9eFrkavPgPM

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Gemini AI'),
          backgroundColor: const Color.fromARGB(255, 0, 170, 255),
        ),
        body: DashChat(
            typingUsers: typing,
            currentUser: currentUser,
            onSend: (ChatMessage message) {
              getData(message);
            },
            messages: allMessages));
  }
}
