import 'package:flutter/material.dart';
import 'package:heart/Api/diary_apis.dart';
import 'package:heart/Model/diary_model.dart';
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

// Future<Map<String, dynamic>> analyzeSentiment(String text) async {
//   final url = Uri.parse('http://3.35.183.52:8081/analyze');
//   final payload = jsonEncode({'text': text});
//   final response = await http.post(
//     url,
//     headers: {'Content-Type': 'application/json'},
//     body: payload,
//   );

//   if (response.statusCode == 200) {
//     Map<String, dynamic> result = jsonDecode(response.body);
//     print(result);
//     print("감정 전송 완료");
//     return result;
//   } else {
//     throw Exception('감정 분석 오류!!');
//   }
// }

class EditDiaries extends StatefulWidget {
  final DiaryModel diary;

  const EditDiaries({
    super.key,
    required this.diary,
  });

  @override
  State<EditDiaries> createState() => _EditDiariesState();
}

class _EditDiariesState extends State<EditDiaries> {
  late Future<DiaryModel> _diaryFuture;
  bool _isEditing = false;
  late TextEditingController _textEditingController;
  late String _content;
  String _emotionType = '';
  late String _selectedImage = 'lib/assets/image/3.png';
  SharedPreferences? prefs;
  List<String> writedays = [];

  Future<void> _initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    final writedaysList = prefs!.getStringList(widget.diary.memberId);

    if (writedaysList != null) {
      writedays = writedaysList;
    }

    if (mounted) {
      setState(() {});
    }
  }

  void _updateWritedays(String date) async {
    writedays.remove(date);
    await prefs!.setStringList(widget.diary.memberId,
        writedays); // writedays 리스트를 SharedPreferences에 저장합니다.
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _textEditingController =
        TextEditingController(text: (widget.diary.content));
    _content = '';
    _emotionType = widget.diary.beforeEmotion;
    _diaryFuture = readDiarybyDiaryId(widget.diary.diaryId!);
    _selectedImage =
        'lib/assets/image/emotions/${widget.diary.beforeEmotion}.png';
    _initPrefs();
  }

  void _showImagePicker(BuildContext context) {
    showModalBottomSheet(
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
                    _selectedImage = 'lib/assets/image/emotions/joy.png';
                    _emotionType = Emotion.joy.toString().split('.').last;
                  });
                  Navigator.pop(context);
                },
                child: const Text('기쁨'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _selectedImage = 'lib/assets/image/emotions/hope.png';
                    _emotionType = Emotion.hope.toString().split('.').last;
                  });
                  Navigator.pop(context);
                },
                child: const Text('희망'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _selectedImage = 'lib/assets/image/emotions/anger.png';
                    _emotionType = Emotion.anger.toString().split('.').last;
                  });
                  Navigator.pop(context);
                },
                child: const Text('분노'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _selectedImage = 'lib/assets/image/emotions/anxiety.png';
                    _emotionType = Emotion.anxiety.toString().split('.').last;
                  });
                  Navigator.pop(context);
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
                  Navigator.pop(context);
                },
                child: const Text('중립'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _selectedImage = 'lib/assets/image/emotions/sadness.png';
                    _emotionType = Emotion.sadness.toString().split('.').last;
                  });
                  Navigator.pop(context);
                },
                child: const Text('슬픔'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _selectedImage = 'lib/assets/images/tiredness.png';
                    _emotionType = Emotion.tiredness.toString().split('.').last;
                  });
                  Navigator.pop(context);
                },
                child: const Text('피곤'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _selectedImage = 'lib/assets/image/emotions/regret.png';
                    _emotionType = Emotion.regret.toString().split('.').last;
                  });
                  Navigator.pop(context);
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
        backgroundColor: const Color(0xFF4CADE4),
        centerTitle: true,
        title: Text(
          (widget.diary.writeDate),
          style: const TextStyle(
            color: Colors.black,
            fontSize: 30,
            fontFamily: 'single_day',
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              // 일기 삭제 기능 구현
              bool isDeleted =
                  await deleteDiary(widget.diary.diaryId.toString());
              if (isDeleted) {
                _updateWritedays(widget.diary.writeDate);
                Navigator.pop(context);
              } else {
                // 삭제 실패 처리
                print("일기 삭제에 실패했습니다.");
              }
            },
            icon: Image.asset(
              'lib/assets/image/delete.png',
              width: 35,
              height: 35,
            ),
          ),
          IconButton(
            onPressed: () async {
              if (_content.isEmpty) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text(
                        '저장 실패',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color.fromARGB(255, 255, 95, 95),
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'single_day',
                        ),
                      ),
                      content: const Text(
                        '일기 내용을 수정해주세요!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontFamily: 'single_day',
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
                              color: Colors.blue,
                              fontSize: 20,
                              fontFamily: 'single_day',
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
                return;
              }
              //백엔드 요청
              DiaryModel newPage = DiaryModel(
                diaryId: widget.diary.diaryId,
                memberId: widget.diary.memberId,
                writeDate: widget.diary.writeDate,
                content: _content,
                beforeEmotion: _emotionType,
              );
              await updateDiary(newPage, widget.diary.diaryId!);
              setState(() {
                _isEditing = false; // 저장 버튼을 누르면 수정 모드 종료
              });
              Navigator.pop(context);
            },
            icon: Image.asset(
              'lib/assets/image/month.png',
              width: 35,
              height: 35,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<DiaryModel>(
          future: _diaryFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              // 데이터가 로드되었을 때의 UI를 표시
              return Column(
                children: [
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GestureDetector(
                      onTap: () {
                        _showImagePicker(context);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 200,
                            padding: const EdgeInsets.all(8),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: const Color(0xFF98DFFF),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              '저를 클릭해서 당신의 \n기분을 변경하세요!',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 22,
                                fontFamily: 'single_day',
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Image.asset(
                            _selectedImage,
                            height: 90,
                            width: 80,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _isEditing = true; // 입력창을 탭하면 수정 모드 시작
                        });
                      },
                      child: SizedBox(
                        width: 350, // 원하는 가로 길이로 설정
                        child: TextField(
                          controller: _textEditingController,
                          enabled: _isEditing,
                          maxLines: 19,
                          onChanged: (value) {
                            setState(() {
                              _content = _textEditingController.text;
                            });
                          },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xFFFFE3EE),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // const SizedBox(height: 16),
                  // Container(
                  //   width: 370, // 원하는 너비로 조정
                  //   height: 50,
                  //   decoration: BoxDecoration(
                  //     color: const Color(0xFFFFE3EE),
                  //     borderRadius: BorderRadius.circular(20),
                  //   ),
                  //   child: TextButton(
                  //     onPressed: () async {
                  //       // 여기!! 여기에 data 전송 api 넣기
                  //       // _content 가 넘어와야 함
                  //       Map<String, dynamic> sentiment =
                  //           await analyzeSentiment(_content);
                  //       Navigator.push(
                  //         // ignore: use_build_context_synchronously
                  //         context,
                  //         MaterialPageRoute(
                  //             builder: (context) =>
                  //                 Statics(sentiment: sentiment)),
                  //       );
                  //     },
                  //     child: const Text(
                  //       '오늘의 기분 상태 보기',
                  //       style: TextStyle(
                  //         color: Color(0xFFFB7474),
                  //         fontSize: 25,
                  //         fontFamily: 'single_day',
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
