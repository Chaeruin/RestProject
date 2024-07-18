import 'dart:convert';

class ProfileModel {
  final String? MemberId;
  final String? Password;
  final String? Alias;
  final String? BirthDate;
  final String? Gender;

  ProfileModel({
    this.MemberId,
    this.Password,
    this.Alias,
    this.BirthDate,
    this.Gender,
  });

  Map<String, dynamic> toMap() {
    return {
      'MemberId': MemberId,
      'Password': Password,
      'Alias': Alias,
      'BirthDate': BirthDate,
      'Gender': Gender,
    };
  }

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      MemberId: map['MemberId'],
      Password: map['Password'],
      Alias: map['Alias'],
      BirthDate: map['BirthDate'],
      Gender: map['Gender'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ProfileModel.fromJson(String source) =>
      ProfileModel.fromMap(json.decode(source));
}