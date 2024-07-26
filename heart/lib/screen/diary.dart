import 'package:flutter/material.dart';
import 'package:heart/Model/diary_model.dart';
import 'package:heart/edit_diary.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:heart/Api/diary_apis.dart';
import 'package:heart/add_diary.dart';

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

      body: Column(
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
              defaultTextStyle: customTextStyle,
              weekendTextStyle: customTextStyle,
              selectedTextStyle: customTextStyle.copyWith(color: Colors.white),
              todayTextStyle: customTextStyle.copyWith(
                  color: const Color.fromARGB(255, 2, 2, 2)),
              selectedDecoration: const BoxDecoration(
                color: Color.fromARGB(255, 89, 181, 81),
                shape: BoxShape.circle,
              ),
              todayDecoration: const BoxDecoration(
                color: Color(0xFFFFFBA0),
                shape: BoxShape.circle,
              ),
            ),
            daysOfWeekStyle: const DaysOfWeekStyle(
              weekdayStyle: customTextStyle,
              weekendStyle: customTextStyle,
            ),
            headerStyle: HeaderStyle(
              titleTextStyle: customTextStyle.copyWith(fontSize: 25),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
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
                    child: Text('No data found'),
                  );
                } else {
                  return ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    children: [
                      Image.asset(
                        'lib/assets/image/emotions/${snapshot.data.beforeEmotion}.png',
                        width: 100,
                      ),
                      const Icon(
                        Icons.arrow_right_alt_sharp,
                        size: 100,
                      ),
                      if (snapshot.data.afterEmotion == null ||
                          snapshot.data.afterEmotion == '')
                        const Icon(
                          Icons.image_not_supported_outlined,
                          size: 100,
                        )
                      else
                        Image.asset(
                          'lib/assets/image/emotions/${snapshot.data.afterEmotion}.png',
                          width: 100,
                        ),
                    ],
                  );
                }
              },
            ),
          ),
          //공간여백을 위해 놔둠
          Expanded(
            child: Container(),
          )
        ],
      ),
      //floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
    );
  }
}
