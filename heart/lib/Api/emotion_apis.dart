//감정 api

import 'dart:convert'; // JSON 데이터의 인코딩 및 디코딩을 처리
import 'package:heart/Model/emotion_model.dart'; //감정 model 불러오기
import 'package:http/http.dart' as http; // HTTP 요청을 보내고 응답을 받기 위한 외부 패키지

//감정통계조회
Future<MonthlyEmo> readEmotionMonthly(String memberId, String writeDate) async {
  final String month = writeDate;
  final Uri uri = Uri.parse(
      "http://54.79.110.239:8080/api/emotion/statistics/$memberId?month=$month");

  try {
    final http.Response response = await http.get(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    print('Response Status Code Monthly: ${response.statusCode}');
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
  final String month = writeDate;
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

    print('Response Status Code Top3: ${response.statusCode}');
    print(
        'Response Body: ${utf8.decode(response.bodyBytes)}'); // Encoding issue resolved

    if (response.statusCode == 200) {
      final datas = jsonDecode(utf8.decode(response.bodyBytes));
      for (var data in datas) {
        print('this data: $data');
        emotionList.add(Top3Emo.fromMap(data));
      }
      return emotionList;
    } else {
      throw Error();
    }
  } catch (e) {
    throw Error();
  }
}

//시간대별 감정조회
Future<List<HourlyEmo>> hourlyEmotions(String memberId) async {
  List<HourlyEmo> emotionList = [];
  final Uri uri =
      Uri.parse("http://54.79.110.239:8080/api/emotion/hourly/$memberId");

  try {
    final http.Response response = await http.get(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    print('Response Status Code Top3: ${response.statusCode}');
    print(
        'Response Body: ${utf8.decode(response.bodyBytes)}'); // Encoding issue resolved

    if (response.statusCode == 200) {
      final datas = jsonDecode(utf8.decode(response.bodyBytes));
      for (var data in datas) {
        print('this data: $data');
        emotionList.add(HourlyEmo.fromMap(data));
      }
      return emotionList;
    } else {
      throw Error();
    }
  } catch (e) {
    throw Error();
  }
}
