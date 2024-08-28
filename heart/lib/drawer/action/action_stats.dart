//행동 통계를 보여주는 페이지
 
import 'package:flutter/material.dart';  // Flutter의 기본 위젯 및 머티리얼 디자인 컴포넌트를 사용하기 위해 가져옴
import 'package:heart/drawer/action/hourlyemo.dart'; //시간대별 가장 빈도가 많은 감정을 보여주는 페이지
import 'package:heart/drawer/action/feel_better.dart'; //기분에 따른 행동을 추천해주는 페이지

class ActionStats extends StatefulWidget {
  final String memberID;
  const ActionStats({
    super.key,
    required this.memberID,
  });

  @override
  State<ActionStats> createState() => _ActionStatsState();
}

class _ActionStatsState extends State<ActionStats> {
  late String memberID = '';

  @override
  void initState() {
    super.initState();
    memberID = widget.memberID;
  }

  @override
  Widget build(BuildContext context) {
    return (memberID == '')
        ? const Scaffold(
            body: Center(
              child: Text('로그인이 필요합니다!'),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: const Color(0xFFFFFBA0),
              title: const Text(
                '행동 통계',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontFamily: 'single_day',
                ),
              ),
              centerTitle: true,
            ),
            body: Column(
              children: [
                const SizedBox(height: 20),
                Expanded(child: FeelBetter(memberID: memberID)),
                const SizedBox(height: 20),
                Expanded(child: HourlyEmotion(memberId: memberID)),
                const SizedBox(height: 20),
              ],
            ),
          );
  }
}
