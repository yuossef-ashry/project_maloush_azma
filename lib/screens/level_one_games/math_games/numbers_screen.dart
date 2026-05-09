import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class NumbersScreen extends StatefulWidget {
  const NumbersScreen({super.key});

  @override
  State<NumbersScreen> createState() => _NumbersScreenState();
}

class _NumbersScreenState extends State<NumbersScreen> {
  final List<Map<String, String>> numbers = [
    {"num": "1", "word": "واحد"},
    {"num": "2", "word": "اثنين"},
    {"num": "3", "word": "ثلاثة"},
    {"num": "4", "word": "أربعة"},
    {"num": "5", "word": "خمسة"},
    {"num": "6", "word": "ستة"},
    {"num": "7", "word": "سبعة"},
    {"num": "8", "word": "ثمانية"},
    {"num": "9", "word": "تسعة"},
    {"num": "10", "word": "عشرة"},
  ];

  int index = 0;
  final AudioPlayer player = AudioPlayer();

  String get currentNumber => numbers[index]["num"]!;
  String get currentWord => numbers[index]["word"]!;

  double get progress => (index + 1) / numbers.length;

  @override
  void initState() {
    super.initState();
    playSound();
  }

  /// 🔊 تشغيل الصوت
  void playSound() async {
    try {
      await player.stop();
      await player.play(AssetSource("sounds/$currentNumber.mp3"));
    } catch (e) {
      debugPrint("Error: $e");
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
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4FC3F7), Color(0xFF81C784)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [

                /// 🔝 العنوان
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    const Expanded(
                      child: Text(
                        "تعلم الأرقام",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),

                const SizedBox(height: 20),

                /// 📊 Progress
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "التقدم",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        Text(
                          "${index + 1} / ${numbers.length}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 14,
                        backgroundColor: Colors.white30,
                        valueColor:
                        const AlwaysStoppedAnimation(Colors.orange),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                /// 🟡 الكارت
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(35),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 15,
                          offset: Offset(0, 8),
                        )
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        /// 🔢 الرقم الكبير
                        Text(
                          currentNumber,
                          style: const TextStyle(
                            fontSize: 120,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        ),

                        const SizedBox(height: 20),

                        /// 📝 اسم الرقم بالعربي
                        Text(
                          currentWord,
                          style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 30),

                        /// 🔊 زر الصوت
                        ElevatedButton.icon(
                          onPressed: playSound,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          icon: const Icon(Icons.volume_up),
                          label: const Text("تشغيل الصوت 🔊"),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                /// ⬅️➡️ الأزرار
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: prev,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        icon: const Icon(Icons.arrow_back),
                        label: const Text("السابق"),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: next,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        icon: const Icon(Icons.arrow_forward),
                        label: const Text("التالي"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}