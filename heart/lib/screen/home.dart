import 'package:flutter/material.dart';
import 'package:heart/drawer/demo1.dart';
import 'package:heart/drawer/demo2.dart';
import 'package:heart/drawer/logIn.dart';
import 'package:heart/drawer/signUp.dart';
void main() {
  runApp(const MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final int _selectedIndex = 2;
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

  void _onItemTapped(int index) {
    _pageController.jumpToPage(index);
  }

  void _onTapDrawer(int index) {
    setState(() {
      _drawerIndex = index;
    });
    if (index == 0) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const Demo1()));
    } else if (index == 1) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const Demo2()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isLargeScreen = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('lib/assets/image/background.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        leading: isLargeScreen
            ? null
            : Builder(
                builder: (context) => IconButton(
                  onPressed: () => Scaffold.of(context).openDrawer(),
                  icon: const Icon(Icons.menu),
                ),
              ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            if (isLogin)
            DrawerHeader(
              child: Text(
                '안녕하세요!\n $nickname님!',
                 style: const TextStyle(
                    color: Colors.black,
                    fontSize: 23,
                    fontFamily: 'single_day',
                  ),
                ),
            )
            else
              const DrawerHeader(
            child: Center(
              child: Text(
                '환영합니다!',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 23,
                  fontFamily: 'single_day',
                ),
              ),
            ),
              ),
              const SizedBox(height: 20),
             Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 89, 181, 81), 
                borderRadius: BorderRadius.circular(30.0), 
              ),
              child: ListTile(
                leading: SizedBox(
                  width: 24,
                  height: 24,
                  child: Image.asset(
                    'lib/assets/image/login.png',
                    fit: BoxFit.contain,
                  ),
                ),
                title: const Text(
                  '로그인하기',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 23,
                    fontFamily: 'single_day',
                  ),
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Login()),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
            Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 89, 181, 81), 
                borderRadius: BorderRadius.circular(30.0), 
              ),
              child: ListTile(
                leading: SizedBox(
                  width: 24,
                  height: 24,
                  child: Image.asset(
                    'lib/assets/image/signup.png',
                    fit: BoxFit.contain,
                  ),
                ),
                title: const Text(
                  '회원가입하기',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 23,
                    fontFamily: 'single_day',
                  ),
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignUp()),
                ),
              ),
            ),
          ),
           
          ],
        ),
      ),

      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/assets/image/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'lib/assets/image/3.png',
                width: 250,
                height: 300,
              ),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFBA0),
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.all(20.0),
                child: const Text(
                  '오늘은 날씨가 선선하니 \n야외에서 30분 산책하기 \n어떠세요?^^',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 23,
                    fontFamily: 'single_day',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
