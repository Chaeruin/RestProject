//로그인 데이터를 다루는 model
import 'dart:convert'; // JSON 데이터의 인코딩 및 디코딩을 처리

class LoginModel {
  final int? id; //로그인시 발급되는 로그인 아이디
  final String memberId; //회원 아이디
  final String password; //비밀번호
  final String nickname; //닉네임
  final String gender; //성별
  final String birthdate; //생년월일

  LoginModel({
    this.id,
    required this.memberId,
    required this.password,
    required this.nickname,
    required this.gender,
    required this.birthdate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'memberId': memberId,
      'password': password,
      'nickname': nickname,
      'gender': gender,
      'birthdate': birthdate   
       };
  }

// 맵(Map) 데이터를 사용해 LoginModel 객체를 생성
  factory LoginModel.fromMap(Map<String, dynamic> map) {
    return LoginModel(
      id: map['id'] as int?,
      memberId: map['memberId'] ?? '',
      password: map['password'] ?? '',
      nickname: map['nickname'] ?? '',
      gender: map['gender'] ?? '',
      birthdate: map['birthdate'] ?? '', 
    );
  }

  String toJson() => json.encode(toMap());

  factory LoginModel.fromJson(String source) {
    try {
      final map = json.decode(source) as Map<String, dynamic>;
      return LoginModel.fromMap(map['user']);
    } catch (e) {
      
      throw FormatException('Invalid JSON format: $e');
    }
  }
}

// 로그인 요청 데이터를 포함하는 모델 클래스
class LogIn {
  final String loginId;
  final String password;

// 생성자: 모든 필드를 초기화
  LogIn({
    required this.loginId,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'loginId': loginId,
      'password': password,
    };
  }

  factory LogIn.fromMap(Map<String, dynamic> map) {
    return LogIn(
      loginId: map['loginId'] ?? '',
      password: map['password'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());
  
// JSON 문자열을 사용해 LogIn 객체를 생성하는 팩토리 메서드
  factory LogIn.fromJson(String source) {
    try {
      final map = json.decode(source) as Map<String, dynamic>;
      return LogIn.fromMap(map); // JSON에서 직접 객체를 생성
    } catch (e) {
      // JSON 형식이 잘못된 경우 예외를 발생
      
      throw FormatException('Invalid JSON format: $e');
    }
  }
}