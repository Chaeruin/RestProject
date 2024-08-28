//오디오 api

import 'package:http/http.dart' as http; // HTTP 요청을 보내고 응답을 받기 위한 외부 패키지
import 'dart:convert'; // JSON 데이터의 인코딩 및 디코딩을 처리

// 감정 데이터를 플라스크 서버로 전송
Future<void> sendEmotionData(String memberID, String afterEmotion) async {
  final url = Uri.parse(
      'http://3.35.183.52:8081/music/recommendation'); // 플라스크 서버의 URL
  final headers = {
    "Content-Type": "application/json; charset=UTF-8",
  };
  final body = jsonEncode({"memberId": memberID, "afterEmotion": afterEmotion});

  try {
    final response = await http.post(url, headers: headers, body: body);

    print('Response Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      print('오디오 데이터가 성공적으로 전송되었습니다.');
    } else {
      print('데이터 전송에 실패했습니다.');
    }
  } catch (e) {
    print('Error: $e');
  }
}

// 최근 일기에서 감정 정보를 반환하는 함수
Future<String?> returnAfterEmotion(String memberID) async {
  final Uri uri =
      Uri.parse("http://54.79.110.239:8080/api/diaries/$memberID/latest-diary");

  try {
    final http.Response response = await http.get(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    print('Response Status Code: ${response.statusCode}');
    print('Response Body: ${utf8.decode(response.bodyBytes)}'); 

    if (response.statusCode == 200) {
      print('데이터가 성공적으로 전송되었습니다.');
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      return data['afterEmotion'];
    } else {
      print('데이터 전송에 실패했습니다. 상태 코드: ${response.statusCode}');
    }
  } catch (e) {
    print('에러 발생: $e');
    rethrow;
  }
  return null;
}
