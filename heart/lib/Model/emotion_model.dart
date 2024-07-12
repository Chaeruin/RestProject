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

  MonthlyEmo copyWith({
    String? month,
    String? joy,
    String? hope,
    String? neutrality,
    String? sadness,
    String? anxiety,
    String? tiredness,
    String? regret,
    String? anger,
  }) {
    return MonthlyEmo(
      month: month ?? this.month,
      joy: joy ?? this.joy,
      hope: hope ?? this.hope,
      neutrality: neutrality ?? this.neutrality,
      sadness: sadness ?? this.sadness,
      anxiety: anxiety ?? this.anxiety,
      tiredness: tiredness ?? this.tiredness,
      regret: regret ?? this.regret,
      anger: anger ?? this.anger,
    );
  }

  @override
  String toString() {
    return 'MonthlyEmo(month: $month, joy: $joy, hope: $hope, neutrality: $neutrality, sadness: $sadness, anxiety: $anxiety, tiredness: $tiredness, regret: $regret, anger: $anger)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MonthlyEmo &&
        other.month == month &&
        other.joy == joy &&
        other.hope == hope &&
        other.neutrality == neutrality &&
        other.sadness == sadness &&
        other.anxiety == anxiety &&
        other.tiredness == tiredness &&
        other.regret == regret &&
        other.anger == anger;
  }

  @override
  int get hashCode {
    return month.hashCode ^
        joy.hashCode ^
        hope.hashCode ^
        neutrality.hashCode ^
        sadness.hashCode ^
        anxiety.hashCode ^
        tiredness.hashCode ^
        regret.hashCode ^
        anger.hashCode;
  }
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
