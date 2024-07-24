import 'package:flutter/material.dart';
import 'package:heart/screen/chat.dart';
import 'package:heart/screen/diary.dart';
import 'package:heart/screen/home.dart';
import 'package:heart/screen/recommendation.dart';
import 'package:heart/screen/statistics.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.deepPurple,
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 2;
  late PageController _pageController;
  late SharedPreferences prefs;
  late String memberID = '';
  late String nickname = '';
  bool isLogin = false;

  //저장소에 nickname이 있는지 확인 후 로그인 여부 판단
  Future initPref() async {
    prefs = await SharedPreferences.getInstance();
    final memId = prefs.getString('ID');
    final nickName = prefs.getString('nickName');

    if (memId != null) {
      setState(() {
        isLogin = true;
        memberID = memId;
        nickname = nickName!;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
    initPref();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onItemTapped(int index) {
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isLargeScreen = width > 800;

    print('memberID: $memberID');
    print('nickname: $nickname');

    return Theme(
      data: ThemeData.light(),
      child: Scaffold(
        body: isLargeScreen
            ? Row(
                children: [
                  NavigationRail(
                    destinations: _navRailItems,
                    selectedIndex: _selectedIndex,
                    onDestinationSelected: (int index) {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                  ),
                  const VerticalDivider(
                    thickness: 2,
                    width: 1,
                  ),
                  Column(
                    children: [
                      IndexedStack(
                        index: _selectedIndex,
                        children: [
                          const Chat(),
                          Diary(memID: memberID),
                          const Home(),
                          Statistics(
                            memId: memberID,
                          ),
                          const Recommendation(),
                        ],
                      )
                    ],
                  )
                ],
              )
            : PageView(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                children: [
                  const Chat(),
                  Diary(memID: memberID),
                  const Home(),
                  Statistics(
                    memId: memberID,
                  ),
                  const Recommendation(),
                ],
              ),
        bottomNavigationBar: Container(
            color: const Color(0xFFFFFBA0), // 배경색 설정
            child: SalomonBottomBar(
              currentIndex: _selectedIndex,
              selectedItemColor: const Color(0xff6200ee),
              unselectedItemColor: const Color(0xff757575),
              items: _navBarItems,
              onTap: _onItemTapped,
            )),
      ),
    );
  }
}

final _navBarItems = [
  SalomonBottomBarItem(
    icon: const Icon(Icons.chat),
    title: const Text(
      "채팅",
      style: TextStyle(
        color: Colors.black,
        fontSize: 15,
        fontFamily: 'single_day',
      ),
    ),
    selectedColor: const Color.fromARGB(255, 89, 181, 81),
  ),
  SalomonBottomBarItem(
    icon: const Icon(Icons.note_alt_outlined),
    title: const Text(
      "일기",
      style: TextStyle(
        color: Colors.black,
        fontSize: 15,
        fontFamily: 'single_day',
      ),
    ),
    selectedColor: const Color.fromARGB(255, 89, 181, 81),
  ),
  SalomonBottomBarItem(
    icon: const Icon(Icons.home),
    title: const Text(
      "홈",
      style: TextStyle(
        color: Colors.black,
        fontSize: 15,
        fontFamily: 'single_day',
      ),
    ),
    selectedColor: const Color.fromARGB(255, 89, 181, 81),
  ),
  SalomonBottomBarItem(
    icon: const Icon(Icons.bar_chart_sharp),
    title: const Text(
      "통계",
      style: TextStyle(
        color: Colors.black,
        fontSize: 15,
        fontFamily: 'single_day',
      ),
    ),
    selectedColor: const Color.fromARGB(255, 89, 181, 81),
  ),
  SalomonBottomBarItem(
    icon: const Icon(Icons.directions_run),
    title: const Text(
      "추천",
      style: TextStyle(
        color: Colors.black,
        fontSize: 15,
        fontFamily: 'single_day',
      ),
    ),
    selectedColor: const Color.fromARGB(255, 89, 181, 81),
  ),
];

final _navRailItems = [
  const NavigationRailDestination(
    icon: Icon(Icons.home),
    label: Text("홈"),
  ),
  const NavigationRailDestination(
    icon: Icon(Icons.chat),
    label: Text("채팅"),
  ),
  const NavigationRailDestination(
    icon: Icon(Icons.note_alt_outlined),
    label: Text("일기"),
  ),
  const NavigationRailDestination(
    icon: Icon(Icons.person),
    label: Text("통계"),
  ),
  const NavigationRailDestination(
    icon: Icon(Icons.directions_run),
    label: Text("추천"),
  ),
];
