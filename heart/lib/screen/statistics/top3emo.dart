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
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isLargeScreen = constraints.maxWidth > 600;

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
                    child: makeList(snapshot, isLargeScreen),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  ListView makeList(AsyncSnapshot<List<Top3Emo>> snapshot, bool isLargeScreen) {
    double itemWidth = isLargeScreen ? 150 : 110;
    double itemHeight = isLargeScreen ? 200 : 150;
    double imageSize = isLargeScreen ? 150 : 110;
    double textSize = isLargeScreen ? 16 : 12;

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
          itemWidth: itemWidth,
          itemHeight: itemHeight,
          imageSize: imageSize,
          textSize: textSize,
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
  final double itemWidth;
  final double itemHeight;
  final double imageSize;
  final double textSize;

  const Top3({
    super.key,
    required this.afterEmotion,
    required this.count,
    required this.itemWidth,
    required this.itemHeight,
    required this.imageSize,
    required this.textSize,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: itemWidth, // Responsive width
      height: itemHeight, // Responsive height including image and text
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'lib/assets/image/emotions/$afterEmotion.png',
            width: imageSize,
            height: imageSize,
            errorBuilder: (context, error, stackTrace) {
              return Icon(
                Icons.image_not_supported,
                size: imageSize,
                color: Colors.grey,
              );
            },
          ),
          const SizedBox(height: 5), // Space between image and text
          Text(
            afterEmotion, // Emotion text
            style: TextStyle(fontSize: textSize), // Responsive text style
          ),
          Text(
            '$count', // Count text
            style: TextStyle(fontSize: textSize), // Responsive text style
          ),
        ],
      ),
    );
  }
}
