import 'dart:math';
import 'package:flutter/material.dart';

class ChooseNumberScreen extends StatefulWidget {
  const ChooseNumberScreen({super.key});

  @override
  State<ChooseNumberScreen> createState() =>
      _ChooseNumberScreenState();
}

class _ChooseNumberScreenState extends State<ChooseNumberScreen> {
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

  final numbers = ["1","2","3","4","5","6","7","8","9","10"];

  int index = 0;
  int score = 0;

  List<String> options = [];
  String? selected;
  bool answered = false;

  Map<String, String> get current => questions[index];
  String get word => current["word"]!;
  String get correct => current["number"]!;

  double get progress => (index + 1) / questions.length;

  @override
  void initState() {
    super.initState();
    generateOptions();
  }

  void generateOptions() {
    Set<String> temp = {correct};
    final rand = Random();

    while (temp.length < 4) {
      temp.add(numbers[rand.nextInt(numbers.length)]);
    }

    options = temp.toList()..shuffle();
  }

  void reset() {
    setState(() {
      index = 0;
      score = 0;
      selected = null;
      answered = false;
      generateOptions();
    });
  }

  void nextQuestion() {
    if (index < questions.length - 1) {
      setState(() {
        index++;
        selected = null;
        answered = false;
        generateOptions();
      });
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ResultScreen(
            score: score,
            total: questions.length,
            onRestart: () {
              Navigator.pop(context);
              reset();
            },
          ),
        ),
      );
    }
  }

  void check(String value) async {
    if (answered) return;

    setState(() {
      selected = value;
      answered = true;
    });

    if (value == correct) score++;

    await Future.delayed(const Duration(milliseconds: 500));

    nextQuestion();
  }

  Color btnColor(String v) {
    if (!answered) return Colors.white;
    if (v == correct) return Colors.green;
    if (v == selected) return Colors.red;
    return Colors.white;
  }

  Color txtColor(String v) {
    if (!answered) return const Color(0xFF173F73);
    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4FC3F7), Color(0xFF81C784)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [

              /// 🔝 HEADER
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back,
                          color: Colors.white),
                    ),
                    const Text(
                      "اختبار الأرقام",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "$score ⭐",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              /// 📊 PROGRESS
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 10,
                  backgroundColor: Colors.white30,
                  valueColor:
                  const AlwaysStoppedAnimation(Colors.orange),
                ),
              ),

              const SizedBox(height: 30),

              const Text(
                "اختر الرقم الصحيح 👇",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 20),

              /// 🟡 CARD
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade200,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    word,
                    style: const TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// 🔢 OPTIONS
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: options.length,
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 1.4,
                  ),
                  itemBuilder: (context, i) {
                    final v = options[i];

                    return GestureDetector(
                      onTap: () => check(v),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        decoration: BoxDecoration(
                          color: btnColor(v),
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(.12),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            )
                          ],
                        ),
                        child: Center(
                          child: Text(
                            v,
                            style: TextStyle(
                              fontSize: 38,
                              fontWeight: FontWeight.bold,
                              color: txtColor(v),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class ResultScreen extends StatelessWidget {
  final int score;
  final int total;
  final VoidCallback onRestart;

  const ResultScreen({
    super.key,
    required this.score,
    required this.total,
    required this.onRestart,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4FC3F7), Color(0xFF81C784)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(35),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 15,
                  offset: Offset(0, 8),
                )
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                const Text(
                  "🎉 ممتاز!",
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                Text(
                  "$score / $total",
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  score == total
                      ? "🔥 شاطر جدًا!"
                      : "👍 حاول مرة تانية",
                  style: const TextStyle(fontSize: 20),
                ),

                const SizedBox(height: 30),

                ElevatedButton.icon(
                  onPressed: onRestart,
                  icon: const Icon(Icons.refresh),
                  label: const Text("إعادة اللعب"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}