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
    {"word": "زرافة", "letter": "ز"},
    {"word": "سمك", "letter": "س"},
    {"word": "شمس", "letter": "ش"},
    {"word": "صقر", "letter": "ص"},
    {"word": "ضفدع", "letter": "ض"},
    {"word": "طائرة", "letter": "ط"},
    {"word": "ظرف", "letter": "ظ"},
    {"word": "عنب", "letter": "ع"},
    {"word": "غزال", "letter": "غ"},
    {"word": "فيل", "letter": "ف"},
    {"word": "قلم", "letter": "ق"},
    {"word": "كتاب", "letter": "ك"},
    {"word": "ليمون", "letter": "ل"},
    {"word": "موز", "letter": "م"},
    {"word": "نمر", "letter": "ن"},
    {"word": "هدهد", "letter": "ه"},
    {"word": "وردة", "letter": "و"},
    {"word": "يمامة", "letter": "ي"},
  ];

  final List<String> letters = [
    "أ","ب","ت","ث","ج","ح","خ","د",
    "ذ","ر","ز","س","ش","ص","ض",
    "ط","ظ","ع","غ","ف","ق","ك",
    "ل","م","ن","ه","و","ي","ء"
  ];

  int index = 0;
  int score = 0;

  List<String> options = [];

  String? selected;
  bool answered = false;

  bool showWrong = false;
  bool showResult = false;

  @override
  void initState() {
    super.initState();
    generateOptions();
  }

  String get currentWord => questions[index]["word"]!;
  String get correctLetter => questions[index]["letter"]!;

  void generateOptions() {
    Set<String> temp = {correctLetter};
    final rand = Random();

    while (temp.length < 4) {
      temp.add(letters[rand.nextInt(letters.length)]);
    }

    options = temp.toList()..shuffle();
  }

  void checkAnswer(String value) {
    if (answered) return;

    setState(() {
      selected = value;
      answered = true;
    });

    bool isCorrect = value == correctLetter;

    if (isCorrect) score++;

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

  Color getButtonColor(String letter) {
    if (!answered) return Colors.orange;

    if (letter == correctLetter) {
      return Colors.green; // الصح
    }

    if (letter == selected) {
      return Colors.red; // الغلط اللي ضغط عليه
    }

    return Colors.grey.shade400;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF81C784),

      appBar: AppBar(
        title: const Text("اختبار 28 حرف"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      body: Center(
        child: showResult
            ? buildResult()
            : buildGame(),
      ),
    );
  }

  Widget buildGame() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Column(
            children: [

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
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ),

              const SizedBox(height: 15),

              const Text(
                "تبدأ بحرف ...... ؟",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        Column(
          children: options.map((letter) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: SizedBox(
                width: 250,
                height: 60,
                child: ElevatedButton(
                  onPressed: () => checkAnswer(letter),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: getButtonColor(letter),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    letter,
                    style: const TextStyle(fontSize: 30),
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
        const Icon(Icons.emoji_events, color: Colors.amber, size: 120),
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