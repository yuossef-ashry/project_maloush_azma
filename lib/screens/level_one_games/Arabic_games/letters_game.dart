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

  String get currentLetter => letters[index];

  void playSound() async {
    await player.stop();
    await player.play(AssetSource("sounds/$currentLetter.mp3"));
  }

  void nextLetter() {
    if (index < letters.length - 1) {
      setState(() => index++);
      playSound();
    }
  }

  void prevLetter() {
    if (index > 0) {
      setState(() => index--);
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
      backgroundColor: const Color(0xFF81C784),

      appBar: AppBar(
        title: const Text("تعلم الحروف"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          /// 🟡 Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
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

                /// 🖼️ صورة الحرف
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    "assets/images/Arabic_letters/$currentLetter.jpg",
                    height: 180,
                    width: 180,
                    fit: BoxFit.contain,
                  ),
                ),

                const SizedBox(height: 20),

                /// 🔊 زر التكرار
                ElevatedButton(
                  onPressed: playSound,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    "تكرار 🔊",
                    style: TextStyle(fontSize: 18),
                  ),
                ),

              ],
            ),
          ),

          const SizedBox(height: 40),

          /// ⬅️ ➡️ buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              ElevatedButton(
                onPressed: prevLetter,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                ),
                child: const Text("السابق"),
              ),

              const SizedBox(width: 20),

              ElevatedButton(
                onPressed: nextLetter,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                child: const Text("التالي"),
              ),
            ],
          )
        ],
      ),
    );
  }
}