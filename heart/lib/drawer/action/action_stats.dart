//행동 통계를 보여주는 페이지

import 'package:flutter/material.dart';
import 'package:heart/drawer/action/hourlyemo.dart';
import 'package:heart/drawer/action/feel_better.dart';

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
        ? Scaffold(
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
