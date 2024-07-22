import 'package:flutter/material.dart';
import 'package:heart/Api/emotion_apis.dart';
import 'package:heart/Model/emotion_model.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

class TotalEmotion extends StatefulWidget {
  final String memberId;
  const TotalEmotion({super.key, required this.memberId});

  @override
  State<TotalEmotion> createState() => _TotalEmotionState();
}

class _TotalEmotionState extends State<TotalEmotion> {
  late Future<MonthlyEmo> sentiment;
  String writeDate = DateFormat('yyyyMM').format(DateTime.now());
  int touchedIndex = 0;

  @override
  void initState() {
    super.initState();
    sentiment = readEmotionMonthly(widget.memberId, writeDate);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: sentiment,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return AspectRatio(
            aspectRatio: 1.3,
            child: AspectRatio(
              aspectRatio: 1,
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          touchedIndex = -1;
                          return;
                        }
                        touchedIndex = pieTouchResponse
                            .touchedSection!.touchedSectionIndex;
                      });
                    },
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  sectionsSpace: 0,
                  centerSpaceRadius: 0,
                  sections: showingSections(snapshot),
                ),
              ),
            ),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  List<PieChartSectionData> showingSections(
      AsyncSnapshot<MonthlyEmo> snapshot) {
    var sentiments = snapshot.data!;

    // 여기 sentiment 받아서 처리하기
    final sectionsData = [
      PieChartSectionData(
        color: Colors.red,
        value: sentiments.joy * 100,
        title: 'JOY',
        badgeWidget: const _Badge(
          assetRoute: 'lib/Assets/Images/joy.png',
          size: 40,
          borderColor: Colors.black,
        ),
      ),
      PieChartSectionData(
        color: Colors.orange,
        value: sentiments.hope * 100,
        title: 'HOPE',
        badgeWidget: const _Badge(
          assetRoute: 'lib/Assets/Images/hope.png',
          size: 40,
          borderColor: Colors.black,
        ),
      ),
      PieChartSectionData(
        color: Colors.yellow,
        value: sentiments.neutrality * 100,
        title: 'NEUTRALITY',
        badgeWidget: const _Badge(
          assetRoute: 'lib/Assets/Images/neutrality.png',
          size: 40,
          borderColor: Colors.black,
        ),
      ),
      PieChartSectionData(
        color: Colors.green,
        value: sentiments.sadness * 100,
        title: 'SADNESS',
        badgeWidget: const _Badge(
          assetRoute: 'lib/Assets/Images/sadness.png',
          size: 40,
          borderColor: Colors.black,
        ),
      ),
      PieChartSectionData(
        color: Colors.blue,
        value: sentiments.anger * 100,
        title: 'ANGER',
        badgeWidget: const _Badge(
          assetRoute: 'lib/Assets/Images/anger.png',
          size: 40,
          borderColor: Colors.black,
        ),
      ),
      PieChartSectionData(
        color: Colors.indigo,
        value: sentiments.anxiety * 100,
        title: 'ANXIETY',
        badgeWidget: const _Badge(
          assetRoute: 'lib/Assets/Images/anxiety.png',
          size: 40,
          borderColor: Colors.black,
        ),
      ),
      PieChartSectionData(
        color: Colors.purple,
        value: sentiments.tiredness * 100,
        title: 'TIREDNESS',
        badgeWidget: const _Badge(
          assetRoute: 'lib/Assets/Images/tiredness.png',
          size: 40,
          borderColor: Colors.black,
        ),
      ),
      PieChartSectionData(
        color: Colors.brown,
        value: sentiments.regret * 100,
        title: 'REGRET',
        badgeWidget: const _Badge(
          assetRoute: 'lib/Assets/Images/regret.png',
          size: 40,
          borderColor: Colors.black,
        ),
      ),
    ];
    return sectionsData
        .where((section) => section.value > 0)
        .toList()
        .asMap()
        .entries
        .map((entry) {
      final i = entry.key;
      final section = entry.value;
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 20.0 : 16.0;
      final radius = isTouched ? 110.0 : 100.0;
      final widgetSize = isTouched ? 55.0 : 40.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

      return PieChartSectionData(
        color: section.color,
        value: section.value,
        title: section.title,
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: const Color(0xffffffff),
          shadows: shadows,
          fontFamily: 'single_day',
        ),
        badgeWidget: _Badge(
          assetRoute: (section.badgeWidget as _Badge).assetRoute,
          size: widgetSize,
          borderColor: Colors.black,
        ),
        badgePositionPercentageOffset: .98,
      );
    }).toList();
  }
}

class _Badge extends StatelessWidget {
  final String assetRoute;
  final double size;
  final Color borderColor;

  const _Badge(
      {required this.size,
      required this.borderColor,
      required this.assetRoute});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: PieChart.defaultDuration,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: 2,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(.5),
            offset: const Offset(3, 3),
            blurRadius: 3,
          ),
        ],
      ),
      padding: EdgeInsets.all(size * .15),
      child: Center(
        child: Image.asset(assetRoute),
      ),
    );
  }
}
