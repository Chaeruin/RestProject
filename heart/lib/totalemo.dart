import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    sentiment = readEmotionMonthly(widget.memberId, writeDate);
  }

  Future<void> _onRefresh() async {
    // Fetch new data
    setState(() {
      sentiment = readEmotionMonthly(widget.memberId, writeDate);
    });
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
                return _buildChart(snapshot);
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
}

Widget _buildChart(AsyncSnapshot<MonthlyEmo> snapshot) {
  var sentiment = snapshot.data!;

  // 여기 sentiment 받아서 처리하기
  double joy = (double.parse(sentiment.joy.replaceAll('%', '')));
  double hope = (double.parse(sentiment.hope.replaceAll('%', '')));
  double neutrality = (double.parse(sentiment.neutrality.replaceAll('%', '')));
  double sadness = (double.parse(sentiment.sadness.replaceAll('%', '')));
  double anger = (double.parse(sentiment.anger.replaceAll('%', '')));
  double anxiety = (double.parse(sentiment.anxiety.replaceAll('%', '')));
  double tiredness = (double.parse(sentiment.tiredness.replaceAll('%', '')));
  double regret = (double.parse(sentiment.regret.replaceAll('%', '')));

  final List<_ChartData> chartData = [
    _ChartData('기쁨', joy, const Color.fromARGB(255, 251, 238, 121)),
    _ChartData('희망', hope, const Color.fromARGB(255, 167, 252, 169)),
    _ChartData('중립', neutrality, const Color.fromARGB(255, 187, 187, 187)),
    _ChartData('슬픔', sadness, const Color.fromARGB(255, 139, 203, 255)),
    _ChartData('화남', anger, const Color.fromARGB(255, 255, 146, 138)),
    _ChartData('불안', anxiety, const Color.fromARGB(255, 255, 169, 95)),
    _ChartData('피곤', tiredness, const Color.fromARGB(255, 139, 150, 253)),
    _ChartData('후회', regret, const Color.fromARGB(255, 255, 113, 205)),
  ];

  return SfCartesianChart(
    primaryXAxis: const CategoryAxis(
      labelStyle: TextStyle(
        fontSize: 12,
        fontFamily: 'single_day',
      ),
    ),
    primaryYAxis: const NumericAxis(
      minimum: 0,
      maximum: 50,
      interval: 25,
    ),
    series: [
      ColumnSeries<_ChartData, String>(
        dataSource: chartData,
        xValueMapper: (chartData, _) => chartData.x,
        yValueMapper: (chartData, _) => chartData.y,
        pointColorMapper: (chartData, _) => chartData.color,
      )
    ],
  );
}

class _ChartData {
  _ChartData(this.x, this.y, this.color);

  final String x;
  final double y;
  final Color color;
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