import 'package:flutter/material.dart';
import '../screens/LevelOneScreen.dart';
import '../screens/LevelTwoScreen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,

        /// 🎨 الخلفية المتدرجة
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF4FC3F7),
              Color(0xFF81C784),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              /// 🏷️ العنوان
              const Text(
                "تعليم الأطفال",
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 20),

              /// 👦 الماسكوت داخل دائرة
              Container(
                width: 190,
                height: 190,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 20,
                      spreadRadius: 3,
                      color: Colors.black.withOpacity(0.25),
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: ClipOval(
                    child: Image.asset(
                      "assets/images/kid.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              /// 🟠 المستوى الأول
              buildLevelCard(
                context,
                title: "المستوى الأول",
                subtitle: "الروضة",
                stars: 5,
                color: Colors.orange,
                image: "assets/images/bear.png",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LevelOneScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 25),

              /// 🟣 المستوى الثاني
              buildLevelCard(
                context,
                title: "المستوى الثاني",
                subtitle: "المدرسة",
                stars: 8,
                color: Colors.purple,
                image: "assets/images/bag.png",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LevelTwoScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLevelCard(
      BuildContext context, {
        required String title,
        required String subtitle,
        required int stars,
        required Color color,
        required String image,
        required VoidCallback onTap,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 340,
        padding: const EdgeInsets.all(18),

        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(30),

          boxShadow: const [
            BoxShadow(
              blurRadius: 15,
              color: Colors.black26,
              offset: Offset(0, 8),
            ),
          ],
        ),

        child: Row(
          children: [

            /// 🧸 صورة المستوى
            Container(
              width: 70,
              height: 70,

              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),

              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Image.asset(
                  image,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(width: 15),

            /// 📝 النصوص والنجوم
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// ⭐ النجوم
                  Row(
                    children: List.generate(
                      stars,
                          (index) => const Padding(
                        padding: EdgeInsets.only(right: 2),
                        child: Icon(
                          Icons.star,
                          color: Colors.yellow,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /// ➡️ السهم
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}