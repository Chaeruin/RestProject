import 'package:flutter/material.dart';
import 'package:heart/top3emo.dart';
import 'package:heart/totalemo.dart';

class DottedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color.fromARGB(255, 89, 181, 81)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    const double dashWidth = 5.0;
    const double dashSpace = 5.0;
    double startX = 0.0;

    while (startX < size.width) {
      canvas.drawLine(
          Offset(startX, 0.0), Offset(startX + dashWidth, 0.0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class Statistics extends StatefulWidget {
  final String memId;
  const Statistics({super.key, required this.memId});

  @override
  State<Statistics> createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  late final String memberID;

  @override
  void initState() {
    super.initState();
    memberID = widget.memId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFBA0),
        title: const Text(
          '마음 통계',
          style: TextStyle(
            color: Colors.black,
            fontSize: 25,
            fontFamily: 'single_day',
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          const Text(
            '월간 감정 통계', // 원하는 텍스트로 변경
            style: TextStyle(
              color: Color.fromARGB(255, 65, 133, 59),
              fontSize: 25,
              fontFamily: 'single_day',
            ), // 적절한 크기로 텍스트 스타일 설정
          ),
          const SizedBox(height: 5), // 텍스트와 리프레셔 사이의 간격
          Expanded(child: TotalEmotion(memberId: memberID)),
          const SizedBox(height: 20),
          Expanded(child: Top3Emotion(memberId: memberID)),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
