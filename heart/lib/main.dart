import 'package:flutter/material.dart';
import 'package:heart/drawer/demo1.dart';
import 'package:heart/drawer/demo2.dart';
import 'package:heart/drawer/logIn.dart';
import 'package:heart/screen/chat.dart';
import 'package:heart/screen/diary.dart';
import 'package:heart/screen/home.dart';
import 'package:heart/screen/mypage.dart';
import 'package:heart/screen/statistics.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

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
  int _drawerIndex = 0;
  late PageController _pageController;
  String memberId = 'test';
  String nickname = 'text';
  bool isLogin = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
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

  void _onTapDrawer(int index) {
    setState(() {
      _drawerIndex = index;
      if (index == 0) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Demo1()));
      } else if (index == 1) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Demo2()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isLargeScreen = width > 800;

    return Theme(
      data: ThemeData.light(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          leading: isLargeScreen
              ? null
              : Builder(
                  builder: (context) => IconButton(
                    onPressed: () => Scaffold.of(context).openDrawer(),
                    icon: const Icon(Icons.menu),
                  ),
                ),
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "마음씨",
                  style: TextStyle(
                      color: Colors.green, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
        drawer: NavigationDrawer(
          selectedIndex: _drawerIndex,
          onDestinationSelected: _onTapDrawer,
          children: [
            if (isLogin)
              DrawerHeader(
                child: Text('안녕하세요\n ${nickname}님!'),
              )
            else
              DrawerHeader(
                child: ElevatedButton(
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Login())),
                  child: Text('로그인하기'),
                ),
              ),
            NavigationDrawerDestination(
                icon: Icon(Icons.abc), label: Text('임시1')),
            NavigationDrawerDestination(
                icon: Icon(Icons.ac_unit), label: Text('임시2')),
          ],
        ),
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
                          Chat(),
                          Diary(),
                          Home(),
                          Statistics(),
                          Mypage(),
                        ],
                      )
                    ],
                  )
                ],
              )
            : PageView(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                children: const [
                  Chat(),
                  Diary(),
                  Home(),
                  Statistics(),
                  Mypage(),
                ],
              ),
        bottomNavigationBar: SalomonBottomBar(
            currentIndex: _selectedIndex,
            selectedItemColor: const Color(0xff6200ee),
            unselectedItemColor: const Color(0xff757575),
            items: _navBarItems,
            onTap: _onItemTapped),
      ),
    );
  }
}

final _navBarItems = [
  SalomonBottomBarItem(
    icon: const Icon(Icons.chat),
    title: const Text("Chat"),
    selectedColor: Colors.pink,
  ),
  SalomonBottomBarItem(
    icon: const Icon(Icons.note_alt_outlined),
    title: const Text("Diary"),
    selectedColor: Colors.orange,
  ),
  SalomonBottomBarItem(
    icon: const Icon(Icons.home),
    title: const Text("Home"),
    selectedColor: Colors.purple,
  ),
  SalomonBottomBarItem(
    icon: const Icon(Icons.bar_chart_sharp),
    title: const Text("Statistics"),
    selectedColor: Colors.teal,
  ),
  SalomonBottomBarItem(
    icon: const Icon(Icons.person_2_outlined),
    title: const Text("MyPage"),
    selectedColor: Colors.teal,
  ),
];

final _navRailItems = [
  const NavigationRailDestination(
    icon: Icon(Icons.home),
    label: Text("Home"),
  ),
  const NavigationRailDestination(
    icon: Icon(Icons.chat),
    label: Text("Chat"),
  ),
  const NavigationRailDestination(
    icon: Icon(Icons.note_alt_outlined),
    label: Text("Diary"),
  ),
  const NavigationRailDestination(
    icon: Icon(Icons.person),
    label: Text("Statistics"),
  ),
  const NavigationRailDestination(
    icon: Icon(Icons.person),
    label: Text("MyPage"),
  ),
];
