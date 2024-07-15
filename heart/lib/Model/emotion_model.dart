import 'dart:convert';

class MonthlyEmo {
  final String month;
  final String joy;
  final String hope;
  final String neutrality;
  final String sadness;
  final String anxiety;
  final String tiredness;
  final String regret;
  final String anger;
  MonthlyEmo({
    required this.month,
    required this.joy,
    required this.hope,
    required this.neutrality,
    required this.sadness,
    required this.anxiety,
    required this.tiredness,
    required this.regret,
    required this.anger,
  });

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
      month: map['month'] ?? '',
      joy: map['joy'] ?? '',
      hope: map['hope'] ?? '',
      neutrality: map['neutrality'] ?? '',
      sadness: map['sadness'] ?? '',
      anxiety: map['anxiety'] ?? '',
      tiredness: map['tiredness'] ?? '',
      regret: map['regret'] ?? '',
      anger: map['anger'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory MonthlyEmo.fromJson(String source) =>
      MonthlyEmo.fromMap(json.decode(source));
}

class Top3Emo {
  final String emoType;
  final int count;

  Top3Emo({
    required this.emoType,
    required this.count,
  });

  Map<String, dynamic> toMap() {
    return {
      'emoType': emoType,
      'count': count,
    };
  }

  factory Top3Emo.fromMap(Map<String, dynamic> map) {
    return Top3Emo(
      emoType: map['emoType'] ?? '',
      count: map['count']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Top3Emo.fromJson(String source) =>
      Top3Emo.fromMap(json.decode(source));
}
