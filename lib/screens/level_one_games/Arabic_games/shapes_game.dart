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
  bool isCorrect = false;
  bool showResult = false;

  @override
  void initState() {
    super.initState();
  }

  String get currentImage => questions[index]["image"];
  String get correctAnswer => questions[index]["name"];

  List<String> get options {
    final rand = Random();
    Set<String> temp = {correctAnswer};

    while (temp.length < 3) {
      temp.add(words[rand.nextInt(words.length)]);
    }

    return temp.toList()..shuffle();
  }

  void checkAnswer(String value) {
    setState(() {
      droppedWord = value;
      showFeedback = true;
      isCorrect = value == correctAnswer;

      if (isCorrect) {
        score++;
      }
    });

    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;

      if (index < questions.length - 1) {
        setState(() {
          index++;
          droppedWord = null;
          showFeedback = false;
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
      droppedWord = null;
      showFeedback = false;
      showResult = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF81C784),

      appBar: AppBar(
        title: const Text("وصل الصورة بالكلمة"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),

      body: Center(
        child: showResult ? buildResult() : buildGame(),
      ),
    );
  }

  /// 🎮 اللعبة
  Widget buildGame() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        /// 🖼️ Drag Target (الصورة)
        DragTarget<String>(
          onAccept: (value) => checkAnswer(value),
          builder: (context, candidate, rejected) {
            return Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: showFeedback
                      ? (isCorrect ? Colors.green : Colors.red)
                      : Colors.transparent,
                  width: 4,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Image.asset(
                    currentImage,
                    height: 120,
                  ),

                  const SizedBox(height: 10),

                  if (droppedWord != null)
                    Text(
                      droppedWord!,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: isCorrect ? Colors.green : Colors.red,
                      ),
                    ),
                ],
              ),
            );
          },
        ),

        const SizedBox(height: 30),

        const Text(
          "اسحب الكلمة الصحيحة وضعها على الصورة 👇",
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 20),

        /// 🔘 Draggable كلمات
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: options.map((word) {
            return Draggable<String>(
              data: word,
              feedback: buildWord(word, Colors.orange.shade300),
              childWhenDragging: buildWord(word, Colors.grey),
              child: buildWord(word, Colors.orange),
            );
          }).toList(),
        ),

        const SizedBox(height: 20),

        /// ⭐ Feedback
        if (showFeedback)
          Icon(
            isCorrect ? Icons.star : Icons.cancel,
            color: isCorrect ? Colors.amber : Colors.red,
            size: 70,
          ),
      ],
    );
  }

  Widget buildWord(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 20,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// 🏁 النتيجة
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
          child: const Text("🔄 إعادة اللعب"),
        ),
      ],
    );
  }
}