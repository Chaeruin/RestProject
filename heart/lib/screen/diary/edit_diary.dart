//일기 수정 페이지

import 'dart:convert';  // JSON 데이터를 인코딩 및 디코딩하기 위해 사용
import 'package:flutter/material.dart';  // Flutter의 기본 위젯 및 머티리얼 디자인 컴포넌트를 사용하기 위해 가져옴
import 'package:heart/Api/diary_apis.dart'; //일기 api 가져오기 
import 'package:heart/Model/diary_model.dart'; //일기 model 가져오기 
import 'package:shared_preferences/shared_preferences.dart'; // 간단한 데이터를 로컬에 저장

class EditDiaries extends StatefulWidget {
  final DiaryModel diary; //수정할 일기 데이터

  const EditDiaries({
    super.key,
    required this.diary,
  });

  @override
  State<EditDiaries> createState() => _EditDiariesState();
}

class _EditDiariesState extends State<EditDiaries> {
  late Future<DiaryModel> _diaryFuture; // 일기 데이터를 가져오기 위한 Future
  bool _isEditing = false; // 수정 모드 여부
  late TextEditingController _textEditingController; // 텍스트 입력 컨트롤러
  late String _content; // 일기 내용
  final String _emotionType = ''; // 감정 유형
  late String _selectedImage = 'lib/assets/image/3.png'; // 선택된 감정 이미지
  SharedPreferences? prefs; // SharedPreferences 인스턴스
  List<String> writedays = []; // 작성된 날짜 리스트

  // SharedPreferences 초기화 및 작성된 날짜 리스트 불러오기
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

// 작성된 날짜 리스트에서 날짜 제거 후 업데이트
  void _updateWritedays(String date) async {
    writedays.remove(date);
    await prefs!.setStringList(widget.diary.memberId, writedays);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController(
        text: utf8.decode(widget.diary.content.codeUnits)); //내용 글자 인코딩
    _content = '';
    _diaryFuture = readDiarybyDiaryId(widget.diary.diaryId!);
    _selectedImage =
        'lib/assets/image/emotions/${widget.diary.beforeEmotion}.png'; // 감정 이미지 경로 설정
    _initPrefs(); // SharedPreferences 초기화
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
                _updateWritedays(widget.diary.writeDate); // 날짜 리스트에서 제거
                Navigator.pop(context); // 이전 화면으로 돌아가기
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

              await updateDiary(_content, widget.diary.diaryId!);
              setState(() {
                _isEditing = false; // 저장 버튼을 누르면 수정 모드 종료
              });
              Navigator.pop(context); // 이전 화면으로 돌아가기
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
          future: _diaryFuture, // 일기 데이터 로드
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
                          controller: _textEditingController, // 텍스트 컨트롤러 설정
                          enabled: _isEditing, // 수정 모드 여부에 따라 입력 활성화
                          maxLines: 19, // 입력 가능한 최대 줄 수
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
