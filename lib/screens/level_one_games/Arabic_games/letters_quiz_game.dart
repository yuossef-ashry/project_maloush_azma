import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class LettersQuizGame extends StatefulWidget {
  const LettersQuizGame({super.key});

  @override
  State<LettersQuizGame> createState() => _LettersQuizGameState();
}

class _LettersQuizGameState extends State<LettersQuizGame> {
  final AudioPlayer player = AudioPlayer();

  final List<Map<String, dynamic>> questions = [
    {"letter": "ق", "sound": "q.mp3"},
    {"letter": "ك", "sound": "k.mp3"},
    {"letter": "أ", "sound": "a.mp3"},
    {"letter": "ب", "sound": "b.mp3"},
  ];

  final List<String> letters = [
    "أ","ب","ت","ث","ج","ح","خ","د",
    "ذ","ر","ز","س","ش","ص","ض",
    "ط","ظ","ع","غ","ف","ق","ك",
    "ل","م","ن","ه","و","ي"
  ];

  int index = 0;
  int score = 0;

  List<String> options = [];

  bool showFeedback = false;
  bool isCorrect = false;
  bool showResult = false;

  @override
  void initState() {
    super.initState();
    generateOptions();
    playSound(); // 👈 يشغل أول سؤال تلقائي
  }

  String get correctLetter => questions[index]["letter"];
  String get currentSound => questions[index]["sound"];

  // 🎧 تشغيل الصوت
  Future<void> playSound() async {
    await player.stop();
    await player.play(AssetSource("sounds/$currentSound"));
  }

  void generateOptions() {
    final rand = Random();
    Set<String> temp = {correctLetter};

    while (temp.length < 4) {
      temp.add(letters[rand.nextInt(letters.length)]);
    }

    options = temp.toList()..shuffle();
  }

  void checkAnswer(String value) async {
    setState(() {
      showFeedback = true;
      isCorrect = value == correctLetter;
    });

    if (isCorrect) score++;

    await Future.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;

    if (index < questions.length - 1) {
      setState(() {
        index++;
        showFeedback = false;
        generateOptions();
      });

      await playSound(); // 👈 صوت السؤال الجديد
    } else {
      setState(() {
        showResult = true;
      });
    }
  }

  void restart() {
    setState(() {
      index = 0;
      score = 0;
      showFeedback = false;
      showResult = false;
      generateOptions();
    });

    playSound();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF81C784),

      appBar: AppBar(
        title: const Text("اسمع الحرف 🎧"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),

      body: Center(
        child: showResult ? buildResult() : buildGame(),
      ),
    );
  }

  Widget buildGame() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        const Text(
          "اسمع الحرف واضغط الإجابة 🎧",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),

        const SizedBox(height: 20),

        ElevatedButton(
          onPressed: playSound,
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
          child: const Text("🔊 إعادة تشغيل الصوت"),
        ),

        const SizedBox(height: 20),

        if (showFeedback)
          Icon(
            isCorrect ? Icons.star : Icons.cancel,
            color: isCorrect ? Colors.amber : Colors.red,
            size: 80,
          ),

        const SizedBox(height: 10),

        Column(
          children: options.map((letter) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: SizedBox(
                width: 260,
                height: 60,
                child: ElevatedButton(
                  onPressed: showFeedback ? null : () => checkAnswer(letter),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(letter, style: const TextStyle(fontSize: 28)),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget buildResult() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.emoji_events, size: 120, color: Colors.amber),
        const SizedBox(height: 20),

        const Text("أحسنت 🎉", style: TextStyle(fontSize: 28, color: Colors.white)),

        const SizedBox(height: 10),

        Text(
          "درجتك: $score / ${questions.length}",
          style: const TextStyle(fontSize: 24, color: Colors.white),
        ),

        const SizedBox(height: 30),

        ElevatedButton(
          onPressed: restart,
          style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
          child: const Text("🔄 إعادة اللعب"),
        ),
      ],
    );
  }
}