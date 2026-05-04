import 'package:flutter/material.dart';

class LevelTwoArabicScreen extends StatelessWidget {
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
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: GridView.builder(
          itemCount: items.length,
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
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

  Widget buildCard(BuildContext context, Map<String, String> item) {
    return InkWell(
      onTap: () {
        // هنا تقدر تعمل navigation
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(item["image"]!, height: 150),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Text(
                item["title"]!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
