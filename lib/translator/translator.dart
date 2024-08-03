import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:translator/translator.dart';

class TranslatorPage extends StatefulWidget {
  const TranslatorPage({super.key});

  @override
  State<TranslatorPage> createState() => _TranslatorPageState();
}

class _TranslatorPageState extends State<TranslatorPage> {
  final outputController = TextEditingController(text: "Result here...");
  final translator = GoogleTranslator();
  final SpeechToText speechToText = SpeechToText();

  String inputLanguage = 'en';
  String outputLanguage = 'en';
  String wordSpoken = '';
  String translatedText = '';
  bool speechEnabled = false;

  Future<void> translateText() async {
    final translated = await translator.translate(wordSpoken,
        from: inputLanguage, to: outputLanguage);
    setState(() {
      translatedText = translated.text;
    });
  }

  @override
  void initState() {
    super.initState();
    initSpeech();
  }

  void initSpeech() async {
    speechEnabled = await speechToText.initialize();
    setState(() {});
  }

  void startListening() async {
    await speechToText.listen(onResult: onSpeechResult);
    setState(() {});
  }

  void stopListening() async {
    await speechToText.stop();
    setState(() {});
  }

  void onSpeechResult(result) {
    setState(() {
      wordSpoken = "${result.recognizedWords}";
      translateText();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: axisDirectionToAxis(AxisDirection.down),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  if (speechToText.isListening) {
                    stopListening();
                  } else {
                    startListening();
                  }
                },
                onLongPressCancel: () {},
                child: CircleAvatar(
                  radius: 95,
                  child: Icon(
                    Icons.mic_rounded,
                    size: 80,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(speechToText.isListening
                  ? "Listening..."
                  : speechEnabled
                      ? "Tap the microphone to start listening..."
                      : "Speech not available"),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DropdownButton<String>(
                    value: inputLanguage,
                    items: <String>['en', 'fr', 'es', 'de', 'ur', 'hi']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        inputLanguage = newValue!;
                      });
                    },
                  ),
                  SizedBox(width: 20),
                  Icon(Icons.arrow_forward_rounded),
                  SizedBox(width: 20),
                  DropdownButton<String>(
                    value: outputLanguage,
                    items: <String>['en', 'fr', 'es', 'de', 'ur', 'hi']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        outputLanguage = newValue!;
                      });
                    },
                  ),
                ],
              ),
              Text(wordSpoken),
              Text(translatedText),
            ],
          ),
        ),
      ),
    );
  }
}
