import 'package:flutter/material.dart';
import 'package:travel/chatbot/chatbot.dart';
import 'package:travel/chatbot/consts.dart';
import 'package:travel/pages/description.dart';
import 'package:travel/pages/getstarted.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

void main() {
  Gemini.init(apiKey: GEMINI_API_KEY);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ChatBotPage(),
    );
  }
}
