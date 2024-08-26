//캘린더 화면

import 'package:flutter/material.dart';
import 'package:heart/Model/diary_model.dart';
import 'package:heart/auth_provider.dart';
import 'package:heart/screen/diary/edit_diary.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:heart/Api/diary_apis.dart';
import 'package:heart/screen/diary/add_diary.dart';

class Diary extends StatefulWidget {
  const Diary({
    super.key,
  });

  @override
  State<Diary> createState() => _DiaryState();
}

class _DiaryState extends State<Diary> {
  CalendarFormat _calendarFormat = CalendarFormat.month; //캘린더 형식
  DateTime _focusedDay = DateTime.now(); // 현재 포커스된 날짜
  DateTime? _selectedDay; //선택한 날짜
  late String memberId; // 사용자 ID

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay; // 초기 선택 날짜를 현재 포커스 날짜로 설정
    // AuthProvider에서 memberId 가져오기
    memberId = Provider.of<AuthProvider>(context, listen: false).ID;
  }

  @override
  Widget build(BuildContext context) {
    const TextStyle customTextStyle = TextStyle(
      fontFamily: 'single_day',
      fontSize: 16,
    );
    memberId = Provider.of<AuthProvider>(context, listen: true).ID;
    return (memberId == '')
        ? const Scaffold(
            body: Center(
              child: Text('로그인이 필요합니다!'),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: const Color(0xFFFFFBA0),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 30.0),
                  child: InkWell(
                    onTap: () async {
                      // 선택된 날짜에 대한 일기 데이터를 읽어옴
                      DiaryModel? newPage =
                          await readDiarybyDate(memberId, _selectedDay!);
                      if (newPage != null) {
                        // 일기가 이미 있는 경우, 수정 페이지로 이동
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditDiaries(diary: newPage),
                          ),
                        );
                      } else {
                        // 일기가 없는 경우, 새 일기 작성 페이지로 이동
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddDiaries(
                              memberId: memberId,
                              selectedDate: _selectedDay!,
                            ),
                          ),
                        );
                      }
                    },
                    child: Image.asset(
                      'lib/assets/image/add.png',
                      width: 40,
                      height: 40,
                    ),
                  ),
                ),
              ],
            ),
            body: LayoutBuilder(
              builder: (context, constraints) {
                final bool isLargeScreen = constraints.maxWidth > 600;
                final double calendarFontSize = isLargeScreen ? 18 : 14;
                final double headerFontSize = isLargeScreen ? 25 : 20;
                final double iconSize = isLargeScreen ? 100 : 70;
                final double imageSize = isLargeScreen ? 100 : 70;
                final double spacing = isLargeScreen ? 20 : 10;

                return Column(
                  children: [
                    TableCalendar(
                      focusedDay: _focusedDay, // 현재 포커스된 날짜
                      firstDay: DateTime.utc(2020, 10, 16), // 달력의 시작 날짜
                      lastDay: DateTime.utc(2030, 3, 14), // 달력의 종료 날짜
                      calendarFormat: _calendarFormat, // 캘린더 형식
                      eventLoader: (day) => [], // 특정 날짜의 이벤트 로더
                      selectedDayPredicate: (day) {
                        return isSameDay(_selectedDay, day); // 선택된 날짜와 일치하는지 확인
                      },
                      onDaySelected: (selectedDay, focusedDay) {
                        // 날짜가 선택되었을 때 호출
                        if (!isSameDay(_selectedDay, selectedDay)) {
                          setState(() {
                            _selectedDay = selectedDay; // 선택된 날짜 업데이트
                            _focusedDay = focusedDay; // 포커스된 날짜 업데이트
                          });
                        }
                      },
                      onFormatChanged: (format) {
                        // 캘린더 형식이 변경되었을 때 호출
                        if (_calendarFormat != format) {
                          setState(() {
                            _calendarFormat = format; // 캘린더 형식 업데이트
                          });
                        }
                      },
                      onPageChanged: (focusedDay) {
                        _focusedDay = focusedDay; // 페이지가 변경되었을 때 포커스된 날짜 업데이트
                      },
                      calendarStyle: CalendarStyle(
                        defaultTextStyle: customTextStyle.copyWith(
                            fontSize: calendarFontSize),
                        weekendTextStyle: customTextStyle.copyWith(
                            fontSize: calendarFontSize),
                        selectedTextStyle: customTextStyle.copyWith(
                            color: Colors.white, fontSize: calendarFontSize),
                        todayTextStyle: customTextStyle.copyWith(
                            color: const Color.fromARGB(255, 2, 2, 2),
                            fontSize: calendarFontSize),
                        selectedDecoration: const BoxDecoration(
                          color: Color.fromARGB(255, 89, 181, 81),
                          shape: BoxShape.circle,
                        ),
                        todayDecoration: const BoxDecoration(
                          color: Color(0xFFFFFBA0),
                          shape: BoxShape.circle,
                        ),
                      ),
                      daysOfWeekStyle: DaysOfWeekStyle(
                        weekdayStyle: customTextStyle.copyWith(
                            fontSize: calendarFontSize),
                        weekendStyle: customTextStyle.copyWith(
                            fontSize: calendarFontSize),
                      ),
                      headerStyle: HeaderStyle(
                        titleTextStyle:
                            customTextStyle.copyWith(fontSize: headerFontSize),
                      ),
                    ),
                    SizedBox(height: spacing),
                    Expanded(
                      child: FutureBuilder<DiaryModel?>(
                        future: readDiarybyDate(memberId, _selectedDay!),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator.adaptive(),
                            );
                          } else if (snapshot.hasError) {
                            // 오류 발생 시 오류 메시지 표시
                            return Center(
                              child: Text('Error: ${snapshot.error}'),
                            );
                          } else if (!snapshot.hasData) {
                            // 데이터가 없는 경우 일기가 없다는 메시지 표시
                            return const Center(
                              child: Text(
                                '아직 일기를 작성하지 않았어요!',
                                 style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 22,
                                  fontFamily: 'single_day',
                                ),
                                ),
                            );
                          } else {
                            return ListView(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              children: [
                                if (snapshot.data.beforeEmotion == null ||
                                    snapshot.data.beforeEmotion == '')
                                  Icon(
                                    Icons.image_not_supported_outlined,
                                    size: iconSize,
                                  )
                                else
                                  Image.asset(
                                    'lib/assets/image/emotions/${snapshot.data.beforeEmotion}.png',
                                    width: imageSize,
                                  ),
                                Icon(
                                  Icons.arrow_right_alt_sharp,
                                  size: iconSize,
                                ),
                                if (snapshot.data.afterEmotion == null ||
                                    snapshot.data.afterEmotion == '')
                                  Icon(
                                    Icons.image_not_supported_outlined,
                                    size: iconSize,
                                  )
                                else
                                  Image.asset(
                                    'lib/assets/image/emotions/${snapshot.data.afterEmotion}.png',
                                    width: imageSize,
                                  ),
                              ],
                            );
                          }
                        },
                      ),
                    ),
                    Expanded(
                      child: Container(),
                    )
                  ],
                );
              },
            ),
          );
  }
}
