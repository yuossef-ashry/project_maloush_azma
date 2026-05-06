import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class NumbersScreen extends StatefulWidget {
  const NumbersScreen({super.key});

  @override
  State<NumbersScreen> createState() => _NumbersScreenState();
}

class _NumbersScreenState extends State<NumbersScreen> {
  final List<String> numbers = [
    "1","2","3","4","5","6","7","8","9","10"
  ];

  int index = 0;

  final AudioPlayer player = AudioPlayer();

  String get current => numbers[index];

  @override
  void initState() {
    super.initState();
    playSound();
  }

  /// 🔊 تشغيل صوت الرقم الحالي
  void playSound() async {
    try {
      await player.stop();

      await player.play(
        AssetSource("sounds/$current.mp3"),
      );
    } catch (e) {
      debugPrint("Error playing sound: $e");
    }
  }

  void next() {
    if (index < numbers.length - 1) {
      setState(() => index++);
      playSound();
    }
  }

  void prev() {
    if (index > 0) {
      setState(() => index--);
      playSound();
    }
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,

      appBar: AppBar(
        title: const Text("تعلم الأرقام"),
        centerTitle: true,
      ),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          /// 🟡 الكارد
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(20),
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
            child: Column(
              children: [

                /// 🖼️ الصورة
                Image.asset(
                  "assets/images/numbers/$current.png",
                  height: 180,
                ),

                const SizedBox(height: 20),

                /// 🔢 الرقم
                Text(
                  current,
                  style: const TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),

                const SizedBox(height: 15),

                /// 🔊 زر الصوت
                ElevatedButton(
                  onPressed: playSound,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 12),
                  ),
                  child: const Text("تشغيل الصوت 🔊"),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          /// ⬅️ ➡️
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              ElevatedButton(
                onPressed: prev,
                child: const Text("السابق"),
              ),

              const SizedBox(width: 20),

              ElevatedButton(
                onPressed: next,
                child: const Text("التالي"),
              ),
            ],
          )
        ],
      ),
    );
  }
}