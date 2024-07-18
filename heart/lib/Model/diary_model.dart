import 'dart:convert';

class DiaryModel {
  final int? DiaryID;
  final String? MemID;
  final String? WriteD;
  final String? Contents;
  final String? PreEmotion;
  final String? PostEmotion;

  DiaryModel({
    this.DiaryID,
    this.MemID,
    this.WriteD,
    this.Contents,
    this.PreEmotion,
    this.PostEmotion,
  });

  Map<String, dynamic> toMap() {
    return {
      'DiaryID': DiaryID,
      'MemID': MemID,
      'WriteD': WriteD,
      'Contents': Contents,
      'PreEmotion': PreEmotion,
      'PostEmotion': PostEmotion,
    };
  }

  factory DiaryModel.fromMap(Map<String, dynamic> map) {
    return DiaryModel(
      DiaryID: map['DiaryID']?.toInt(),
      MemID: map['MemID'],
      WriteD: map['WriteD'],
      Contents: map['Contents'],
      PreEmotion: map['PreEmotion'],
      PostEmotion: map['PostEmotion'],
    );
  }

  String toJson() => json.encode(toMap());

  factory DiaryModel.fromJson(String source) =>
      DiaryModel.fromMap(json.decode(source));
}