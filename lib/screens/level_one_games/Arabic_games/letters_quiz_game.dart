import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class LettersQuizGame extends StatefulWidget {
  const LettersQuizGame({super.key});

  @override
  State<LettersQuizGame> createState() => _LettersQuizGameState();
}

class _LettersQuizGameState extends State<LettersQuizGame> {
  final player = AudioPlayer();

  final List<Map<String, dynamic>> questions = [
    {"emoji": "🦁", "answer": "أ", "sound": "1.mp3"},
    {"emoji": "🐟", "answer": "س", "sound": "2.mp3"},
    {"emoji": "🐘", "answer": "ف", "sound": "3.mp3"},
    {"emoji": "🌹", "answer": "و", "sound": "4.mp3"},
    {"emoji": "🚗", "answer": "س", "sound": "5.mp3"},
  ];

  final List<String> letters = [
    "أ","ب","ت","ث","ج","ح","خ","د","ذ","ر","ز","س","ش","ص","ض",
    "ط","ظ","ع","غ","ف","ق","ك","ل","م","ن","ه","و","ي"
  ];

  int index = 0;
  int score = 0;

  List<String> options = [];
  String selected = "";
  bool answered = false;
  bool showResult = false;

  @override
  void initState() {
    super.initState();
    generateOptions();
    playSound();
  }

  String get correct => questions[index]["answer"];
  String get emoji => questions[index]["emoji"];
  String get sound => questions[index]["sound"];

  Future<void> playSound() async {
    await player.stop();
    await player.play(AssetSource("sounds/$sound"));
  }

  void generateOptions() {
    final rand = Random();
    Set<String> set = {correct};

    while (set.length < 4) {
      set.add(letters[rand.nextInt(letters.length)]);
    }

    options = set.toList()..shuffle();
  }

  void answer(String value) async {
    if (answered) return;

    setState(() {
      selected = value;
      answered = true;
    });

    if (value == correct) score++;

    await Future.delayed(const Duration(milliseconds: 600));

    if (index == questions.length - 1) {
      setState(() => showResult = true);
    } else {
      setState(() {
        index++;
        selected = "";
        answered = false;
        generateOptions();
      });

      playSound();
    }
  }

  void restart() {
    setState(() {
      index = 0;
      score = 0;
      selected = "";
      answered = false;
      showResult = false;
      generateOptions();
    });

    playSound();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4FC3F7), Color(0xFF66BB6A)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: showResult ? buildResult() : buildGame(),
        ),
      ),
    );
  }

  // ───────── GAME ─────────
  Widget buildGame() {
    return Column(
      children: [

        const SizedBox(height: 10),

        // HEADER
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              const Text(
                "اختبار الحروف 🎧",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              Text(
                "$score",
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            ],
          ),
        ),

        const SizedBox(height: 10),

        // PROGRESS
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: List.generate(questions.length, (i) {
              return Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  height: 8,
                  decoration: BoxDecoration(
                    color: i <= index ? Colors.white : Colors.white30,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            }),
          ),
        ),

        const SizedBox(height: 30),

        // CARD
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
              )
            ],
          ),
          child: Column(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 70)),
              const SizedBox(height: 10),
              IconButton(
                onPressed: playSound,
                icon: const Icon(Icons.volume_up,
                    color: Colors.green, size: 40),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // OPTIONS (مظبوطة مقاس)
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.builder(
              itemCount: options.length,
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (context, i) {
                final opt = options[i];

                Color color = Colors.white;

                if (answered) {
                  if (opt == correct) {
                    color = Colors.green;
                  } else if (opt == selected) {
                    color = Colors.red;
                  }
                }

                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () => answer(opt),
                  child: Text(
                    opt,
                    style: const TextStyle(
                      fontSize: 26,
                      color: Colors.black,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  // ───────── RESULT ─────────
  Widget buildResult() {
    int stars = (score / questions.length * 3).round();

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("🏆", style: TextStyle(fontSize: 90)),
          const SizedBox(height: 10),

          const Text(
            "أحسنت!",
            style: TextStyle(fontSize: 30, color: Colors.white),
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
          )
        ],
      ),
    );
  }
}