import 'dart:convert';

class DiaryModel {
  final int? diaryId;
  final String memberId;
  final String writeDate;
  final String content;
  final String beforeEmotion;
  final String? afterEmotion;

  DiaryModel(
      {this.diaryId,
      required this.memberId,
      required this.writeDate,
      required this.content,
      required this.beforeEmotion,
      this.afterEmotion});

  Map<String, dynamic> toMap() {
    return {
      'diaryId': diaryId,
      'memberId': memberId,
      'writeDate': writeDate,
      'content': content,
      'beforeEmotion': beforeEmotion,
      'afterEmotion': afterEmotion,
    };
  }

  factory DiaryModel.fromMap(Map<String, dynamic> map) {
    return DiaryModel(
      diaryId: map['diaryId']?.toInt() ?? 0,
      memberId: map['memberId'] ?? '',
      writeDate: map['writeDate'] ?? '',
      content: map['content'] ?? '',
      beforeEmotion: map['beforeEmotion'] ?? '',
      afterEmotion: map['afterEmotion'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory DiaryModel.fromJson(String source) =>
      DiaryModel.fromMap(json.decode(source));
}