import 'package:flutter/material.dart';
import '../screens/LevelOneMathScreen.dart';
import '../screens/LevelOneArabicScreen.dart';

class LevelOneScreen extends StatelessWidget {
  const LevelOneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(
              "المستوى الأول ( الروضة )",
              style: Theme.of(
                context,
              ).textTheme.headlineMedium!.copyWith(fontSize: 24),
            ),
          ),
          backgroundColor: Colors.blue,

          bottom: PreferredSize(
            preferredSize: Size.fromHeight(60),
            child: TabBar(
              indicatorColor: Colors.pink,
              indicatorWeight: 3,

              indicatorSize: TabBarIndicatorSize.tab,

              labelColor: Colors.white,
              unselectedLabelColor: Colors.white,

              tabs: [
                Tab(
                  child: Text(
                    "اللغة العربية",
                    style: Theme.of(
                      context,
                    ).textTheme.headlineSmall!.copyWith(fontSize: 16),
                  ),
                ),
                Tab(
                  child: Text(
                    "رياضيات",
                    style: Theme.of(
                      context,
                    ).textTheme.headlineSmall!.copyWith(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [LevelOneArabicScreen(), LevelOneMathScreen()],
        ),
      ),
    );
  }
}
