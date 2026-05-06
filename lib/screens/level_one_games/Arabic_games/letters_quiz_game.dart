import 'dart:math';
import 'package:flutter/material.dart';

class LettersQuizGame extends StatefulWidget {
  const LettersQuizGame({super.key});

  @override
  State<LettersQuizGame> createState() => _LettersQuizGameState();
}

class _LettersQuizGameState extends State<LettersQuizGame> {
  final List<Map<String, dynamic>> questions = [
    {"image": "assets/images/cat.png", "letter": "ق"},
    {"image": "assets/images/dog.png", "letter": "ك"},
    {"image": "assets/images/lion.png", "letter": "أ"},
    {"image": "assets/images/banana.png", "letter": "ب"},
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
  }

  String get currentImage => questions[index]["image"];
  String get correctLetter => questions[index]["letter"];

  /// ✅ توليد اختيارات صحيحة 100%
  void generateOptions() {
    final rand = Random();

    Set<String> temp = {};
    temp.add(correctLetter);

    while (temp.length < 4) {
      temp.add(letters[rand.nextInt(letters.length)]);
    }

    options = temp.toList()..shuffle();
  }

  void checkAnswer(String value) {
    setState(() {
      showFeedback = true;
      isCorrect = value == correctLetter;

      if (isCorrect) {
        score++;
      }
    });

    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;

      if (index < questions.length - 1) {
        setState(() {
          index++;
          showFeedback = false;
          generateOptions();
        });
      } else {
        setState(() {
          showResult = true;
        });
      }
    });
  }

  void restart() {
    setState(() {
      index = 0;
      score = 0;
      showFeedback = false;
      showResult = false;
      generateOptions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF81C784),

      appBar: AppBar(
        title: const Text("حرف وصورة"),
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

        /// 🖼️ الصورة
        Container(
          width: 180,
          height: 180,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Image.asset(
              currentImage,
              fit: BoxFit.contain,
            ),
          ),
        ),

        const SizedBox(height: 20),

        const Text(
          "الصورة تبدأ بأي حرف؟",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),

        const SizedBox(height: 15),

        /// ⭐ Feedback
        if (showFeedback)
          Icon(
            isCorrect ? Icons.star : Icons.cancel,
            color: isCorrect ? Colors.amber : Colors.red,
            size: 80,
          ),

        const SizedBox(height: 10),

        /// 🔘 الأزرار (مضمونة 4)
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
                  child: Text(
                    letter,
                    style: const TextStyle(fontSize: 28),
                  ),
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

        const Text(
          "أحسنت 🎉",
          style: TextStyle(fontSize: 28, color: Colors.white),
        ),

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