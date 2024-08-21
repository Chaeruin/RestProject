//통계 메인 페이지

import 'package:flutter/material.dart';
import 'package:heart/drawer/action/feel_better.dart';
import 'package:heart/drawer/action/hourlyemo.dart';
import 'package:heart/screen/statistics/top3emo.dart';
import 'package:heart/screen/statistics/totalemo.dart';

//통계 화면을 표시
class Statistics extends StatefulWidget {
  final String memId;
  const Statistics({super.key, required this.memId});

  @override
  State<Statistics> createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  late final String memberID; // 회원 ID 저장 변수

  @override
  void initState() {
    super.initState();
    memberID = widget.memId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFBA0),
        title: const Text(
          '마음 통계',
          style: TextStyle(
            color: Colors.black,
            fontSize: 25,
            fontFamily: 'single_day',
          ),
        ),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool isLargeScreen = constraints.maxWidth > 600;
          final double titleFontSize = isLargeScreen ? 30 : 23;
          final double sectionSpacing = isLargeScreen ? 30 : 20;

          return SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: sectionSpacing),
                Text(
                  '<월간 감정 통계>',
                  style: TextStyle(
                    color: const Color.fromARGB(255, 65, 133, 59),
                    fontSize: titleFontSize,
                    fontFamily: 'single_day',
                  ),
                ),
                SizedBox(height: sectionSpacing / 2),
                SizedBox(
                  height: 300, 
                  child: TotalEmotion(memberId: memberID),
                ),
                SizedBox(height: sectionSpacing),
                SizedBox(
                  height: 300, 
                  child: Top3Emotion(memberId: memberID),
                ),
                SizedBox(height: sectionSpacing),
                SizedBox(
                  height: 300, 
                  child: FeelBetter(memberID: memberID),
                ),
                SizedBox(height: sectionSpacing),
                SizedBox(
                  height: 300, 
                  child: HourlyEmotion(memberId: memberID),
                ),
                SizedBox(height: sectionSpacing),
              ],
            ),
          );
        },
      ),
    );
  }
}
