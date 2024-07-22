import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:heart/Api/diary_apis.dart';
import 'package:heart/Model/event_model.dart';
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

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  Future<List<Event>> _getEventsForDay(DateTime day) async {
    String date = DateFormat('yyyyMM').format(day);
    return fetchEventsForDay(widget.memID, date);
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
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddDiaries(
                    selectedDate: _selectedDay.toString(),
                    memberId: 'text',
                  ),
                ),
              ),
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
            child: FutureBuilder<List<Event>>(
              future: _getEventsForDay(_selectedDay!),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else if (!snapshot.hasData || snapshot.data.isEmpty) {
                  return const Center(
                    child: Text('No data found'),
                  );
                } else {
                  final events = snapshot.data!;
                  if (events.length < 2) {
                    return const Center(
                      child: Text('Not enough data to display emotion changes'),
                    );
                  }
                  return Row(
                    children: [
                      Container(
                        color: Colors.amber,
                        child: Text('${events[0]}'),
                      ),
                      const Icon(Icons.arrow_right_alt_sharp),
                      Container(
                        color: Colors.lightBlue,
                        child: Text('${events[1]}'),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ],
      ),
      //floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
    );
  }
}
