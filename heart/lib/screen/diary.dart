import 'package:flutter/material.dart';
import 'package:heart/Api/diary_apis.dart';
import 'package:heart/Model/event_model.dart';
import 'package:heart/add_diary.dart';
import 'package:table_calendar/table_calendar.dart';

//빈칸에 감정변화 전 -> 후 보이게 << 이건 api열리고 나서
class Diary extends StatefulWidget {
  const Diary({super.key});

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
    return fetchEventsForDay(day);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diary Demo'),
      ),
      body: Column(
        children: [
          TableCalendar(
            focusedDay: _focusedDay,
            firstDay: kFirstDay,
            lastDay: kLastDay,
            calendarFormat: _calendarFormat,
            eventLoader: (day) => [], // Dummy loader,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              if (!isSameDay(_selectedDay, selectedDay)) {
                // Call `setState()` when updating the selected day
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              }
            },
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                // Call `setState()` when updating calendar format
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              // No need to call `setState()` here
              _focusedDay = focusedDay;
            },
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: FutureBuilder<List<Event>>(
              future: _getEventsForDay(_selectedDay!),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isempty) {
                  return Center(
                    child: Text('No data found'),
                  );
                } else {
                  final events = snapshot.data!;
                  return Row(
                    children: [
                      Container(
                        color: Colors.amber,
                        child: Text('${events[0]}'),
                      ),
                      Icon(Icons.arrow_right_alt_sharp),
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
      floatingActionButton: ElevatedButton.icon(
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddDiaries(
                selectedDate: _selectedDay.toString(),
                memberId: 'text', //후에 수정
              ),
            )),
        label: Icon(
          Icons.add,
          size: 50,
        ),
      ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
    );
  }
}
