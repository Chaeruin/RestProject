//행동을 완료한 후 감정을 선택하는 페이지

import 'package:flutter/material.dart';
import 'package:heart/APi/action_api.dart';

class ActionAfter extends StatefulWidget {
  final String recommendation; //추천행동 가져오기
  final int memberActionId; //멤버별 행동 id
  final String memberId; //멤버 id

  const ActionAfter({
    super.key,
    required this.recommendation,
    required this.memberActionId,
    required this.memberId,
  });

  @override
  _ActionAfterState createState() => _ActionAfterState();
}

class _ActionAfterState extends State<ActionAfter> {
  @override
  void initState() {
    super.initState();
    print('memberActionId: ${widget.memberActionId}');
  }

  @override
  Widget build(BuildContext context) {
    //선택 가능한 감정 목록
    final List<Map<String, String>> emotions = [
      {'image': 'lib/assets/image/emotions/joy.png', 'label': '기쁨', 'value': 'joy'},
      {'image': 'lib/assets/image/emotions/hope.png', 'label': '희망', 'value': 'hope'},
      {'image': 'lib/assets/image/emotions/anger.png', 'label': '분노', 'value': 'anger'},
      {'image': 'lib/assets/image/emotions/anxiety.png', 'label': '불안', 'value': 'anxiety'},
      {'image': 'lib/assets/image/emotions/neutrality.png', 'label': '중립', 'value': 'neutrality'},
      {'image': 'lib/assets/image/emotions/sadness.png', 'label': '슬픔', 'value': 'sadness'},
      {'image': 'lib/assets/image/emotions/tiredness.png', 'label': '피곤', 'value': 'tiredness'},
      {'image': 'lib/assets/image/emotions/regret.png', 'label': '후회', 'value': 'regret'},
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFBA0),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            const Center(
              child: Text(
                '행동 완료하기',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromARGB(255, 65, 133, 59),
                  fontSize: 24,
                  fontFamily: 'single_day',
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Container(
                width: 350,
                height: 100,
                margin: const EdgeInsets.symmetric(horizontal: 8.0),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFBA0),
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 65, 133, 59).withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    widget.recommendation,
                    style: const TextStyle(
                      fontSize: 21,
                      fontFamily: 'single_day',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 50),
            const Center(
              child: Text(
                '지금 기분상태는?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromARGB(255, 65, 133, 59),
                  fontSize: 24,
                  fontFamily: 'single_day',
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 1.0,
                  crossAxisSpacing: 1.0,
                  childAspectRatio: 0.8,
                ),
                itemCount: emotions.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () async {
                      final selectedEmotion = emotions[index]['value']!;
                  
                     // 사용자가 선택한 감정을 API를 통해 서버에 전달
                      try {
                        final response = await completeAction(
                          widget.memberActionId,
                          selectedEmotion,
                        );

                        print('Raw Response: ${response.toString()}');

                        final completedAction =
                            response['completedMemberAction'];
                            
                        if (completedAction != null &&
                            completedAction is Map<String, dynamic>) {
                          final status = completedAction['status'] ?? '완료';
                         
                         Navigator.of(context).pop({
                              'status': status,
                              'memberActionId': widget.memberActionId,
                            }); // 감정 선택이 완료되면 이전 화면으로 돌아감
                        } else {
                         
                          Navigator.of(context).pop('완료');
                        }
                      } catch (e) {
                        print('Error: $e');
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('오류'),
                              content: Text('행동을 완료하는데 실패했습니다. 오류: $e'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop('error');
                                  },
                                  child: const Text('확인'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    child: Column(
                      children: [
                        Expanded(
                          child: Image.asset(
                            emotions[index]['image']!,
                            width: 70,
                            height: 70,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          emotions[index]['label']!,
                          style: const TextStyle(
                            fontSize: 16,
                            fontFamily: 'single_day',
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}