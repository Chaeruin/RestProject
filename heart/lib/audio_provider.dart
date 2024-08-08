import 'package:flutter/material.dart';
import 'package:heart/Api/audio_apis.dart';
import 'package:just_audio/just_audio.dart';

class AudioProvider with ChangeNotifier {
  // ignore: prefer_final_fields
  late AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  final String memID;

  AudioProvider(this.memID) {
    var afterEmotion = returnAfterEmotion(memID);
    _init(memID, afterEmotion);
  }

  void _init(memID, afterEmotion) async {
    try {
      await _audioPlayer.setUrl(
          'https://chatbotmg.s3.ap-northeast-2.amazonaws.com/${memID}_${afterEmotion}.wav');
      _audioPlayer.setLoopMode(LoopMode.all);
      _audioPlayer.play();
    } catch (e) {
      print("Error: $e");
    }
  }

  void change(memID, afterEmotion) async {
    try {
      await _audioPlayer.setUrl(
          'https://chatbotmg.s3.ap-northeast-2.amazonaws.com/${memID}_${afterEmotion}.wav');
      _audioPlayer.setLoopMode(LoopMode.all);
      _audioPlayer.play();
    } catch (e) {
      print("Error: $e");
    }
  }

  void play() async {
    if (!_isPlaying) {
      await _audioPlayer.play();
      _isPlaying = true;
      notifyListeners();
    }
  }

  void pause() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
      _isPlaying = false;
      notifyListeners();
    }
  }

  bool get isPlaying => _isPlaying;
}
