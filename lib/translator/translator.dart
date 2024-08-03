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

  String inputLanguage = 'English'; // Correct initial value
  String outputLanguage = 'English'; // Correct initial value
  String inputLanguageSymbol = 'en';
  String outputLanguageSymbol = 'en';
  String wordSpoken = 'spoken';
  String translatedText = 'translate';
  bool speechEnabled = false;

  Future<void> translateText() async {
    final translated = await translator.translate(wordSpoken,
        from: inputLanguageSymbol, to: outputLanguageSymbol);
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

  void changeLanguageToSymbol() {
    if (inputLanguage == "English") {
      inputLanguageSymbol = "en";
    } else if (inputLanguage == "Malay") {
      inputLanguageSymbol = "ms";
    } else if (inputLanguage == "Chinese") {
      inputLanguageSymbol = "zh-CN";
    } else if (inputLanguage == "French") {
      inputLanguageSymbol = "fr";
    } else if (inputLanguage == "Korean") {
      inputLanguageSymbol = "ko";
    } else if (inputLanguage == "Hindi") {
      inputLanguageSymbol = "hi";
    }
    // Also update outputLanguageSymbol if needed
    if (outputLanguage == "English") {
      outputLanguageSymbol = "en";
    } else if (outputLanguage == "Malay") {
      outputLanguageSymbol = "ms";
    } else if (outputLanguage == "Chinese") {
      outputLanguageSymbol = "zh-CN";
    } else if (outputLanguage == "French") {
      outputLanguageSymbol = "fr";
    } else if (outputLanguage == "Korean") {
      outputLanguageSymbol = "ko";
    } else if (outputLanguage == "Hindi") {
      outputLanguageSymbol = "hi";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        scrollDirection: axisDirectionToAxis(AxisDirection.down),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
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
                  items: <String>[
                    'English',
                    'Malay',
                    'Chinese',
                    'French',
                    'Korean',
                    'Hindi'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      inputLanguage = newValue!;
                      changeLanguageToSymbol();
                    });
                  },
                ),
                SizedBox(width: 20),
                Icon(Icons.arrow_forward_rounded),
                SizedBox(width: 20),
                DropdownButton<String>(
                  value: outputLanguage,
                  items: <String>[
                    'English',
                    'Malay',
                    'Chinese',
                    'French',
                    'Korean',
                    'Hindi'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      outputLanguage = newValue!;
                      changeLanguageToSymbol();
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Color(0xff97AFB8),
                ),
                width: MediaQuery.of(context).size.width * 0.80,
                height: MediaQuery.of(context).size.height * 0.16,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        // Padding(
                        //   padding: const EdgeInsets.all(5.0),
                        //   child: Text(
                        //     inputLanguage,
                        //     style: TextStyle(
                        //         fontSize: 15, fontWeight: FontWeight.w400),
                        //   ),
                        // ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            wordSpoken,
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
            SizedBox(height: 30),
            Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Color(0xff97AFB8),
                ),
                width: MediaQuery.of(context).size.width * 0.80,
                height: MediaQuery.of(context).size.height * 0.16,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        // Padding(
                        //   padding: const EdgeInsets.all(5.0),
                        //   child: Text(
                        //     inputLanguage,
                        //     style: TextStyle(
                        //         fontSize: 15, fontWeight: FontWeight.w400),
                        //   ),
                        // ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            translatedText,
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
