//우울증 척도 테스트

import 'package:flutter/material.dart';  // Flutter의 기본 위젯 및 머티리얼 디자인 컴포넌트를 사용하기 위해 가져옴
import 'package:shared_preferences/shared_preferences.dart'; // 간단한 데이터를 로컬에 저장

class PHQ9 extends StatefulWidget {
  final String memberId;
  final DateTime? selectedDate;

  const PHQ9({super.key, required this.memberId, this.selectedDate});

  @override
  State<PHQ9> createState() => _PHQ9State();
}

class _PHQ9State extends State<PHQ9> {
  late String memberId;
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    memberId = widget.memberId;
    selectedDate = widget.selectedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '우울증 건강설문(PHQ-9)',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFFFB7474),
            fontSize: 25,
            fontFamily: 'single_day',
          ),
        ),
      ),
      body: TableForm(memberId: memberId), // 설문 테이블 폼을 표시
    );
  }
}

//설문지 테이블 생성
class TableForm extends StatefulWidget {
  final String memberId;
  const TableForm({super.key, required this.memberId});

  @override
  TableFormState createState() => TableFormState();
}

class TableFormState extends State<TableForm> {
  int score = 0;
  SharedPreferences? prefs;
  List<String> testScore = []; //저장된 점수 리스트
  int bottomNavIndex = 0;

  //질문에 대한 선택된 값을 저장하는 리스트, 초기값은 모두 0
  final List<int> _selectedValues = List.filled(9, 0);

  // SharedPreferences 초기화 및 저장된 점수 리스트 불러오기
  Future<void> _initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    final testScoreList = prefs!.getStringList('testScore');

    if (testScoreList == null) {
      await prefs!.setStringList('testScore', []);
    } else if (testScoreList.length == 2) {
      testScoreList[0] = testScoreList[1];
      testScore = testScoreList;
    } else {
      testScore = testScoreList;
    }

    if (mounted) {
      setState(() {});
    }
  }

  // 테스트 점수 업데이트 및 SharedPreferences에 저장
  void _updateTestScore(String score) async {
    testScore.add(score);
    await prefs!.setStringList('testScore', testScore);
    setState(() {});
  }

  // 사용자가 체크박스를 변경할 때 호출되는 함수
  void _onCheckboxChanged(int questionIndex, int value) {
    setState(() {
      _selectedValues[questionIndex] = value;
      score = _selectedValues.reduce((a, b) => a + b);
    });
  }

  @override
  void initState() {
    super.initState();
    _initPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Table(
              border: TableBorder.all(),
              columnWidths: const {
                0: FlexColumnWidth(3),
                1: FlexColumnWidth(0.5),
                2: FlexColumnWidth(0.5),
                3: FlexColumnWidth(0.5),
                4: FlexColumnWidth(0.5),
              },
              children: [
                // Headline
                const TableRow(
                  children: [
                    TableCell(
                        child: Center(
                            child: Text('문    항',
                                style: TextStyle(
                                    fontSize: 20, fontFamily: 'single_day')))),
                    TableCell(
                        child: Center(
                            child: Text('없음',
                                style: TextStyle(
                                    fontSize: 18, fontFamily: 'single_day')))),
                    TableCell(
                        child: Center(
                            child: Text('2~6일',
                                style: TextStyle(
                                    fontSize: 18, fontFamily: 'single_day')))),
                    TableCell(
                        child: Center(
                            child: Text('7~12일',
                                style: TextStyle(
                                    fontSize: 18, fontFamily: 'single_day')))),
                    TableCell(
                        child: Center(
                            child: Text('거의\n매일',
                                style: TextStyle(
                                    fontSize: 18, fontFamily: 'single_day')))),
                  ],
                ),

                _buildTableRow(
                  questionIndex: 0,
                  questionText: '기분이 가라앉거나, 우울하거나,\n 희망이 없다고 느꼈다.',
                ),
                _buildTableRow(
                  questionIndex: 1,
                  questionText: '평소 하던 일에 대한 흥미가 \n없어지거나 즐거움을 느끼지 못했다.',
                ),
                _buildTableRow(
                  questionIndex: 2,
                  questionText: '잠들기가 어렵거나 자주 깼다. \n 혹은 너무 많이 잤다.',
                ),
                _buildTableRow(
                  questionIndex: 3,
                  questionText: '평소보다 식욕이 줄었다. \n 혹은 평소보다 많이 먹었다.',
                ),
                _buildTableRow(
                  questionIndex: 4,
                  questionText:
                      '다른 사람들이 눈치 챌 정도로 평소보다 말과 행동이 느려졌다. \n 혹은 너무 안절부절 못해서 가만히 앉아있을 수 없었다.',
                ),
                _buildTableRow(
                  questionIndex: 5,
                  questionText: '피곤하고 기운이 없었다.',
                ),
                _buildTableRow(
                  questionIndex: 6,
                  questionText:
                      '내가 잘못했거나, 실패했다는 생각이 들었다.\n 혹은 자신과 가족을 실망시켰다고 생각했다.',
                ),
                _buildTableRow(
                  questionIndex: 7,
                  questionText: '신문을 읽거나 TV를 보는 것과 같은 일상적인 일에도 집중할 수가 없었다.',
                ),
                _buildTableRow(
                  questionIndex: 8,
                  questionText: '차라리 죽는 것은 더 낫겠다고 생각했다. \n 혹은 자해할 생각을 했다.',
                ),
              ],
            ),
            // 점수와 결과 확인 버튼
            IconButton(
              onPressed: () {
                _updateTestScore(score.toString());
                showDialog(
                  context: context,
                  builder: (context) {
                    return SimpleDialog(
                      title: const Text(
                        '<검사결과>',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'single_day',
                          color: Color(0xFFFB7474),
                        ),
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '총 $score점 입니다!',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 20,
                              fontFamily: 'single_day',
                              color: Color.fromARGB(255, 106, 191, 255),
                            ),
                          ),
                        ),
                        //점수에 따른 결과 표시
                        if (score <= 4)
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              '우울 아님',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 20, fontFamily: 'single_day'),
                            ),
                          )
                        else if (score > 4 && score <= 9)
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              '가벼운 우울',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 20, fontFamily: 'single_day'),
                            ),
                          )
                        else if (score > 9 && score <= 19)
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              '중간 정도의 우울',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 20, fontFamily: 'single_day'),
                            ),
                          )
                        else
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              '심한 우울',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 20, fontFamily: 'single_day'),
                            ),
                          ),
                      ],
                    );
                  },
                );
              },
              icon: const Icon(Icons.check),
            ),
          ],
        ),
      ),
    );
  }

  TableRow _buildTableRow(
      {required int questionIndex, required String questionText}) {
    return TableRow(
      children: [
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              questionText,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
        TableCell(
          child: Center(
            child: Radio<int>(
              value: 0,
              groupValue: _selectedValues[questionIndex],
              onChanged: (value) {
                _onCheckboxChanged(questionIndex, value!);
              },
            ),
          ),
        ),
        TableCell(
          child: Center(
            child: Radio<int>(
              value: 1,
              groupValue: _selectedValues[questionIndex],
              onChanged: (value) {
                _onCheckboxChanged(questionIndex, value!);
              },
            ),
          ),
        ),
        TableCell(
          child: Center(
            child: Radio<int>(
              value: 2,
              groupValue: _selectedValues[questionIndex],
              onChanged: (value) {
                _onCheckboxChanged(questionIndex, value!);
              },
            ),
          ),
        ),
        TableCell(
          child: Center(
            child: Radio<int>(
              value: 3,
              groupValue: _selectedValues[questionIndex],
              onChanged: (value) {
                _onCheckboxChanged(questionIndex, value!);
              },
            ),
          ),
        ),
      ],
    );
  }
}
