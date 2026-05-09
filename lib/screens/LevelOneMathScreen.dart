import 'package:flutter/material.dart';

import 'level_one_games/math_games/numbers_screen.dart';
import 'level_one_games/math_games/match_image_number_screen.dart';
import 'level_one_games/math_games/choose_number_screen.dart';
import 'level_one_games/math_games/numbers_quiz_screen.dart';

class LevelOneMathScreen extends StatelessWidget {
  const LevelOneMathScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> items = [
      {
        "title": "الأرقام",
        "image": "assets/images/5.jpeg",
        "color": Colors.orange,
        "screen": const NumbersScreen(),
      },
      {
        "title": "صل الصورة بالرقم",
        "image": "assets/images/6.jpeg",
        "color": Colors.purple,
        "screen": const MatchImageNumberScreen(),
      },
      {
        "title": "اختر الرقم الصحيح",
        "image": "assets/images/7.jpeg",
        "color": Colors.blue,
        "screen": const ChooseNumberScreen(),
      },
      {
        "title": "اختبار الأرقام",
        "image": "assets/images/8.jpeg",
        "color": Colors.red,
        "screen": const NumbersQuizScreen(),
      },
    ];

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
              const SizedBox(height: 30),

              const Text(
                "المستوى الأول - رياضيات",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),

              const SizedBox(height: 20),

              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: items.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.85,
                  ),
                  itemBuilder: (context, index) {
                    final item = items[index];

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => item["screen"],
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: item["color"],
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Image.asset(item["image"]),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              item["title"],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
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