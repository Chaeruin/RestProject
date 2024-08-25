//일기를 작성하는 페이지
import 'package:flutter/material.dart';
import 'package:heart/Api/audio_apis.dart';
import 'package:heart/Api/diary_apis.dart';
import 'package:heart/Model/diary_model.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

class AddDiaries extends StatefulWidget {
  final DateTime selectedDate; //사용자가 선택한 날짜
  final String memberId;
  const AddDiaries(
      {super.key, required this.selectedDate, required this.memberId});

  @override
  State<AddDiaries> createState() => _AddDiariesState();
}

class _AddDiariesState extends State<AddDiaries> {
  late String _content = ' ';
  late String _writeDate;
  final TextEditingController _textEditingController = TextEditingController();
  String _emotionType = ''; //선택한 감정 타입
  late String _selectedImage = 'lib/assets/image/1.png';
  final Emotion selectedEmotion = Emotion.joy;
  Emotion? _selectedEmotion;
  late String beforeEmotion = ' ';

  late final SharedPreferences prefs;
  List<String> writedays = [];

// SharedPreferences 초기화
  Future<void> _initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    final writedaysList = prefs.getStringList(widget.memberId);

    if (writedaysList != null) {
      writedays = writedaysList;
    }

    if (mounted) {
      setState(() {});
    }
  }

// 작성한 날짜를 업데이트하고 저장
  void _updateWritedays(String date) async {
    writedays.add(date);
    await prefs.setStringList(widget.memberId, writedays); // writedays 리스트를 저장
    setState(() {});
  }

  //음악 생성을 위한 딜레이 추가
  Future<void> musicCreationDelay() async {
    await Future.delayed(Duration(minutes: 4));
  }

  @override
  void initState() {
    super.initState();
    _initPrefs();
    _writeDate = DateFormat('yyyyMMdd').format(widget.selectedDate);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final String? selectedEmotion = await _showImagePicker(context);
      if (selectedEmotion != null) {
        setState(() {
          _selectedEmotion = Emotion.values.firstWhere(
              (e) => e.toString().split('.').last == selectedEmotion);
          beforeEmotion = selectedEmotion;
        });
      }
    });
  }

// 감정 선택 모달을 표시하는 함수
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
              // 감정별로 버튼을 생성하고 이미지와 감정 타입을 설정
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _selectedImage = 'lib/assets/image/emotions/joy.png';
                    _emotionType = Emotion.joy.toString().split('.').last;
                  });
                  Navigator.pop(context, _emotionType);
                },
                child: const Text('기쁨'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _selectedImage = 'lib/assets/image/emotions/hope.png';
                    _emotionType = Emotion.hope.toString().split('.').last;
                  });
                  Navigator.pop(context, _emotionType);
                },
                child: const Text('희망'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _selectedImage = 'lib/assets/image/emotions/anger.png';
                    _emotionType = Emotion.anger.toString().split('.').last;
                  });
                  Navigator.pop(context, _emotionType);
                },
                child: const Text('분노'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _selectedImage = 'lib/assets/image/emotions/anxiety.png';
                    _emotionType = Emotion.anxiety.toString().split('.').last;
                  });
                  Navigator.pop(context, _emotionType);
                },
                child: const Text('불안'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _selectedImage = 'lib/assets/image/emotions/neutrality.png';
                    _emotionType =
                        Emotion.neutrality.toString().split('.').last;
                  });
                  Navigator.pop(context, _emotionType);
                },
                child: const Text('중립'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _selectedImage = 'lib/assets/image/emotions/sadness.png';
                    _emotionType = Emotion.sadness.toString().split('.').last;
                  });
                  Navigator.pop(context, _emotionType);
                },
                child: const Text('슬픔'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _selectedImage = 'lib/assets/image/emotions/tiredness.png';
                    _emotionType = Emotion.tiredness.toString().split('.').last;
                  });
                  Navigator.pop(context, _emotionType);
                },
                child: const Text('피곤'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _selectedImage = 'lib/assets/image/emotions/regret.png';
                    _emotionType = Emotion.regret.toString().split('.').last;
                  });
                  Navigator.pop(context, _emotionType);
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
        centerTitle: true,
        title: Text(
          (_writeDate),
          style: const TextStyle(
            color: Colors.black,
            fontSize: 25,
            fontFamily: 'single_day',
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              // 감정이 선택되지 않은 경우 경고 메시지 표시
              if (_emotionType.isEmpty) {
                //감정이 선택되지 않은 경우 경고 메시지
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: const Color.fromARGB(255, 206, 251, 201),
                      content: const Text(
                        '감정을 선택해주세요!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'single_day',
                          fontSize: 25,
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            '확인',
                            style: TextStyle(
                              color: Color.fromARGB(255, 89, 181, 81),
                              fontFamily: 'single_day',
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
                return;
              }
              // 내용이 입력되지 않은 경우 경고 메시지 표시
              if (_content.isEmpty) {
                // 내용이 입력되지 않은 경우 경고 메시지
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: const Color.fromARGB(255, 206, 251, 201),
                      content: const Text(
                        '내용을 입력해주세요!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'single_day',
                          color: Colors.black,
                          fontSize: 25,
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            '확인',
                            style: TextStyle(
                              fontFamily: 'single_day',
                              color: Color.fromARGB(255, 89, 181, 81),
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
                return;
              }

              String? afterEmotion = await _showImagePicker(context);

              // 음악 추천 요청을 위한 감정 전송
              await sendEmotionData(widget.memberId, afterEmotion!);

              print('beforeEmotin: $beforeEmotion');
              print('afterEmotion: $afterEmotion');
              //백엔드 요청
              DiaryModel newPage = DiaryModel(
                memberId: widget.memberId,
                writeDate: _writeDate,
                content: _content,
                beforeEmotion: beforeEmotion,
                afterEmotion: afterEmotion,
              );
              if (await saveDiary(newPage)) {
                _updateWritedays(_writeDate); //작성한 날짜 저장
                Navigator.pop(context);
              } else {
                // 실패 시 알림 처리
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: const Text('일기 저장에 실패했습니다.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('확인'),
                        ),
                      ],
                    );
                  },
                );
              }
            },
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: 8),
                Image.asset(
                  _selectedImage,
                  height: 80,
                  width: 70,
                ),
              ],
            ),
            const SizedBox(height: 35),
            TextField(
              controller: _textEditingController,
              maxLines: 19,
              onChanged: (value) {
                setState(() {
                  _content = value;
                });
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFFFFBA0), // 배경색 지정
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
