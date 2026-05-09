import 'package:flutter/material.dart';

// 📌 استيراد شاشات الألعاب (مرة واحدة فقط)
import 'package:teaching_children/screens/level_two_games/math_games_2/times_table_screen.dart';
import 'package:teaching_children/screens/level_two_games/math_games_2/addition_game_screen.dart';
import 'package:teaching_children/screens/level_two_games/math_games_2/subtraction_game_screen.dart';
import 'package:teaching_children/screens/level_two_games/math_games_2/multiplication_game_screen.dart';
import 'package:teaching_children/screens/level_two_games/math_games_2/division_game_screen.dart';

class LevelTwoMathScreen extends StatelessWidget {
  LevelTwoMathScreen({super.key});

  final List<Map<String, String>> items = [
    {"title": "جدول الضرب", "image": "assets/images/13.jpeg"},
    {"title": "الجمع", "image": "assets/images/14.jpeg"},
    {"title": "الطرح", "image": "assets/images/17.jpeg"},
    {"title": "الضرب", "image": "assets/images/15.jpeg"},
    {"title": "القسمة", "image": "assets/images/16.jpeg"},
  ];

  final List<Widget> screens = [
    TimesTableScreen(),
    AdditionGameScreen(),
    SubtractionGameScreen(),
    MultiplicationGameScreen(),
    DivisionGameScreen(),
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
            children: [
              const SizedBox(height: 25),

              /// 🟦 TITLE
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    )
                  ],
                ),
                child: const Text(
                  "المستوى الثاني - رياضيات",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// 🧩 GRID
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: GridView.builder(
                    itemCount: items.length,
                    gridDelegate:
                    const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      childAspectRatio: 7 / 8,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                    ),
                    itemBuilder: (context, index) {
                      return buildCard(context, index);
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

  Widget buildCard(BuildContext context, int index) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => screens[index]),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 85,
              height: 85,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Image.asset(items[index]["image"]!),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Text(
                items[index]["title"]!,
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