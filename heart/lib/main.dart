import 'package:flutter/material.dart';
import 'package:heart/Api/audio_apis.dart';
import 'package:heart/screen/chat/chat.dart';
import 'package:heart/screen/diary/diary.dart';
import 'package:heart/screen/home.dart';
import 'package:heart/screen/action/recommendation.dart';
import 'package:heart/screen/statistics/statistics.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'audio_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  late final memberID;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AudioProvider(memberID),
        ),
      ],
      child: MaterialApp(
        title: 'App Demo',
        theme: ThemeData(
          primaryColor: Colors.deepPurple,
          useMaterial3: true,
        ),
        home: const MyHomePage(),
      ),
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
  late String? latestEmotion = '';

  // 저장소에 nickname이 있는지 확인 후 로그인 여부 판단
  Future<void> initPref() async {
    prefs = await SharedPreferences.getInstance();
    final memId = prefs.getString('ID');
    final nickName = prefs.getString('nick');
    final isLogIn = prefs.getBool('isLogin') ?? false;

    if (memId != null && nickName != null && isLogIn) {
      setState(() {
        memberID = memId;
        nickname = nickName;
        isLogin = isLogIn;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await initPref();
      if (isLogin) {
        await getLatestEmotion(memberID);
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onItemTapped(int index) {
    _pageController.jumpToPage(index);
  }

  Future<void> getLatestEmotion(String memID) async {
    print('get latest emotion memID: $memID');
    final latest = await returnAfterEmotion(memID);
    print('get latest emotion latest: $latest');
    setState(() {
      latestEmotion = latest;
    });
    print('get latest emotion latestEmotion: $latestEmotion');
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isLargeScreen = width > 800;

    print('memberID: $memberID');
    print('nickname: $nickname');
    print('latest Emotion: $latestEmotion');

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
                  Expanded(
                    child: IndexedStack(
                      index: _selectedIndex,
                      children: [
                        const Chat(),
                        Diary(memID: memberID),
                        const Home(),
                        Statistics(memId: memberID),
                        Recommendation(memberID: memberID),
                      ],
                    ),
                  ),
                ],
              )
            : PageView(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                children: [
                  const Chat(),
                  Diary(memID: memberID),
                  const Home(),
                  Statistics(memId: memberID),
                  Recommendation(memberID: memberID),
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
          ),
        ),
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
