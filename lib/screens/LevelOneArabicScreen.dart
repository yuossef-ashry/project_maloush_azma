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
      "color": Colors.orange,
    },
    {
      "title": "اختبار الحروف",
      "image": "assets/images/2.jpeg",
      "page": LettersQuizGame(),
      "color": Colors.blue,
    },
    {
      "title": "اختر الحرف الصحيح",
      "image": "assets/images/3.jpeg",
      "page": ChooseLetterGame(),
      "color": Colors.purple,
    },
    {
      "title": "توصيل الأشكال",
      "image": "assets/images/4.jpeg",
      "page": ShapesGame(),
      "color": Colors.green,
    },
  ];

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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 30),

              /// ⭐ العنوان داخل بوكس جميل
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 25,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: const Text(
                  "المستوى الأول - عربي",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrange,
                  ),
                ),
              ),

              const SizedBox(height: 25),

              /// 📦 الجريد
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: GridView.builder(
                    itemCount: items.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 14,
                          crossAxisSpacing: 14,
                          childAspectRatio: 0.85,
                        ),
                    itemBuilder: (context, index) {
                      return buildCard(context, items[index]);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 🎴 الكروت
  Widget buildCard(BuildContext context, Map<String, dynamic> item) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => item["page"]),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: item["color"],
          borderRadius: BorderRadius.circular(30),
          boxShadow: const [
            BoxShadow(
              color: Colors.black38,
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// 🟢 الصورة الدائرية
            Container(
              width: 85,
              height: 85,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: ClipOval(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Image.asset(item["image"], fit: BoxFit.cover),
                ),
              ),
            ),

            const SizedBox(height: 12),

            /// 📝 العنوان
            Text(
              item["title"],
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
