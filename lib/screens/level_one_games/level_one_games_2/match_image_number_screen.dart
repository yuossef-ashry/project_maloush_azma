import 'dart:math';
import 'package:flutter/material.dart';

class MatchImageNumberScreen extends StatefulWidget {
  const MatchImageNumberScreen({super.key});

  @override
  State<MatchImageNumberScreen> createState() =>
      _MatchImageNumberScreenState();
}

class _MatchImageNumberScreenState extends State<MatchImageNumberScreen> {
  final List<List<Map<String, String>>> levels = [
    [
      {"word": "واحد", "number": "1"},
      {"word": "اثنين", "number": "2"},
      {"word": "ثلاثة", "number": "3"},
    ],
    [
      {"word": "أربعة", "number": "4"},
      {"word": "خمسة", "number": "5"},
      {"word": "ستة", "number": "6"},
    ],
    [
      {"word": "سبعة", "number": "7"},
      {"word": "ثمانية", "number": "8"},
      {"word": "تسعة", "number": "9"},
    ],
  ];

  final List<List<String>> levelNumbers = [
    ["1", "2", "3"],
    ["4", "5", "6"],
    ["7", "8", "9"],
  ];

  int level = 0;

  List<Map<String, String>> words = [];
  List<String> numbers = [];

  Map<String, String> matched = {};

  @override
  void initState() {
    super.initState();
    loadLevel();
  }

  void loadLevel() {
    words = List.from(levels[level])..shuffle(Random());
    numbers = List.from(levelNumbers[level])..shuffle(Random());
    matched = {};
  }

  void checkMatch(String word, String number) {
    final correct = levels[level]
        .firstWhere((e) => e["word"] == word)["number"];

    if (correct == number) {
      setState(() {
        matched[word] = number;
      });

      if (matched.length == levels[level].length) {
        Future.delayed(const Duration(milliseconds: 500), () {
          if (level < levels.length - 1) {
            setState(() {
              level++;
              loadLevel();
            });
          } else {
            showDialog(
              context: context,
              builder: (_) => const AlertDialog(
                title: Text("🎉 مبروك"),
                content: Text("خلصت كل المستويات"),
              ),
            );
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF81C784),

      appBar: AppBar(
        title: Text("Level ${level + 1}"),
        centerTitle: true,
      ),

      body: Column(
        children: [

          const SizedBox(height: 80),

          /// 📌 تعليمات
          Container(
            padding: const EdgeInsets.all(15),
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              "👆 اسحب الرقم وحطه على الكلمة الصح",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 20),

          Expanded(
            child: Row(
              children: [

                /// 🔢 NUMBERS (Draggable)
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: numbers.map((num) {
                      return Draggable<String>(
                        data: num,
                        feedback: Material(
                          color: Colors.transparent,
                          child: buildNumber(num, Colors.grey),
                        ),
                        childWhenDragging:
                        buildNumber(num, Colors.grey.shade300),
                        child: buildNumber(num, Colors.blue),
                      );
                    }).toList(),
                  ),
                ),

                /// 🟨 WORDS (Drop targets)
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: words.map((item) {
                      final word = item["word"]!;
                      final isDone = matched.containsKey(word);

                      return DragTarget<String>(
                        onAccept: (num) => checkMatch(word, num),
                        builder: (context, candidate, rejected) {
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            width: 120,
                            height: 70,
                            decoration: BoxDecoration(
                              color: isDone
                                  ? Colors.green
                                  : candidate.isNotEmpty
                                  ? Colors.amber
                                  : Colors.orange,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Center(
                              child: Text(
                                word,
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildNumber(String num, Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: 100,
      height: 70,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Center(
        child: Text(
          num,
          style: const TextStyle(
            fontSize: 26,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}