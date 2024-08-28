//감정의 빈도를 일기 작성을 기반으로 월 단위로 원 그래프로 나타내는 화면 

import 'package:flutter/material.dart'; // Flutter의 기본 위젯 및 머티리얼 디자인 컴포넌트를 사용하기 위해 가져옴
import 'package:heart/Api/emotion_apis.dart'; //감정 api 가져오기
import 'package:heart/Model/emotion_model.dart'; //감정 model 가져오기
import 'package:intl/intl.dart'; // 날짜와 시간 형식을 지정하고 조작하기 위해 사용되는 패키지를 가져옴
import 'package:fl_chart/fl_chart.dart'; // 원형 그래프를 그릴 수 있는 패키지를 가져옴

class TotalEmotion extends StatefulWidget {
  final String memberId;
  const TotalEmotion({super.key, required this.memberId});

  @override
  State<TotalEmotion> createState() => _TotalEmotionState();
}

class _TotalEmotionState extends State<TotalEmotion> {
  late Future<MonthlyEmo> sentiment; // 월간 감정 데이터를 비동기로 가져올 Future 변수
  String writeDate = DateFormat('yyyyMM').format(DateTime.now()); // 현재 월을 'yyyyMM' 형식으로 저장
  int touchedIndex = 0; // 터치된 인덱스 저장 변수

  @override
  void initState() {
    super.initState();
    sentiment = readEmotionMonthly(widget.memberId, writeDate);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: sentiment, // 비동기 데이터 전달
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return AspectRatio(
            aspectRatio: 1.3,
            child: AspectRatio(
              aspectRatio: 1, // 원형 차트의 비율 설정
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      setState(() {
                        // 차트 터치 시 인덱스 업데이트
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
                    show: false, // 차트 경계선 비활성화
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

// 원형 차트의 섹션 데이터 반환 메서드
  List<PieChartSectionData> showingSections(
      AsyncSnapshot<MonthlyEmo> snapshot) {
    var sentiments = snapshot.data!;

    // 원형 차트의 각 섹션 데이터 정의
    final sectionsData = [
      PieChartSectionData(
        color: const Color.fromARGB(255, 255, 120, 110),
        value: sentiments.joy * 100,
        title: 'JOY',
        badgeWidget: const _Badge(
          assetRoute: 'lib/assets/image/emotions/joy.png',
          size: 40,
          borderColor: Colors.black,
        ),
      ),
      PieChartSectionData(
        color: const Color.fromARGB(255, 255, 185, 80),
        value: sentiments.hope * 100,
        title: 'HOPE',
        badgeWidget: const _Badge(
          assetRoute: 'lib/assets/image/emotions/hope.png',
          size: 40,
          borderColor: Colors.black,
        ),
      ),
      PieChartSectionData(
        color: const Color.fromARGB(255, 255, 240, 101),
        value: sentiments.neutrality * 100,
        title: 'NEUTRALITY',
        badgeWidget: const _Badge(
          assetRoute: 'lib/assets/image/emotions/neutrality.png',
          size: 40,
          borderColor: Colors.black,
        ),
      ),
      PieChartSectionData(
        color: const Color.fromARGB(255, 90, 255, 115),
        value: sentiments.sadness * 100,
        title: 'SADNESS',
        badgeWidget: const _Badge(
          assetRoute: 'lib/assets/image/emotions/sadness.png',
          size: 40,
          borderColor: Colors.black,
        ),
      ),
      PieChartSectionData(
        color: const Color.fromARGB(255, 132, 200, 255),
        value: sentiments.anger * 100,
        title: 'ANGER',
        badgeWidget: const _Badge(
          assetRoute: 'lib/assets/image/emotions/anger.png',
          size: 40,
          borderColor: Colors.black,
        ),
      ),
      PieChartSectionData(
        color: const Color.fromARGB(255, 134, 151, 245),
        value: sentiments.anxiety * 100,
        title: 'ANXIETY',
        badgeWidget: const _Badge(
          assetRoute: 'lib/assets/image/emotions/anxiety.png',
          size: 40,
          borderColor: Colors.black,
        ),
      ),
      PieChartSectionData(
        color: const Color.fromARGB(255, 239, 148, 255),
        value: sentiments.tiredness * 100,
        title: 'TIREDNESS',
        badgeWidget: const _Badge(
          assetRoute: 'lib/assets/image/emotions/tiredness.png',
          size: 40,
          borderColor: Colors.black,
        ),
      ),
      PieChartSectionData(
        color: const Color.fromARGB(255, 255, 150, 234),
        value: sentiments.regret * 100,
        title: 'REGRET',
        badgeWidget: const _Badge(
          assetRoute: 'lib/assets/image/emotions/regret.png',
          size: 40,
          borderColor: Colors.black,
        ),
      ),
    ];

    // 각 섹션 데이터의 스타일을 설정하고, 값이 0보다 큰 섹션만 반환
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

// 원형 차트의 각 섹션에 대한 배지 위젯
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
