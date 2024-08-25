import 'dart:convert';

class LoginModel {
  final int? id;
  final String memberId;
  final String password;
  final String nickname;
  final String gender;
  final String birthdate;

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
      'birthdate': birthdate, // Use 'birthdate' to match field name
    };
  }

  factory LoginModel.fromMap(Map<String, dynamic> map) {
    return LoginModel(
      id: map['id'] as int?,
      memberId: map['memberId'] ?? '',
      password: map['password'] ?? '',
      nickname: map['nickname'] ?? '',
      gender: map['gender'] ?? '',
      birthdate: map['birthdate'] ?? '', // Use 'birthdate' to match field name
    );
  }

  String toJson() => json.encode(toMap());

  factory LoginModel.fromJson(String source) {
    try {
      final map = json.decode(source) as Map<String, dynamic>;
      return LoginModel.fromMap(map['user']);
    } catch (e) {
      // Handle JSON decoding errors
      throw FormatException('Invalid JSON format: $e');
    }
  }
}

class LogIn {
  final String loginId;
  final String password;

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

  factory LogIn.fromJson(String source) {
    try {
      final map = json.decode(source) as Map<String, dynamic>;
      return LogIn.fromMap(map);
    } catch (e) {
      // Handle JSON decoding errors
      throw FormatException('Invalid JSON format: $e');
    }
  }
}