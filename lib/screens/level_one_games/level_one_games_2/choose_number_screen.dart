import 'dart:math';
import 'package:flutter/material.dart';

class ChooseNumberScreen extends StatefulWidget {
  const ChooseNumberScreen({super.key});

  @override
  State<ChooseNumberScreen> createState() => _ChooseNumberScreenState();
}

class _ChooseNumberScreenState extends State<ChooseNumberScreen> {
  /// 🟢 الكلمات (السؤال)
  final List<Map<String, String>> questions = [
    {"word": "واحد", "number": "1"},
    {"word": "اثنين", "number": "2"},
    {"word": "ثلاثة", "number": "3"},
    {"word": "أربعة", "number": "4"},
    {"word": "خمسة", "number": "5"},
    {"word": "ستة", "number": "6"},
    {"word": "سبعة", "number": "7"},
    {"word": "ثمانية", "number": "8"},
    {"word": "تسعة", "number": "9"},
    {"word": "عشرة", "number": "10"},
  ];

  final List<String> numbers = [
    "1","2","3","4","5","6","7","8","9","10"
  ];

  int index = 0;
  int score = 0;

  List<String> options = [];
  String? selected;
  bool answered = false;
  bool showResult = false;

  @override
  void initState() {
    super.initState();
    generateOptions();
  }

  /// 📌 السؤال الحالي
  String get currentWord => questions[index]["word"]!;
  String get correctAnswer => questions[index]["number"]!;

  void generateOptions() {
    Set<String> temp = {correctAnswer};
    final rand = Random();

    while (temp.length < 4) {
      temp.add(numbers[rand.nextInt(numbers.length)]);
    }

    options = temp.toList()..shuffle();
  }

  void checkAnswer(String value) {
    if (answered) return;

    setState(() {
      selected = value;
      answered = true;
    });

    if (value == correctAnswer) score++;

    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;

      if (index < questions.length - 1) {
        setState(() {
          index++;
          generateOptions();
          selected = null;
          answered = false;
        });
      } else {
        setState(() {
          showResult = true;
        });
      }
    });
  }

  void restartGame() {
    setState(() {
      index = 0;
      score = 0;
      selected = null;
      answered = false;
      showResult = false;
      generateOptions();
    });
  }

  Color getColor(String value) {
    if (!answered) return Colors.orange;

    if (value == correctAnswer) {
      return Colors.green;
    }

    if (value == selected) {
      return Colors.red;
    }

    return Colors.grey.shade400;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4FC3F7),

      appBar: AppBar(
        title: const Text("اختبار الأرقام"),
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

        /// 🔥 رقم السؤال
        Text(
          "سؤال ${index + 1} من ${questions.length}",
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),

        const SizedBox(height: 15),

        /// 🟡 الكارد
        Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Column(
            children: [

              /// 🔤 الكلمة (بدل الرقم)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.amber.shade200,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  currentWord,
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ),

              const SizedBox(height: 15),

              const Text(
                "اختر الرقم الصحيح 👇",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        /// 🔘 الاختيارات
        Column(
          children: options.map((value) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: SizedBox(
                width: 250,
                height: 60,
                child: ElevatedButton(
                  onPressed: () => checkAnswer(value),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: getColor(value),
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
            color: Colors.amber, size: 120),

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
          onPressed: restartGame,
          child: const Text("🔄 إعادة اللعب"),
        ),
      ],
    );
  }
}