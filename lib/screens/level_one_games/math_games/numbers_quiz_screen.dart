import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class NumbersQuizScreen extends StatefulWidget {
  const NumbersQuizScreen({super.key});

  @override
  State<NumbersQuizScreen> createState() =>
      _NumbersQuizScreenState();
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

  final numbers = ["1","2","3","4","5","6","7","8","9","10"];

  int index = 0;
  int score = 0;

  List<String> options = [];

  bool showFeedback = false;
  bool isCorrect = false;

  Map<String, dynamic> get current => questions[index];
  String get correct => current["number"];
  String get sound => current["sound"];

  double get progress => (index + 1) / questions.length;

  @override
  void initState() {
    super.initState();
    generateOptions();
    playSound();
  }

  /// 🔊 صوت الرقم
  Future<void> playSound() async {
    await player.stop();
    await player.play(AssetSource("sounds/$sound"));
  }

  void generateOptions() {
    final rand = Random();
    Set<String> temp = {correct};

    while (temp.length < 4) {
      temp.add(numbers[rand.nextInt(numbers.length)]);
    }

    options = temp.toList()..shuffle();
  }

  void nextQuestion() async {
    if (index < questions.length - 1) {
      setState(() {
        index++;
        showFeedback = false;
        generateOptions();
      });

      await playSound();
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

  void reset() {
    setState(() {
      index = 0;
      score = 0;
      showFeedback = false;
      generateOptions();
    });

    playSound();
  }

  void check(String value) async {
    if (showFeedback) return;

    setState(() {
      showFeedback = true;
      isCorrect = value == correct;
    });

    if (isCorrect) score++;

    await Future.delayed(const Duration(milliseconds: 600));

    nextQuestion();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
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
                      "اسمع الرقم 🎧",
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
                "اسمع الرقم واختر الإجابة 🎧",
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
                child: Column(
                  children: [

                    ElevatedButton.icon(
                      onPressed: playSound,
                      icon: const Icon(Icons.volume_up),
                      label: const Text("إعادة الصوت"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                    ),

                    const SizedBox(height: 15),

                    if (showFeedback)
                      Icon(
                        isCorrect
                            ? Icons.check_circle
                            : Icons.cancel,
                        color:
                        isCorrect ? Colors.green : Colors.red,
                        size: 60,
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
                    final v = options[i];

                    return GestureDetector(
                      onTap: () => check(v),
                      child: AnimatedContainer(
                        duration:
                        const Duration(milliseconds: 250),
                        decoration: BoxDecoration(
                          color: Colors.white,
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
                            style: const TextStyle(
                              fontSize: 38,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF173F73),
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