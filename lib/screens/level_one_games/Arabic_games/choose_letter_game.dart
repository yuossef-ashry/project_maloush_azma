import 'dart:math';
import 'package:flutter/material.dart';

class ChooseLetterGame extends StatefulWidget {
  const ChooseLetterGame({super.key});

  @override
  State<ChooseLetterGame> createState() => _ChooseLetterGameState();
}

class _ChooseLetterGameState extends State<ChooseLetterGame> {
  final List<Map<String, String>> questions = [
    {"word": "أسد", "letter": "أ"},
    {"word": "بطة", "letter": "ب"},
    {"word": "تفاح", "letter": "ت"},
    {"word": "ثعلب", "letter": "ث"},
    {"word": "جمل", "letter": "ج"},
    {"word": "حوت", "letter": "ح"},
    {"word": "خبز", "letter": "خ"},
    {"word": "دب", "letter": "د"},
    {"word": "ذرة", "letter": "ذ"},
    {"word": "رمان", "letter": "ر"},
  ];

  final List<String> letters = [
    "أ","ب","ت","ث","ج","ح","خ","د","ذ","ر","ز","س","ش","ص","ض"
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

  String get word => questions[index]["word"]!;
  String get correct => questions[index]["letter"]!;

  void generateOptions() {
    final rand = Random();
    Set<String> set = {correct};

    while (set.length < 4) {
      set.add(letters[rand.nextInt(letters.length)]);
    }

    options = set.toList()..shuffle();
  }

  void check(String value) {
    if (answered) return;

    setState(() {
      selected = value;
      answered = true;

      if (value == correct) score++;
    });

    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;

      if (index == questions.length - 1) {
        setState(() => showResult = true);
      } else {
        setState(() {
          index++;
          selected = null;
          answered = false;
          generateOptions();
        });
      }
    });
  }

  void restart() {
    setState(() {
      index = 0;
      score = 0;
      selected = null;
      answered = false;
      showResult = false;
      generateOptions();
    });
  }

  // ───────── BACKGROUND ─────────
  Widget buildBackground({required Widget child}) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF4FC3F7),
            Color(0xFF81C784),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: child,
    );
  }

  Color color(String v) {
    if (!answered) return Colors.orange;
    if (v == correct) return Colors.green;
    if (v == selected) return Colors.red;
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildBackground(
        child: showResult ? buildResult() : buildGame(),
      ),
    );
  }

  // ───── GAME ─────
  Widget buildGame() {
    return SafeArea(
      child: Column(
        children: [

          // HEADER
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                ),

                const Text(
                  "اختبار الحروف",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber),
                    const SizedBox(width: 5),
                    Text("$score",
                        style: const TextStyle(color: Colors.white)),
                  ],
                ),
              ],
            ),
          ),

          // PROGRESS
          Row(
            children: List.generate(questions.length, (i) {
              return Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  height: 8,
                  decoration: BoxDecoration(
                    color: i <= index ? Colors.white : Colors.white38,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            }),
          ),

          const SizedBox(height: 25),

          // CARD
          Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Column(
              children: [
                Text(word, style: const TextStyle(fontSize: 40)),
                const SizedBox(height: 10),
                const Text("يبدأ بأي حرف؟"),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // OPTIONS
          Column(
            children: options.map((e) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: SizedBox(
                  width: 260,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color(e),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () => check(e),
                    child: Text(
                      e,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ───── RESULT ─────
  Widget buildResult() {
    int stars = (score / questions.length * 3).round();

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          const Text("🏆", style: TextStyle(fontSize: 80)),

          const SizedBox(height: 10),

          const Text(
            "أحسنت!",
            style: TextStyle(fontSize: 28, color: Colors.white),
          ),

          Text(
            "درجتك: $score / ${questions.length}",
            style: const TextStyle(color: Colors.white),
          ),

          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              3,
                  (i) => Icon(
                Icons.star,
                color: i < stars ? Colors.amber : Colors.white30,
              ),
            ),
          ),

          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: restart,
            child: const Text("إعادة اللعب"),
          ),
        ],
      ),
    );
  }
}