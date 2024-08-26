// 페이지 전체 관리

import 'package:flutter/material.dart';
import 'package:heart/Api/audio_apis.dart';
import 'package:heart/audio_provider.dart';
import 'package:heart/auth_provider.dart';
import 'package:heart/screen/chat/chat.dart';
import 'package:heart/screen/diary/diary.dart';
import 'package:heart/screen/home.dart';
import 'package:heart/screen/action/recommendation.dart';
import 'package:heart/screen/statistics/statistics.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

void main() {
  //위젯 생성 시 초기화 되기전에 바인딩이 형성되는 경우를 막음
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // SharedPreferences 인스턴스를 비동기로 가져옴
  final Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  late final memberID = ''; //사용자 id 변수 초기화

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // AudioProvider를 ChangeNotifierProvider로 제공
        ChangeNotifierProvider(create: (_) => AudioProvider(memberID)),
        ChangeNotifierProvider(
          create: (_) => AuthProvider()..loadLoginInfo(),
          child: const MyHomePage(),
        )
      ],
      child: MaterialApp(
        title: '마음 ℃',
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
  int _selectedIndex = 2; // 현재 선택된 페이지 인덱스
  late PageController _pageController; // 페이지 컨트롤러
  late SharedPreferences prefs; // SharedPreferences 인스턴스
  late String memberID = ''; // 사용자 ID
  late String nickname = ''; // 사용자 닉네임
  bool isLogin = false; // 로그인 여부
  late String? latestEmotion = ''; // 최신 감정 값

  // 저장소에 nickname이 있는지 확인 후 로그인 여부 판단
  Future<void> initPref() async {
    prefs = await SharedPreferences.getInstance();
    final memId = prefs.getString('ID'); // 저장된 사용자 ID 가져오기
    final nickName = prefs.getString('nick'); // 저장된 닉네임 가져오기
    final isLogIn = prefs.getBool('isLogin') ?? false; // 저장된 로그인 상태 가져오기

    if (memId != null && nickName != null && isLogIn) {
      setState(() {
        memberID = memId; // 사용자 ID 설정
        nickname = nickName; // 닉네임 설정
        isLogin = isLogIn; // 로그인 상태 설정
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _pageController =
        PageController(initialPage: _selectedIndex); // 페이지 컨트롤러 초기화
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await initPref(); // 초기화 후 SharedPreferences에서 값 가져오기
      if (isLogin) {
        await getLatestEmotion(memberID); // 로그인 되어 있으면 최신 감정 가져오기
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose(); // 페이지 컨트롤러 해제
    super.dispose();
  }

  // 페이지가 변경될 때 호출되는 메서드
  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index; // 선택된 페이지 인덱스 업데이트
    });
  }

  // 하단 내비게이션 바 항목이 선택될 때 호출되는 메서드
  void _onItemTapped(int index) {
    _pageController.jumpToPage(index); // 페이지를 선택된 인덱스로 이동
  }

  // 최신 감정을 가져와서 상태를 업데이트하는 비동기 메서드
  Future<void> getLatestEmotion(String memID) async {
    final latest = await returnAfterEmotion(memID); // API 호출하여 최신 감정 값 가져오기

    setState(() {
      latestEmotion = latest; // 최신 감정 값 상태 업데이트
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isLargeScreen = width > 800;

    return Theme(
      data: ThemeData.light(),
      child: Scaffold(
        body: isLargeScreen
            ? Row(
                children: [
                  // 큰 화면일 때 네비게이션 레일 사용
                  NavigationRail(
                    destinations: _navRailItems, // 내비게이션 항목 설정
                    selectedIndex: _selectedIndex, // 선택된 인덱스 설정
                    onDestinationSelected: (int index) {
                      setState(() {
                        _selectedIndex = index; // 선택된 페이지 인덱스 업데이트
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
                      children: const [
                        Chat(), // 채팅 화면
                        Diary(), // 일기 화면
                        Home(), // 홈 화면
                        Statistics(), // 통계 화면
                        Recommendation(), // 행동 추천 화면
                      ],
                    ),
                  ),
                ],
              )
            : PageView(
                controller: _pageController, // 페이지 컨트롤러
                onPageChanged: _onPageChanged, // 페이지 변경 시 호출
                children: const [
                  Chat(),
                  Diary(),
                  Home(),
                  Statistics(),
                  Recommendation(),
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
