import 'package:flutter/material.dart';
import 'package:heart/drawer/login.dart';
import 'package:heart/drawer/signup.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  late SharedPreferences prefs;
  late int points = 0;
  bool isLogin = false;
  late String nickname;

  Future initPref() async {
    prefs = await SharedPreferences.getInstance();
    final point = prefs.getInt('point') ?? 0;
    final nickName = prefs.getString('nickName');

    if (nickName != null) {
      setState(() {
        isLogin = true;
        nickname = nickName;
      });
    }

    setState(() {
      points = point;
    });
  }

  @override
  void initState() {
    super.initState();
    initPref();
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
                  '안녕하세요!\n $nickname 님!',
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
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
              imageChange(points),
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

//획득 포인트에 맞춰 이미지를 바꾸는 함수
imageChange(int points) {
  if (points >= 0 && points < 10) {
    return Image.asset(
      'lib/assets/image/2.png', //레벨에 맞는 이미지 삽입
      width: 250,
      height: 300,
    );
  } else if (points >= 10 && points < 50) {
    return Image.asset(
      'lib/assets/image/3.png', //레벨에 맞는 이미지 삽입
      width: 250,
      height: 300,
    );
  } else {
    return Image.asset(
      'lib/assets/image/4.png', //레벨에 맞는 이미지 삽입
      width: 250,
      height: 300,
    );
  }
}
