import 'package:flutter/material.dart';
import 'package:travel/chatbot/consts.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:travel/pages/getstarted.dart';

void main() {
  Gemini.init(apiKey: GEMINI_API_KEY);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GetStarted(),
    );
  }
}
