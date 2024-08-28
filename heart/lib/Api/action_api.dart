//행동 api
import 'dart:convert'; // JSON 데이터의 인코딩 및 디코딩을 처리
import 'package:http/http.dart' as http; // HTTP 요청을 보내고 응답을 받기 위한 외부 패키지

//메인 페이지 행동 추천
Future<String> fetchActionRecommendation() async {
  final response = await http.get(Uri.parse('http://54.79.110.239:8080/api/actions/recommendation'),
  headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(utf8.decode(response.bodyBytes));
    print('Response Body: ${utf8.decode(response.bodyBytes)}'); 
    return data['action'];
  } else {
    throw Exception('Failed to load action recommendation');
  }
}

//멤버가 좋아하는 행동 2개 조회
Future<List<String>> feelBetterActions(String memberId) async {
  final url =
      'http://54.79.110.239:8080/api/member-actions/$memberId/feel-better';

  try {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      return data.map((item) => item['action'] as String).toList();
    } else {
      throw Exception('Failed to load recommendations');
    }
  } catch (e) {
    return ['추천 데이터를 불러오는데 실패했습니다.'];
  }
}

//행동 추천 페이지에서 3개 행동 추천
Future<List<Map<String, dynamic>>> Recommendations(String memberId, String emotion) async {
  final now = DateTime.now();
  final recommendationDate =
      '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
  final url =
      'http://54.79.110.239:8080/api/daily-recommendations/$memberId/$emotion/$recommendationDate';

  try {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      print('Response Body: ${utf8.decode(response.bodyBytes)}');
      return data.map((item) => {
        'action': item['action'],
        'actionId': item['actionId'],
        'memberActionId': item['memberActionId'],
        'status':item['status']
      }).toList();
    } else {
      throw Exception('Failed to load recommendations');
    }
  } catch (e) {
    return [{'action': '추천 데이터를 불러오는데 실패했습니다.', 'actionId': null}];
  }
}

//행동 진행중
Future<Map<String, dynamic>> startAction(int actionId, String memberId, String beforeEmotion) async {
  final now = DateTime.now();
  final recommendationDate =
      '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
  final url = Uri.parse('http://54.79.110.239:8080/api/member-actions/add');
  final headers = {
    'Content-Type': 'application/json; charset=utf-8',
    'Accept-Charset': 'utf-8',
  };
  final body = jsonEncode({
    'actionId': actionId,
    'memberId': memberId,
    'beforeEmotion': beforeEmotion,
    'recommendationDate': recommendationDate
  });

  final response = await http.post(url, headers: headers, body: body);

  if (response.statusCode == 200) {
    final decodedBody = utf8.decode(response.bodyBytes, allowMalformed: true);
    print('Decoded Response Body: $decodedBody');
    return jsonDecode(decodedBody);
  } else {
    return {
      'error': true,
      'statusCode': response.body,
      'body': utf8.decode(response.bodyBytes, allowMalformed: true),
    };
  }
}

//행동 완료
Future<Map<String, dynamic>> completeAction(int memberActionId, String afterEmotion) async {
  final response = await http.put(
    Uri.parse('http://54.79.110.239:8080/api/member-actions/$memberActionId/complete'),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Accept-Charset': 'utf-8'
    },
    body: jsonEncode({'afterEmotion': afterEmotion}),
  );

  if (response.statusCode == 201) {
    final decodedBody = utf8.decode(response.bodyBytes, allowMalformed: true);
    print('Decoded Response Body: $decodedBody');
    
   
    return jsonDecode(decodedBody) as Map<String, dynamic>;
  } else {
    throw Exception('Failed to complete action: ${response.statusCode}');
  }
}
