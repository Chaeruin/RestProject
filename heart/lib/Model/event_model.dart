import 'dart:convert';

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);

class Event {
  final String title;

  const Event(this.title);

  @override
  String toString() => title;

  Map<String, dynamic> toMap() {
    return {
      'title': title,
    };
  }

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      map['title'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Event.fromJson(String source) => Event.fromMap(json.decode(source));
}