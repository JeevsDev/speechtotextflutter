import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Speech To Text',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const SpeechScreen(),
    );
  }
}

class SpeechScreen extends StatefulWidget {
  const SpeechScreen({super.key});

  @override
  State<SpeechScreen> createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {
  SpeechToText speechToText = SpeechToText();
  var isListening = false;
  var text = 'Press the button and start speaking.';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Speech To Text'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: isListening,
        glowColor: Theme.of(context).primaryColor,
        endRadius: 75.0,
        duration: const Duration(milliseconds: 2000),
        repeatPauseDuration: const Duration(milliseconds: 100),
        repeat: true,
        showTwoGlows: true,
        child: GestureDetector(
              onTapDown: (details) async {
                if (!isListening) {
                  var available = await speechToText.initialize();
                  if (available) {
                    setState(() {
                      isListening = true;
                      speechToText.listen(
                        onResult:(result) {
                          setState(() {
                            text = result.recognizedWords;
                          });
                        },
                      );
                    });
                  }
                }
              },
              onTapUp: (details) {
                setState(() { 
                  isListening = false;
                });
                speechToText.stop();
              },
          
          child: CircleAvatar(
            backgroundColor: Colors.red,
            radius: 35,
            child: Icon(isListening ? Icons.mic: Icons.mic_none),


            ),
          ),
        ),
      body: SingleChildScrollView(
        reverse: true,
        child: Container(
          padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 150.0),
          // ignore: prefer_const_constructors
          child: Text(text, style: TextStyle(fontSize: 32.0, color: Colors.black, fontWeight: FontWeight.w400),),
        ),
      ),
    );
  }
}