import 'package:flutter/material.dart';

class TimesTableScreen extends StatefulWidget {
  const TimesTableScreen({super.key});

  @override
  State<TimesTableScreen> createState() => _TimesTableScreenState();
}

class _TimesTableScreenState extends State<TimesTableScreen> {
  int selectedTable = 1;
  bool showQuiz = false;

  int quizNum = 1;
  List<int> options = [];

  int? selectedAnswer;

  int score = 0;
  int questionNumber = 0;
  bool answered = false;

  void generateQuiz() {
    setState(() {
      quizNum = (questionNumber % 10) + 1;
      selectedAnswer = null;
      answered = false;

      int correct = selectedTable * quizNum;

      Set<int> set = {correct};

      while (set.length < 4) {
        int wrong =
            selectedTable * (1 + (set.length + questionNumber) % 10);
        set.add(wrong);
      }

      options = set.toList()..shuffle();
    });
  }

  void checkAnswer(int answer) {
    if (answered) return;

    setState(() {
      selectedAnswer = answer;
      answered = true;

      if (answer == selectedTable * quizNum) {
        score++;
      }
    });

    Future.delayed(const Duration(seconds: 1), () {
      questionNumber++;

      if (questionNumber < 10) {
        generateQuiz();
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
        title: const Text("🎉 انتهت اللعبة"),
        content: Text("نتيجتك: $score من 10"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                score = 0;
                questionNumber = 0;
                showQuiz = true;
              });
              generateQuiz();
            },
            child: const Text("إعادة اللعب"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("خروج"),
          ),
        ],
      ),
    );
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
          child: showQuiz ? buildQuiz() : buildTableSelector(),
        ),
      ),
    );
  }

  /// 🎯 اختيار الجدول
  Widget buildTableSelector() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "اختار جدول الضرب",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),

        Expanded(
          child: Center(
            child: GridView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.all(16),
              itemCount: 10,
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1,
              ),
              itemBuilder: (context, i) {
                int table = i + 1;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedTable = table;
                      showQuiz = true;
                      score = 0;
                      questionNumber = 0;
                    });
                    generateQuiz();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: Text(
                        "$table",
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4FC3F7),
                        ),
                      ),
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

  /// 🎯 اللعبة
  Widget buildQuiz() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        /// السؤال
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            "$selectedTable × $quizNum = ?",
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 38,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        const SizedBox(height: 20),

        /// الاختيارات (في النص + مسافات مريحة)
        Expanded(
          child: Center(
            child: GridView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.all(20),
              itemCount: options.length,
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 2.8,
              ),
              itemBuilder: (context, i) {
                int opt = options[i];

                Color bg = Colors.white;

                if (answered) {
                  if (opt == selectedTable * quizNum) {
                    bg = Colors.green;
                  } else if (opt == selectedAnswer) {
                    bg = Colors.red;
                  }
                }

                return InkWell(
                  onTap: () => checkAnswer(opt),
                  child: Container(
                    decoration: BoxDecoration(
                      color: bg,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: Text(
                        "$opt",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: answered ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),

        Text(
          "السؤال ${questionNumber + 1} من 10",
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),

        const SizedBox(height: 10),
      ],
    );
  }
}