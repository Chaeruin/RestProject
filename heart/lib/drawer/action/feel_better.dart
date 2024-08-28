//기분에 따른 행동을 추천해주는 페이지

import 'package:flutter/material.dart'; // Flutter의 기본 위젯 및 머티리얼 디자인 컴포넌트를 사용하기 위해 가져옴
import 'package:heart/Api/action_api.dart'; //행동  api 불러오기
import 'package:shared_preferences/shared_preferences.dart'; // 간단한 데이터를 로컬에 저장

class FeelBetter extends StatefulWidget {
  final String memberID;
  const FeelBetter({super.key, required this.memberID});

  @override
  State<FeelBetter> createState() => _FeelBetterStatsState();
}

class _FeelBetterStatsState extends State<FeelBetter> {
  late final Future<List<String>> feelBetterLists;
  String? nickname;
  late SharedPreferences prefs;

  Future<void> initPref() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      nickname = prefs.getString('nick') ?? 'Guest';
    });
    print("Nickname: $nickname");
  }

  @override
  void initState() {
    super.initState();
    feelBetterLists = feelBetterActions(widget.memberID);
    initPref(); 
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      
        children: [
        const Row(
          children: [
            Expanded(
              child: Text(
                '<행통 통계>',
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
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 150,
              width: 200,
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBA0),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Center(
                child: Text(
                  '"$nickname"님은 이런 행동을\n하면 기분이 좋아져요!',
                  style: const TextStyle(
                    fontSize: 19,
                    fontFamily: 'single_day',
                  ),
                ),
              ),
            ),
            const SizedBox(width: 20),
            Image.asset(
              'lib/assets/image/activity2.png',
              width: 100,
              height: 100,
            )
          ],
        ),
        const SizedBox(height: 10),
        Expanded( 
          child: FutureBuilder(
            future: feelBetterLists,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data == null) {
                return const Center(child: Text('데이터가 없습니다.'));
              } else {
                var lists = snapshot.data as List<String>;
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: lists.length,
                  padding: const EdgeInsets.all(10),
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Icon(Icons.circle),
                            const SizedBox(width: 5),
                            Text(
                              lists[index],
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontFamily: 'single_day',
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
