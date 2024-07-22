import 'dart:convert';

class DiaryModel {
  final String? diaryID;
  final String memID;
  final String writeD;
  final String contents;
  final String emotionType;

  DiaryModel(
      {this.diaryID,
      required this.memID,
      required this.writeD,
      required this.contents,
      required this.emotionType});

  Map<String, dynamic> toMap() {
    return {
      'diaryID': diaryID,
      'memID': memID,
      'writeD': writeD,
      'contents': contents,
      'emotionType': emotionType,
    };
  }

  factory DiaryModel.fromMap(Map<String, dynamic> map) {
    return DiaryModel(
      diaryID: map['diaryID'],
      memID: map['memID'] ?? '',
      writeD: map['writeD'] ?? '',
      contents: map['contents'] ?? '',
      emotionType: map['emotionType'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory DiaryModel.fromJson(String source) =>
      DiaryModel.fromMap(json.decode(source));
}
