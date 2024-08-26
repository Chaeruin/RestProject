import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;
  String _ID = '';
  String _NickName = '';

  bool get isLoggedIn => _isLoggedIn;
  String get ID => _ID;
  String get NickName => _NickName;

  // SharedPreferences에서 로그인 상태를 로드하는 함수
  Future<void> loadLoginInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    _ID = prefs.getString('ID') ?? '';
    _NickName = prefs.getString('nick') ?? '';
    notifyListeners();
  }

  // 로그인 함수
  Future<void> login(String ID, String nick) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isLoggedIn = true;
    _ID = ID;
    _NickName = nick;
    await prefs.setBool('isLoggedIn', _isLoggedIn);
    await prefs.setString('ID', _ID);
    await prefs.setString('nick', _NickName);
    notifyListeners();
  }

  // 로그아웃 함수
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isLoggedIn = false;
    _ID = '';
    _NickName = '';
    await prefs.remove('isLoggedIn');
    await prefs.remove('ID');
    await prefs.remove('nick');
    notifyListeners();
  }
}
