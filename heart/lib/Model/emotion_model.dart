//감정 데이터 model

import 'dart:convert'; // JSON 데이터의 인코딩 및 디코딩을 처리

// 월별 감정 데이터를 나타내는 모델 클래스
class MonthlyEmo {
  final String month;  // 월을 나타내는 문자열
  final double joy; // 기쁨의 정도
  final double hope; // 희망의 정도
  final double neutrality; // 중립적인 감정의 정도
  final double sadness; // 슬픔의 정도
  final double anxiety; // 불안의 정도
  final double tiredness; // 피로의 정도
  final double regret; // 후회의 정도
  final double anger; // 분노의 정도

  MonthlyEmo(this.month, this.joy, this.hope, this.neutrality, this.sadness,
      this.anxiety, this.tiredness, this.regret, this.anger);

// 객체를 맵(Map) 형태로 변환
  Map<String, dynamic> toMap() {
    return {
      'month': month,
      'joy': joy,
      'hope': hope,
      'neutrality': neutrality,
      'sadness': sadness,
      'anxiety': anxiety,
      'tiredness': tiredness,
      'regret': regret,
      'anger': anger,
    };
  }

  factory MonthlyEmo.fromMap(Map<String, dynamic> map) {
    return MonthlyEmo(
      map['MONTH'] ?? '',
      map['JOY']?.toDouble() ?? 0.0,
      map['HOPE']?.toDouble() ?? 0.0,
      map['NEUTRALITY']?.toDouble() ?? 0.0,
      map['SADNESS']?.toDouble() ?? 0.0,
      map['ANXIETY']?.toDouble() ?? 0.0,
      map['TIREDNESS']?.toDouble() ?? 0.0,
      map['REGRET']?.toDouble() ?? 0.0,
      map['ANGER']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

// JSON 문자열을 사용해 MonthlyEmo 객체를 생성
  factory MonthlyEmo.fromJson(String source) =>
      MonthlyEmo.fromMap(json.decode(source));
}

// 상위 3개의 감정을 나타내는 모델 클래스
class Top3Emo {
  final String afterEmotion; // 감정 상태
  final int count; // 감정 상태의 발생 횟수

  Top3Emo({
    required this.afterEmotion,
    required this.count,
  });

  Map<String, dynamic> toMap() {
    return {
      'afterEmotion': afterEmotion,
      'count': count,
    };
  }

// 맵(Map) 데이터를 사용해 Top3Emo 객체를 생성
  factory Top3Emo.fromMap(Map<String, dynamic> map) {
    return Top3Emo(
      afterEmotion: map['AFTER_EMOTION'] ?? '',
      count: map['COUNT']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Top3Emo.fromJson(String source) =>
      Top3Emo.fromMap(json.decode(source));
}
// 시간별 감정 데이터를 나타내는 모델 클래스
class HourlyEmo {
  final String afterEmotion; // 감정 상태
  final String timeRange; // 시간 범위
  final int count;  // 감정 상태의 발생 횟수

  HourlyEmo({
    required this.afterEmotion,
    required this.timeRange,
    required this.count,
  });

  Map<String, dynamic> toMap() {
    return {
      'afterEmotion': afterEmotion,
      'timeRange': timeRange,
      'count': count,
    };
  }

  factory HourlyEmo.fromMap(Map<String, dynamic> map) {
    return HourlyEmo(
      afterEmotion: map['AFTER_EMOTION'] ?? '',
      timeRange: map['TIME_RANGE'] ?? '',
      count: map['COUNT']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory HourlyEmo.fromJson(String source) =>
      HourlyEmo.fromMap(json.decode(source));
}
