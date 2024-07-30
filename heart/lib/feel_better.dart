import 'package:flutter/material.dart';
import 'package:heart/Api/action_api.dart';

class FeelBetter extends StatefulWidget {
  final String memberID;
  const FeelBetter({super.key, required this.memberID});

  @override
  State<FeelBetter> createState() => _FeelBetterStatsState();
}

class _FeelBetterStatsState extends State<FeelBetter> {
  late final Future<List<String>> feelBetterLists;

  @override
  void initState() {
    super.initState();
    feelBetterLists = feelBetterActions(widget.memberID);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          '행동 통계', // 원하는 텍스트로 변경
          style: TextStyle(
            color: Color.fromARGB(255, 65, 133, 59),
            fontSize: 25,
            fontFamily: 'single_day',
          ), // 적절한 크기로 텍스트 스타일 설정
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 150,
              width: 150,
              decoration: const BoxDecoration(color: Colors.pinkAccent),
              child: const Text(
                'ooo님은 이런 행동을\n하면 기분이 좋아져요!',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'single_day',
                ),
              ),
            ),
            const SizedBox(width: 50),
            const Icon(
              Icons.accessibility,
              size: 150,
            ),
          ],
        ),
        const SizedBox(height: 10),
        FutureBuilder(
          future: feelBetterLists,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: 2,
              padding: const EdgeInsets.all(10),
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(Icons.circle),
                        const SizedBox(width: 5),
                        Text('${snapshot.data[index]}')
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
