import 'package:flutter/material.dart';
import 'package:heart/Model/diary_model.dart';
import 'package:heart/screen/diary/edit_diary.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:heart/Api/diary_apis.dart';
import 'package:heart/screen/diary/add_diary.dart';

class Diary extends StatefulWidget {
  final String memID;
  const Diary({
    super.key,
    required this.memID,
  });

  @override
  State<Diary> createState() => _DiaryState();
}

class _DiaryState extends State<Diary> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  late String memId;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    memId = widget.memID;
  }

  @override
  Widget build(BuildContext context) {
    const TextStyle customTextStyle = TextStyle(
      fontFamily: 'single_day',
      fontSize: 16,
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFBA0),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 30.0),
            child: InkWell(
              onTap: () async {
                DiaryModel? newPage =
                    await readDiarybyDate(memId, _selectedDay!);
                if (newPage != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditDiaries(diary: newPage),
                    ),
                  );
                } else {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddDiaries(
                        memberId: memId,
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
          final double imageSize = isLargeScreen ? 120 : 90;
          final double spacing = isLargeScreen ? 60 : 50;

          return Column(
            children: [
              TableCalendar(
                focusedDay: _focusedDay,
                firstDay: DateTime.utc(2020, 10, 16),
                lastDay: DateTime.utc(2030, 3, 14),
                calendarFormat: _calendarFormat,
                eventLoader: (day) => [],
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  if (!isSameDay(_selectedDay, selectedDay)) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  }
                },
                onFormatChanged: (format) {
                  if (_calendarFormat != format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  }
                },
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                },
                calendarStyle: CalendarStyle(
                  defaultTextStyle:
                      customTextStyle.copyWith(fontSize: calendarFontSize),
                  weekendTextStyle:
                      customTextStyle.copyWith(fontSize: calendarFontSize),
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
                  weekdayStyle:
                      customTextStyle.copyWith(fontSize: calendarFontSize),
                  weekendStyle:
                      customTextStyle.copyWith(fontSize: calendarFontSize),
                ),
                headerStyle: HeaderStyle(
                  titleTextStyle:
                      customTextStyle.copyWith(fontSize: headerFontSize),
                ),
              ),
              SizedBox(height: spacing),
              Expanded(
                child: FutureBuilder<DiaryModel?>(
                  future: readDiarybyDate(memId, _selectedDay!),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator.adaptive(),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    } else if (!snapshot.hasData) {
                      return const Center(
                        child: Text(
                          '아직 일기를 작성하지 않았어요!',
                           style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'single_day',
                        ),),
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
