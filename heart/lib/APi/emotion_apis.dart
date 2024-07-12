import 'dart:convert';

import 'package:heart/Model/emotion_model.dart';
import 'package:http/http.dart' as http;

//감정통계조회
Future<MonthlyEmo> readEmotionMonthly(String memberId, String writeDate) async {
  final String month = writeDate.substring(0, 6);
  final Uri uri = Uri.parse(
      "http://54.79.110.239:8080/api/emotion/statistics/$memberId?month=$month");

  try {
    final http.Response response = await http.get(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    print('Response Status Code: ${response.statusCode}');
    print(
        'Response Body: ${utf8.decode(response.bodyBytes)}'); // Encoding issue resolved

    if (response.statusCode == 200) {
      return MonthlyEmo.fromJson(response.body);
    } else {
      throw Error();
    }
  } catch (e) {
    throw Error();
  }
}

//top3감정조회
Future<List<Top3Emo>> top3Emotions(String memberId, String writeDate) async {
  final String month = writeDate.substring(0, 6);
  List<Top3Emo> emotionList = [];
  final Uri uri = Uri.parse(
      "http://54.79.110.239:8080/api/emotion/top3/$memberId?month=$month");

  try {
    final http.Response response = await http.get(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    print('Response Status Code: ${response.statusCode}');
    print(
        'Response Body: ${utf8.decode(response.bodyBytes)}'); // Encoding issue resolved

    if (response.statusCode == 200) {
      final datas = jsonDecode(utf8.decode(response.bodyBytes));
      for (var data in datas) {
        emotionList.add(Top3Emo.fromJson(data));
      }
      return emotionList;
    } else {
      throw Error();
    }
  } catch (e) {
    throw Error();
  }
}
