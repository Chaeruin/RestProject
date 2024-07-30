import 'dart:convert';

class MonthlyEmo {
  final String month;
  final double joy;
  final double hope;
  final double neutrality;
  final double sadness;
  final double anxiety;
  final double tiredness;
  final double regret;
  final double anger;

  MonthlyEmo(this.month, this.joy, this.hope, this.neutrality, this.sadness,
      this.anxiety, this.tiredness, this.regret, this.anger);

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

  factory MonthlyEmo.fromJson(String source) =>
      MonthlyEmo.fromMap(json.decode(source));
}

class Top3Emo {
  final String afterEmotion;
  final int count;

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

class HourlyEmo {
  final String afterEmotion;
  final String timeRange;
  final int count;

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
