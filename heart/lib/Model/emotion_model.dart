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
      map['month'] ?? '',
      map['joy']?.toDouble() ?? 0.0,
      map['hope']?.toDouble() ?? 0.0,
      map['neutrality']?.toDouble() ?? 0.0,
      map['sadness']?.toDouble() ?? 0.0,
      map['anxiety']?.toDouble() ?? 0.0,
      map['tiredness']?.toDouble() ?? 0.0,
      map['regret']?.toDouble() ?? 0.0,
      map['anger']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory MonthlyEmo.fromJson(String source) =>
      MonthlyEmo.fromMap(json.decode(source));
}

class Top3Emo {
  final String afterEmoType;
  final int count;

  Top3Emo({
    required this.afterEmoType,
    required this.count,
  });

  Map<String, dynamic> toMap() {
    return {
      'afterEmoType': afterEmoType,
      'count': count,
    };
  }

  factory Top3Emo.fromMap(Map<String, dynamic> map) {
    return Top3Emo(
      afterEmoType: map['afterEmoType'] ?? '',
      count: map['count']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Top3Emo.fromJson(String source) =>
      Top3Emo.fromMap(json.decode(source));
}
