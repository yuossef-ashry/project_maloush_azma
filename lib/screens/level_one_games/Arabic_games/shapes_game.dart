import 'dart:math';
import 'package:flutter/material.dart';

class ShapesGame extends StatefulWidget {
  const ShapesGame({super.key});

  @override
  State<ShapesGame> createState() => _ShapesGameState();
}

class _ShapesGameState extends State<ShapesGame> {
  final List<Map<String, dynamic>> questions = [
    {"image": "assets/images/dog.png", "name": "كلب"},
    {"image": "assets/images/cat.png", "name": "قطة"},
    {"image": "assets/images/lion.png", "name": "أسد"},
  ];

  final List<String> words = ["كلب", "قطة", "أسد", "فيل", "حصان"];

  int index = 0;
  int score = 0;

  String? droppedWord;
  bool showFeedback = false;
  bool showResult = false;
  bool isCorrect = false;

  List<String> options = [];

  @override
  void initState() {
    super.initState();
    generateOptions();
  }

  String get image => questions[index]["image"];
  String get correct => questions[index]["name"];

  void generateOptions() {
    final rand = Random();
    Set<String> set = {correct};

    while (set.length < 3) {
      set.add(words[rand.nextInt(words.length)]);
    }

    options = set.toList()..shuffle();
  }

  void checkAnswer(String value) {
    if (showFeedback) return;

    setState(() {
      droppedWord = value;
      showFeedback = true;
      isCorrect = value == correct;
    });

    if (isCorrect) score++;

    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;

      if (index == questions.length - 1) {
        setState(() => showResult = true);
      } else {
        setState(() {
          index++;
          droppedWord = null;
          showFeedback = false;
          isCorrect = false;
          generateOptions();
        });
      }
    });
  }

  void restart() {
    setState(() {
      index = 0;
      score = 0;
      droppedWord = null;
      showFeedback = false;
      showResult = false;
      generateOptions();
    });
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

  // ───── GAME ─────
  Widget buildGame() {
    return Column(
      children: [

        // HEADER
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              const Text(
                "وصل الصورة بالكلمة",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              Text(
                "$score",
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),

        // IMAGE CARD
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Image.asset(image, height: 140),
        ),

        const SizedBox(height: 10),

        // DROP BOX
        DragTarget<String>(
          onAccept: (value) => checkAnswer(value),
          builder: (context, candidate, rejected) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: showFeedback
                      ? (isCorrect ? Colors.green : Colors.red)
                      : Colors.grey.shade300,
                  width: 3,
                ),
              ),
              child: Center(
                child: droppedWord == null
                    ? const Text("⬇️ اسحب الكلمة هنا")
                    : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      droppedWord!,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: isCorrect ? Colors.green : Colors.red,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Icon(
                      isCorrect ? Icons.check : Icons.close,
                      color: isCorrect ? Colors.green : Colors.red,
                      size: 30,
                    )
                  ],
                ),
              ),
            );
          },
        ),

        const SizedBox(height: 20),

        // OPTIONS (تحت بعض بدل Grid)
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListView.builder(
              itemCount: options.length,
              itemBuilder: (context, i) {
                final word = options[i];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Draggable<String>(
                    data: word,
                    feedback: Material(
                      color: Colors.transparent,
                      child: buildWord(word),
                    ),
                    childWhenDragging: Opacity(
                      opacity: 0.4,
                      child: buildWord(word),
                    ),
                    child: buildWord(word),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  // ───── WORD (بدون shadow) ─────
  Widget buildWord(String text) {
    return Container(
      height: 55,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: const Color(0xFFFF9800),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
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
          const Text("🏆", style: TextStyle(fontSize: 90)),

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