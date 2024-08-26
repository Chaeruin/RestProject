import 'package:flutter/material.dart';
import 'package:heart/auth_provider.dart';
import 'package:provider/provider.dart';
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
  const Recommendation({super.key});

  @override
  _RecommendationState createState() => _RecommendationState();
}

class _RecommendationState extends State<Recommendation> {
  List<Map<String, dynamic>> _currentRecommendations = []; // 추천행동 리스트
  late String memberID;
  late String status;
  late int memberActionId;
  SharedPreferences? prefs;
  List<String> testScore = ['', '']; // 우울척도 테스트 점수 저장

  Emotion? _selectedEmotion;
  bool _isLoading = false; // 로딩 상태를 나타내는 플래그

  Future<void> _initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    List<String>? storedTestScore = prefs!.getStringList('testScore');

    // 테스트 점수가 없는 경우 초기값으로 설정
    if (storedTestScore == null || storedTestScore.length < 2) {
      await prefs!.setStringList('testScore', ['', '']);
      setState(() {
        testScore = ['', ''];
      });
    } else {
      // 테스트 점수가 두 개 이상인 경우 최신 두 개의 점수만 유지
      storedTestScore = storedTestScore.length > 2
          ? storedTestScore.sublist(storedTestScore.length - 2)
          : storedTestScore;
      await prefs!.setStringList('testScore', storedTestScore);
      setState(() {
        testScore = storedTestScore!;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // 초기 memberID 값을 설정
    memberID = Provider.of<AuthProvider>(context, listen: false).ID;

    _initPrefs();

    // 위젯이 처음 렌더링될 때 감정 선택창을 보여줌
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

  @override
  Widget build(BuildContext context) {
    // AuthProvider의 상태 변화에 따라 memberID를 업데이트
    memberID = Provider.of<AuthProvider>(context, listen: true).ID;

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
                  // 감정이 선택되지 않았을 경우 로딩 상태 표시
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
                                // 행동 상태에 따라 해당 페이지로 이동
                                if (_currentRecommendations[index]['status'] ==
                                    '없음') {
                                  final result = await Navigator.push<
                                      Map<String, dynamic>>(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ActionBefore(
                                        recommendation:
                                            _currentRecommendations[index]
                                                ['action'],
                                        memberId: memberID,
                                        actionId: _currentRecommendations[index]
                                            ['actionId'],
                                      ),
                                    ),
                                  );

                                  if (result != null) {
                                    setState(() {
                                      _currentRecommendations[index]['status'] =
                                          result['status'];
                                      _currentRecommendations[index]
                                              ['memberActionId'] =
                                          result['memberActionId'];
                                    });
                                  }
                                } else if (_currentRecommendations[index]
                                        ['status'] ==
                                    '진행중') {
                                  final memberActionId =
                                      _currentRecommendations[index]
                                          ['memberActionId'];
                                  final result = await Navigator.push<
                                      Map<String, dynamic>>(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ActionAfter(
                                        recommendation:
                                            _currentRecommendations[index]
                                                ['action'],
                                        memberActionId: memberActionId,
                                        memberId: memberID,
                                      ),
                                    ),
                                  );

                                  if (result != null) {
                                    setState(() {
                                      _currentRecommendations[index]['status'] =
                                          result['status'];
                                      _currentRecommendations[index]
                                              ['memberActionId'] =
                                          result['memberActionId'];
                                    });
                                  }
                                }
                              },
                              child: Container(
                                width: 170,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                padding: const EdgeInsets.all(16.0),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFFBA0),
                                  borderRadius: BorderRadius.circular(10.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          const Color.fromARGB(255, 65, 133, 59)
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
                                      _currentRecommendations[index]
                                              ['action'] ??
                                          '행동 없음',
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

                    // 우울 척도 테스트와 결과를 보여주는 부분
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
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: const [
                                Text(
                                  '우울척도 테스트',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontFamily: 'single_day',
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 8),
                                Icon(Icons.analytics_outlined,
                                    size: 40, color: Colors.black),
                              ],
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            Text(
                              '1차 우울척도: ${testScore[0]}',
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.red,
                                fontFamily: 'single_day',
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              '2차 우울척도: ${testScore[1]}',
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.red,
                                fontFamily: 'single_day',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          );
  }

  // 감정 선택창
  Future<String?> _showImagePicker(BuildContext context) async {
    String? selectedEmotion = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            '오늘의 감정을 선택하세요',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color.fromARGB(255, 65, 133, 59),
              fontSize: 24,
              fontFamily: 'single_day',
            ),
          ),
          content: SizedBox(
            height: 300, // 적절한 크기 지정
            width: double.minPositive,
            child: GridView.count(
              crossAxisCount: 3,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              children: Emotion.values.map((Emotion emotion) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pop(context, emotion.toString().split('.').last);
                  },
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/image/emotions/${emotion.toString().split('.').last}.png',
                        width: 70,
                        height: 70,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        emotion.toString().split('.').last,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'single_day',
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
    return selectedEmotion;
  }

  // 행동 추천 요청 함수
  Future<void> _Recommendations(Emotion emotion) async {
    setState(() {
      _isLoading = true;
    });

    try {
      Map<String, dynamic> requestData = {
        "memberId": memberID,
        "emotion": emotion.toString().split('.').last
      };
      var response = await Recommendations(requestData[0], requestData[1]);
      setState(() {
        _currentRecommendations = response;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching recommendations: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }
}
