import 'package:flutter/material.dart';

import '../screens/level_one_games/Arabic_games/letters_game.dart';
import '../screens/level_one_games/Arabic_games/letters_quiz_game.dart';
import '../screens/level_one_games/Arabic_games/choose_letter_game.dart';
import '../screens/level_one_games/Arabic_games/shapes_game.dart';

class LevelOneArabicScreen extends StatelessWidget {
  LevelOneArabicScreen({super.key});

  final List<Map<String, dynamic>> items = [
    {
      "title": "الحروف العربية",
      "image": "assets/images/1.jpeg",
      "page": LettersGame(),
    },
    {
      "title": "اختبار الحروف",
      "image": "assets/images/2.jpeg",
      "page": LettersQuizGame(),
    },
    {
      "title": "اختر الحرف الصحيح",
      "image": "assets/images/3.jpeg",
      "page": ChooseLetterGame(),
    },
    {
      "title": "توصيل الأشكال",
      "image": "assets/images/4.jpeg",
      "page": ShapesGame(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: GridView.builder(
          itemCount: items.length,
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 7 / 8,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            return buildCard(context, items[index]);
          },
        ),
      ),
    );
  }

  Widget buildCard(BuildContext context, Map<String, dynamic> item) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => item["page"]),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(item["image"], height: 150, fit: BoxFit.cover),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Text(
                item["title"],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
