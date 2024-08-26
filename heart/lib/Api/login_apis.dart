import 'dart:convert';
import 'package:heart/Model/login_model.dart';
import 'package:http/http.dart' as http;

//이메일 중복 검사
Future<String> checkEmailDuplicate(String email) async {
  final response = await http.get(
    Uri.parse('http://54.79.110.239:8080/api/members/checkId?memberId=$email'),
  );

  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception('중복 체크 실패!!');
  }
}

//회원가입 정보 전송
Future<bool> saveUser(LoginModel member) async {
  try {
    final response = await http.post(
      Uri.parse("http://54.79.110.239:8080/api/members/add"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(member.toMap()),
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

//로그인
Future<String?> loginUser(String id, String password) async {
  try {
    final loginData = LogIn(loginId: id, password: password);
    final response = await http.post(
      Uri.parse("http://54.79.110.239:8080/api/login"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: loginData.toJson(),
    );

    
    final responseBody = utf8.decode(response.bodyBytes);

    print('Response Status Code: ${response.statusCode}');
    print('Response Body: $responseBody');

    if (response.statusCode == 200) {
      
      print('로그인 성공!');
      return LoginModel.fromJson(responseBody).nickname;
    } else {
      print("로그인 실패: ${response.statusCode}");
      return null;
    }
  } catch (e) {
    print("로그인 요청 실패: $e");
    return null;
  }
}

//회원정보 수정
Future<bool> updateUser(LoginModel member, String memberId) async {
  String userId = memberId;
  try {
    final response = await http.put(
      Uri.parse("http://54.79.110.239:8080/api/members/$userId/edit"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(member.toJson()),
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
