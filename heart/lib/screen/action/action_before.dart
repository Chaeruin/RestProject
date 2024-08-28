//행동을 시작하는 페이지

import 'package:flutter/material.dart'; // Flutter의 기본 위젯 및 머티리얼 디자인 컴포넌트를 사용하기 위해 가져옴
import 'package:heart/APi/action_api.dart'; //행동 api 가져오기
import 'dart:convert';// JSON 데이터를 인코딩 및 디코딩하기 위해 사용
import 'package:shared_preferences/shared_preferences.dart'; // 간단한 데이터를 로컬에 저장
import 'package:heart/screen/action/recommendation.dart'; //행동 추천 페이지 연결

class ActionBefore extends StatelessWidget {
  final String recommendation; // 추천된 행동을 가져오기 위한 변수
  final int actionId; // 행동 ID
  final String memberId; // 멤버 ID

  const ActionBefore({
    super.key,
    required this.recommendation,
    required this.actionId,
    required this.memberId,
  });

  // 멤버별 행동 ID를 로컬 저장소에 저장하는 함수
  Future<void> _saveMemberActionId(int actionId, int memberActionId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('member_action_id_$actionId', memberActionId);
  }

  @override
  Widget build(BuildContext context) {
    // 사용 가능한 감정 목록을 정의
    final List<Map<String, String>> emotions = [
      {
        'image': 'lib/assets/image/emotions/joy.png',
        'label': '기쁨',
        'value': 'joy'
      },
      {
        'image': 'lib/assets/image/emotions/hope.png',
        'label': '희망',
        'value': 'hope'
      },
      {
        'image': 'lib/assets/image/emotions/anger.png',
        'label': '분노',
        'value': 'anger'
      },
      {
        'image': 'lib/assets/image/emotions/anxiety.png',
        'label': '불안',
        'value': 'anxiety'
      },
      {
        'image': 'lib/assets/image/emotions/neutrality.png',
        'label': '중립',
        'value': 'neutrality'
      },
      {
        'image': 'lib/assets/image/emotions/sadness.png',
        'label': '슬픔',
        'value': 'sadness'
      },
      {
        'image': 'lib/assets/image/emotions/tiredness.png',
        'label': '피곤',
        'value': 'tiredness'
      },
      {
        'image': 'lib/assets/image/emotions/regret.png',
        'label': '후회',
        'value': 'regret'
      },
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
                '행동 시작하기',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromARGB(255, 65, 133, 59),
                  fontSize: 24,
                  fontFamily: 'single_day',
                ),
              ),
            ),
            const SizedBox(height: 16),
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
                      color: const Color.fromARGB(255, 65, 133, 59)
                          .withOpacity(0.5),
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

                      // 사용자가 선택한 감정을 API를 통해 서버에 전달
                      try {
                        final response = await startAction(
                          actionId,
                          memberId,
                          selectedEmotion,
                        );

                        dynamic body = response['body'];

                        if (body is String) {
                          body = jsonDecode(body);
                        }
                        // API로부터 받은 응답 데이터 처리
                        if (body is Map<String, dynamic>) {
                          final savedMemberAction = body['savedMemberAction'];
                          if (savedMemberAction is Map<String, dynamic>) {
                            final status = savedMemberAction['status'];
                            final memberActionId =
                                savedMemberAction['memberActionId'];

                            // 멤버 행동 ID를 로컬 저장소에 저장
                            if (memberActionId != null) {
                              await _saveMemberActionId(
                                  actionId, memberActionId);
                            }

                            // 감정 선택이 완료되면 이전 화면으로 돌아감
                            Navigator.of(context).pop({
                              'status': status,
                              'memberActionId': memberActionId,
                            });
                          } else {
                            throw Exception('savedMemberAction is not a Map');
                          }
                        } else {
                          throw Exception('body is neither a String nor a Map');
                        }
                      } catch (e) {
                        print('Error: $e');
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('오류'),
                              content: Text('행동을 시작하는데 실패했습니다. 오류: $e'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const Recommendation()),
                                    );
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
                            width: 70,
                            height: 70,
                            emotions[index]['image']!,
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
