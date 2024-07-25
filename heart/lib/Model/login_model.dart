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
      'birthDate': birthdate,
    };
  }

  factory LoginModel.fromMap(Map<String, dynamic> map) {
    return LoginModel(
      memberId: map['memberId'] ?? '',
      password: map['password'] ?? '',
      nickname: map['nickname'] ?? '',
      gender: map['gender'] ?? '',
      birthdate: map['birthdate'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory LoginModel.fromJson(String source) =>
      LoginModel.fromMap(json.decode(source));
}

class LogIn {
  final String loginId;
  final String password;

  LogIn({required this.loginId, required this.password});

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

  factory LogIn.fromJson(String source) => LogIn.fromMap(json.decode(source));
}
