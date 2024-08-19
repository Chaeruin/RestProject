import 'package:flutter/material.dart';
import 'package:heart/Api/audio_apis.dart';
import 'package:heart/drawer/login.dart';
import 'package:heart/drawer/signup.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:heart/Api/action_api.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

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
  late String? latestEmotion = '';

  Future<void> initPref() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      points = prefs.getInt('point') ?? 0;
      nickname = prefs.getString('nick') ?? '';
      memberID = prefs.getString('ID') ?? '';
      isLogin = prefs.getBool('isLogin') ?? false;
    });
    print("Login status: $isLogin, Nickname: $nickname, MemberID: $memberID");
  }

  @override
  void initState() {
    super.initState();
    initPref().then((_) {
      checkLogIn();
      fetchActionRecommendationFromApi();
    });
  }

  Future<void> getLatestEmotion(String memID) async {
    print('Fetching latest emotion for memID: $memID');
    try {
      final latest = await returnAfterEmotion(memID);
      print('Fetched latest emotion: $latest');
      setState(() {
        latestEmotion = latest;
      });
      if (latestEmotion != null && latestEmotion!.isNotEmpty) {
        print("Calling _initAudioPlayer with emotion: $latestEmotion");
        _initAudioPlayer(latestEmotion!);
      } else {
        print("Latest emotion is null or empty");
      }
    } catch (e) {
      print("Error fetching latest emotion: $e");
    }
  }

  void checkLogIn() {
    if (isLogin) {
      getLatestEmotion(memberID);
    }
  }

  Future<void> _initAudioPlayer(String latestEmotion) async {
    final audioPlayer = context.read<AudioPlayer>();
    print("Entered _initAudioPlayer with emotion: $latestEmotion");
    try {
      final url =
          'https://chatbotmg.s3.ap-northeast-2.amazonaws.com/${memberID}_${latestEmotion}.wav';
      print('Audio URL: $url'); // Print the URL for debugging
      await audioPlayer.setUrl(url);
      audioPlayer.setLoopMode(LoopMode.one);
      audioPlayer.play();
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> fetchActionRecommendationFromApi() async {
    try {
      final action = await fetchActionRecommendation();
      if (mounted) {
        setState(() {
          actionMessage = action;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          actionMessage = '행동 추천을 불러오는데 오류가 발생했습니다.';
        });
      }
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
          final double fontSize = isLargeScreen ? 30 : 23;
          final double containerWidth = isLargeScreen ? 450 : 350;
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
                    width: containerWidth,
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
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: fontSize,
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

  Widget _buildAudioPlayerControls() {
    final audioPlayer = context.watch<AudioPlayer>();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.play_arrow),
          onPressed: () async {
            try {
              await audioPlayer.play();
            } catch (e) {
              print("Error playing audio: $e");
            }
          },
        ),
        IconButton(
          icon: const Icon(Icons.pause),
          onPressed: () async {
            try {
              await audioPlayer.pause();
            } catch (e) {
              print("Error pausing audio: $e");
            }
          },
        ),
        IconButton(
          icon: const Icon(Icons.stop),
          onPressed: () async {
            try {
              await audioPlayer.stop();
            } catch (e) {
              print("Error stopping audio: $e");
            }
          },
        ),
      ],
    );
  }

  Widget imageChange(int points, double size) {
    // 포인트에 따라 이미지 변경 로직 작성
    String imagePath;
    if (points >= 100) {
      imagePath = 'lib/assets/image/2.png'; // 포인트가 높을 때의 이미지
    } else {
      imagePath = 'lib/assets/image/3.png'; // 포인트가 낮을 때의 이미지
    }

    return Image.asset(
      imagePath,
      width: size,
      height: size,
      fit: BoxFit.contain,
    );
  }
}
