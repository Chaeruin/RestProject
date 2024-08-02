import 'package:flutter/material.dart';
import 'package:heart/Api/action_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FeelBetter extends StatefulWidget {
  final String memberID;
  const FeelBetter({super.key, required this.memberID});

  @override
  State<FeelBetter> createState() => _FeelBetterStatsState();
}

class _FeelBetterStatsState extends State<FeelBetter> {
  late final Future<List<String>> feelBetterLists;
  late String nickName = '';
  late final prefs;

  Future<void> initPref() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      nickName = prefs.getString('nick') ?? '';
    });
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
      // mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
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
                  '$nickName님은 이런 행동을\n하면 기분이 좋아져요!',
                  style: TextStyle(
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
        FutureBuilder(
          future: feelBetterLists,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data == null) {
              return const Center(child: Text('No data available'));
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
                            softWrap: true,
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
      ],
    );
  }
}
