import 'package:flutter/material.dart';
import 'dart:math';

class MultiplicationGameScreen extends StatefulWidget {
  const MultiplicationGameScreen({super.key});

  @override
  State<MultiplicationGameScreen> createState() =>
      _MultiplicationGameScreenState();
}

class _MultiplicationGameScreenState extends State<MultiplicationGameScreen> {
  final Random _random = Random();

  int num1 = 0;
  int num2 = 0;

  List<int> options = [];
  int? selectedAnswer;

  int score = 0;
  int questionNumber = 0;
  bool answered = false;

  @override
  void initState() {
    super.initState();
    generateQuestion();
  }

  void generateQuestion() {
    num1 = _random.nextInt(5) + 1;
    num2 = _random.nextInt(5) + 1;

    selectedAnswer = null;
    answered = false;

    int correct = num1 * num2;

    Set<int> set = {correct};
    while (set.length < 4) {
      set.add(_random.nextInt(25) + 1);
    }

    options = set.toList()..shuffle();

    setState(() {});
  }

  void checkAnswer(int answer) {
    if (answered) return;

    setState(() {
      selectedAnswer = answer;
      answered = true;

      if (answer == num1 * num2) {
        score++;
      }
    });

    Future.delayed(const Duration(seconds: 1), () {
      questionNumber++;

      if (questionNumber < 10) {
        generateQuestion();
      } else {
        showResult();
      }
    });
  }

  void showResult() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        title: const Text(
          "🎉 ممتاز",
          textAlign: TextAlign.center,
        ),
        content: Text("النتيجة: $score من 10"),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                score = 0;
                questionNumber = 0;
              });
              generateQuestion();
            },
            child: const Text("إعادة اللعب"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text("خروج"),
          ),
        ],
      ),
    );
  }

  Color optionColor(int opt) {
    if (selectedAnswer == null) return Colors.white;

    if (opt == num1 * num2) return Colors.green;
    if (opt == selectedAnswer) return Colors.red;

    return Colors.white;
  }

  Color textColor() {
    return selectedAnswer == null ? Colors.black : Colors.white;
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
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),

                  const Text(
                    "لعبة الضرب ✖",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Text(
                    "النقاط: $score",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// السؤال
                  Container(
                    margin: const EdgeInsets.all(15),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "$num1 × $num2 = ؟",
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  /// الاختيارات (مظبوطة ومش لازقة)
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(20),
                    itemCount: options.length,
                    gridDelegate:
                    const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 150,
                      childAspectRatio: 2.5,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                    ),
                    itemBuilder: (context, index) {
                      int opt = options[index];

                      return InkWell(
                        onTap: () => checkAnswer(opt),
                        child: Container(
                          decoration: BoxDecoration(
                            color: optionColor(opt),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Center(
                            child: Text(
                              "$opt",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: textColor(),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "السؤال ${questionNumber + 1} من 10",
                    style: const TextStyle(color: Colors.white),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}