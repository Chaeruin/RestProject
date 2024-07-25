import 'dart:convert';

class DiaryModel {
  final int? diaryID;
  final String memID;
  final String writeD;
  final String contents;
  final String emotionBefore;
  final String? emotionAfter;

  DiaryModel(
      {this.diaryID,
      required this.memID,
      required this.writeD,
      required this.contents,
      required this.emotionBefore,
      this.emotionAfter});

  Map<String, dynamic> toMap() {
    return {
      'diaryID': diaryID,
      'memID': memID,
      'writeD': writeD,
      'contents': contents,
      'emotionBefore': emotionBefore,
      'emotionAfter': emotionAfter
    };
  }

  factory DiaryModel.fromMap(Map<String, dynamic> map) {
    return DiaryModel(
      diaryID: map['diaryId'],
      memID: map['memId'] ?? '',
      writeD: map['writeDate'] ?? '',
      contents: map['content'] ?? '',
      emotionBefore: map['beforeEmotion'] ?? '',
      emotionAfter: map['afterEmotion'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory DiaryModel.fromJson(String source) =>
      DiaryModel.fromMap(json.decode(source));
}
