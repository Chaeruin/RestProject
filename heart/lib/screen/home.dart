import 'package:flutter/material.dart';
import 'package:heart/drawer/login.dart';
import 'package:heart/drawer/signup.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:heart/Api/action_api.dart';
import 'package:just_audio/just_audio.dart';

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
  late String memberID;
  String? actionMessage;

  final AudioPlayer audioPlayer = AudioPlayer();

  Future<void> initPref() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      points = prefs.getInt('point') ?? 0;
      nickname = prefs.getString('nickName') ?? '';
      memberID = prefs.getString('ID') ?? '';
      isLogin = prefs.getBool('isLogin') ?? false;
    });
    print(
        "Login status: $isLogin, Nickname: $nickname, MemberID: $memberID"); // 디버깅용 출력
  }

  @override
  void initState() {
    super.initState();
    initPref();
    _initAudioPlayer();
    fetchActionRecommendationFromApi();
  }

  //오디오 연결하는 api->0.wav를 joy.wav로 변경하면 감정에 맞는 음악이 나옴
  Future<void> _initAudioPlayer() async {
    try {
      await audioPlayer
          .setUrl('https://chatbotmg.s3.ap-northeast-2.amazonaws.com/0.wav');
      audioPlayer.play();
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  Future<void> fetchActionRecommendationFromApi() async {
    try {
      final action = await fetchActionRecommendation();
      setState(() {
        actionMessage = action;
      });
    } catch (e) {
      setState(() {
        actionMessage = '행동 추천을 불러오는데 오류가 발생했습니다.';
      });
    }
  }

  Future<void> logout() async {
    await prefs.remove('nickName');
    await prefs.remove('ID');
    setState(() {
      isLogin = false;
      nickname = '';
      memberID = '';
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
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
        leading: MediaQuery.of(context).size.width > 600
            ? null
            : Builder(
                builder: (context) => IconButton(
                  onPressed: () => Scaffold.of(context).openDrawer(),
                  icon: const Icon(Icons.menu),
                ),
              ),
        actions: [
          _buildAudioPlayerControls(),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Center(
                child: Text(
                  isLogin ? '안녕하세요!\n $nickname 님!' : '환영합니다!',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 23,
                    fontFamily: 'single_day',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (isLogin)
              _buildDrawerItem(
                title: '로그아웃하기',
                icon: Icons.logout,
                onTap: logout,
              )
            else ...[
              _buildDrawerItem(
                title: '로그인하기',
                icon: 'lib/assets/image/login.png',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Login()),
                ),
              ),
              const SizedBox(height: 20),
              _buildDrawerItem(
                title: '회원가입하기',
                icon: 'lib/assets/image/signup.png',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignUp()),
                ),
              ),
            ],
            const SizedBox(height: 20),
          ],
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool isLargeScreen = constraints.maxWidth > 600;
          final double fontSize = isLargeScreen ? 30 : 20;
          final double containerWidth = isLargeScreen ? 450 : 300;
          final double containerHeight = isLargeScreen ? 150 : 100;
          final double imageSize = isLargeScreen ? 350 : 250;

          return Container(
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
                  imageChange(points, imageSize),
                  const SizedBox(height: 25),
                  Container(
                    width: 350,
                    height: containerHeight,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFBA0),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.all(20.0),
                    child: Center(
                      child: Text(
                        actionMessage != null
                            ? '"$actionMessage" 어떠세요?'
                            : 'Loading...',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 23,
                          fontFamily: 'single_day',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDrawerItem({
    required String title,
    required dynamic icon,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 89, 181, 81),
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: ListTile(
          leading: icon is IconData
              ? Icon(icon, color: Colors.black)
              : SizedBox(
                  width: 24,
                  height: 24,
                  child: Image.asset(
                    icon,
                    fit: BoxFit.contain,
                  ),
                ),
          title: Text(
            title,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 23,
              fontFamily: 'single_day',
            ),
          ),
          onTap: onTap,
        ),
      ),
    );
  }

  //오디오 기능 UI
  Widget _buildAudioPlayerControls() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: IconButton(
        icon: Icon(audioPlayer.playing ? Icons.pause : Icons.play_arrow),
        onPressed: () {
          if (audioPlayer.playing) {
            audioPlayer.pause();
          } else {
            audioPlayer.play();
          }
          setState(() {});
        },
      ),
    );
  }
}

// 획득 포인트에 맞춰 이미지를 바꾸는 함수
Widget imageChange(int points, double imageSize) {
  if (points >= 0 && points < 10) {
    return Image.asset(
      'lib/assets/image/2.png', // 레벨에 맞는 이미지 삽입
      width: imageSize,
      height: imageSize,
    );
  } else if (points >= 10 && points < 50) {
    return Image.asset(
      'lib/assets/image/3.png', // 레벨에 맞는 이미지 삽입
      width: imageSize,
      height: imageSize,
    );
  } else {
    return Image.asset(
      'lib/assets/image/4.png', // 레벨에 맞는 이미지 삽입
      width: imageSize,
      height: imageSize,
    );
  }
}
