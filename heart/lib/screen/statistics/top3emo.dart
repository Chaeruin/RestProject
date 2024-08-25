//일기 작성 페이지를 기반으로 월 단위로 가장 빈도가 높은 감정 Top 3 

import 'package:flutter/material.dart';
import 'package:heart/Api/emotion_apis.dart';
import 'package:heart/Model/emotion_model.dart';
import 'package:intl/intl.dart';

// 상위 3가지 감정을 표시
class Top3Emotion extends StatefulWidget {
  final String memberId;
  const Top3Emotion({super.key, required this.memberId});

  @override
  State<Top3Emotion> createState() => _Top3EmotionState();
}

class _Top3EmotionState extends State<Top3Emotion> {
  late String writeDate; // 현재 날짜를 기준으로 월을 저장할 변수
  late String memberId; // 회원 ID 저장 변수
  late Future<List<Top3Emo>> top3; // 상위 3가지 감정을 비동기로 가져올 Future 변수
 
  @override
  void initState() {
    super.initState();
    writeDate = DateFormat('yyyyMM').format(DateTime.now());
    memberId = widget.memberId; // 위젯에서 받은 회원 ID 초기화
    top3 = top3Emotions(memberId, writeDate); // 상위 3가지 감정을 가져오는 Future 초기화
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
              future: top3,  // FutureBuilder에 비동기 데이터 전달
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

 // 상위 3가지 감정을 리스트로 반환하는 메서드
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

// 상위 3가지 감정 항목을 표시하는 StatelessWidget 클래스
class Top3 extends StatelessWidget {
  final String afterEmotion; //감정 이름
  final int count; // 감정 횟수
  final double itemWidth; // 아이템의 너비
  final double itemHeight; // 아이템의 높이
  final double imageSize; // 이미지 크기
  final double textSize; // 텍스트 크기

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
      width: itemWidth, 
      height: itemHeight, 
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
          const SizedBox(height: 5), 
          Text(
            afterEmotion, 
            style: TextStyle(fontSize: textSize),
          ),
          Text(
            '$count', 
            style: TextStyle(fontSize: textSize), 
          ),
        ],
      ),
    );
  }
}
