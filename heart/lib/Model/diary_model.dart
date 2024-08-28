//일기 데이터 model

import 'dart:convert'; // JSON 데이터의 인코딩 및 디코딩을 처리

class DiaryModel {
  final int? diaryId; //일기 고유 id
  final String memberId; //작성자 id 
  final String writeDate; //알가 작성 날짜
  final String content; //일기 내용
  final String beforeEmotion; // 일기 작성 전의 감정 상태
  final String? afterEmotion; // 일기 작성 후의 감정 상태
 
 //각 필드 초기화
  DiaryModel(
      {this.diaryId,
      required this.memberId,
      required this.writeDate,
      required this.content,
      required this.beforeEmotion,
      this.afterEmotion});

//일기 데이터를 맵 형태로 변환
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

// 맵(Map) 데이터를 사용해 DiaryModel 객체를 생성
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

// 일기 데이터를 JSON 문자열로 변환
  String toJson() => json.encode(toMap());

// JSON 문자열을 사용해 DiaryModel 객체를 생성
  factory DiaryModel.fromJson(String source) =>
      DiaryModel.fromMap(json.decode(source));
}