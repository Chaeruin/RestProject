import 'package:flutter/material.dart';
import 'package:heart/APi/action_api.dart';

class ActionAfter extends StatelessWidget {
  final String recommendation;
  final int memberActionId;
  final String memberId;

  const ActionAfter({
    super.key,
    required this.recommendation,
    required this.memberActionId,
    required this.memberId,
  });

  @override
  Widget build(BuildContext context) {
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

    print('ActionAfter initialized with memberActionId: $memberActionId');

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
                    recommendation,
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
                      print('Selected Emotion: $selectedEmotion');
                      print('memberActionId: $memberActionId');
                      print('Member ID: $memberId');
                      
                      try {
                        final response = await completeAction(
                          memberActionId,
                          selectedEmotion,
                        );
                        final message = response['message'];
                        print('Response: $message');
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('성공'),
                              content: Text(message ?? '행동이 완료되었습니다.'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('확인'),
                                ),
                              ],
                            );
                          },
                        );
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
