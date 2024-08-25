import 'dart:convert';

import 'package:heart/Model/diary_model.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

//다이어리 생성
Future<bool> saveDiary(DiaryModel diary) async {
  try {
    final response = await http.post(
      Uri.parse("http://54.79.110.239:8080/api/diaries/add"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(diary.toMap()),
    );

    print('Response Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 201) {
      print("데이터가 성공적으로 전송되었습니다.");
      return true;
    } else {
      print("데이터 전송에 실패했습니다.");
      print('Response Body: ${response.body}');

      return false;
    }
  } catch (e) {
    print("Failed to send post data: $e");
    return false;
  }
}

//diaryID로 조회
Future<DiaryModel> readDiarybyDiaryId(int diaryId) async {
  final response = await http.get(
    Uri.parse("http://54.79.110.239:8080/api/diaries/$diaryId"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  print('Response Status Code: ${response.statusCode}');
  print(
      'Response Body readDiaryByDiaryId: ${utf8.decode(response.bodyBytes)}'); //인코딩 깨지는 부분 해결

  if (response.statusCode == 201) {
    return DiaryModel.fromJson(response.body);
  }
  throw Error();
}

//memberId, writeDate로 조회
Future<DiaryModel?> readDiarybyDate(String memberId, DateTime writeDate) async {
  String formatedDate = DateFormat('yyyyMMdd').format(writeDate);
  final Uri uri = Uri.parse(
      "http://54.79.110.239:8080/api/diaries/$memberId/$formatedDate");

  try {
    final http.Response response = await http.get(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      print('Response Status Code: ${response.statusCode}');
      print(
          'Response Body: ${utf8.decode(response.bodyBytes)}'); // Encoding issue resolved
      return DiaryModel.fromJson(response.body);
    }
  } catch (e) {
    print("$e");
    return null;
  }
  return null;
}

// 다이어리 수정
Future<bool> updateDiary(String contents, int diaryId) async {
  try {
    final response = await http.put(
      Uri.parse("http://54.79.110.239:8080/api/diaries/$diaryId/edit"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'content': contents,
      }),
    );

    print('Response Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      print("데이터가 성공적으로 전송되었습니다.");
      return true;
    } else {
      print("데이터 전송에 실패했습니다.");
      return false;
    }
  } catch (e) {
    print("Failed to send post data: $e");
    return false;
  }
}

//다이어리 삭제
Future<bool> deleteDiary(String diaryId) async {
  try {
    final response = await http.put(
      Uri.parse("http://54.79.110.239:8080/api/diaries/$diaryId/delete"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    print('Response Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      print("데이터가 성공적으로 전송되었습니다.");
      return true;
    } else {
      print("데이터 전송에 실패했습니다.");
      return false;
    }
  } catch (e) {
    print("Failed to send post data: $e");
    return false;
  }
}


