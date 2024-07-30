import 'dart:convert';
import 'package:http/http.dart' as http;

//메인 페이지 행동 추천
Future<String> fetchActionRecommendation() async {
  final response = await http.get(
    Uri.parse('http://54.79.110.239:8080/api/actions/recommendation'),
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

//행동 추천 페이지에서 3개 행동 추천
Future<List<String>> Recommendations(String memberId, String emotion) async {
  final now = DateTime.now();
  final recommendationDate =
      '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
  final url =
      'http://54.79.110.239:8080/api/daily-recommendations/$memberId/$emotion/$recommendationDate';

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
