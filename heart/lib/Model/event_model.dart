//이벤트 관련 model
import 'dart:convert'; // JSON 데이터의 인코딩 및 디코딩을 처리

// 현재 날짜와 시간
final kToday = DateTime.now();
// 현재 날짜 기준으로 3개월 전 날짜
final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
// 현재 날짜 기준으로 3개월 후 날짜
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