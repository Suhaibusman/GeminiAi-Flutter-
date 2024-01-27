// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

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
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                _scaffoldKey.currentState!.openDrawer();
              },
              icon: const Icon(
                Icons.menu,
                color: Colors.white,
              )),
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
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(
                    0,
                    166,
                    126,
                    1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(
                          'https://media.licdn.com/dms/image/D5603AQEm8gqDfvzrBA/profile-displayphoto-shrink_800_800/0/1689103165548?e=2147483647&v=beta&t=g7TaydPxRthr2NDcvMNIKXHSoi_r2UvYz8FYKz3BuFI',
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: Text(
                        'Developed By Muhammad Suhaib',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: Image.network(
                  'https://img.icons8.com/color/48/000000/portfolio.png', // Portfolio icon
                  height: 24,
                  width: 24,
                ),
                title: const Text('Click to See Portfolio'),
                onTap: () {
                  // Handle portfolio tap
                  launch('https://suhaibportfolio.vercel.app/');
                },
              ),
              ListTile(
                leading: Image.network(
                  'https://img.icons8.com/color/48/000000/gmail.png', // Gmail icon
                  height: 24,
                  width: 24,
                ),
                title: const Text('suhaibusman54@gmail.com'),
                onTap: () {
                  launch('mailto:suhaibusman54@gmail.com');
                  // Handle email tap
                },
              ),
              ListTile(
                leading: Image.network(
                  'https://img.icons8.com/color/48/000000/whatsapp.png', // WhatsApp icon
                  height: 24,
                  width: 24,
                ),
                title: const Text(' 03112136120'),
                onTap: () {
                  launch(
                      'https://api.whatsapp.com/send?phone=+923112136120&text=Hello,%20Suhaib%20See%20Your%20GeminiAiApp');
                  // Handle contact tap
                },
              ),
              ListTile(
                leading: Image.network(
                  'https://img.icons8.com/color/48/000000/linkedin.png', // LinkedIn icon
                  height: 24,
                  width: 24,
                ),
                title: const Text('Muhammad Suhaib Usman'),
                onTap: () {
                  launch('https://www.linkedin.com/in/suhaibusman/');
                },
              ),
              ListTile(
                leading: Image.network(
                  'https://img.icons8.com/color/48/000000/instagram.png', // Instagram icon
                  height: 24,
                  width: 24,
                ),
                title: const Text('suhaib__usman'),
                onTap: () {
                  launch('https://instagram.com/suhaib__usman');
                },
              ),
              ListTile(
                leading: Image.network(
                  'https://img.icons8.com/color/48/000000/facebook-new.png', // Facebook icon
                  height: 24,
                  width: 24,
                ),
                title: const Text('Muhammad Suhaib'),
                onTap: () {
                  launch('https://www.facebook.com/MuhammadSuhaib0/');
                },
              ),
            ],
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
