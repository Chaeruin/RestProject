import 'package:flutter/material.dart';
import 'package:heart/Api/emotion_apis.dart';
import 'package:heart/Model/emotion_model.dart';
import 'package:intl/intl.dart';

class Top3Emotion extends StatefulWidget {
  final String memberId;
  const Top3Emotion({super.key, required this.memberId});

  @override
  State<Top3Emotion> createState() => _Top3EmotionState();
}

class _Top3EmotionState extends State<Top3Emotion> {
  late String writeDate;
  late String memberId;
  late Future<List<Top3Emo>> top3;

  @override
  void initState() {
    super.initState();
    writeDate = DateFormat('yyyyMM').format(DateTime.now());
    memberId = widget.memberId;
    top3 = top3Emotions(memberId, writeDate);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Row(
          children: [
            Expanded(
              child: Text(
                '이번달 당신이 가장 많이 느낀 감정이에요!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromARGB(255, 65, 133, 59),
                  fontSize: 23,
                  fontFamily: 'single_day',
                ),
              ),
            ),
          ],
        ),
        FutureBuilder<List<Top3Emo>>(
          future: top3,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text('No data available'),
              );
            } else {
              return Expanded(
                child: makeList(snapshot),
              );
            }
          },
        ),
      ],
    );
  }

  ListView makeList(AsyncSnapshot<List<Top3Emo>> snapshot) {
    return ListView.separated(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: snapshot.data!.length,
      padding: const EdgeInsets.all(8),
      itemBuilder: (context, index) {
        var rank = snapshot.data![index];
        return Top3(
          afterEmotion:
              rank.afterEmotion.isNotEmpty ? rank.afterEmotion : 'Unknown',
          count: rank.count,
        );
      },
      separatorBuilder: (context, index) => const SizedBox(
        width: 25,
      ),
    );
  }
}

class Top3 extends StatelessWidget {
  final String afterEmotion;
  final int count;
  const Top3({
    super.key,
    required this.afterEmotion,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 110, // Desired width
      height: 150, // Height including image and text
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'lib/assets/image/emotions/$afterEmotion.png',
            width: 110,
            height: 110,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(
                Icons.image_not_supported,
                size: 110,
                color: Colors.grey,
              );
            },
          ),
          const SizedBox(height: 5), // Space between image and text
          Text(
            afterEmotion, // Desired text
            style: const TextStyle(fontSize: 12), // Appropriate text style
          ),
          Text(
            '$count', // Desired text
            style: const TextStyle(fontSize: 12), // Appropriate text style
          ),
        ],
      ),
    );
  }
}
