//통계 페이지

import 'package:flutter/material.dart'; // Flutter의 기본 위젯 및 머티리얼 디자인 컴포넌트를 사용하기 위해 가져옴
import 'package:heart/auth_provider.dart'; // 사용자 인증 상태를 관리하기 위한 Provider
import 'package:provider/provider.dart'; // 상태 관리를 위해 Provider 패키지 가져오기
import 'package:heart/drawer/action/feel_better.dart'; //기분에 따른 행동을 추천해주는 페이지
import 'package:heart/drawer/action/hourlyemo.dart'; //시간대별 가장 빈도가 많은 감정을 보여주는 페이지
import 'package:heart/screen/statistics/top3emo.dart'; //일기 작성 페이지를 기반으로 월 단위로 가장 빈도가 높은 감정 Top 3 
import 'package:heart/screen/statistics/totalemo.dart'; //감정의 빈도를 일기 작성을 기반으로 월 단위로 원 그래프로 나타내는 화면 
 
// 통계 화면을 표시
class Statistics extends StatefulWidget {
  const Statistics({super.key});

  @override
  State<Statistics> createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  late String memberID; // 회원 ID 저장 변수

  @override
  void initState() {
    super.initState();
    // 초기 memberID 값을 설정
    memberID = Provider.of<AuthProvider>(context, listen: false).ID;
  }

  @override
  Widget build(BuildContext context) {
    // AuthProvider의 상태 변화에 따라 memberID를 업데이트
    memberID = Provider.of<AuthProvider>(context, listen: true).ID;

    return (memberID == '')
        ? const Scaffold(
            body: Center(
              child: Text(
                '로그인이 필요합니다!',
                 style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'single_day',
                  ),
                ),
            ),
          )
        : Scaffold(
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
                final double titleFontSize = isLargeScreen ? 30 : 23;
                final double sectionSpacing = isLargeScreen ? 30 : 20;

                return SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: sectionSpacing),
                      Text(
                        '<월간 감정 통계>',
                        style: TextStyle(
                          color: const Color.fromARGB(255, 65, 133, 59),
                          fontSize: titleFontSize,
                          fontFamily: 'single_day',
                        ),
                      ),
                      SizedBox(height: sectionSpacing / 2),
                      SizedBox(
                        height: 300,
                        child: TotalEmotion(memberId: memberID),
                      ),
                      SizedBox(height: sectionSpacing),
                      SizedBox(
                        height: 300,
                        child: Top3Emotion(memberId: memberID),
                      ),
                      SizedBox(height: sectionSpacing),
                      SizedBox(
                        height: 300,
                        child: FeelBetter(memberID: memberID),
                      ),
                      SizedBox(height: sectionSpacing),
                      SizedBox(
                        height: 300,
                        child: HourlyEmotion(memberId: memberID),
                      ),
                      SizedBox(height: sectionSpacing),
                    ],
                  ),
                );
              },
            ),
          );
  }
}
