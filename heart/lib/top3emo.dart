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
  String writeDate = DateFormat('yyyyMM').format(DateTime.now()).toString();
  late String memberId;
  late Future<List<Top3Emo>> top3;

  @override
  void initState() {
    super.initState();
    memberId = widget.memberId;
    top3 = top3Emotions(memberId, writeDate);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Title(
              color: Colors.black,
              child: const Text(
                textAlign: TextAlign.center,
                '    이번달 당신이 가장 많이 느낀 감정이에요!',
                style: TextStyle(
                  color: Color.fromARGB(255, 65, 133, 59),
                  fontSize: 23,
                  fontFamily: 'single_day',
                ),
              ),
            ),
          ],
        ),
        FutureBuilder(
          future: top3,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Expanded(
                child: makeList(snapshot),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ],
    );
  }
}

ListView makeList(AsyncSnapshot<List<Top3Emo>> snapshot) {
  return ListView.separated(
    shrinkWrap: true,
    scrollDirection: Axis.horizontal,
    itemCount: 3,
    padding: const EdgeInsets.all(8),
    itemBuilder: (context, index) {
      var rank = snapshot.data![index];
      return Top3(
        afterEmoType: rank.afterEmoType,
        count: rank.count,
      );
    },
    separatorBuilder: (context, index) => const SizedBox(
      width: 25,
    ),
  );
}

class Top3 extends StatelessWidget {
  final String afterEmoType;
  final int count;
  const Top3({
    super.key,
    required this.afterEmoType,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 110, // 원하는 너비로 설정
      height: 150, // 이미지와 텍스트를 포함한 높이로 설정
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'lib/assets/images/$afterEmoType.png',
            width: 110,
            height: 110,
          ),
          const SizedBox(height: 5), // 이미지와 텍스트 사이의 간격
          Text(
            afterEmoType, // 원하는 텍스트로 변경
            style: const TextStyle(fontSize: 10), // 적절한 크기로 텍스트 스타일 설정
          ),
        ],
      ),
    );
  }
}
