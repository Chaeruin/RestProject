// 메인 홈 페이지
import 'package:flutter/material.dart';
import 'package:heart/Api/audio_apis.dart';
import 'package:heart/audio_provider.dart';
import 'package:heart/auth_provider.dart';
import 'package:heart/drawer/login.dart';
import 'package:heart/drawer/signup.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:heart/Api/action_api.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  late int points = 0; // 포인트 초기값
  late bool isLogin; // 로그인 여부
  late String nickname; // 사용자 닉네임
  late String memberID; // 사용자 ID
  String? actionMessage; // 행동 추천 메시지
  late String? latestEmotion = ''; // 최신 감정 상태

  @override
  void initState() {
    super.initState();
    _initializeState(); // 상태 초기화
  }

  // 상태 초기화 메서드 (비동기)
  Future<void> _initializeState() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await fetchActionRecommendationFromApi(); // 행동 추천 메시지 불러오기

    // 로그인 상태 초기화
    isLogin = authProvider.isLoggedIn;
    if (isLogin) {
      memberID = authProvider.ID;
      nickname = authProvider.NickName;
      await getLatestEmotion(memberID); // 최신 감정 불러오기
    }
  }

  // 최신 감정을 서버에서 가져오는 메서드
  Future<void> getLatestEmotion(String memberID) async {
    try {
      final latest = await returnAfterEmotion(memberID);
      setState(() {
        latestEmotion = latest;
      });
      if (latestEmotion != null && latestEmotion!.isNotEmpty) {
        _initAudioPlayer(latestEmotion!); // 최신 감정에 따른 오디오 플레이어 초기화
      } else {
        print("최신 감정이 null이거나 비어 있습니다.");
      }
    } catch (e) {
      print("최신 감정 가져오기 오류: $e");
    }
  }

  // 오디오 플레이어 초기화 및 설정
  Future<void> _initAudioPlayer(String latestEmotion) async {
    try {
      final url =
          'https://chatbotmg.s3.ap-northeast-2.amazonaws.com/${memberID}_$latestEmotion.wav';
      final audioProvider = Provider.of<AudioProvider>(context, listen: false);

      // 현재 설정된 URL과 재생 중인 상태를 확인
      if (audioProvider.currentUrl != url ||
          !audioProvider.audioPlayer.playing) {
        await audioProvider.setUrl(url);
        await audioProvider.audioPlayer.setLoopMode(LoopMode.all);
        audioProvider.play();
      }
    } catch (e) {
      print("오류 발생: $e");
    }
  }

  // 행동 추천 메시지를 서버에서 가져오는 메서드
  Future<void> fetchActionRecommendationFromApi() async {
    try {
      final action = await fetchActionRecommendation();
      if (mounted) {
        setState(() {
          actionMessage = action; // 행동 추천 메시지 상태 업데이트
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

  // 로그아웃 메서드
  Future<void> logout() async {
    context.read<AuthProvider>().logout();
    Navigator.pop(context); // 로그아웃 후 화면 닫기
  }

  @override
  Widget build(BuildContext context) {
    final audioProvider = Provider.of<AudioProvider>(context, listen: true);
    final authProvider = Provider.of<AuthProvider>(context, listen: true);
    isLogin = authProvider.isLoggedIn;
    nickname = authProvider.NickName;

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
          _buildAudioPlayerControls(audioProvider), // 오디오 플레이어 컨트롤 버튼
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
                onTap: logout, // 로그아웃 버튼 클릭 시 로그아웃 메서드 호출
              )
            else ...[
              _buildDrawerItem(
                title: '로그인하기',
                icon: 'lib/assets/image/login.png',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const Login()), // 로그인 화면으로 이동
                ),
              ),
              const SizedBox(height: 20),
              _buildDrawerItem(
                title: '회원가입하기',
                icon: 'lib/assets/image/signup.png',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SignUp()), // 회원가입 화면으로 이동
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
                  imageChange(points, imageSize), // 포인트에 따른 이미지 변경 함수 호출
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
                            ? '"$actionMessage" 어떠세요?' // 행동 추천 메시지 출력
                            : 'Loading...', // 로딩 중 메시지
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

  // Drawer 아이템 생성 메서드
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
          onTap: onTap, // 아이템 클릭 시 동작 설정
        ),
      ),
    );
  }

  // 오디오 플레이어 컨트롤 버튼 생성 메서드
  Widget _buildAudioPlayerControls(AudioProvider audioProvider) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: IconButton(
        icon: Icon(
            audioProvider.audioPlayer.playing ? Icons.pause : Icons.play_arrow),
        onPressed: () {
          if (audioProvider.audioPlayer.playing) {
            audioProvider.audioPlayer.pause(); // 오디오 플레이어 일시 정지
          } else {
            audioProvider.audioPlayer.play(); // 오디오 플레이어 재생
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
