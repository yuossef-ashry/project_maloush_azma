import 'package:flutter/material.dart';

class LevelTwoArabicScreen extends StatelessWidget {
  LevelTwoArabicScreen({super.key});

  final List<Map<String, String>> items = [
    {"title": "الاملاء", "image": "assets/images/7.jpeg"},
    {"title": "املاء اسماء الحيوانات", "image": "assets/images/8.jpeg"},
    {"title": "اختر الاجابة الصحيحة", "image": "assets/images/9.jpeg"},
    {"title": "السحب والافلات", "image": "assets/images/10.jpeg"},
    {"title": "شهور السنة", "image": "assets/images/11.jpeg"},
    {"title": "القرآن الكريم", "image": "assets/images/12.jpeg"},
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

              /// 📦 العنوان
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
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
                  "المستوى الثاني - عربي",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: GridView.builder(
                    itemCount: items.length,
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      childAspectRatio: 0.85,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
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

  Widget buildCard(BuildContext context, Map<String, String> item) {
    return InkWell(
      onTap: () {},
      child: Container(
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            /// 🖼️ صورة بشكل أجمل ومقصوص صح
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey.shade100,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  item["image"]!,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 12),

            /// 📝 العنوان
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Text(
                item["title"]!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}