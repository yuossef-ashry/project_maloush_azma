import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class NumbersQuizScreen extends StatefulWidget {
  const NumbersQuizScreen({super.key});

  @override
  State<NumbersQuizScreen> createState() => _NumbersQuizScreenState();
}

class _NumbersQuizScreenState extends State<NumbersQuizScreen> {
  final AudioPlayer player = AudioPlayer();

  final List<Map<String, dynamic>> questions = [
    {"number": "1", "sound": "1.mp3"},
    {"number": "2", "sound": "2.mp3"},
    {"number": "3", "sound": "3.mp3"},
    {"number": "4", "sound": "4.mp3"},
    {"number": "5", "sound": "5.mp3"},
    {"number": "6", "sound": "6.mp3"},
    {"number": "7", "sound": "7.mp3"},
    {"number": "8", "sound": "8.mp3"},
    {"number": "9", "sound": "9.mp3"},
    {"number": "10", "sound": "10.mp3"},
  ];

  final List<String> numbers = [
    "1","2","3","4","5","6","7","8","9","10"
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
    playSound();
  }

  String get correctNumber => questions[index]["number"];
  String get currentSound => questions[index]["sound"];

  /// 🔊 تشغيل الصوت
  Future<void> playSound() async {
    await player.stop();
    await player.play(AssetSource("sounds/$currentSound"));
  }

  void generateOptions() {
    final rand = Random();
    Set<String> temp = {correctNumber};

    while (temp.length < 4) {
      temp.add(numbers[rand.nextInt(numbers.length)]);
    }

    options = temp.toList()..shuffle();
  }

  void checkAnswer(String value) async {
    setState(() {
      showFeedback = true;
      isCorrect = value == correctNumber;
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

      await playSound();
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
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4FC3F7),

      appBar: AppBar(
        title: const Text("اسمع الرقم 🎧"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
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

        /// 🧠 تعليمات
        const Text(
          "اسمع الرقم واختر الإجابة 🎧",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),

        const SizedBox(height: 20),

        /// 🔊 زر الصوت
        ElevatedButton(
          onPressed: playSound,
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
          child: const Text("🔊 إعادة تشغيل الصوت"),
        ),

        const SizedBox(height: 20),

        /// ⭐ feedback
        if (showFeedback)
          Icon(
            isCorrect ? Icons.star : Icons.cancel,
            color: isCorrect ? Colors.amber : Colors.red,
            size: 80,
          ),

        const SizedBox(height: 10),

        /// 🔘 options
        Column(
          children: options.map((value) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: SizedBox(
                width: 260,
                height: 60,
                child: ElevatedButton(
                  onPressed: showFeedback ? null : () => checkAnswer(value),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    value,
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
        const Icon(Icons.emoji_events,
            size: 120, color: Colors.amber),

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