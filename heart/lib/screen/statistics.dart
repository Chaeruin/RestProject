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
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool isLargeScreen = constraints.maxWidth > 600;
          final double titleFontSize = isLargeScreen ? 30 : 20;
          final double sectionSpacing = isLargeScreen ? 30 : 20;

          return Column(
            children: [
              SizedBox(height: sectionSpacing),
              Text(
                '월간 감정 통계',
                style: TextStyle(
                  color: const Color.fromARGB(255, 65, 133, 59),
                  fontSize: titleFontSize,
                  fontFamily: 'single_day',
                ),
              ),
              SizedBox(height: sectionSpacing / 2),
              Expanded(child: TotalEmotion(memberId: memberID)),
              SizedBox(height: sectionSpacing),
              Expanded(child: Top3Emotion(memberId: memberID)),
              SizedBox(height: sectionSpacing),
            ],
          );
        },
      ),
    );
  }
}
