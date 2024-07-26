import 'package:flutter/material.dart';
import 'package:heart/drawer/phq9test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:heart/APi/action_api.dart';

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
  RecommendationState createState() => RecommendationState();
}

class RecommendationState extends State<Recommendation> {
  List<String> _currentRecommendations = [];
  late String memberID;
  SharedPreferences? prefs;
  List<String> testScore = ['', ''];

  Emotion? _selectedEmotion;
  bool _isLoading = false;
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
      final recommendations =
          await Recommendations(memberID, emotion.toString().split('.').last);
      setState(() {
        _currentRecommendations = recommendations;
      });
    } catch (e) {
      setState(() {
        _currentRecommendations = ['추천 데이터를 불러오는데 실패했습니다.'];
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
                  Navigator.pop(
                      context, Emotion.joy.toString().split('.').last);
                },
                child: const Text('기쁨'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _selectedEmotion = Emotion.hope;
                  });
                  Navigator.pop(
                      context, Emotion.hope.toString().split('.').last);
                },
                child: const Text('희망'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _selectedEmotion = Emotion.anger;
                  });
                  Navigator.pop(
                      context, Emotion.anger.toString().split('.').last);
                },
                child: const Text('분노'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _selectedEmotion = Emotion.anxiety;
                  });
                  Navigator.pop(
                      context, Emotion.anxiety.toString().split('.').last);
                },
                child: const Text('불안'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _selectedEmotion = Emotion.neutrality;
                  });
                  Navigator.pop(
                      context, Emotion.neutrality.toString().split('.').last);
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
                  height: 160,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _currentRecommendations.length,
                    itemBuilder: (context, index) {
                      return Container(
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
                        child: Center(
                          child: Text(
                            _currentRecommendations[index],
                            style: const TextStyle(
                              fontSize: 20,
                              fontFamily: 'single_day',
                            ),
                            textAlign: TextAlign.center,
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
