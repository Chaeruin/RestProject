import 'package:flutter/material.dart';
import 'package:heart/top3emo.dart';
import 'package:heart/totalemo.dart';

class Statistics extends StatefulWidget {
  final String memId;
  const Statistics({super.key, required this.memId});

  @override
  State<Statistics> createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  late final String memberID;

  @override
  void initState() {
    super.initState();
    memberID = widget.memId;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Scaffold(
        body: Column(
          children: [
            Expanded(child: TotalEmotion(memberId: memberID)),
            // SizedBox(
            //   height: 20,
            // ),
            Expanded(child: Top3Emotion(memberId: 'test')),
            // SizedBox(
            //   height: 30,
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  child: Text('ooo님은 ㅁㅁ을 하면\n기분이 나아져요!!'),
                ),
                Column(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      color: Colors.cyan,
                      child: Text('Action'),
                    ),
                    Text('행동추천'),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
