import 'package:flutter/material.dart';

class MatchImageNumberScreen extends StatefulWidget {
  const MatchImageNumberScreen({super.key});

  @override
  State<MatchImageNumberScreen> createState() =>
      _MatchImageNumberScreenState();
}

class _MatchImageNumberScreenState extends State<MatchImageNumberScreen> {
  final List<Map<String, dynamic>> questions = [
    {"emoji": "🍎", "count": 1},
    {"emoji": "🍌", "count": 2},
    {"emoji": "🍓", "count": 3},
    {"emoji": "⚽", "count": 4},
    {"emoji": "⭐", "count": 1},
    {"emoji": "🚗", "count": 2},
    {"emoji": "🐥", "count": 3},
    {"emoji": "🌸", "count": 4},
    {"emoji": "🍇", "count": 2},
    {"emoji": "🦋", "count": 3},
  ];

  final options = [1, 2, 3, 4];

  int index = 0;
  int score = 0;
  int selected = -1;

  Map<String, dynamic> get current => questions[index];
  int get correct => current["count"];
  String get emoji => current["emoji"];

  double get progress => (index + 1) / questions.length;

  void reset() {
    setState(() {
      index = 0;
      score = 0;
      selected = -1;
    });
  }

  void answer(int value) async {
    if (selected != -1) return;

    setState(() => selected = value);

    await Future.delayed(const Duration(milliseconds: 500));

    if (value == correct) score++;

    if (index == questions.length - 1) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text(
            "🎉 ممتاز",
            textAlign: TextAlign.center,
          ),
          content: Text(
            "النتيجة: $score / ${questions.length}",
            textAlign: TextAlign.center,
          ),
          actions: [
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  reset();
                },
                child: const Text("إعادة اللعب"),
              ),
            )
          ],
        ),
      );
    } else {
      setState(() {
        index++;
        selected = -1;
      });
    }
  }

  Color optionColor(int opt) {
    if (selected == -1) return Colors.white;

    if (opt == correct) return Colors.green;
    if (opt == selected) return Colors.red;

    return Colors.white;
  }

  Color textColor(int opt) {
    if (selected == -1) return const Color(0xFF173F73);
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
                      "صل الصور بالرقم",
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
                "كم عددهم؟",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
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
                child: Column(
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      alignment: WrapAlignment.center,
                      children: List.generate(
                        correct,
                            (_) => Text(
                          emoji,
                          style: const TextStyle(fontSize: 60),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    if (selected != -1)
                      Icon(
                        selected == correct
                            ? Icons.check_circle
                            : Icons.cancel,
                        color: selected == correct
                            ? Colors.green
                            : Colors.red,
                        size: 55,
                      ),
                  ],
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
                    final opt = options[i];

                    return GestureDetector(
                      onTap: () => answer(opt),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        decoration: BoxDecoration(
                          color: optionColor(opt),
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
                            "$opt",
                            style: TextStyle(
                              fontSize: 38,
                              fontWeight: FontWeight.bold,
                              color: textColor(opt),
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