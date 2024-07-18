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
  String writeDate = DateFormat('yyyyMMdd').format(DateTime.now()).toString();
  int touchedIndex = 0;

  @override
  void initState() {
    super.initState();
    sentiment = readEmotionMonthly(widget.memberId, writeDate);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 위에 여백을 추가하고 싶다면 사용
        const Text(
          '월간 감정 통계', // 원하는 텍스트로 변경
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'single_day',
          ), // 적절한 크기로 텍스트 스타일 설정
        ),
        const SizedBox(height: 5), // 텍스트와 리프레셔 사이의 간격
        Expanded(
          child: FutureBuilder(
            future: sentiment,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return PieChart(
                  PieChartData(
                    pieTouchData: PieTouchData(
                      touchCallback: (FlTouchEvent event, PieTouchResponse) {
                        setState(() {
                          if (!event.isInterestedForInteractions ||
                              PieTouchResponse == null ||
                              PieTouchResponse.touchedSection == null) {
                            touchedIndex = -1;
                            return;
                          }
                          touchedIndex = PieTouchResponse
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
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
      ],
    );
  }

  List<PieChartSectionData> showingSections(
      AsyncSnapshot<MonthlyEmo> snapshot) {
    var sentiments = snapshot.data!;

    // 여기 sentiment 받아서 처리하기
    double joy = (double.parse(sentiments.joy.substring(0, 2)));
    double hope = (double.parse(sentiments.hope.substring(0, 2)));
    double neutrality = (double.parse(sentiments.neutrality.substring(0, 2)));
    double sadness = (double.parse(sentiments.sadness.substring(0, 2)));
    double anger = (double.parse(sentiments.anger.substring(0, 2)));
    double anxiety = (double.parse(sentiments.anxiety.substring(0, 2)));
    double tiredness = (double.parse(sentiments.tiredness.substring(0, 2)));
    double regret = (double.parse(sentiments.regret.substring(0, 2)));

    return List.generate(8, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 20.0 : 16.0;
      final radius = isTouched ? 110.0 : 100.0;
      final widgetSize = isTouched ? 55.0 : 40.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Colors.red,
            value: joy,
            title: 'JOY',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Color(0xffffffff),
              shadows: shadows,
              fontFamily: 'single_day',
            ),
            badgeWidget: _Badge(
              assetRoute: 'lib/Assets/Images/joy.png',
              size: widgetSize,
              borderColor: Colors.black,
            ),
            badgePositionPercentageOffset: .98,
          );
        case 1:
          return PieChartSectionData(
            color: Colors.red,
            value: hope,
            title: 'HOPE',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Color(0xffffffff),
              shadows: shadows,
              fontFamily: 'single_day',
            ),
            badgeWidget: _Badge(
              assetRoute: 'lib/Assets/Images/hope.png',
              size: widgetSize,
              borderColor: Colors.black,
            ),
            badgePositionPercentageOffset: .98,
          );
        case 2:
          return PieChartSectionData(
            color: Colors.red,
            value: neutrality,
            title: 'NEUTRALITY',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Color(0xffffffff),
              shadows: shadows,
              fontFamily: 'single_day',
            ),
            badgeWidget: _Badge(
              assetRoute: 'lib/Assets/Images/neutrality.png',
              size: widgetSize,
              borderColor: Colors.black,
            ),
            badgePositionPercentageOffset: .98,
          );
        case 3:
          return PieChartSectionData(
            color: Colors.red,
            value: sadness,
            title: 'SADNESS',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Color(0xffffffff),
              shadows: shadows,
              fontFamily: 'single_day',
            ),
            badgeWidget: _Badge(
              assetRoute: 'lib/Assets/Images/sadness.png',
              size: widgetSize,
              borderColor: Colors.black,
            ),
            badgePositionPercentageOffset: .98,
          );
        case 4:
          return PieChartSectionData(
            color: Colors.red,
            value: anger,
            title: 'ANGER',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Color(0xffffffff),
              shadows: shadows,
              fontFamily: 'single_day',
            ),
            badgeWidget: _Badge(
              assetRoute: 'lib/Assets/Images/anger.png',
              size: widgetSize,
              borderColor: Colors.black,
            ),
            badgePositionPercentageOffset: .98,
          );
        case 5:
          return PieChartSectionData(
            color: Colors.red,
            value: anxiety,
            title: 'ANXIETY',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Color(0xffffffff),
              shadows: shadows,
              fontFamily: 'single_day',
            ),
            badgeWidget: _Badge(
              assetRoute: 'lib/Assets/Images/anxiety.png',
              size: widgetSize,
              borderColor: Colors.black,
            ),
            badgePositionPercentageOffset: .98,
          );
        case 6:
          return PieChartSectionData(
            color: Colors.red,
            value: tiredness,
            title: 'TIREDNESS',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Color(0xffffffff),
              shadows: shadows,
              fontFamily: 'single_day',
            ),
            badgeWidget: _Badge(
              assetRoute: 'lib/Assets/Images/tiredness.png',
              size: widgetSize,
              borderColor: Colors.black,
            ),
            badgePositionPercentageOffset: .98,
          );
        case 7:
          return PieChartSectionData(
            color: Colors.red,
            value: regret,
            title: 'REGRET',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Color(0xffffffff),
              shadows: shadows,
              fontFamily: 'single_day',
            ),
            badgeWidget: _Badge(
              assetRoute: 'lib/Assets/Images/regret.png',
              size: widgetSize,
              borderColor: Colors.black,
            ),
            badgePositionPercentageOffset: .98,
          );
        default:
          throw Exception('Wrong Error!!');
      }
    });
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
            offset: Offset(3, 3),
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

// import 'package:fl_chart_app/presentation/resources/app_resources.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';

// class PieChartSample3 extends StatefulWidget {
//   const PieChartSample3({super.key});

//   @override
//   State<StatefulWidget> createState() => PieChartSample3State();
// }

// class PieChartSample3State extends State {
//   int touchedIndex = 0;

//   @override
//   Widget build(BuildContext context) {
//     return AspectRatio(
//       aspectRatio: 1.3,
//       child: AspectRatio(
//         aspectRatio: 1,
//         child: PieChart(
//           PieChartData(
//             pieTouchData: PieTouchData(
//               touchCallback: (FlTouchEvent event, pieTouchResponse) {
//                 setState(() {
//                   if (!event.isInterestedForInteractions ||
//                       pieTouchResponse == null ||
//                       pieTouchResponse.touchedSection == null) {
//                     touchedIndex = -1;
//                     return;
//                   }
//                   touchedIndex =
//                       pieTouchResponse.touchedSection!.touchedSectionIndex;
//                 });
//               },
//             ),
//             borderData: FlBorderData(
//               show: false,
//             ),
//             sectionsSpace: 0,
//             centerSpaceRadius: 0,
//             sections: showingSections(),
//           ),
//         ),
//       ),
//     );
//   }

//   List<PieChartSectionData> showingSections() {
//     return List.generate(4, (i) {
//       final isTouched = i == touchedIndex;
//       final fontSize = isTouched ? 20.0 : 16.0;
//       final radius = isTouched ? 110.0 : 100.0;
//       final widgetSize = isTouched ? 55.0 : 40.0;
//       const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

//       switch (i) {
//         case 0:
//           return PieChartSectionData(
//             color: AppColors.contentColorBlue,
//             value: 40,
//             title: '40%',
//             radius: radius,
//             titleStyle: TextStyle(
//               fontSize: fontSize,
//               fontWeight: FontWeight.bold,
//               color: const Color(0xffffffff),
//               shadows: shadows,
//             ),
//             badgeWidget: _Badge(
//               'assets/icons/ophthalmology-svgrepo-com.svg',
//               size: widgetSize,
//               borderColor: AppColors.contentColorBlack,
//             ),
//             badgePositionPercentageOffset: .98,
//           );
//         case 1:
//           return PieChartSectionData(
//             color: AppColors.contentColorYellow,
//             value: 30,
//             title: '30%',
//             radius: radius,
//             titleStyle: TextStyle(
//               fontSize: fontSize,
//               fontWeight: FontWeight.bold,
//               color: const Color(0xffffffff),
//               shadows: shadows,
//             ),
//             badgeWidget: _Badge(
//               'assets/icons/librarian-svgrepo-com.svg',
//               size: widgetSize,
//               borderColor: AppColors.contentColorBlack,
//             ),
//             badgePositionPercentageOffset: .98,
//           );
//         case 2:
//           return PieChartSectionData(
//             color: AppColors.contentColorPurple,
//             value: 16,
//             title: '16%',
//             radius: radius,
//             titleStyle: TextStyle(
//               fontSize: fontSize,
//               fontWeight: FontWeight.bold,
//               color: const Color(0xffffffff),
//               shadows: shadows,
//             ),
//             badgeWidget: _Badge(
//               'assets/icons/fitness-svgrepo-com.svg',
//               size: widgetSize,
//               borderColor: AppColors.contentColorBlack,
//             ),
//             badgePositionPercentageOffset: .98,
//           );
//         case 3:
//           return PieChartSectionData(
//             color: AppColors.contentColorGreen,
//             value: 15,
//             title: '15%',
//             radius: radius,
//             titleStyle: TextStyle(
//               fontSize: fontSize,
//               fontWeight: FontWeight.bold,
//               color: const Color(0xffffffff),
//               shadows: shadows,
//             ),
//             badgeWidget: _Badge(
//               'assets/icons/worker-svgrepo-com.svg',
//               size: widgetSize,
//               borderColor: AppColors.contentColorBlack,
//             ),
//             badgePositionPercentageOffset: .98,
//           );
//         default:
//           throw Exception('Oh no');
//       }
//     });
//   }
// }

// class _Badge extends StatelessWidget {
//   const _Badge(
//     this.svgAsset, {
//     required this.size,
//     required this.borderColor,
//   });
//   final String svgAsset;
//   final double size;
//   final Color borderColor;

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedContainer(
//       duration: PieChart.defaultDuration,
//       width: size,
//       height: size,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         shape: BoxShape.circle,
//         border: Border.all(
//           color: borderColor,
//           width: 2,
//         ),
//         boxShadow: <BoxShadow>[
//           BoxShadow(
//             color: Colors.black.withOpacity(.5),
//             offset: const Offset(3, 3),
//             blurRadius: 3,
//           ),
//         ],
//       ),
//       padding: EdgeInsets.all(size * .15),
//       child: Center(
//         child: SvgPicture.asset(
//           svgAsset,
//         ),
//       ),
//     );
//   }
// }