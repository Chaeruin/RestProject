import 'package:flutter/material.dart';

class Recommendation extends StatelessWidget {
  const Recommendation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFBA0),
        title: const Text(
          '행동 추천',
          style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontFamily: 'single_day',
                  ),
          ),
          centerTitle: true,
      ),
      body: const Center(
        child: Text('MyPage'),
      ),
    );
  }
}
