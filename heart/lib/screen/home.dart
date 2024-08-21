// 메인 홈 페이지
import 'package:flutter/material.dart';
import 'package:heart/Api/audio_apis.dart';
import 'package:heart/audio_provider.dart';
import 'package:heart/drawer/login.dart';
import 'package:heart/drawer/signup.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:heart/Api/action_api.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  late SharedPreferences prefs;  // SharedPreferences 인스턴스
  late int points = 0; // 포인트 저장 변수
  bool isLogin = false; // 로그인 상태 저장 변수
  late String nickname; // 사용자 닉네임
  late String memberID; // 사용자 ID
  String? actionMessage; // 행동 추천 메시지
  late String? latestEmotion = ''; // 최신 감정 저장 변수

// SharedPreferences를 초기화하고 상태를 설정하는 비동기 메서드
  Future<void> initPref() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      points = prefs.getInt('point') ?? 0;
      nickname = prefs.getString('nick') ?? '';
      memberID = prefs.getString('ID') ?? '';
      isLogin = prefs.getBool('isLogin') ?? false;
    });
  }

  @override
  void initState() {
    super.initState();
    initPref().then((_) {
      checkLogIn(); // 로그인 상태에 따라 최신 감정 확인
      fetchActionRecommendationFromApi(); // 행동 추천 메시지 가져오기
    });
  }

// 최신 감정을 API에서 가져오는 비동기 메서드
  Future<void> getLatestEmotion(String memID) async {
    
    try {
      final latest = await returnAfterEmotion(memID); //감정 가져오기
      
      setState(() {
        latestEmotion = latest;
      });
      if (latestEmotion != null && latestEmotion!.isNotEmpty) {
       
        _initAudioPlayer(latestEmotion!); // 오디오 플레이어 초기화 및 재생
      } else {
        print("최신 감정이 null이거나 비어 있습니다.");
      }
    } catch (e) {
      print("최신 감정 가져오기 오류: $e");
    }
  }

  // 로그인 상태를 확인하고, 로그인 상태일 경우 최신 감정 가져오기
  void checkLogIn() {
    if (isLogin) {
      getLatestEmotion(memberID);
    }
  }

 // 최신 감정에 기반하여 오디오 플레이어를 설정하고 재생하는 비동기 메서드
  Future<void> _initAudioPlayer(String latestEmotion) async {
   
    try {
      final url =
          'https://chatbotmg.s3.ap-northeast-2.amazonaws.com/${memberID}_$latestEmotion.wav';
     
      final audioProvider = Provider.of<AudioProvider>(context, listen: false);  // 오디오 파일 URL
      await audioProvider.setUrl(url); // 오디오 URL 설정
      await audioProvider.audioPlayer.setLoopMode(LoopMode.all); // 오디오 루프 설정
      audioProvider.play(); // 오디오 재생
    } catch (e) {
      print("오류 발생: $e");
    }
  }

// 행동 추천 메시지를 API에서 가져오는 비동기 메서드
  Future<void> fetchActionRecommendationFromApi() async {
    try {
      final action = await fetchActionRecommendation(); // 행동 추천 메시지 가져오기
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

// 로그아웃 기능을 수행하는 비동기 메서드
  Future<void> logout() async {
    await prefs.remove('nickName'); //닉네임 삭제
    await prefs.remove('ID'); //아이디 삭제
    await prefs.setBool('isLogin', false);// 로그인 상태 변경
    setState(() {
      isLogin = false;
      nickname = '';
      memberID = '';
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final audioProvider = Provider.of<AudioProvider>(context);

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
          _buildAudioPlayerControls(audioProvider), // 오디오 플레이어 컨트롤 추가
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Center(
                child: Text(
                  // 로그인 상태에 따른 인사말
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
                  imageChange(points, imageSize), // 포인트에 따라 이미지 변경
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

// Drawer 항목을 생성하는 메서드
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

//오디오 플레이어 컨트롤을 생성하는 메서드
  Widget _buildAudioPlayerControls(AudioProvider audioProvider) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: IconButton(
        icon: Icon(audioProvider.audioPlayer.playing ? Icons.pause : Icons.play_arrow),
        onPressed: () {
          if (audioProvider.audioPlayer.playing) {
            audioProvider.audioPlayer.pause(); // 재생 중이면 일시 정지
           
          } else {
            audioProvider.audioPlayer.play(); // 정지 중이면 재생
           
          }
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
