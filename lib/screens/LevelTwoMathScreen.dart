import 'package:flutter/material.dart';

class LevelTwoMathScreen extends StatelessWidget {
  final List<Map<String, String>> items = [
    {"title": "جدول الضرب", "image": "assets/images/13.jpeg"},
    {"title": "الجمع", "image": "assets/images/14.jpeg"},
    {"title": "الطرح", "image": "assets/images/17.jpeg"},
    {"title": "الضرب", "image": "assets/images/15.jpeg"},
    {"title": "القسمة", "image": "assets/images/16.jpeg"},
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
