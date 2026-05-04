import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class LettersGame extends StatefulWidget {
  const LettersGame({super.key});

  @override
  State<LettersGame> createState() => _LettersGameState();
}

class _LettersGameState extends State<LettersGame> {
  final List<String> letters = [
    "أ", "ب", "ت", "ث", "ج", "ح", "خ", "د",
    "ذ", "ر", "ز", "س", "ش", "ص", "ض",
    "ط", "ظ", "ع", "غ", "ف", "ق", "ك",
    "ل", "م", "ن", "ه", "و", "ي"
  ];

  int index = 0;

  final AudioPlayer player = AudioPlayer();

  void playSound() async {
    String letter = letters[index];
    await player.stop();
    await player.play(AssetSource("sounds/أ.mp3"));
  }

  void nextLetter() {
    if (index < letters.length - 1) {
      setState(() {
        index++;
      });
      playSound();
    }
  }

  void prevLetter() {
    if (index > 0) {
      setState(() {
        index--;
      });
      playSound();
    }
  }

  @override
  void initState() {
    super.initState();
    playSound();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("تعلم الحروف")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            // 🔤 الحرف
            Text(
              letters[index],
              style: const TextStyle(
                fontSize: 120,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 50),

            // ⬅️ ➡️ الأزرار
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: prevLetter,
                  child: const Text("السابق"),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: nextLetter,
                  child: const Text("التالي"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}