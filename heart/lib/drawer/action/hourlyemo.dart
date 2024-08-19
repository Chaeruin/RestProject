//시간대별 가장 빈도가 많은 감정을 보여주는 페이지

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:heart/Api/emotion_apis.dart';
import 'package:heart/Model/emotion_model.dart';

class HourlyEmotion extends StatefulWidget {
  final String memberId;
  const HourlyEmotion({super.key, required this.memberId});

  @override
  State<HourlyEmotion> createState() => _HourlyEmotionState();
}

class _HourlyEmotionState extends State<HourlyEmotion> {
  late String writeDate;
  late String memberId;
  late Future<List<HourlyEmo>> hourly;

  @override
  void initState() {
    super.initState();
    writeDate = DateFormat('yyyyMM').format(DateTime.now());
    memberId = widget.memberId;
    hourly = hourlyEmotions(memberId);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Row(
          children: [
            Expanded(
              child: Text(
                '시간대별 당신이 가장 많이 느낀 감정이에요!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromARGB(255, 65, 133, 59),
                  fontSize: 23,
                  fontFamily: 'single_day',
                ),
              ),
            ),
          ],
        ),
        FutureBuilder<List<HourlyEmo>>(
          future: hourly,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text('No data available'),
              );
            } else {
              return Expanded(
                child: makeList(snapshot),
              );
            }
          },
        ),
      ],
    );
  }

  ListView makeList(AsyncSnapshot<List<HourlyEmo>> snapshot) {
    return ListView.separated(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: snapshot.data!.length,
      padding: const EdgeInsets.all(8),
      itemBuilder: (context, index) {
        var rank = snapshot.data![index];
        return Hourly(
          afterEmotion:
              rank.afterEmotion.isNotEmpty ? rank.afterEmotion : 'Unknown',
          count: rank.count,
          timeRange: rank.timeRange,
        );
      },
      separatorBuilder: (context, index) => const SizedBox(
        width: 10,
      ),
    );
  }
}

class Hourly extends StatelessWidget {
  final String afterEmotion;
  final String timeRange;
  final int count;
  const Hourly({
    super.key,
    required this.afterEmotion,
    required this.timeRange,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 90, 
      height: 150, 
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$timeRange시간', 
            style: const TextStyle(
              fontSize: 18,
              fontFamily: 'single_day',
              ), 
          ),
          const SizedBox(height: 5), 
          Image.asset(
            'lib/assets/image/emotions/$afterEmotion.png',
            width: 110,
            height: 110,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(
                Icons.image_not_supported,
                size: 110,
                color: Colors.grey,
              );
            },
          ),
          const SizedBox(height: 5), 
          Text(
            '$count번', 
            style: const TextStyle(
              fontSize: 18,
              fontFamily: 'single_day',
              ), 
          ),
        ],
      ),
    );
  }
}
