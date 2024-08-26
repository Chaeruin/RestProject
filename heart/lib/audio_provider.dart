//오디오 플레이어 관리

import 'package:flutter/material.dart';
import 'package:heart/Api/audio_apis.dart';
import 'package:just_audio/just_audio.dart';

class AudioProvider with ChangeNotifier {
  late AudioPlayer _audioPlayer; // AudioPlayer 인스턴스
  bool _isPlaying = false; // 현재 재생 상태를 나타내는 변수
  final String memID; // 사용자 ID
  AudioPlayer get audioPlayer =>
      _audioPlayer; // 외부에서 AudioPlayer 인스턴스에 접근할 수 있도록 하는 getter
  String? currentUrl; // 현재 재생 중인 URL

// 지정된 URL로 오디오를 설정하는 비동기 메서드
  Future<void> setUrl(String url) async {
    if (currentUrl != url) {
      currentUrl = url;
      await audioPlayer.setUrl(url); // URL로 오디오 설정
      notifyListeners(); // 상태가 변경되었음을 알림
    }
  }

  static AudioProvider? _singleton; // 싱글턴 인스턴스 변수

// 싱글턴 패턴을 사용하여 AudioProvider 인스턴스를 생성
  factory AudioProvider(String memID) {
    _singleton ??= AudioProvider._internal(memID); // 인스턴스가 없으면 새로 생성
    return _singleton!; // 기존 인스턴스 반환
  }

  // 내부 생성자
  AudioProvider._internal(this.memID) {
    _audioPlayer = AudioPlayer(); // AudioPlayer 인스턴스 초기화
    var afterEmotion = returnAfterEmotion(memID); // 감정에 따른 오디오 파일 URL 가져오기
    _init(memID, afterEmotion); // 오디오 초기화
  }

  // 오디오를 초기화하고 설정하는 비동기 메서드
  void _init(memID, afterEmotion) async {
    try {
      await audioPlayer.setUrl(
          'https://chatbotmg.s3.ap-northeast-2.amazonaws.com/${memID}_$afterEmotion.wav');
      await audioPlayer.setLoopMode(LoopMode.all); // 오디오 루프 모드 설정
    } catch (e) {
      print("Error: $e");
    }
  }

// 감정 값 변경에 따라 오디오 URL을 업데이트하는 비동기 메서드
  void change(memID, afterEmotion) async {
    try {
      await audioPlayer.setUrl(
          'https://chatbotmg.s3.ap-northeast-2.amazonaws.com/${memID}_$afterEmotion.wav');
      await audioPlayer.setLoopMode(LoopMode.all); // 오디오 루프 모드 설정
    } catch (e) {
      print("Error: $e");
    }
  }

// 오디오를 재생하는 비동기 메서드
  void play() async {
    if (!_isPlaying) {
      // 현재 재생 중이지 않으면
      await audioPlayer.play(); // 오디오 재생
      _isPlaying = true; // 재생 상태 업데이트
      notifyListeners(); // 상태 변경 알림
    }
  }

// 오디오를 일시 정지하는 비동기 메서드
  void pause() async {
    if (_isPlaying) {
      // 현재 재생 중이면
      await audioPlayer.pause(); // 오디오 일시 정지
      _isPlaying = false; // 재생 상태 업데이트
      notifyListeners(); // 상태 변경 알림
    }
  }

// 현재 재생 상태를 반환하는 getter
  bool get isPlaying => _isPlaying;
}
