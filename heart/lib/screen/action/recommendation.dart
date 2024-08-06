import 'package:flutter/material.dart';
import 'package:heart/drawer/phq9test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:heart/APi/action_api.dart'; 
import 'package:heart/screen/action/action_before.dart';
import 'package:heart/screen/action/action_after.dart';

enum Emotion {
  joy,
  hope,
  anger,
  anxiety,
  neutrality,
  sadness,
  tiredness,
  regret,
}

class Recommendation extends StatefulWidget {
  final String memberID;
  const Recommendation({super.key, required this.memberID});

  @override
  _RecommendationState createState() => _RecommendationState();
}

class _RecommendationState extends State<Recommendation> {
  List<Map<String, dynamic>> _currentRecommendations = [];
  late String memberID;
  SharedPreferences? prefs;
  List<String> testScore = ['', ''];

  Emotion? _selectedEmotion;
  bool _isLoading = false;

  Future<void> _saveMemberActionId(String actionId, String memberActionId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('member_action_id_$actionId', memberActionId);
  }

  Future<String?> _getMemberActionId(String actionId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('member_action_id_$actionId');
  }

  Future<void> _initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    List<String>? storedTestScore = prefs!.getStringList('testScore');

    if (storedTestScore == null || storedTestScore.length < 2) {
      await prefs!.setStringList('testScore', ['', '']);
      setState(() {
        testScore = ['', ''];
      });
    } else {
      storedTestScore = storedTestScore.length > 2
          ? storedTestScore.sublist(storedTestScore.length - 2)
          : storedTestScore;
      await prefs!.setStringList('testScore', storedTestScore);
      setState(() {
        testScore = storedTestScore!;
      });
    }
  }

  Future<void> _saveActionStatus(String actionId, String status) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('action_status_$actionId', status);
  }

  Future<String?> _getActionStatus(String actionId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('action_status_$actionId');
  }

  @override
  void initState() {
    super.initState();
    memberID = widget.memberID;
    _initPrefs();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final String? selectedEmotion = await _showImagePicker(context);
      if (selectedEmotion != null) {
        setState(() {
          _selectedEmotion = Emotion.values.firstWhere(
              (e) => e.toString().split('.').last == selectedEmotion);
        });
        await _Recommendations(_selectedEmotion!);
      }
    });
  }

  Future<void> _Recommendations(Emotion emotion) async {
  setState(() {
    _isLoading = true;
  });

  try {
    final response = await Recommendations(
        memberID, emotion.toString().split('.').last);

    final List<Map<String, dynamic>> recommendations = await Future.wait(
      (response as List).map((item) async {
        final actionId = item['actionId'];
        final memberActionId = await _getMemberActionId(actionId.toString());
        final savedStatus = await _getActionStatus(actionId.toString());
        print('Parsed Item: actionId=$actionId, memberActionId=$memberActionId, status=$savedStatus');
        return {
          'action': item['action'],
          'actionId': int.tryParse(item['actionId'].toString()) ?? 0, // 변환
          'status': savedStatus ?? item['status'] ?? '없음',
          'memberActionId': int.tryParse(memberActionId ?? '0'), // 변환
        };
      }),
    );
    setState(() {
      _currentRecommendations = recommendations;
    });
  } catch (e) {
    setState(() {
      _currentRecommendations = [
        {'action': '추천 데이터를 불러오는데 실패했습니다.', 'actionId': 0, 'status': '없음', 'memberActionId': 0}
      ];
    });
  } finally {
    setState(() {
      _isLoading = false;
    });
  }
}


  Future<String?> _showImagePicker(BuildContext context) async {
    return showModalBottomSheet<String>(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 500,
          width: 400,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _selectedEmotion = Emotion.joy;
                  });
                  Navigator.pop(context, Emotion.joy.toString().split('.').last);
                },
                child: const Text('기쁨'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _selectedEmotion = Emotion.hope;
                  });
                  Navigator.pop(context, Emotion.hope.toString().split('.').last);
                },
                child: const Text('희망'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _selectedEmotion = Emotion.anger;
                  });
                  Navigator.pop(context, Emotion.anger.toString().split('.').last);
                },
                child: const Text('분노'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _selectedEmotion = Emotion.anxiety;
                  });
                  Navigator.pop(context, Emotion.anxiety.toString().split('.').last);
                },
                child: const Text('불안'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _selectedEmotion = Emotion.neutrality;
                  });
                  Navigator.pop(context, Emotion.neutrality.toString().split('.').last);
                },
                child: const Text('중립'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _selectedEmotion = Emotion.sadness;
                  });
                  Navigator.pop(
                      context, Emotion.sadness.toString().split('.').last);
                },
                child: const Text('슬픔'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _selectedEmotion = Emotion.tiredness;
                  });
                  Navigator.pop(
                      context, Emotion.tiredness.toString().split('.').last);
                },
                child: const Text('피곤'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _selectedEmotion = Emotion.regret;
                  });
                  Navigator.pop(
                      context, Emotion.regret.toString().split('.').last);
                },
                child: const Text('후회'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFBA0),
        title: const Text(
          '행동 추천',
          style: TextStyle(
            color: Colors.black,
            fontSize: 25,
            fontFamily: 'single_day',
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_selectedEmotion == null)
              const Center(
                child: Text(
                  'Loading...',
                  style: TextStyle(
                    color: Color.fromARGB(255, 65, 133, 59),
                    fontSize: 24,
                    fontFamily: 'single_day',
                  ),
                ),
              )
            else ...[
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  '추천 행동 List',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color.fromARGB(255, 65, 133, 59),
                    fontSize: 24,
                    fontFamily: 'single_day',
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (_isLoading)
                const Center(
                  child: Text(
                    'Loading...',
                    style: TextStyle(
                      color: Color.fromARGB(255, 65, 133, 59),
                      fontSize: 24,
                      fontFamily: 'single_day',
                    ),
                  ),
                )
              else
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _currentRecommendations.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () async {
                          if (_currentRecommendations[index]['status'] ==
                              '없음') {
                            final status = await Navigator.push<String>(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ActionBefore(
                                  recommendation: _currentRecommendations[index]
                                      ['action'],
                                  memberId: memberID,
                                  actionId: _currentRecommendations[index]
                                      ['actionId'],
                                ),
                              ),
                            );
                            if (status != null) {
                              setState(() {
                                _currentRecommendations[index]['status'] =
                                    status;
                              });
                              await _saveActionStatus(
                                _currentRecommendations[index]['actionId']
                                    .toString(),
                                status,
                              );
                            }
                          } else if (_currentRecommendations[index]['status'] ==
                              '진행중') {
                            final memberActionId =
                                _currentRecommendations[index]
                                        ['memberActionId'] ??
                                    0;
                            final status = await Navigator.push<String>(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ActionAfter(
                                  recommendation: _currentRecommendations[index]
                                      ['action'],
                                  memberActionId: memberActionId,
                                  memberId: memberID,
                                ),
                              ),
                            );
                            print('Returned status from ActionAfter: $status');
                            if (status != null) {
                              setState(() {
                                _currentRecommendations[index]['status'] =
                                    status;
                              });
                              await _saveActionStatus(
                                _currentRecommendations[index]['actionId']
                                    .toString(),
                                status,
                              );
                            }
                          }

                          
                          final result = await _getActionStatus(
                              _currentRecommendations[index]['actionId']
                                  .toString());
                          print(
                              'Retrieved status from SharedPreferences: $result');
                          if (result != null) {
                            setState(() {
                              _currentRecommendations[index]['status'] = result;
                            });
                          }
                        },

                        child: Container(
                          width: 170,
                          margin: const EdgeInsets.symmetric(horizontal: 8.0),
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFFBA0),
                            borderRadius: BorderRadius.circular(10.0),
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
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                               _currentRecommendations[index]['action'] ?? '행동 없음',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'single_day',
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 10),
                              Text(
                               '상태: ${_currentRecommendations[index]['status'] ?? '없음'}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Color.fromARGB(255, 65, 133, 59),
                                  fontFamily: 'single_day',
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              const SizedBox(height: 30),
              const Center(
                child: Text(
                  '우울 척도 Test',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color.fromARGB(255, 65, 133, 59),
                    fontSize: 24,
                    fontFamily: 'single_day',
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PHQ9(memberId: memberID),
                      ),
                    ),
                    child: Container(
                      width: 170,
                      height: 130,
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFBA0),
                        borderRadius: BorderRadius.circular(10.0),
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
                      child: const Text(
                        '우울증 건강 설문\n해보기',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'single_day',
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    child: Container(
                      width: 170,
                      height: 130,
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFBA0),
                        borderRadius: BorderRadius.circular(10.0),
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
                      child: Text(
                        '우울체크 트래킹\n"이전" 검사결과: ${testScore.isNotEmpty ? testScore[0] : ''}\n"이번" 검사결과: ${testScore.length > 1 ? testScore[1] : ''}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          fontFamily: 'single_day',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}