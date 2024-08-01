import 'package:flutter/material.dart';
import 'package:heart/Api/diary_apis.dart';
import 'package:heart/Model/diary_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    await prefs!.setStringList(widget.diary.memberId,writedays); 
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFBA0),
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
              width: 40,
              height: 40,
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
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
                            fillColor: const Color(0xFFFFFBA0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}